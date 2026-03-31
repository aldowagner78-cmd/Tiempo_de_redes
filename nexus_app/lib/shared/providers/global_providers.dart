/// ============================================
/// NEXUS CONTROL - Global Providers
/// ============================================
/// Providers globales de Riverpod para la aplicación

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/services/isar_service.dart';
import '../../core/utils/platform_channel.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/biocoins/domain/entities/biocoin_entity.dart';
import '../../features/monitor/domain/entities/blacklist_entity.dart';
import '../../features/monitor/domain/entities/task_entity.dart';

// ========== SERVICIOS CORE ==========

/// Provider para el servicio de canales de plataforma
final platformServiceProvider = Provider<PlatformChannelService>((ref) {
  return PlatformChannelService();
});

// ========== ESTADO DE USUARIO ==========

/// Usuario actualmente logueado (null si no hay sesión)
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, UserEntity?>((ref) {
  return CurrentUserNotifier();
});

class CurrentUserNotifier extends StateNotifier<UserEntity?> {
  CurrentUserNotifier() : super(null);
  
  void setUser(UserEntity user) {
    state = user;
  }
  
  void clearUser() {
    state = null;
  }
  
  void updateBioCoins(int newBalance) {
    if (state != null) {
      state = state!..bioCoins = newBalance;
    }
  }
  
  void updateTimeUsed(int minutesUsed) {
    if (state != null) {
      state = state!..timeUsedTodayMinutes = minutesUsed;
    }
  }
}

/// ¿Es el usuario actual un padre?
final isParentProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role == UserRole.parent;
});

/// ¿Es el usuario actual un hijo?
final isChildProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role == UserRole.child;
});

// ========== BIO-COINS ==========

/// Balance actual de Bio-Coins
final bioCoinBalanceProvider = Provider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.bioCoins ?? 0;
});

/// Tiempo restante en minutos
final timeRemainingProvider = Provider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.timeRemainingMinutes ?? 0;
});

/// Configuración de Bio-Coins
final bioCoinConfigProvider = FutureProvider<BioCoinConfig>((ref) async {
  return await IsarService.getConfig();
});

// ========== MONITOREO DE APPS ==========

/// Estado del servicio de monitoreo
final monitoringActiveProvider = StateProvider<bool>((ref) => false);

/// App actualmente en primer plano
final foregroundAppProvider = StateProvider<String?>((ref) => null);

/// Lista de apps bloqueadas
final blacklistProvider = FutureProvider<List<BlacklistApp>>((ref) async {
  final isar = IsarService.instance;
  return (await isar.blacklistApps.getAll([])).whereType<BlacklistApp>().toList();
});

/// Stream de apps bloqueadas (para actualizaciones en tiempo real)
final blacklistStreamProvider = StreamProvider<List<BlacklistApp>>((ref) {
  final isar = IsarService.instance;
  return isar.blacklistApps.where().watch(fireImmediately: true);
});

// ========== TAREAS ==========

/// Proveedor de tareas del hijo actual
final childTasksProvider = FutureProvider<List<TaskEntity>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.child) return [];
  
  final isar = IsarService.instance;
  return await isar.taskEntitys
      .filter()
      .childUserIdEqualTo(user.id)
      .statusEqualTo(TaskStatus.available)
      .or()
      .statusEqualTo(TaskStatus.inProgress)
      .findAll();
});

/// Tareas disponibles hoy
final availableTasksProvider = Provider<AsyncValue<List<TaskEntity>>>((ref) {
  return ref.watch(childTasksProvider);
});

/// Conteo de tareas completadas hoy
final completedTasksTodayProvider = FutureProvider<int>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return 0;
  
  final isar = IsarService.instance;
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  
  return await isar.taskEntitys
      .filter()
      .childUserIdEqualTo(user.id)
      .statusEqualTo(TaskStatus.completed)
      .completedAtGreaterThan(startOfDay)
      .count();
});

// ========== PERMISOS ==========

/// Estado de permisos especiales
final permissionsStateProvider = StateNotifierProvider<PermissionsNotifier, PermissionsState>((ref) {
  return PermissionsNotifier(ref.read(platformServiceProvider));
});

class PermissionsState {
  final bool hasUsageStats;
  final bool hasOverlay;
  final bool isDeviceOwner;
  
  const PermissionsState({
    this.hasUsageStats = false,
    this.hasOverlay = false,
    this.isDeviceOwner = false,
  });
  
  bool get allGranted => hasUsageStats && hasOverlay;
  
  PermissionsState copyWith({
    bool? hasUsageStats,
    bool? hasOverlay,
    bool? isDeviceOwner,
  }) {
    return PermissionsState(
      hasUsageStats: hasUsageStats ?? this.hasUsageStats,
      hasOverlay: hasOverlay ?? this.hasOverlay,
      isDeviceOwner: isDeviceOwner ?? this.isDeviceOwner,
    );
  }
}

class PermissionsNotifier extends StateNotifier<PermissionsState> {
  final PlatformChannelService _platformService;
  
  PermissionsNotifier(this._platformService) : super(const PermissionsState());
  
  Future<void> checkAll() async {
    final usageStats = await _platformService.hasUsageStatsPermission();
    final overlay = await _platformService.hasOverlayPermission();
    final deviceOwner = await _platformService.isDeviceOwner();
    
    state = PermissionsState(
      hasUsageStats: usageStats,
      hasOverlay: overlay,
      isDeviceOwner: deviceOwner,
    );
  }
  
  Future<void> requestUsageStats() async {
    await _platformService.requestUsageStatsPermission();
  }
  
  Future<void> requestOverlay() async {
    await _platformService.requestOverlayPermission();
  }
}

// ========== NAVEGACIÓN ==========

/// Índice actual del bottom navigation
final currentNavIndexProvider = StateProvider<int>((ref) => 0);

/// ¿Está mostrando el overlay de bloqueo?
final isBlockedProvider = StateProvider<bool>((ref) => false);
