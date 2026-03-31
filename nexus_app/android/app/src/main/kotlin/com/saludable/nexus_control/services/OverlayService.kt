package com.saludable.nexus_control.services

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import com.saludable.nexus_control.MainActivity

/**
 * OverlayService - Servicio que muestra el "Muro" de bloqueo
 * 
 * Cuando el usuario intenta usar una app bloqueada sin tiempo/Bio-Coins,
 * este overlay de pantalla completa bloquea el acceso y dirige al usuario
 * a completar actividades en "La Mina".
 */
class OverlayService : Service() {
    
    companion object {
        const val ACTION_SHOW = "com.saludable.nexus_control.SHOW_OVERLAY"
        const val ACTION_HIDE = "com.saludable.nexus_control.HIDE_OVERLAY"
        const val EXTRA_MESSAGE = "message"
        
        var isVisible = false
            private set
    }
    
    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    
    override fun onBind(intent: Intent?): IBinder? = null
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_SHOW -> {
                val message = intent.getStringExtra(EXTRA_MESSAGE) ?: "Acceso Denegado"
                showOverlay(message)
            }
            ACTION_HIDE -> {
                hideOverlay()
            }
        }
        return START_NOT_STICKY
    }
    
    override fun onDestroy() {
        hideOverlay()
        super.onDestroy()
    }
    
    /**
     * Mostrar el overlay de bloqueo con estilo cyberpunk
     */
    private fun showOverlay(message: String) {
        if (isVisible) return
        
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        
        // Crear la vista programáticamente con estilo cyberpunk
        overlayView = createCyberpunkOverlay(message)
        
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.CENTER
        }
        
        try {
            windowManager?.addView(overlayView, params)
            isVisible = true
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    
    /**
     * Ocultar el overlay
     */
    private fun hideOverlay() {
        if (!isVisible || overlayView == null) return
        
        try {
            windowManager?.removeView(overlayView)
            overlayView = null
            isVisible = false
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    
    /**
     * Crear vista de overlay con estilo cyberpunk/neón
     */
    private fun createCyberpunkOverlay(message: String): View {
        // Layout raíz
        val layout = android.widget.LinearLayout(this).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setBackgroundColor(Color.parseColor("#E60A0E17")) // Fondo oscuro semi-transparente
            setPadding(48, 48, 48, 48)
        }
        
        // Línea decorativa superior
        val topLine = View(this).apply {
            setBackgroundColor(Color.parseColor("#00F5FF"))
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
                4
            ).apply {
                bottomMargin = 48
            }
        }
        layout.addView(topLine)
        
        // Ícono de bloqueo (usando símbolo Unicode)
        val lockIcon = TextView(this).apply {
            text = "🔒"
            textSize = 72f
            gravity = Gravity.CENTER
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 24
            }
        }
        layout.addView(lockIcon)
        
        // Título principal
        val titleText = TextView(this).apply {
            text = "⚠ ACCESO DENEGADO ⚠"
            textSize = 28f
            setTextColor(Color.parseColor("#FF3366")) // Rojo neón
            gravity = Gravity.CENTER
            setTypeface(null, android.graphics.Typeface.BOLD)
            letterSpacing = 0.15f
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 16
            }
        }
        layout.addView(titleText)
        
        // Mensaje personalizable
        val messageText = TextView(this).apply {
            text = message
            textSize = 16f
            setTextColor(Color.parseColor("#8899AA"))
            gravity = Gravity.CENTER
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 32
            }
        }
        layout.addView(messageText)
        
        // Información de Bio-Coins
        val coinsInfo = TextView(this).apply {
            text = "Sin Bio-Coins disponibles\nSin tiempo de red restante"
            textSize = 14f
            setTextColor(Color.parseColor("#FFE600")) // Amarillo neón
            gravity = Gravity.CENTER
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 48
            }
        }
        layout.addView(coinsInfo)
        
        // Botón para ir a La Mina
        val mineButton = Button(this).apply {
            text = "🏭 IR A LA MINA"
            textSize = 16f
            setTextColor(Color.parseColor("#0A0E17"))
            setBackgroundColor(Color.parseColor("#00F5FF"))
            setPadding(48, 24, 48, 24)
            setOnClickListener {
                // Abrir MainActivity de Nexus Control
                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    putExtra("openMine", true)
                }
                startActivity(intent)
                hideOverlay()
            }
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 16
            }
        }
        layout.addView(mineButton)
        
        // Botón de emergencia (requiere PIN del padre)
        val emergencyButton = Button(this).apply {
            text = "🔑 Emergencia (PIN Padre)"
            textSize = 12f
            setTextColor(Color.parseColor("#8899AA"))
            setBackgroundColor(Color.TRANSPARENT)
            setOnClickListener {
                // Abrir pantalla de emergencia con PIN
                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    putExtra("emergencyUnlock", true)
                }
                startActivity(intent)
            }
        }
        layout.addView(emergencyButton)
        
        // Línea decorativa inferior
        val bottomLine = View(this).apply {
            setBackgroundColor(Color.parseColor("#FF00FF"))
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
                4
            ).apply {
                topMargin = 48
            }
        }
        layout.addView(bottomLine)
        
        return layout
    }
}
