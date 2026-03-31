/// ============================================
/// NEXUS CONTROL - BioCoin Entity
/// ============================================
/// Sistema de moneda virtual - Bio-Coins

import 'package:isar/isar.dart';

part 'biocoin_entity.g.dart';

/// Tipo de transacción de Bio-Coins
enum TransactionType {
  /// Ganado por completar actividad
  earned,
  /// Gastado para desbloquear tiempo
  spent,
  /// Bonus otorgado por padre
  bonus,
  /// Penalización
  penalty,
}

/// Fuente de la transacción (qué módulo)
enum TransactionSource {
  arena,      // Ejercicio físico
  biofuel,    // Nutrición
  comms,      // Lectura
  logic,      // Lógica/Ingenio
  math,       // Matemáticas
  coding,     // Programación
  neuro,      // Entrenamiento cognitivo
  override,   // Puzzles técnicos
  parent,     // Otorgado por padre
  system,     // Sistema (bonificaciones automáticas)
}

@collection
class BioCoinTransaction {
  Id id = Isar.autoIncrement;
  
  /// ID del usuario dueño
  int userId = 0;
  
  /// Cantidad de Bio-Coins (positivo o negativo)
  int amount = 0;
  
  /// Tipo de transacción
  @Enumerated(EnumType.ordinal)
  TransactionType type = TransactionType.earned;
  
  /// Fuente de la transacción
  @Enumerated(EnumType.ordinal)
  TransactionSource source = TransactionSource.system;
  
  /// Descripción de la transacción
  String description = '';
  
  /// Fecha de la transacción
  DateTime createdAt = DateTime.now();
  
  /// Balance después de la transacción
  int balanceAfter = 0;
  
  /// Metadatos adicionales (JSON serializado)
  String? metadata;
  
  /// ========== STATIC METHODS ==========
  
  /// Crear transacción de ganancia
  static BioCoinTransaction earned({
    required int userId,
    required int amount,
    required TransactionSource source,
    required String description,
    required int currentBalance,
  }) {
    return BioCoinTransaction()
      ..userId = userId
      ..amount = amount
      ..type = TransactionType.earned
      ..source = source
      ..description = description
      ..createdAt = DateTime.now()
      ..balanceAfter = currentBalance + amount;
  }
  
  /// Crear transacción de gasto (convertir a tiempo)
  static BioCoinTransaction spent({
    required int userId,
    required int amount,
    required String description,
    required int currentBalance,
  }) {
    return BioCoinTransaction()
      ..userId = userId
      ..amount = -amount
      ..type = TransactionType.spent
      ..source = TransactionSource.system
      ..description = description
      ..createdAt = DateTime.now()
      ..balanceAfter = currentBalance - amount;
  }
}

/// ============================================
/// Configuración de Tasas de Conversión
/// ============================================
@collection
class BioCoinConfig {
  Id id = Isar.autoIncrement;
  
  /// Bio-Coins requeridos por 1 minuto de tiempo
  int coinsPerMinute = 10;
  
  /// Bio-Coins por 1000 pasos (Arena)
  int coinsPerThousandSteps = 15;
  
  /// Bio-Coins por comida saludable (BioFuel)
  int coinsPerHealthyMeal = 20;
  
  /// Bio-Coins por quiz de lectura correcto (Comms)
  int coinsPerReadingQuiz = 25;
  
  /// Bio-Coins por puzzle resuelto (Logic)
  int coinsPerPuzzle = 15;
  
  /// Bio-Coins por problema matemático (Math)
  int coinsPerMathProblem = 10;
  
  /// Bio-Coins por ejercicio de código (Coding)
  int coinsPerCodingExercise = 30;
  
  /// Multiplicador de racha (bonus por días consecutivos)
  double streakMultiplier = 1.1;
  
  /// Días de racha actual
  int currentStreakDays = 0;
  
  /// Fecha de última actividad (para calcular racha)
  DateTime? lastActivityDate;
  
  /// ========== MÉTODOS ==========
  
  /// Calcular Bio-Coins con multiplicador de racha
  int calculateWithStreak(int baseCoins) {
    if (currentStreakDays <= 1) return baseCoins;
    final multiplier = 1.0 + (currentStreakDays * 0.1).clamp(0, 1.0);
    return (baseCoins * multiplier).round();
  }
  
  /// Convertir Bio-Coins a minutos de tiempo
  int coinsToMinutes(int coins) {
    if (coinsPerMinute <= 0) return 0;
    return coins ~/ coinsPerMinute;
  }
  
  /// Minutos a Bio-Coins requeridos
  int minutesToCoins(int minutes) {
    return minutes * coinsPerMinute;
  }
}
