/// ============================================
/// NEXUS CONTROL - Neuro Screen
/// ============================================
/// Módulo de entrenamiento cognitivo.
/// Juegos mentales que mejoran concentración, memoria
/// y velocidad de procesamiento — y desbloquean tiempo.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../neuro/data/models/cognitive_game_model.dart';
import 'neuro_game_screen.dart';

class NeuroScreen extends ConsumerWidget {
  const NeuroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.moduleNeuro),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          AppStrings.moduleNeuro,
          style: TextStyle(
            color: AppColors.moduleNeuro,
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
                'JUEGOS DE ENTRENAMIENTO',
                style: TextStyle(
                  color: AppColors.neonCyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),

              // Grid de juegos cognitivos
              ...CognitiveGameType.values.map(
                (type) => _buildGameCard(context, type),
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
            AppColors.moduleNeuro.withOpacity(0.15),
            AppColors.background,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.moduleNeuro.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.psychology, color: AppColors.moduleNeuro, size: 48)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(end: 1.1, duration: 2.seconds),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Entrena tu mente',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Completa juegos cognitivos para ganar Bio-Coins y tiempo libre.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, CognitiveGameType type) {
    final info = _gameInfo(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.moduleNeuro.withOpacity(0.25)),
        color: AppColors.surface.withOpacity(0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.moduleNeuro.withOpacity(0.15),
            border: Border.all(color: AppColors.moduleNeuro.withOpacity(0.5)),
          ),
          child: Icon(info['icon'] as IconData, color: AppColors.moduleNeuro, size: 22),
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
              style: TextStyle(
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
            builder: (_) => NeuroGameScreen(gameType: type),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (CognitiveGameType.values.indexOf(type) * 80).ms);
  }

  // _showComingSoon eliminado: cada tipo lanza NeuroGameScreen

  Map<String, dynamic> _gameInfo(CognitiveGameType type) {
    switch (type) {
      case CognitiveGameType.nBack:
        return {
          'icon': Icons.grid_view,
          'title': 'N-Back',
          'description': 'Memoria de trabajo — recuerda patrones pasados',
          'coins': 15,
          'time': 10,
        };
      case CognitiveGameType.stroopTest:
        return {
          'icon': Icons.palette,
          'title': 'Stroop Test',
          'description': 'Control inhibitorio — ignora distracciones',
          'coins': 10,
          'time': 8,
        };
      case CognitiveGameType.dividedAttention:
        return {
          'icon': Icons.copy_all,
          'title': 'Atención Dividida',
          'description': 'Procesa múltiples canales simultáneamente',
          'coins': 20,
          'time': 12,
        };
      case CognitiveGameType.reactionTime:
        return {
          'icon': Icons.bolt,
          'title': 'Tiempo de Reacción',
          'description': 'Velocidad y precisión de respuesta',
          'coins': 8,
          'time': 5,
        };
      case CognitiveGameType.patternMemory:
        return {
          'icon': Icons.pattern,
          'title': 'Memoria de Patrones',
          'description': 'Reproduce secuencias cada vez más largas',
          'coins': 12,
          'time': 8,
        };
      case CognitiveGameType.simonSays:
        return {
          'icon': Icons.speaker,
          'title': 'Simon Says',
          'description': 'Secuencias de colores y sonidos',
          'coins': 10,
          'time': 6,
        };
    }
  }
}
