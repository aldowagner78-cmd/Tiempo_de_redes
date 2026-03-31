package com.saludable.nexus_control.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.saludable.nexus_control.services.AppMonitorService

/**
 * BootReceiver - Inicia el servicio de monitoreo al arrancar el dispositivo
 * 
 * Garantiza que el control parental esté activo desde el encendido,
 * sin necesidad de abrir la app manualmente.
 */
class BootReceiver : BroadcastReceiver() {
    
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == "android.intent.action.QUICKBOOT_POWERON") {
            
            // Verificar si el monitoreo estaba activo
            val prefs = context.getSharedPreferences("nexus_settings", Context.MODE_PRIVATE)
            val monitoringEnabled = prefs.getBoolean("monitoring_enabled", false)
            
            if (monitoringEnabled) {
                // Iniciar servicio de monitoreo
                val serviceIntent = Intent(context, AppMonitorService::class.java)
                context.startForegroundService(serviceIntent)
            }
        }
    }
}
