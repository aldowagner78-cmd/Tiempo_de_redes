/// ============================================
/// NEXUS CONTROL - Task Entity
/// ============================================
/// Entidad para tareas/misiones configurables por el padre

import 'package:isar/isar.dart';

part 'task_entity.g.dart';

/// Tipo de tarea según módulo
enum TaskModule {
  arena,      // Ejercicio físico
  biofuel,    // Nutrición
  comms,      // Lectura
  logic,      // Lógica/Ingenio
  math,       // Matemáticas
  coding,     // Programación
  custom,     // Tarea personalizada por padre
}

/// Estado de la tarea
enum TaskStatus {
  available,   // Disponible para realizar
  inProgress,  // En progreso
  completed,   // Completada
  verified,    // Verificada por padre (si requiere)
  expired,     // Expiró sin completar
}

/// Frecuencia de la tarea
enum TaskFrequency {
  once,        // Una sola vez
  daily,       // Diaria
  weekly,      // Semanal
  custom,      // Días específicos
}

@collection
class TaskEntity {
  Id id = Isar.autoIncrement;
  
  /// ID del usuario hijo asignado
  int childUserId = 0;
  
  /// Título de la tarea
  String title = '';
  
  /// Descripción detallada
  String? description;
  
  /// Módulo al que pertenece
  @Enumerated(EnumType.ordinal)
  TaskModule module = TaskModule.custom;
  
  /// Estado actual
  @Enumerated(EnumType.ordinal)
  TaskStatus status = TaskStatus.available;
  
  /// Frecuencia de la tarea
  @Enumerated(EnumType.ordinal)
  TaskFrequency frequency = TaskFrequency.daily;
  
  /// Recompensa en Bio-Coins
  int rewardCoins = 10;
  
  /// ¿Requiere verificación del padre?
  bool requiresVerification = false;
  
  /// ========== CONFIGURACIÓN DE META ==========
  
  /// Meta numérica (pasos, problemas, páginas, etc.)
  int? targetValue;
  
  /// Progreso actual hacia la meta
  int currentProgress = 0;
  
  /// Unidad de la meta (pasos, minutos, páginas, etc.)
  String? targetUnit;
  
  /// ========== TIEMPO ==========
  
  /// Fecha de creación
  DateTime createdAt = DateTime.now();
  
  /// Fecha de expiración (si aplica)
  DateTime? expiresAt;
  
  /// Fecha de inicio (para tareas en progreso)
  DateTime? startedAt;
  
  /// Fecha de completado
  DateTime? completedAt;
  
  /// Duración mínima requerida (minutos)
  int? minimumDurationMinutes;
  
  /// ========== VALIDACIÓN ==========
  
  /// ¿Requiere foto de evidencia?
  bool requiresPhoto = false;
  
  /// ¿Requiere ubicación GPS?
  bool requiresLocation = false;
  
  /// ¿Usa sensores del dispositivo?
  bool usesSensors = false;
  
  /// Evidencia fotográfica (path local)
  String? evidencePhotoPath;
  
  /// Datos de sensores (JSON)
  String? sensorData;
  
  /// ========== MÉTODOS DE UTILIDAD ==========
  
  /// Porcentaje de progreso
  @ignore
  double get progressPercentage {
    if (targetValue == null || targetValue == 0) return 0;
    return (currentProgress / targetValue!).clamp(0.0, 1.0);
  }
  
  /// ¿Está la tarea completada?
  @ignore
  bool get isComplete {
    if (targetValue != null) {
      return currentProgress >= targetValue!;
    }
    return status == TaskStatus.completed || status == TaskStatus.verified;
  }
  
  /// ¿Está expirada?
  @ignore
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
  
  /// ¿Puede reclamar recompensa?
  @ignore
  bool get canClaimReward {
    if (!isComplete) return false;
    if (requiresVerification && status != TaskStatus.verified) return false;
    return true;
  }
  
  /// Tiempo restante antes de expirar
  @ignore
  Duration? get timeRemaining {
    if (expiresAt == null) return null;
    final remaining = expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

/// ============================================
/// Plantilla de tareas reutilizables
/// ============================================
@collection
class TaskTemplate {
  Id id = Isar.autoIncrement;
  
  /// Título de la plantilla
  String title = '';
  
  /// Descripción
  String? description;
  
  /// Módulo asociado
  @Enumerated(EnumType.ordinal)
  TaskModule module = TaskModule.custom;
  
  /// Recompensa base
  int baseRewardCoins = 10;
  
  /// Meta base (si aplica)
  int? baseTargetValue;
  
  /// Unidad
  String? targetUnit;
  
  /// ¿Activa por defecto?
  bool isActiveByDefault = true;
}
