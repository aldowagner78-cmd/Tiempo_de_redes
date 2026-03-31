import 'package:isar/isar.dart';

part 'puzzle_record_model.g.dart';

@collection
class PuzzleRecordModel {
  Id id = Isar.autoIncrement;

  /// Tipo de puzzle
  @Enumerated(EnumType.name)
  late PuzzleType puzzleType;

  /// ID del puzzle específico
  late String puzzleId;

  /// Nivel de dificultad (1-10)
  late int difficultyLevel;

  /// Si fue completado correctamente
  late bool isCompleted;

  /// Intentos realizados
  late int attempts;

  /// Tiempo para completar en segundos
  late int completionTimeSeconds;

  /// Puntuación obtenida
  late int score;

  /// Bio-Coins ganados
  late int coinsEarned;

  /// XP ganado
  late int xpEarned;

  /// Tiempo extra ganado en segundos
  late int timeEarnedSeconds;

  /// Fecha de completado
  @Index()
  late DateTime completedAt;

  PuzzleRecordModel() {
    completedAt = DateTime.now();
    difficultyLevel = 1;
    isCompleted = false;
    attempts = 0;
    completionTimeSeconds = 0;
    score = 0;
    coinsEarned = 0;
    xpEarned = 0;
    timeEarnedSeconds = 0;
    puzzleId = '';
  }
}

enum PuzzleType {
  logicGate,     // Puertas lógicas AND/OR/NOT
  debugging,     // Encontrar el bug en pseudocódigo
  flowchart,     // Completar diagrama de flujo
  sequenceSort,  // Ordenar pasos de algoritmo
  patternMatch,  // Reconocer patrones
}
