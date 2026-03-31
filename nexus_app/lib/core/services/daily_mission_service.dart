/// ============================================
/// NEXUS CONTROL - Daily Mission Service
/// ============================================
/// Sistema de misiones diarias con rotación automática.
/// Genera 5 misiones únicas cada día basándose en la fecha,
/// asegurando variedad entre módulos y tipos de actividad.

import 'package:flutter/material.dart';

/// Módulo fuente de la misión
enum MissionModule {
  arena,
  biofuel,
  comms,
  logic,
  math,
  coding,
  neuro,
  override,
}

/// Misión diaria
class DailyMission {
  final String id;
  final String title;
  final String description;
  final MissionModule module;
  final int targetValue;
  final int reward;
  final IconData icon;

  const DailyMission({
    required this.id,
    required this.title,
    required this.description,
    required this.module,
    required this.targetValue,
    required this.reward,
    required this.icon,
  });

  String get moduleDisplayName {
    switch (module) {
      case MissionModule.arena: return 'Entrenamiento';
      case MissionModule.biofuel: return 'Alimentación';
      case MissionModule.comms: return 'Biblioteca';
      case MissionModule.logic: return 'Ingenio';
      case MissionModule.math: return 'Cálculo';
      case MissionModule.coding: return 'Programación';
      case MissionModule.neuro: return 'Mente';
      case MissionModule.override: return 'Desafíos';
    }
  }
}

class DailyMissionService {
  /// Pool completo de misiones posibles (40+ misiones para buena rotación)
  static final List<DailyMission> _missionPool = [
    // === ENTRENAMIENTO ===
    const DailyMission(
      id: 'arena_steps_1k', title: 'Caminata Ligera',
      description: 'Camina 1000 pasos hoy',
      module: MissionModule.arena, targetValue: 1000, reward: 15, icon: Icons.directions_walk,
    ),
    const DailyMission(
      id: 'arena_steps_3k', title: 'Caminata Intensa',
      description: 'Alcanza 3000 pasos en un día',
      module: MissionModule.arena, targetValue: 3000, reward: 30, icon: Icons.directions_run,
    ),
    const DailyMission(
      id: 'arena_squats_20', title: 'Reto Sentadillas',
      description: 'Haz 20 sentadillas detectadas',
      module: MissionModule.arena, targetValue: 20, reward: 15, icon: Icons.accessibility_new,
    ),
    const DailyMission(
      id: 'arena_balance_60', title: 'Maestro del Equilibrio',
      description: 'Mantén el equilibrio 60 segundos',
      module: MissionModule.arena, targetValue: 60, reward: 20, icon: Icons.balance,
    ),
    const DailyMission(
      id: 'arena_gps_500', title: 'Explorador',
      description: 'Recorre 500 metros con GPS',
      module: MissionModule.arena, targetValue: 500, reward: 25, icon: Icons.gps_fixed,
    ),
    const DailyMission(
      id: 'arena_twists_15', title: 'Giros de Tronco',
      description: 'Haz 15 giros de tronco',
      module: MissionModule.arena, targetValue: 15, reward: 12, icon: Icons.rotate_right,
    ),

    // === ALIMENTACIÓN ===
    const DailyMission(
      id: 'biofuel_scan_3', title: 'Registro Nutricional',
      description: 'Fotografía 3 comidas hoy',
      module: MissionModule.biofuel, targetValue: 3, reward: 20, icon: Icons.camera_alt,
    ),
    const DailyMission(
      id: 'biofuel_healthy_2', title: 'Nutrición Saludable',
      description: 'Registra 2 comidas con score ≥70',
      module: MissionModule.biofuel, targetValue: 2, reward: 25, icon: Icons.eco,
    ),
    const DailyMission(
      id: 'biofuel_fruit', title: 'Come Fruta',
      description: 'Fotografía al menos 1 fruta',
      module: MissionModule.biofuel, targetValue: 1, reward: 15, icon: Icons.local_florist,
    ),

    // === BIBLIOTECA ===
    const DailyMission(
      id: 'comms_scan_5', title: 'Lector Novato',
      description: 'Escanea 5 páginas de un libro',
      module: MissionModule.comms, targetValue: 5, reward: 20, icon: Icons.menu_book,
    ),
    const DailyMission(
      id: 'comms_scan_10', title: 'Lector Avanzado',
      description: 'Escanea 10 páginas hoy',
      module: MissionModule.comms, targetValue: 10, reward: 35, icon: Icons.auto_stories,
    ),
    const DailyMission(
      id: 'comms_scan_3', title: 'Lectura Rápida',
      description: 'Lee al menos 3 páginas',
      module: MissionModule.comms, targetValue: 3, reward: 15, icon: Icons.chrome_reader_mode,
    ),

    // === INGENIO ===
    const DailyMission(
      id: 'logic_solve_3', title: 'Pensador Lógico',
      description: 'Resuelve 3 puzzles de lógica',
      module: MissionModule.logic, targetValue: 3, reward: 20, icon: Icons.extension,
    ),
    const DailyMission(
      id: 'logic_solve_5', title: 'Mente Brillante',
      description: 'Completa 5 puzzles de ingenio',
      module: MissionModule.logic, targetValue: 5, reward: 30, icon: Icons.lightbulb,
    ),
    const DailyMission(
      id: 'logic_pattern', title: 'Detective de Patrones',
      description: 'Resuelve 2 puzzles de patrones',
      module: MissionModule.logic, targetValue: 2, reward: 15, icon: Icons.grid_view,
    ),

    // === CÁLCULO ===
    const DailyMission(
      id: 'math_problems_5', title: 'Calculadora Humana',
      description: 'Resuelve 5 problemas de matemáticas',
      module: MissionModule.math, targetValue: 5, reward: 15, icon: Icons.calculate,
    ),
    const DailyMission(
      id: 'math_problems_10', title: 'Genio Matemático',
      description: 'Resuelve 10 problemas correctamente',
      module: MissionModule.math, targetValue: 10, reward: 25, icon: Icons.functions,
    ),
    const DailyMission(
      id: 'math_streak_5', title: 'Racha Perfecta',
      description: '5 respuestas correctas seguidas',
      module: MissionModule.math, targetValue: 5, reward: 20, icon: Icons.stars,
    ),

    // === PROGRAMACIÓN ===
    const DailyMission(
      id: 'coding_level_1', title: 'Aprendiz Coder',
      description: 'Completa 1 nivel de programación',
      module: MissionModule.coding, targetValue: 1, reward: 20, icon: Icons.code,
    ),
    const DailyMission(
      id: 'coding_level_2', title: 'Programador Junior',
      description: 'Completa 2 niveles de coding',
      module: MissionModule.coding, targetValue: 2, reward: 35, icon: Icons.terminal,
    ),

    // === MENTE ===
    const DailyMission(
      id: 'neuro_games_3', title: 'Entrenador Cerebral',
      description: 'Juega 3 juegos cognitivos',
      module: MissionModule.neuro, targetValue: 3, reward: 20, icon: Icons.psychology,
    ),
    const DailyMission(
      id: 'neuro_games_5', title: 'Maratón Mental',
      description: 'Completa 5 ejercicios de mente',
      module: MissionModule.neuro, targetValue: 5, reward: 30, icon: Icons.neurology,
    ),
    const DailyMission(
      id: 'neuro_memory', title: 'Memoria de Elefante',
      description: 'Completa 2 ejercicios de memoria',
      module: MissionModule.neuro, targetValue: 2, reward: 15, icon: Icons.memory,
    ),

    // === DESAFÍOS ===
    const DailyMission(
      id: 'override_puzzle_1', title: 'Hacker Novato',
      description: 'Resuelve 1 puzzle técnico',
      module: MissionModule.override, targetValue: 1, reward: 25, icon: Icons.security,
    ),
    const DailyMission(
      id: 'override_puzzle_3', title: 'Hacker Experto',
      description: 'Completa 3 desafíos técnicos',
      module: MissionModule.override, targetValue: 3, reward: 45, icon: Icons.shield,
    ),

    // === MIXTAS (bonus variado) ===
    const DailyMission(
      id: 'mixed_modules_3', title: 'Explorador Total',
      description: 'Usa al menos 3 módulos diferentes hoy',
      module: MissionModule.neuro, targetValue: 3, reward: 40, icon: Icons.explore,
    ),
    const DailyMission(
      id: 'mixed_earn_50', title: 'Recolector de Coins',
      description: 'Gana al menos 50 Bio-Coins hoy',
      module: MissionModule.override, targetValue: 50, reward: 20, icon: Icons.monetization_on,
    ),
  ];

  /// Genera las misiones del día actual.
  /// Usa la fecha como seed para rotación determinística.
  /// Garantiza que no se repitan módulos en las 5 misiones.
  static List<DailyMission> getTodaysMissions({DateTime? date}) {
    final today = date ?? DateTime.now();
    // Seed determinístico basado en día del año + año
    final seed = today.year * 1000 + today.month * 32 + today.day;
    
    // Barajar el pool de forma determinística
    final shuffled = List<DailyMission>.from(_missionPool);
    _deterministicShuffle(shuffled, seed);
    
    // Seleccionar 5 misiones asegurando diversidad de módulos
    final selected = <DailyMission>[];
    final usedModules = <MissionModule>{};
    
    // Primero: 1 misión por módulo diferente (hasta 5)
    for (final mission in shuffled) {
      if (selected.length >= 5) break;
      if (!usedModules.contains(mission.module)) {
        selected.add(mission);
        usedModules.add(mission.module);
      }
    }
    
    // Si no llegamos a 5, permitir repetir módulo
    if (selected.length < 5) {
      for (final mission in shuffled) {
        if (selected.length >= 5) break;
        if (!selected.any((m) => m.id == mission.id)) {
          selected.add(mission);
        }
      }
    }
    
    return selected;
  }
  
  /// Shuffle determinístico (Fisher-Yates con seed)
  static void _deterministicShuffle(List<DailyMission> list, int seed) {
    var s = seed;
    for (var i = list.length - 1; i > 0; i--) {
      s = ((s * 1103515245) + 12345) & 0x7fffffff;
      final j = s % (i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }
  
  /// Calcula la recompensa total posible del día
  static int totalPossibleReward({DateTime? date}) {
    return getTodaysMissions(date: date)
        .fold(0, (sum, m) => sum + m.reward);
  }
}
