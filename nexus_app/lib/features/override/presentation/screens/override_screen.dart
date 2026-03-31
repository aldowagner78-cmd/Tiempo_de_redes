/// ============================================
/// NEXUS CONTROL - Override Screen
/// ============================================
/// Módulo de desafíos de programación y lógica.
/// Resolver puzzles técnicos desbloquea tiempo y
/// demuestra habilidades de pensamiento computacional.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../override/data/models/puzzle_record_model.dart';
import 'override_puzzle_screen.dart';

class OverrideScreen extends ConsumerWidget {
  const OverrideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.moduleOverride),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          AppStrings.moduleOverride,
          style: TextStyle(
            color: AppColors.moduleOverride,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: BioCoinDisplay(amount: 0),
          ),
        ],
      ),
      body: ScanlineOverlay(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner del módulo
              _buildBanner(context),
              const SizedBox(height: 24),

              // Título sección
              const Text(
                'PUZZLES TÉCNICOS',
                style: TextStyle(
                  color: AppColors.neonCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),

              // Lista de tipos de puzzle
              ...PuzzleType.values.map(
                (type) => _buildPuzzleCard(context, type),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.moduleOverride.withOpacity(0.15),
            AppColors.background,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.moduleOverride.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.terminal, color: AppColors.moduleOverride, size: 48)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(end: 1.1, duration: 2.seconds),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hackea tu mente',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Resuelve puzzles de lógica y programación para ganar Bio-Coins y tiempo libre.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleCard(BuildContext context, PuzzleType type) {
    final info = _puzzleInfo(type);
    final idx = PuzzleType.values.indexOf(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.moduleOverride.withOpacity(0.25)),
        color: AppColors.surface.withOpacity(0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.moduleOverride.withOpacity(0.15),
            border: Border.all(color: AppColors.moduleOverride.withOpacity(0.5)),
          ),
          child: Icon(info['icon'] as IconData,
              color: AppColors.moduleOverride, size: 22),
        ),
        title: Text(
          info['title'] as String,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          info['description'] as String,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '+${info['coins']} ◈',
              style: const TextStyle(
                color: AppColors.neonYellow,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '+${info['time']}min',
              style: const TextStyle(color: AppColors.neonGreen, fontSize: 11),
            ),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OverridePuzzleScreen(puzzleType: type),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (idx * 80).ms);
  }

  // _showComingSoon eliminado: cada tipo lanza OverridePuzzleScreen

  Map<String, dynamic> _puzzleInfo(PuzzleType type) {
    switch (type) {
      case PuzzleType.logicGate:
        return {
          'icon': Icons.device_hub,
          'title': 'Compuertas Lógicas',
          'description': 'AND, OR, NOT — diseña circuitos de verdad',
          'coins': 20,
          'time': 15,
        };
      case PuzzleType.debugging:
        return {
          'icon': Icons.bug_report,
          'title': 'Debugging',
          'description': 'Encuentra y corrige errores en código',
          'coins': 25,
          'time': 20,
        };
      case PuzzleType.flowchart:
        return {
          'icon': Icons.account_tree,
          'title': 'Diagramas de Flujo',
          'description': 'Diseña algoritmos con estructuras de control',
          'coins': 15,
          'time': 12,
        };
      case PuzzleType.sequenceSort:
        return {
          'icon': Icons.sort,
          'title': 'Ordenamiento de Secuencias',
          'description': 'Ordena algoritmos paso a paso correctamente',
          'coins': 15,
          'time': 10,
        };
      case PuzzleType.patternMatch:
        return {
          'icon': Icons.pattern,
          'title': 'Reconocimiento de Patrones',
          'description': 'Identifica reglas en secuencias de datos',
          'coins': 18,
          'time': 12,
        };
    }
  }
}
