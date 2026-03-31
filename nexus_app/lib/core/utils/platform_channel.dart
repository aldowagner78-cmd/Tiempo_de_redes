/// ============================================
/// NEXUS CONTROL - Platform Channel Service
/// ============================================
/// Puente de comunicación Flutter <-> Kotlin nativo
/// Para servicios de sistema Android

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para el servicio de plataforma
final platformChannelProvider = Provider<PlatformChannelService>((ref) {
  return PlatformChannelService();
});

class PlatformChannelService {
  /// Canal principal para monitoreo de apps
  static const MethodChannel _monitorChannel = 
      MethodChannel('com.saludable.nexus_control/monitor');
  
  /// Canal para overlay de bloqueo
  static const MethodChannel _overlayChannel = 
      MethodChannel('com.saludable.nexus_control/overlay');
  
  /// Canal para permisos especiales
  static const MethodChannel _permissionsChannel = 
      MethodChannel('com.saludable.nexus_control/permissions');
  
  /// Stream de eventos desde el servicio nativo
  static const EventChannel _monitorEventChannel = 
      EventChannel('com.saludable.nexus_control/monitor_events');

  /// StreamController para recibir la señal "navegar a /wall" desde el overlay nativo.
  final StreamController<void> _navigateToWallController =
      StreamController<void>.broadcast();

  PlatformChannelService() {
    // Escuchar llamadas entrantes del lado nativo (ej: overlay → "IR A LA MINA")
    _monitorChannel.setMethodCallHandler((call) async {
      if (call.method == 'navigateToWall') {
        _navigateToWallController.add(null);
      }
    });
  }
  
  // ========== SERVICIO DE MONITOREO ==========
  
  /// Iniciar el servicio de monitoreo de apps
  Future<bool> startMonitorService() async {
    try {
      final result = await _monitorChannel.invokeMethod<bool>('startService');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error iniciando servicio de monitoreo: ${e.message}');
      return false;
    }
  }
  
  /// Detener el servicio de monitoreo
  Future<bool> stopMonitorService() async {
    try {
      final result = await _monitorChannel.invokeMethod<bool>('stopService');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error deteniendo servicio: ${e.message}');
      return false;
    }
  }
  
  /// Obtener la app actualmente en primer plano
  Future<String?> getCurrentForegroundApp() async {
    try {
      return await _monitorChannel.invokeMethod<String>('getForegroundApp');
    } on PlatformException catch (e) {
      print('Error obteniendo app en primer plano: ${e.message}');
      return null;
    }
  }
  
  /// Actualizar la lista de apps bloqueadas en el servicio nativo
  Future<bool> updateBlacklist(List<String> packageNames) async {
    try {
      final result = await _monitorChannel.invokeMethod<bool>(
        'updateBlacklist',
        {'packages': packageNames},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error actualizando blacklist: ${e.message}');
      return false;
    }
  }
  
  /// Obtener estadísticas de uso del día
  Future<Map<String, int>?> getTodayUsageStats() async {
    try {
      final result = await _monitorChannel.invokeMethod<Map>(
        'getUsageStats',
        {'period': 'today'},
      );
      return result?.cast<String, int>();
    } on PlatformException catch (e) {
      print('Error obteniendo estadísticas: ${e.message}');
      return null;
    }
  }
  
  /// Stream de cambios de app en primer plano
  Stream<String> get foregroundAppStream {
    return _monitorEventChannel
        .receiveBroadcastStream()
        .map((event) => event as String);
  }

  /// Emite cuando el overlay nativo pide abrir la pantalla /wall.
  Stream<void> get navigateToWallStream => _navigateToWallController.stream;
  
  // ========== SERVICIO DE OVERLAY (BLOQUEO) ==========
  
  /// Mostrar el overlay de bloqueo
  Future<bool> showBlockOverlay({String? message}) async {
    try {
      final result = await _overlayChannel.invokeMethod<bool>(
        'showOverlay',
        {'message': message ?? 'Acceso Denegado'},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error mostrando overlay: ${e.message}');
      return false;
    }
  }
  
  /// Ocultar el overlay de bloqueo
  Future<bool> hideBlockOverlay() async {
    try {
      final result = await _overlayChannel.invokeMethod<bool>('hideOverlay');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error ocultando overlay: ${e.message}');
      return false;
    }
  }
  
  /// Verificar si el overlay está visible
  Future<bool> isOverlayVisible() async {
    try {
      final result = await _overlayChannel.invokeMethod<bool>('isVisible');
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error verificando overlay: ${e.message}');
      return false;
    }
  }
  
  // ========== PERMISOS ESPECIALES ==========
  
  /// Verificar permiso de estadísticas de uso
  Future<bool> hasUsageStatsPermission() async {
    try {
      final result = await _permissionsChannel.invokeMethod<bool>(
        'hasUsageStatsPermission',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error verificando permiso: ${e.message}');
      return false;
    }
  }
  
  /// Solicitar permiso de estadísticas de uso (abre configuración)
  Future<void> requestUsageStatsPermission() async {
    try {
      await _permissionsChannel.invokeMethod('requestUsageStatsPermission');
    } on PlatformException catch (e) {
      print('Error solicitando permiso: ${e.message}');
    }
  }
  
  /// Verificar permiso de overlay
  Future<bool> hasOverlayPermission() async {
    try {
      final result = await _permissionsChannel.invokeMethod<bool>(
        'hasOverlayPermission',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error verificando permiso de overlay: ${e.message}');
      return false;
    }
  }
  
  /// Solicitar permiso de overlay (abre configuración)
  Future<void> requestOverlayPermission() async {
    try {
      await _permissionsChannel.invokeMethod('requestOverlayPermission');
    } on PlatformException catch (e) {
      print('Error solicitando permiso de overlay: ${e.message}');
    }
  }
  
  /// Verificar si la app es Device Owner
  Future<bool> isDeviceOwner() async {
    try {
      final result = await _permissionsChannel.invokeMethod<bool>(
        'isDeviceOwner',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print('Error verificando Device Owner: ${e.message}');
      return false;
    }
  }
  
  /// Obtener lista de apps instaladas
  Future<List<Map<String, String>>> getInstalledApps() async {
    try {
      final result = await _permissionsChannel.invokeMethod<List>(
        'getInstalledApps',
      );
      return result?.map((app) => Map<String, String>.from(app)).toList() ?? [];
    } on PlatformException catch (e) {
      print('Error obteniendo apps instaladas: ${e.message}');
      return [];
    }
  }
}
