import 'package:isar/isar.dart';

part 'cognitive_game_model.g.dart';

@collection
class CognitiveGameModel {
  Id id = Isar.autoIncrement;

  /// Tipo de juego cognitivo
  @Enumerated(EnumType.name)
  late CognitiveGameType gameType;

  /// Nivel alcanzado en la sesión
  late int levelReached;

  /// Puntuación final
  late int score;

  /// Mejor racha (streak) en la sesión
  late int bestStreak;

  /// Precisión porcentual (0-100)
  late double accuracy;

  /// Tiempo de reacción promedio en ms
  late int avgReactionTimeMs;

  /// Bio-Coins ganados
  late int coinsEarned;

  /// XP ganado
  late int xpEarned;

  /// Tiempo extra ganado en segundos
  late int timeEarnedSeconds;

  /// Duración de la sesión en segundos
  late int sessionDurationSeconds;

  /// Fecha de completado
  @Index()
  late DateTime completedAt;

  CognitiveGameModel() {
    completedAt = DateTime.now();
    levelReached = 1;
    score = 0;
    bestStreak = 0;
    accuracy = 0;
    avgReactionTimeMs = 0;
    coinsEarned = 0;
    xpEarned = 0;
    timeEarnedSeconds = 0;
    sessionDurationSeconds = 0;
  }
}

enum CognitiveGameType {
  nBack,            // N-Back memory test
  stroopTest,       // Test de Stroop (color vs palabra)
  dividedAttention, // Atención dividida
  reactionTime,     // Tiempo de reacción
  patternMemory,    // Memoria de patrones
  simonSays,        // Simon dice (secuencias de color)
}
