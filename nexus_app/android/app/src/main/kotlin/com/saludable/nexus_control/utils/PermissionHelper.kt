package com.saludable.nexus_control.utils

import android.app.AppOpsManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Process
import android.provider.Settings
import com.saludable.nexus_control.receivers.DeviceAdminReceiver

/**
 * PermissionHelper - Utilidades para manejar permisos especiales de Android
 * 
 * Maneja permisos que requieren configuración manual del usuario:
 * - PACKAGE_USAGE_STATS (estadísticas de uso)
 * - SYSTEM_ALERT_WINDOW (overlay)
 * - Device Owner (administrador del dispositivo)
 */
object PermissionHelper {
    
    /**
     * Verificar si tenemos permiso de estadísticas de uso
     * Este permiso es necesario para monitorear apps en primer plano
     */
    fun hasUsageStatsPermission(context: Context): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }
    
    /**
     * Abrir configuración para otorgar permiso de estadísticas de uso
     */
    fun requestUsageStatsPermission(context: Context) {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        context.startActivity(intent)
    }
    
    /**
     * Verificar si tenemos permiso de overlay (pantalla sobre otras apps)
     */
    fun hasOverlayPermission(context: Context): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(context)
        } else {
            true
        }
    }
    
    /**
     * Abrir configuración para otorgar permiso de overlay
     */
    fun requestOverlayPermission(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:${context.packageName}")
            ).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
        }
    }
    
    /**
     * Verificar si la app es Device Owner
     * Device Owner permite control total del dispositivo sin root
     * Se configura via ADB: adb shell dpm set-device-owner com.saludable.nexus_control/.receivers.DeviceAdminReceiver
     */
    fun isDeviceOwner(context: Context): Boolean {
        val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        return dpm.isDeviceOwnerApp(context.packageName)
    }
    
    /**
     * Verificar si la app es Device Admin (nivel menor que Owner)
     */
    fun isDeviceAdmin(context: Context): Boolean {
        val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminComponent = ComponentName(context, DeviceAdminReceiver::class.java)
        return dpm.isAdminActive(adminComponent)
    }
    
    /**
     * Solicitar ser Device Admin
     */
    fun requestDeviceAdmin(context: Context) {
        val adminComponent = ComponentName(context, DeviceAdminReceiver::class.java)
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
            putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent)
            putExtra(
                DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                "Nexus Control necesita permisos de administrador para el control parental"
            )
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        context.startActivity(intent)
    }
    
    /**
     * Obtener lista de apps instaladas por el usuario (no sistema)
     */
    fun getInstalledApps(context: Context): List<Map<String, String>> {
        val pm = context.packageManager
        val apps = mutableListOf<Map<String, String>>()
        
        val packages = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pm.getInstalledApplications(PackageManager.ApplicationInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION")
            pm.getInstalledApplications(PackageManager.GET_META_DATA)
        }
        
        for (appInfo in packages) {
            // Filtrar apps de sistema
            if (appInfo.flags and ApplicationInfo.FLAG_SYSTEM == 0) {
                val appName = pm.getApplicationLabel(appInfo).toString()
                val packageName = appInfo.packageName
                
                // Excluir nuestra propia app
                if (packageName != context.packageName) {
                    apps.add(mapOf(
                        "name" to appName,
                        "package" to packageName
                    ))
                }
            }
        }
        
        // Ordenar alfabéticamente
        return apps.sortedBy { it["name"]?.lowercase() }
    }
    
    /**
     * Bloquear una app específica (requiere Device Owner)
     */
    fun blockApp(context: Context, packageName: String): Boolean {
        if (!isDeviceOwner(context)) return false
        
        val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminComponent = ComponentName(context, DeviceAdminReceiver::class.java)
        
        return try {
            dpm.setApplicationHidden(adminComponent, packageName, true)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
    
    /**
     * Desbloquear una app específica (requiere Device Owner)
     */
    fun unblockApp(context: Context, packageName: String): Boolean {
        if (!isDeviceOwner(context)) return false
        
        val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminComponent = ComponentName(context, DeviceAdminReceiver::class.java)
        
        return try {
            dpm.setApplicationHidden(adminComponent, packageName, false)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
