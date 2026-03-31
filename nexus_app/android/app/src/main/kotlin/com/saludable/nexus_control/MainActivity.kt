package com.saludable.nexus_control

import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import com.saludable.nexus_control.services.AppMonitorService
import com.saludable.nexus_control.services.OverlayService
import com.saludable.nexus_control.utils.PermissionHelper

/**
 * MainActivity - Punto de entrada principal de la app
 * Configura los canales de comunicación Flutter <-> Kotlin
 */
class MainActivity : FlutterActivity() {
    
    companion object {
        private const val MONITOR_CHANNEL = "com.saludable.nexus_control/monitor"
        private const val OVERLAY_CHANNEL = "com.saludable.nexus_control/overlay"
        private const val PERMISSIONS_CHANNEL = "com.saludable.nexus_control/permissions"
        private const val MONITOR_EVENTS_CHANNEL = "com.saludable.nexus_control/monitor_events"
    }
    
    private var eventSink: EventChannel.EventSink? = null
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Canal de monitoreo de apps
        setupMonitorChannel(flutterEngine)
        
        // Canal de overlay
        setupOverlayChannel(flutterEngine)
        
        // Canal de permisos
        setupPermissionsChannel(flutterEngine)
        
        // Canal de eventos (stream)
        setupEventChannel(flutterEngine)
    }
    
    /**
     * Configura el canal de monitoreo de apps
     */
    private fun setupMonitorChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MONITOR_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        val success = startMonitorService()
                        result.success(success)
                    }
                    "stopService" -> {
                        val success = stopMonitorService()
                        result.success(success)
                    }
                    "getForegroundApp" -> {
                        val packageName = AppMonitorService.getCurrentForegroundApp(this)
                        result.success(packageName)
                    }
                    "updateBlacklist" -> {
                        val packages = call.argument<List<String>>("packages") ?: emptyList()
                        updateBlacklist(packages)
                        result.success(true)
                    }
                    "getUsageStats" -> {
                        val period = call.argument<String>("period") ?: "today"
                        val stats = AppMonitorService.getUsageStats(this, period)
                        result.success(stats)
                    }
                    else -> result.notImplemented()
                }
            }
    }
    
    /**
     * Configura el canal de overlay
     */
    private fun setupOverlayChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OVERLAY_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "showOverlay" -> {
                        val message = call.argument<String>("message") ?: "Acceso Denegado"
                        val success = showBlockOverlay(message)
                        result.success(success)
                    }
                    "hideOverlay" -> {
                        val success = hideBlockOverlay()
                        result.success(success)
                    }
                    "isVisible" -> {
                        result.success(OverlayService.isVisible)
                    }
                    else -> result.notImplemented()
                }
            }
    }
    
    /**
     * Configura el canal de permisos
     */
    private fun setupPermissionsChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSIONS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasUsageStatsPermission" -> {
                        result.success(PermissionHelper.hasUsageStatsPermission(this))
                    }
                    "requestUsageStatsPermission" -> {
                        PermissionHelper.requestUsageStatsPermission(this)
                        result.success(null)
                    }
                    "hasOverlayPermission" -> {
                        result.success(PermissionHelper.hasOverlayPermission(this))
                    }
                    "requestOverlayPermission" -> {
                        PermissionHelper.requestOverlayPermission(this)
                        result.success(null)
                    }
                    "isDeviceOwner" -> {
                        result.success(PermissionHelper.isDeviceOwner(this))
                    }
                    "getInstalledApps" -> {
                        val apps = PermissionHelper.getInstalledApps(this)
                        result.success(apps)
                    }
                    else -> result.notImplemented()
                }
            }
    }
    
    /**
     * Configura el canal de eventos para streaming
     */
    private fun setupEventChannel(flutterEngine: FlutterEngine) {
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, MONITOR_EVENTS_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    AppMonitorService.setEventSink(events)
                }
                
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    AppMonitorService.setEventSink(null)
                }
            })
    }
    
    // ========== MÉTODOS DE SERVICIO ==========
    
    private fun startMonitorService(): Boolean {
        return try {
            val intent = Intent(this, AppMonitorService::class.java)
            startForegroundService(intent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
    
    private fun stopMonitorService(): Boolean {
        return try {
            val intent = Intent(this, AppMonitorService::class.java)
            stopService(intent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
    
    private fun updateBlacklist(packages: List<String>) {
        val prefs = getSharedPreferences("nexus_blacklist", Context.MODE_PRIVATE)
        prefs.edit().putStringSet("blocked_packages", packages.toSet()).apply()
        
        // Notificar al servicio
        val intent = Intent(this, AppMonitorService::class.java).apply {
            action = AppMonitorService.ACTION_UPDATE_BLACKLIST
        }
        startService(intent)
    }
    
    private fun showBlockOverlay(message: String): Boolean {
        return try {
            val intent = Intent(this, OverlayService::class.java).apply {
                action = OverlayService.ACTION_SHOW
                putExtra(OverlayService.EXTRA_MESSAGE, message)
            }
            startService(intent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
    
    private fun hideBlockOverlay(): Boolean {
        return try {
            val intent = Intent(this, OverlayService::class.java).apply {
                action = OverlayService.ACTION_HIDE
            }
            startService(intent)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    /**
     * Manejar intent entrante (ej: abrir desde overlay "IR A LA MINA").
     * Notifica a Flutter para que navegue a /wall.
     */
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.getBooleanExtra("openMine", false)) {
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, MONITOR_CHANNEL)
                    .invokeMethod("navigateToWall", null)
            }
        }
    }
}
