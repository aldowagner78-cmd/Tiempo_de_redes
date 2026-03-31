/// ============================================
/// NEXUS CONTROL - Blacklist Entity
/// ============================================
/// Entidades para control de apps bloqueadas

import 'package:isar/isar.dart';

part 'blacklist_entity.g.dart';

/// Tipo de control de app
enum AppControlType {
  blocked,       // Completamente bloqueada
  timeLimited,   // Con límite de tiempo
  allowed,       // Permitida sin restricciones
}

@collection
class BlacklistApp {
  Id id = Isar.autoIncrement;
  
  /// Nombre del paquete Android (ej: com.instagram.android)
  @Index(unique: true)
  String packageName = '';
  
  /// Nombre visible de la app
  String appName = '';
  
  /// Tipo de control
  @Enumerated(EnumType.ordinal)
  AppControlType controlType = AppControlType.blocked;
  
  /// Límite diario en minutos (si es timeLimited)
  int dailyLimitMinutes = 30;
  
  /// Tiempo usado hoy
  int timeUsedTodayMinutes = 0;
  
  /// ¿Es app del sistema?
  bool isSystemApp = false;
  
  /// Categoría de la app
  String? category;
  
  /// Fecha de agregado a blacklist
  DateTime createdAt = DateTime.now();
  
  /// Última modificación
  DateTime updatedAt = DateTime.now();
  
  /// ========== MÉTODOS ==========
  
  /// ¿Puede acceder ahora?
  bool canAccess(int availableCoins) {
    switch (controlType) {
      case AppControlType.allowed:
        return true;
      case AppControlType.blocked:
        return false;
      case AppControlType.timeLimited:
        return timeUsedTodayMinutes < dailyLimitMinutes || availableCoins > 0;
    }
  }
  
  /// Tiempo restante en minutos
  @ignore
  int get timeRemainingMinutes {
    if (controlType != AppControlType.timeLimited) return 0;
    final remaining = dailyLimitMinutes - timeUsedTodayMinutes;
    return remaining > 0 ? remaining : 0;
  }
  
  /// Crear app bloqueada
  static BlacklistApp blocked({
    required String packageName,
    required String appName,
  }) {
    return BlacklistApp()
      ..packageName = packageName
      ..appName = appName
      ..controlType = AppControlType.blocked
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
  }
  
  /// Crear app con límite de tiempo
  static BlacklistApp limited({
    required String packageName,
    required String appName,
    required int dailyMinutes,
  }) {
    return BlacklistApp()
      ..packageName = packageName
      ..appName = appName
      ..controlType = AppControlType.timeLimited
      ..dailyLimitMinutes = dailyMinutes
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
  }
}

/// ============================================
/// Categorías predefinidas de apps
/// ============================================
@collection
class AppCategory {
  Id id = Isar.autoIncrement;
  
  /// Nombre de la categoría
  String name = '';
  
  /// Descripción
  String? description;
  
  /// Color hex
  String colorHex = '#FF00FF';
  
  /// Icono (nombre del ícono Material)
  String iconName = 'apps';
  
  /// Tipo de control por defecto
  @Enumerated(EnumType.ordinal)
  AppControlType defaultControlType = AppControlType.blocked;
  
  /// Lista de packages en esta categoría
  List<String> packageNames = [];
}

/// Categorías predefinidas con apps conocidas
class PredefinedCategories {
  static const List<Map<String, String>> socialMedia = [
    {'package': 'com.instagram.android', 'name': 'Instagram'},
    {'package': 'com.facebook.katana', 'name': 'Facebook'},
    {'package': 'com.twitter.android', 'name': 'Twitter/X'},
    {'package': 'com.zhiliaoapp.musically', 'name': 'TikTok'},
    {'package': 'com.snapchat.android', 'name': 'Snapchat'},
    {'package': 'com.whatsapp', 'name': 'WhatsApp'},
  ];
  
  static const List<Map<String, String>> games = [
    {'package': 'com.supercell.clashofclans', 'name': 'Clash of Clans'},
    {'package': 'com.supercell.brawlstars', 'name': 'Brawl Stars'},
    {'package': 'com.kiloo.subwaysurf', 'name': 'Subway Surfers'},
    {'package': 'com.mojang.minecraftpe', 'name': 'Minecraft'},
    {'package': 'com.innersloth.spacemafia', 'name': 'Among Us'},
    {'package': 'com.tencent.ig', 'name': 'PUBG Mobile'},
  ];
  
  static const List<Map<String, String>> streaming = [
    {'package': 'com.google.android.youtube', 'name': 'YouTube'},
    {'package': 'com.netflix.mediaclient', 'name': 'Netflix'},
    {'package': 'com.disney.disneyplus', 'name': 'Disney+'},
    {'package': 'com.amazon.avod.thirdpartyclient', 'name': 'Prime Video'},
    {'package': 'com.spotify.music', 'name': 'Spotify'},
  ];
}
