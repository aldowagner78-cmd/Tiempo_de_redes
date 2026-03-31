/// ============================================
/// NEXUS CONTROL - App Constants
/// ============================================
/// Constantes globales: tiempos, claves, notificaciones

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'NEXUS CONTROL';
  static const String appVersion = '1.0.0';

  // Tiempo base diario (en minutos)
  static const int defaultDailyTimeMinutes = 60;
  static const int minDailyTimeMinutes = 15;
  static const int maxDailyTimeMinutes = 240;

  // Intervalos de chequeo (en milisegundos)
  static const int appCheckIntervalMs = 5000;    // 5 segundos
  static const int timeDeductionIntervalMs = 60000; // 1 minuto

  // Bio-Coins por módulo
  static const int coinsForArenaTask = 15;
  static const int coinsForBioFuelTask = 20;
  static const int coinsForCommsTask = 25;
  static const int coinsForLogicTask = 15;
  static const int coinsForMathTask = 10;
  static const int coinsForCodingTask = 30;
  static const int coinsForOverrideTask = 15;
  static const int coinsForNeuroTask = 10;

  // Niveles y XP
  static const int xpPerLevel = 100;
  static const int maxLevel = 50;

  // PIN
  static const int pinLength = 4;
  static const int maxPinAttempts = 3;
  static const int pinLockoutMinutes = 30;

  // Notificaciones (Android)
  static const String notificationChannelId = 'nexus_monitor';
  static const String notificationChannelName = 'Nexus Monitor';
  static const String notificationChannelDescription =
      'Servicio de monitoreo de aplicaciones';

  // SharedPreferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyParentPin = 'parent_pin';
  static const String keyCurrentRole = 'current_role';
  static const String keyDailyTimeLimit = 'daily_time_limit';
  static const String keyRemainingTime = 'remaining_time';
  static const String keyLastTimeReset = 'last_time_reset';
  static const String keyUserLevel = 'user_level';
  static const String keyUserXp = 'user_xp';
  static const String keyBioCoins = 'bio_coins';
}

/// Paquetes en la lista negra por defecto
class DefaultBlacklist {
  DefaultBlacklist._();

  static const List<String> socialMedia = [
    'com.zhiliaoapp.musically',  // TikTok
    'com.ss.android.ugc.trill',  // TikTok Lite
    'com.instagram.android',
    'com.facebook.katana',
    'com.facebook.orca',         // Messenger
    'com.snapchat.android',
    'com.twitter.android',
    'com.pinterest',
    'com.reddit.frontpage',
    'com.whatsapp',
  ];

  static const List<String> videoStreaming = [
    'com.google.android.youtube',
    'com.netflix.mediaclient',
    'tv.twitch.android.app',
    'com.amazon.avod.thirdpartyclient',
  ];

  static const List<String> games = [
    'com.supercell.clashofclans',
    'com.supercell.clashroyale',
    'com.mojang.minecraftpe',
    'com.roblox.client',
    'com.tencent.ig',            // PUBG
    'com.garena.game.freefire',
  ];

  static List<String> get all => [
    ...socialMedia,
    ...videoStreaming,
    ...games,
  ];
}
