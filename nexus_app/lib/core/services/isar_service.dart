/// ============================================
/// NEXUS CONTROL - Isar Database Service
/// ============================================
/// Servicio central para la base de datos local Isar
/// Offline-first: todos los datos se guardan localmente

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/biocoins/domain/entities/biocoin_entity.dart';
import '../../features/monitor/domain/entities/blacklist_entity.dart';
import '../../features/monitor/domain/entities/task_entity.dart';
import '../../features/neuro/data/models/cognitive_game_model.dart';
import '../../features/override/data/models/puzzle_record_model.dart';

/// Provider global para el servicio de Isar
final isarServiceProvider = Provider<IsarService>((ref) {
  throw UnimplementedError('IsarService debe ser inicializado antes de usar');
});

/// Provider para la instancia de Isar inicializada
final isarProvider = FutureProvider<Isar>((ref) async {
  return await IsarService.initialize();
});

class IsarService {
  static Isar? _isar;
  
  /// Obtener instancia de Isar (debe estar inicializada)
  static Isar get instance {
    if (_isar == null) {
      throw StateError('Isar no ha sido inicializado. Llama a initialize() primero.');
    }
    return _isar!;
  }
  
  /// Verificar si Isar está inicializado
  static bool get isInitialized => _isar != null;
  
  /// Inicializar Isar con todos los schemas
  static Future<Isar> initialize() async {
    if (_isar != null) return _isar!;
    
    final dir = await getApplicationDocumentsDirectory();
    
    _isar = await Isar.open(
      [
        UserEntitySchema,
        BioCoinTransactionSchema,
        BioCoinConfigSchema,
        BlacklistAppSchema,
        AppCategorySchema,
        TaskEntitySchema,
        TaskTemplateSchema,
        CognitiveGameModelSchema,
        PuzzleRecordModelSchema,
      ],
      directory: dir.path,
      name: 'nexus_control',
      inspector: true, // Habilitar inspector en debug
    );
    
    // Inicializar configuración por defecto si no existe
    await _initializeDefaults();
    
    return _isar!;
  }
  
  /// Inicializar valores por defecto
  static Future<void> _initializeDefaults() async {
    final isar = instance;
    
    // Verificar si existe configuración de Bio-Coins
    final existingConfig = await isar.bioCoinConfigs.where().findFirst();
    if (existingConfig == null) {
      await isar.writeTxn(() async {
        await isar.bioCoinConfigs.put(BioCoinConfig());
      });
    }
    
    // Agregar categorías predefinidas si no existen
    final existingCategories = await isar.appCategorys.count();
    if (existingCategories == 0) {
      await _initializeDefaultCategories();
    }
  }
  
  /// Inicializar categorías predefinidas
  static Future<void> _initializeDefaultCategories() async {
    final isar = instance;
    
    await isar.writeTxn(() async {
      // Redes Sociales
      final socialCategory = AppCategory()
        ..name = 'Redes Sociales'
        ..description = 'Apps de redes sociales'
        ..colorHex = '#FF00FF'
        ..iconName = 'people'
        ..defaultControlType = AppControlType.blocked
        ..packageNames = PredefinedCategories.socialMedia
            .map((e) => e['package'] as String)
            .toList();
      await isar.appCategorys.put(socialCategory);
      
      // Juegos
      final gamesCategory = AppCategory()
        ..name = 'Juegos'
        ..description = 'Videojuegos y apps de entretenimiento'
        ..colorHex = '#FF6B35'
        ..iconName = 'sports_esports'
        ..defaultControlType = AppControlType.timeLimited
        ..packageNames = PredefinedCategories.games
            .map((e) => e['package'] as String)
            .toList();
      await isar.appCategorys.put(gamesCategory);
      
      // Streaming
      final streamingCategory = AppCategory()
        ..name = 'Streaming'
        ..description = 'Plataformas de video y música'
        ..colorHex = '#4D9FFF'
        ..iconName = 'play_circle'
        ..defaultControlType = AppControlType.timeLimited
        ..packageNames = PredefinedCategories.streaming
            .map((e) => e['package'] as String)
            .toList();
      await isar.appCategorys.put(streamingCategory);
    });
  }
  
  /// Cerrar conexión de Isar
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
  
  /// Limpiar todos los datos (para testing o reset)
  static Future<void> clearAll() async {
    final isar = instance;
    await isar.writeTxn(() async {
      await isar.clear();
    });
    await _initializeDefaults();
  }
  
  // ========== REPOSITORIOS DE ACCESO RÁPIDO ==========
  
  /// Colección de usuarios
  static IsarCollection<UserEntity> get users => instance.userEntitys;
  
  /// Colección de transacciones
  static IsarCollection<BioCoinTransaction> get transactions => 
      instance.bioCoinTransactions;
  
  /// Colección de apps en blacklist
  static IsarCollection<BlacklistApp> get blacklist => instance.blacklistApps;
  
  /// Colección de tareas
  static IsarCollection<TaskEntity> get tasks => instance.taskEntitys;
  
  /// Configuración de Bio-Coins
  static Future<BioCoinConfig> getConfig() async {
    final config = await instance.bioCoinConfigs.where().findFirst();
    return config ?? BioCoinConfig();
  }
}
