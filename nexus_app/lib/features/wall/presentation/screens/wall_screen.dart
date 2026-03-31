/// ============================================
/// NEXUS CONTROL - Wall Screen
/// ============================================
/// Pantalla de "El Muro" dentro de Flutter.
///
/// Se muestra cuando:
///   - El usuario abre Nexus Control mientras está bloqueado
///   - El usuario pulsa "IR A LA MINA" desde el overlay nativo
///
/// Permite ver cuánto tiempo le queda y navegar directamente a los módulos.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/wall_monitor_notifier.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';

class WallScreen extends ConsumerWidget {
  const WallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallState = ref.watch(wallMonitorProvider);
    final bioCoins = ref.watch(bioCoinBalanceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScanlineOverlay(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // ── Banner de bloqueo ──────────
                  _buildBlockBanner(wallState).animate().fadeIn().slideY(begin: -0.3),

                  const SizedBox(height: 28),

                  // ── Stats de estado ────────────
                  _buildStatusRow(wallState, bioCoins).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 32),

                  // ── Sección "La Mina" ──────────
                  _buildMineSection(context).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 28),

                  // ── Botón modos adicionales ───
                  _buildSecondaryActions(context, ref)
                      .animate()
                      .fadeIn(delay: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Banner principal ─────────────────────────

  Widget _buildBlockBanner(WallState wall) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF3366), width: 2),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF3366).withOpacity(0.12),
            AppColors.background,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3366).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          // Ícono pulsante
          const Text('🔒', style: TextStyle(fontSize: 60))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 1.0, end: 1.15, duration: 1.5.seconds),

          const SizedBox(height: 16),

          const Text(
            '⚠ ACCESO DENEGADO ⚠',
            style: TextStyle(
              color: Color(0xFFFF3366),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            wall.currentBlockedApp != null
                ? 'App bloqueada: ${wall.currentBlockedApp}'
                : 'Tu tiempo de redes sociales se ha agotado.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Tiempo restante
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.surface,
              border: Border.all(
                color: wall.remainingSeconds > 0
                    ? AppColors.neonGreen
                    : const Color(0xFFFF3366),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  color: wall.remainingSeconds > 0
                      ? AppColors.neonGreen
                      : const Color(0xFFFF3366),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  wall.remainingSeconds > 0
                      ? 'Tiempo restante: ${wall.remainingFormatted}'
                      : 'TIEMPO AGOTADO',
                  style: TextStyle(
                    color: wall.remainingSeconds > 0
                        ? AppColors.neonGreen
                        : const Color(0xFFFF3366),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Fila de stats ────────────────────────────

  Widget _buildStatusRow(WallState wall, int bioCoins) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            label: 'Bio-Coins',
            value: '$bioCoins ◈',
            icon: Icons.toll,
            color: AppColors.neonYellow,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            label: 'Tiempo restante',
            value: wall.remainingFormatted,
            icon: Icons.hourglass_bottom,
            color: wall.remainingSeconds > 0
                ? AppColors.neonGreen
                : const Color(0xFFFF3366),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surface,
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 15)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  // ── Sección La Mina ──────────────────────────

  Widget _buildMineSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DESBLOQUEA TIEMPO EN LA MINA',
          style: TextStyle(
            color: AppColors.neonCyan,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Completa una actividad para ganar tiempo libre.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 16),
        _mineGrid(context),
      ],
    );
  }

  Widget _mineGrid(BuildContext context) {
    final modules = [
      _ModuleInfo(
          route: '/arena',
          icon: Icons.fitness_center,
          title: 'Arena',
          subtitle: 'Ejercicio físico',
          color: AppColors.moduleArena,
          reward: '+15min'),
      _ModuleInfo(
          route: '/biofuel',
          icon: Icons.restaurant,
          title: 'Biofuel',
          subtitle: 'Nutrición',
          color: AppColors.moduleBiofuel,
          reward: '+20min'),
      _ModuleInfo(
          route: '/comms',
          icon: Icons.menu_book,
          title: 'Comms',
          subtitle: 'Lectura',
          color: AppColors.moduleComms,
          reward: '+25min'),
      _ModuleInfo(
          route: '/logic',
          icon: Icons.extension,
          title: 'Logic',
          subtitle: 'Ingenio',
          color: AppColors.moduleLogic,
          reward: '+15min'),
      _ModuleInfo(
          route: '/math',
          icon: Icons.calculate,
          title: 'Math',
          subtitle: 'Matemáticas',
          color: AppColors.moduleMath,
          reward: '+10min'),
      _ModuleInfo(
          route: '/coding',
          icon: Icons.code,
          title: 'Coding',
          subtitle: 'Programación',
          color: AppColors.moduleCoding,
          reward: '+30min'),
      _ModuleInfo(
          route: '/neuro',
          icon: Icons.psychology,
          title: 'Neuro',
          subtitle: 'Mente',
          color: AppColors.moduleNeuro,
          reward: '+20min'),
      _ModuleInfo(
          route: '/override',
          icon: Icons.terminal,
          title: 'Override',
          subtitle: 'Puzzles',
          color: AppColors.moduleOverride,
          reward: '+25min'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: modules.length,
      itemBuilder: (ctx, i) {
        final m = modules[i];
        return GestureDetector(
          onTap: () => Navigator.of(ctx).pushNamed(m.route),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.surface,
              border: Border.all(color: m.color.withOpacity(0.4)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(m.icon, color: m.color, size: 26),
                const SizedBox(height: 4),
                Text(m.title,
                    style: TextStyle(
                        color: m.color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                Text(m.reward,
                    style: const TextStyle(
                        color: AppColors.neonGreen, fontSize: 9)),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (i * 60).ms);
      },
    );
  }

  // ── Acciones secundarias ─────────────────────

  Widget _buildSecondaryActions(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Volver al HUD (para ver progreso)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushReplacementNamed('/hud'),
            icon: const Icon(Icons.dashboard, size: 18),
            label: const Text('Ver Panel Principal'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.neonCyan,
              side: const BorderSide(color: AppColors.neonCyan),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Data class interna ──────────────────────────

class _ModuleInfo {
  final String route;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String reward;

  const _ModuleInfo({
    required this.route,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.reward,
  });
}
