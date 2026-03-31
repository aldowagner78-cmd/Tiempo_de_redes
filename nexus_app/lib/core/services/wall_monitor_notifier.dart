/// ============================================
/// NEXUS CONTROL - Wall Monitor Notifier
/// ============================================
/// Cerebro del sistema de bloqueo ("El Muro").
///
/// Responsabilidades:
///   1. Descuenta tiempo cada 60s cuando hay app bloqueada activa en foreground.
///   2. Persiste el tiempo restante en SharedPreferences con la clave
///      "nexus_remaining_time" (que el servicio Android también lee).
///   3. Restaura el tiempo diario a la medianoche.
///   4. Pide al canal nativo mostrar/ocultar el overlay.
///   5. Escucha el stream de apps en primer plano para reaccionar.

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/platform_channel.dart';
import '../constants/app_constants.dart';
import '../../shared/providers/global_providers.dart';
import 'command_listener_service.dart';
import 'firebase_sync_service.dart';

// ──────────────────────────────────────────────
// ESTADO
// ──────────────────────────────────────────────

class WallState {
  final int remainingSeconds;
  final bool isWallActive;
  final String? currentBlockedApp;
  final bool monitoringEnabled;

  const WallState({
    this.remainingSeconds = AppConstants.defaultDailyTimeMinutes * 60,
    this.isWallActive = false,
    this.currentBlockedApp,
    this.monitoringEnabled = false,
  });

  WallState copyWith({
    int? remainingSeconds,
    bool? isWallActive,
    String? currentBlockedApp,
    bool? monitoringEnabled,
    bool clearBlockedApp = false,
  }) {
    return WallState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isWallActive: isWallActive ?? this.isWallActive,
      currentBlockedApp:
          clearBlockedApp ? null : (currentBlockedApp ?? this.currentBlockedApp),
      monitoringEnabled: monitoringEnabled ?? this.monitoringEnabled,
    );
  }

  /// Minutos restantes (redondeado hacia arriba)
  int get remainingMinutes => (remainingSeconds / 60).ceil();

  /// Formato "H:MM"
  String get remainingFormatted {
    final h = remainingSeconds ~/ 3600;
    final m = (remainingSeconds % 3600) ~/ 60;
    final s = remainingSeconds % 60;
    return h > 0 ? '$h:${m.toString().padLeft(2, '0')}h' : '${m}m ${s}s';
  }
}

// ──────────────────────────────────────────────
// PROVIDER
// ──────────────────────────────────────────────

final wallMonitorProvider =
    StateNotifierProvider<WallMonitorNotifier, WallState>((ref) {
  final platform = ref.read(platformServiceProvider);
  return WallMonitorNotifier(platform, ref);
});

// ──────────────────────────────────────────────
// NOTIFIER
// ──────────────────────────────────────────────

class WallMonitorNotifier extends StateNotifier<WallState> {
  final PlatformChannelService _platform;
  final Ref _ref;

  Timer? _deductTimer;
  Timer? _midnightTimer;
  Timer? _liveStatusTimer;
  StreamSubscription<String>? _appStreamSub;
  bool _blockedAppInForeground = false;

  WallMonitorNotifier(this._platform, this._ref)
      : super(const WallState()) {
    _restoreFromPrefs();
  }

  // ── Inicialización ───────────────────────────

  Future<void> _restoreFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString(AppConstants.keyLastTimeReset);
    final today = _todayKey();

    int remainingSeconds;
    if (lastReset != today) {
      // Nuevo día → resetear tiempo
      final limitMinutes =
          prefs.getInt(AppConstants.keyDailyTimeLimit) ??
          AppConstants.defaultDailyTimeMinutes;
      remainingSeconds = limitMinutes * 60;
      await _persistSeconds(remainingSeconds);
      await prefs.setString(AppConstants.keyLastTimeReset, today);
    } else {
      remainingSeconds = prefs.getInt(AppConstants.keyRemainingTime) ??
          (AppConstants.defaultDailyTimeMinutes * 60);
    }

    state = state.copyWith(remainingSeconds: remainingSeconds);
    _scheduleMidnightReset();
  }

  // ── Activar / Desactivar monitoreo ───────────

  Future<void> startMonitoring() async {
    if (state.monitoringEnabled) return;

    // Iniciar servicio nativo
    await _platform.startMonitorService();

    // Escuchar stream de apps
    _appStreamSub = _platform.foregroundAppStream.listen(
      _onForegroundAppChanged,
      onError: (_) {},
    );

    // Timer de descuento: cada 60s
    _deductTimer = Timer.periodic(
      const Duration(milliseconds: AppConstants.timeDeductionIntervalMs),
      (_) => _deductSecond(),
    );

    // Iniciar listener de comandos del padre
    final cmdListener = CommandListenerService.instance;
    cmdListener.setExecutor(_executeParentCommand);
    cmdListener.start();

    // Reportar estado en vivo al padre cada 30 segundos
    _liveStatusTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _reportLiveStatus(),
    );

    state = state.copyWith(monitoringEnabled: true);
  }

  Future<void> stopMonitoring() async {
    _deductTimer?.cancel();
    _appStreamSub?.cancel();
    _liveStatusTimer?.cancel();
    CommandListenerService.instance.stop();
    state = state.copyWith(monitoringEnabled: false);
    await _platform.stopMonitorService();
  }

  // ── Lógica central ───────────────────────────

  void _onForegroundAppChanged(String packageName) async {
    // Leer blacklist del estado global
    final blacklistAsync = _ref.read(blacklistStreamProvider);
    final blacklist = blacklistAsync.value ?? [];
    final blockedPackages = blacklist.map((a) => a.packageName).toSet();

    _blockedAppInForeground = blockedPackages.contains(packageName);

    if (_blockedAppInForeground && state.remainingSeconds <= 0) {
      await _activateWall(packageName);
    } else if (!_blockedAppInForeground && state.isWallActive) {
      await _deactivateWall();
    } else if (_blockedAppInForeground) {
      state = state.copyWith(currentBlockedApp: packageName);
    }
  }

  void _deductSecond() async {
    if (!_blockedAppInForeground) return;

    final newSeconds = (state.remainingSeconds - 60).clamp(0, 86400);
    state = state.copyWith(remainingSeconds: newSeconds);
    await _persistSeconds(newSeconds);

    if (newSeconds <= 0 && !state.isWallActive) {
      await _activateWall(state.currentBlockedApp);
    }
  }

  Future<void> _activateWall(String? appPackage) async {
    state = state.copyWith(
      isWallActive: true,
      currentBlockedApp: appPackage,
    );
    // El overlay nativo ya lo maneja AppMonitorService.kt
    // Por si el servicio no está corriendo, también lo pedimos desde Flutter:
    await _platform.showBlockOverlay(
      message: 'Sin tiempo disponible.\nCompleta actividades en La Mina para desbloquear.',
    );
  }

  Future<void> _deactivateWall() async {
    state = state.copyWith(
      isWallActive: false,
      clearBlockedApp: true,
    );
    await _platform.hideBlockOverlay();
  }

  // ── Recompensa tiempo ────────────────────────

  /// Añade segundos de recompensa (tras completar una actividad en La Mina)
  Future<void> addTimeReward(int seconds) async {
    final newSeconds = (state.remainingSeconds + seconds).clamp(0, 86400);
    state = state.copyWith(remainingSeconds: newSeconds);
    await _persistSeconds(newSeconds);

    // Si el muro estaba activo y ahora tiene tiempo, ocultarlo
    if (state.isWallActive && newSeconds > 0) {
      await _deactivateWall();
    }
  }

  // ── Configuración parental ───────────────────

  /// Establece el límite diario desde el panel parental (en minutos)
  Future<void> setDailyLimit(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyDailyTimeLimit, minutes);
    // Aplicar inmediatamente al día de hoy
    final newSeconds = minutes * 60;
    state = state.copyWith(remainingSeconds: newSeconds);
    await _persistSeconds(newSeconds);
  }

  // ── Ejecución de comandos del padre ──────────

  /// Callback para CommandListenerService — ejecuta comandos remotos.
  Future<void> _executeParentCommand(
      CommandType type, Map<String, dynamic> payload) async {
    switch (type) {
      case CommandType.setTimeLimit:
        final minutes = payload['minutes'] as int? ?? 60;
        await setDailyLimit(minutes);
        break;

      case CommandType.addTime:
        final minutes = payload['minutes'] as int? ?? 15;
        await addTimeReward(minutes * 60);
        break;

      case CommandType.emergencyLock:
        // Poner tiempo a 0 y activar el muro
        state = state.copyWith(remainingSeconds: 0);
        await _persistSeconds(0);
        await _activateWall('EMERGENCY_LOCK');
        break;

      case CommandType.emergencyUnlock:
        // Restaurar 60 min y desactivar muro
        final prefs = await SharedPreferences.getInstance();
        final limitMinutes =
            prefs.getInt(AppConstants.keyDailyTimeLimit) ??
            AppConstants.defaultDailyTimeMinutes;
        final newSeconds = limitMinutes * 60;
        state = state.copyWith(remainingSeconds: newSeconds);
        await _persistSeconds(newSeconds);
        await _deactivateWall();
        break;

      case CommandType.blockApp:
        final pkg = payload['packageName'] as String? ?? '';
        if (pkg.isNotEmpty) {
          await _addToBlacklist(pkg);
        }
        break;

      case CommandType.unblockApp:
        final pkg = payload['packageName'] as String? ?? '';
        if (pkg.isNotEmpty) {
          await _removeFromBlacklist(pkg);
        }
        break;

      case CommandType.updateBlacklist:
        final packages = (payload['packages'] as List<dynamic>?)
                ?.cast<String>() ??
            [];
        if (packages.isNotEmpty) {
          await _replaceBlacklist(packages);
        }
        break;
    }
  }

  // ── Gestión de blacklist dinámica ────────────

  Future<void> _addToBlacklist(String packageName) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList('nexus_custom_blacklist') ?? [];
    if (!current.contains(packageName)) {
      current.add(packageName);
      await prefs.setStringList('nexus_custom_blacklist', current);
      // Actualizar el servicio nativo
      final allBlocked = [...DefaultBlacklist.all, ...current];
      await _platform.updateBlacklist(allBlocked);
    }
  }

  Future<void> _removeFromBlacklist(String packageName) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList('nexus_custom_blacklist') ?? [];
    current.remove(packageName);
    await prefs.setStringList('nexus_custom_blacklist', current);
    // Actualizar servicio nativo — quitar de defaults también si aplica
    final allBlocked = DefaultBlacklist.all
        .where((p) => p != packageName)
        .toList()
      ..addAll(current);
    await _platform.updateBlacklist(allBlocked);
  }

  Future<void> _replaceBlacklist(List<String> packages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('nexus_custom_blacklist', packages);
    await _platform.updateBlacklist(packages);
  }

  // ── Internos ─────────────────────────────────

  Future<void> _persistSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    // Esta clave la lee el AppMonitorService.kt de Android
    await prefs.setInt(AppConstants.keyRemainingTime, seconds);
  }

  void _scheduleMidnightReset() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final diff = midnight.difference(now);

    _midnightTimer?.cancel();
    _midnightTimer = Timer(diff, () async {
      final prefs = await SharedPreferences.getInstance();
      final limitMinutes =
          prefs.getInt(AppConstants.keyDailyTimeLimit) ??
          AppConstants.defaultDailyTimeMinutes;
      final newSeconds = limitMinutes * 60;
      state = state.copyWith(remainingSeconds: newSeconds);
      await _persistSeconds(newSeconds);
      await prefs.setString(AppConstants.keyLastTimeReset, _todayKey());
      _scheduleMidnightReset(); // Re-agendar para el día siguiente
    });
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  @override
  void dispose() {
    _deductTimer?.cancel();
    _midnightTimer?.cancel();
    _liveStatusTimer?.cancel();
    _appStreamSub?.cancel();
    CommandListenerService.instance.stop();
    super.dispose();
  }

  // ── Live Status Reporting ────────────────────

  /// Reporta el estado actual del dispositivo al padre via Firestore.
  Future<void> _reportLiveStatus() async {
    try {
      await FirebaseSyncService.instance.reportLiveStatus(
        currentApp: state.currentBlockedApp,
        currentAppName: state.currentBlockedApp,
        isBlocked: _blockedAppInForeground,
        remainingSeconds: state.remainingSeconds,
        isWallActive: state.isWallActive,
      );
    } catch (_) {
      // No es crítico
    }
  }
}
