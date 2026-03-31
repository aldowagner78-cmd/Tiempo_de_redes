import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// ============================================
/// NEXUS CONTROL - App Monitor Service
/// ============================================
/// Servicio de fondo que monitorea las apps abiertas,
/// descuenta tiempo de pantalla y muestra El Muro (overlay)
/// cuando el saldo de Bio-Coins se agota.
/// 
/// Requiere permisos Android:
///   - PACKAGE_USAGE_STATS
///   - SYSTEM_ALERT_WINDOW
///   - FOREGROUND_SERVICE
///   - RECEIVE_BOOT_COMPLETED
class AppMonitorService {
  AppMonitorService._();

  static final FlutterBackgroundService _service = FlutterBackgroundService();
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Inicializa el servicio de fondo + notificaciones
  static Future<void> initialize() async {
    await _initializeNotifications();

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        autoStart: true,
        autoStartOnBoot: true,
        isForegroundMode: true,
        notificationChannelId: AppConstants.notificationChannelId,
        initialNotificationTitle: AppConstants.appName,
        initialNotificationContent: 'Monitoreando tiempo de pantalla...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: _onStart,
        onBackground: _onIosBackground,
      ),
    );
  }

  static Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(initSettings);

    const channel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDescription,
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Inicia el servicio
  static Future<void> start() async {
    await _service.startService();
  }

  /// Detiene el servicio
  static void stop() {
    _service.invoke('stop');
  }

  /// Verifica si el servicio está corriendo
  static Future<bool> isRunning() async {
    return await _service.isRunning();
  }

  /// Muestra el overlay de bloqueo (El Muro)
  static void showBlockOverlay() {
    _service.invoke('showOverlay');
  }

  /// Oculta el overlay de bloqueo
  static void hideBlockOverlay() {
    _service.invoke('hideOverlay');
  }

  /// Actualiza la lista negra de apps bloqueadas
  static void updateBlacklist(List<String> packageNames) {
    _service.invoke('updateBlacklist', {'packages': packageNames});
  }

  /// Escucha eventos del servicio (cambio de app, tiempo actualizado, muro activado)
  static Stream<Map<String, dynamic>?> on(String event) {
    return _service.on(event);
  }
}

// ============================================================
// ENTRY POINT DEL ISOLATE DE FONDO
// ============================================================

/// Este código corre en un isolate separado del hilo principal.
/// NO puede acceder a widgets ni a providers de Riverpod.
@pragma('vm:entry-point')
Future<void> _onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  List<String> blacklistedApps = [...DefaultBlacklist.all];
  Timer? checkTimer;
  Timer? deductTimer;
  bool isBlockedAppForeground = false;
  String? currentForegroundApp;

  final prefs = await SharedPreferences.getInstance();

  // Comandos entrantes desde Flutter
  service.on('stop').listen((_) {
    checkTimer?.cancel();
    deductTimer?.cancel();
    service.stopSelf();
  });

  service.on('updateBlacklist').listen((event) {
    if (event != null && event['packages'] is List) {
      blacklistedApps = List<String>.from(event['packages']);
    }
  });

  service.on('showOverlay').listen((_) async {
    await _showBlockingOverlay();
  });

  service.on('hideOverlay').listen((_) async {
    await _hideBlockingOverlay();
  });

  // Chequeo periódico de qué app está en primer plano
  checkTimer = Timer.periodic(
    const Duration(milliseconds: AppConstants.appCheckIntervalMs),
    (_) async {
      final foregroundApp = await _getForegroundApp();

      if (foregroundApp != currentForegroundApp) {
        currentForegroundApp = foregroundApp;
        isBlockedAppForeground = blacklistedApps.contains(foregroundApp);

        service.invoke('foregroundAppChanged', {
          'package': foregroundApp,
          'isBlocked': isBlockedAppForeground,
        });
      }

      final remainingTime = prefs.getInt(AppConstants.keyRemainingTime) ?? 0;
      if (isBlockedAppForeground && remainingTime <= 0) {
        await _showBlockingOverlay();
      }
    },
  );

  // Descuento de tiempo cada minuto cuando hay app bloqueada activa
  deductTimer = Timer.periodic(
    const Duration(milliseconds: AppConstants.timeDeductionIntervalMs),
    (_) async {
      if (!isBlockedAppForeground) return;

      final remainingTime = prefs.getInt(AppConstants.keyRemainingTime) ?? 0;

      if (remainingTime > 0) {
        final newTime = remainingTime - 60;
        await prefs.setInt(AppConstants.keyRemainingTime, newTime);
        await _updateNotification(newTime);

        service.invoke('timeUpdated', {'remaining': newTime});

        if (newTime <= 0) {
          await _showBlockingOverlay();
          service.invoke('wallActivated');
        }
      }
    },
  );

  // Notificación inicial
  final initialTime = prefs.getInt(AppConstants.keyRemainingTime) ??
      (AppConstants.defaultDailyTimeMinutes * 60);
  await _updateNotification(initialTime);
}

/// Obtiene el paquete en primer plano.
/// TODO (Fase 2): Implementar via MethodChannel → Kotlin UsageStatsManager
Future<String?> _getForegroundApp() async {
  return null;
}

/// Muestra El Muro (overlay de bloqueo).
/// TODO (Fase 2): Implementar via flutter_overlay_window
Future<void> _showBlockingOverlay() async {}

/// Oculta El Muro.
/// TODO (Fase 2): Implementar via flutter_overlay_window
Future<void> _hideBlockingOverlay() async {}

/// Actualiza el texto de la notificación del foreground service
Future<void> _updateNotification(int remainingSeconds) async {
  final hours = remainingSeconds ~/ 3600;
  final minutes = (remainingSeconds % 3600) ~/ 60;

  final String content;
  if (remainingSeconds <= 0) {
    content = '⚠️ TIEMPO AGOTADO · Completa tareas para desbloquear';
  } else if (remainingSeconds < 300) {
    content = '⚡ ¡Quedan ${minutes}m! · Desbloqueo pronto';
  } else {
    content = '⏱️ Tiempo restante: ${hours}h ${minutes}m';
  }

  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.show(
    888,
    AppConstants.appName,
    content,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        AppConstants.notificationChannelId,
        AppConstants.notificationChannelName,
        channelDescription: AppConstants.notificationChannelDescription,
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        showWhen: false,
        icon: '@mipmap/ic_launcher',
      ),
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> _onIosBackground(ServiceInstance service) async {
  return true;
}
