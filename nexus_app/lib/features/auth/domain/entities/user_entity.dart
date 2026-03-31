/// ============================================
/// NEXUS CONTROL - User Entity
/// ============================================
/// Entidad de usuario con roles (Padre/Hijo)

import 'package:isar/isar.dart';

part 'user_entity.g.dart';

/// Roles disponibles en la aplicación
enum UserRole {
  /// Padre/Comandante - Control total
  parent,
  /// Hijo/Piloto - Solo puede realizar actividades
  child,
}

@collection
class UserEntity {
  Id id = Isar.autoIncrement;
  
  /// Nombre del usuario
  String name = '';
  
  /// Avatar (índice de avatar predefinido)
  int avatarIndex = 0;
  
  /// Rol del usuario
  @Enumerated(EnumType.ordinal)
  UserRole role = UserRole.child;
  
  /// PIN de acceso (hash SHA256)
  String? pinHash;
  
  /// Fecha de creación
  DateTime createdAt = DateTime.now();
  
  /// Última actividad
  DateTime? lastActiveAt;
  
  /// ¿Es el usuario actualmente activo?
  bool isActive = false;
  
  /// Configuración específica del hijo
  /// Tiempo diario permitido en minutos (configurado por padre)
  int dailyTimeAllowedMinutes = 60;
  
  /// Tiempo usado hoy en minutos
  int timeUsedTodayMinutes = 0;
  
  /// Bio-Coins actuales
  int bioCoins = 0;
  
  /// Bio-Coins totales ganados históricos
  int totalBioCoinsEarned = 0;
  
  /// Última fecha de reseteo de tiempo diario
  DateTime? lastDailyReset;
  
  /// ========== MÉTODOS DE UTILIDAD ==========
  
  /// Tiempo restante en minutos
  @ignore
  int get timeRemainingMinutes {
    final remaining = dailyTimeAllowedMinutes - timeUsedTodayMinutes;
    return remaining > 0 ? remaining : 0;
  }
  
  /// Porcentaje de tiempo usado
  @ignore
  double get timeUsedPercentage {
    if (dailyTimeAllowedMinutes == 0) return 1.0;
    return timeUsedTodayMinutes / dailyTimeAllowedMinutes;
  }
  
  /// ¿Tiene tiempo disponible?
  @ignore
  bool get hasTimeRemaining => timeRemainingMinutes > 0;
  
  /// ¿Puede acceder a apps bloqueadas?
  @ignore
  bool get canAccessBlockedApps => hasTimeRemaining || bioCoins > 0;
  
  /// Crear usuario padre
  static UserEntity parent({
    required String name,
    required String pinHash,
  }) {
    return UserEntity()
      ..name = name
      ..role = UserRole.parent
      ..pinHash = pinHash
      ..createdAt = DateTime.now()
      ..isActive = true;
  }
  
  /// Crear usuario hijo
  static UserEntity child({
    required String name,
    int dailyTimeMinutes = 60,
  }) {
    return UserEntity()
      ..name = name
      ..role = UserRole.child
      ..createdAt = DateTime.now()
      ..dailyTimeAllowedMinutes = dailyTimeMinutes
      ..isActive = false;
  }
}
