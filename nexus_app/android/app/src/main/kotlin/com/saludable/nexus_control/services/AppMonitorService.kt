package com.saludable.nexus_control.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat
import com.saludable.nexus_control.MainActivity
import com.saludable.nexus_control.R
import io.flutter.plugin.common.EventChannel
import java.util.Calendar

/**
 * AppMonitorService - Servicio de monitoreo de apps en primer plano
 * 
 * Este servicio corre en segundo plano y verifica cada 1000ms
 * qué aplicación está en primer plano. Si la app está en la blacklist
 * y el usuario no tiene Bio-Coins/tiempo disponible, dispara el overlay.
 */
class AppMonitorService : Service() {
    
    companion object {
        const val ACTION_UPDATE_BLACKLIST = "com.saludable.nexus_control.UPDATE_BLACKLIST"
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "nexus_monitor_channel"
        private const val POLL_INTERVAL_MS = 1000L
        /** Segundos por defecto si la clave aún no fue escrita desde Flutter */
        private const val DEFAULT_DAILY_SECONDS = 3600 // 60 minutos
        
        private var eventSink: EventChannel.EventSink? = null
        private var lastForegroundPackage: String? = null
        
        /**
         * Establecer el sink de eventos para comunicar con Flutter
         */
        fun setEventSink(sink: EventChannel.EventSink?) {
            eventSink = sink
        }
        
        /**
         * Obtener la app actualmente en primer plano
         */
        fun getCurrentForegroundApp(context: Context): String? {
            val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) 
                as? UsageStatsManager ?: return null
            
            val endTime = System.currentTimeMillis()
            val beginTime = endTime - 1000 * 60 // Último minuto
            
            val usageStats = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                beginTime,
                endTime
            )
            
            if (usageStats.isNullOrEmpty()) return null
            
            // Encontrar la app más reciente
            var recentStats: UsageStats? = null
            for (stats in usageStats) {
                if (recentStats == null || 
                    stats.lastTimeUsed > recentStats.lastTimeUsed) {
                    recentStats = stats
                }
            }
            
            return recentStats?.packageName
        }
        
        /**
         * Obtener estadísticas de uso
         */
        fun getUsageStats(context: Context, period: String): Map<String, Long> {
            val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE)
                as? UsageStatsManager ?: return emptyMap()
            
            val calendar = Calendar.getInstance()
            val endTime = calendar.timeInMillis
            
            when (period) {
                "today" -> {
                    calendar.set(Calendar.HOUR_OF_DAY, 0)
                    calendar.set(Calendar.MINUTE, 0)
                    calendar.set(Calendar.SECOND, 0)
                }
                "week" -> calendar.add(Calendar.DAY_OF_YEAR, -7)
                "month" -> calendar.add(Calendar.MONTH, -1)
                else -> calendar.add(Calendar.HOUR, -24)
            }
            
            val beginTime = calendar.timeInMillis
            
            val usageStats = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                beginTime,
                endTime
            )
            
            val result = mutableMapOf<String, Long>()
            for (stats in usageStats) {
                if (stats.totalTimeInForeground > 0) {
                    result[stats.packageName] = stats.totalTimeInForeground / 1000 / 60 // Minutos
                }
            }
            
            return result
        }
    }
    
    private val handler = Handler(Looper.getMainLooper())
    private var isRunning = false
    private var blacklistedPackages = setOf<String>()
    private var userHasTime = true // Se actualiza desde Flutter
    
    private val monitorRunnable = object : Runnable {
        override fun run() {
            if (!isRunning) return
            
            checkForegroundApp()
            handler.postDelayed(this, POLL_INTERVAL_MS)
        }
    }
    
    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        loadBlacklist()
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_UPDATE_BLACKLIST -> {
                loadBlacklist()
                return START_STICKY
            }
        }
        
        // Iniciar como foreground service
        startForeground(NOTIFICATION_ID, createNotification())
        
        // Iniciar monitoreo
        if (!isRunning) {
            isRunning = true
            handler.post(monitorRunnable)
        }
        
        return START_STICKY
    }
    
    override fun onBind(intent: Intent?): IBinder? = null
    
    override fun onDestroy() {
        isRunning = false
        handler.removeCallbacks(monitorRunnable)
        super.onDestroy()
    }
    
    /**
     * Verificar la app en primer plano y actuar si está bloqueada.
     * Lee el tiempo restante de SharedPreferences (escrito por el lado Flutter)
     * y dispara / oculta el overlay directamente, sin depender del app en foreground.
     */
    private fun checkForegroundApp() {
        val currentPackage = getCurrentForegroundApp(this) ?: return

        val isBlocked = blacklistedPackages.contains(currentPackage)
        val remainingSeconds = getRemainingTimeSeconds()

        // Enviar evento a Flutter si la app cambió
        if (currentPackage != lastForegroundPackage) {
            lastForegroundPackage = currentPackage
            eventSink?.success(currentPackage)
        }

        if (isBlocked && remainingSeconds <= 0) {
            // Sin tiempo —> mostrar El Muro
            if (!OverlayService.isVisible) {
                val intent = Intent(this, OverlayService::class.java).apply {
                    action = OverlayService.ACTION_SHOW
                    putExtra(OverlayService.EXTRA_MESSAGE,
                        "Has agotado tu tiempo de pantalla.\nCompleta actividades en La Mina para desbloquear.")
                }
                startService(intent)
            }
        } else {
            // App permitida o tiene tiempo —> ocultar overlay si estaba visible
            if (OverlayService.isVisible) {
                val intent = Intent(this, OverlayService::class.java).apply {
                    action = OverlayService.ACTION_HIDE
                }
                startService(intent)
            }
        }
    }

    /**
     * Leer los segundos restantes del día desde SharedPreferences.
     * La clave "nexus_remaining_time" la escribe el servicio Flutter (Dart side).
     */
    private fun getRemainingTimeSeconds(): Int {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        // flutter_shared_preferences prefija las claves con "flutter."
        return prefs.getInt("flutter.nexus_remaining_time", DEFAULT_DAILY_SECONDS)
    }
    
    /**
     * Cargar la lista de apps bloqueadas desde SharedPreferences
     */
    private fun loadBlacklist() {
        val prefs = getSharedPreferences("nexus_blacklist", Context.MODE_PRIVATE)
        blacklistedPackages = prefs.getStringSet("blocked_packages", emptySet()) ?: emptySet()
    }
    
    /**
     * Crear el canal de notificación (requerido Android O+)
     */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Monitor de Nexus Control",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Monitoreo de uso de aplicaciones"
                setShowBadge(false)
            }
            
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }
    
    /**
     * Crear la notificación persistente del servicio
     */
    private fun createNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Nexus Control Activo")
            .setContentText("Protegiendo tu tiempo de pantalla")
            .setSmallIcon(android.R.drawable.ic_lock_lock)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }
}
