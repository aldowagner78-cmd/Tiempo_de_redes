package com.saludable.nexus_control.receivers

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast

/**
 * DeviceAdminReceiver - Receptor para modo Device Owner/Admin
 * 
 * Permite control avanzado del dispositivo cuando se configura como Device Owner:
 * - Ocultar/mostrar apps
 * - Bloquear desinstalación de Nexus Control
 * - Control de políticas del dispositivo
 * 
 * Para configurar como Device Owner (requiere dispositivo sin cuentas):
 * adb shell dpm set-device-owner com.saludable.nexus_control/.receivers.DeviceAdminReceiver
 */
class DeviceAdminReceiver : DeviceAdminReceiver() {
    
    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        Toast.makeText(
            context,
            "Nexus Control: Administrador activado",
            Toast.LENGTH_SHORT
        ).show()
    }
    
    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        Toast.makeText(
            context,
            "Nexus Control: Administrador desactivado",
            Toast.LENGTH_SHORT
        ).show()
    }
    
    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        return "¿Desactivar el control parental de Nexus Control?"
    }
}
