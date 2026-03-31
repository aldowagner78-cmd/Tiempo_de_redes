/// ============================================
/// NEXUS CONTROL - HUD Main Screen
/// ============================================
/// Pantalla principal tipo "Nave Espacial" para el modo hijo

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/wall_monitor_notifier.dart';
import '../../../../core/services/daily_mission_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';

class HudMainScreen extends ConsumerStatefulWidget {
  const HudMainScreen({super.key});

  @override
  ConsumerState<HudMainScreen> createState() => _HudMainScreenState();
}

class _HudMainScreenState extends ConsumerState<HudMainScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  StreamSubscription<void>? _wallNavSub;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    // Iniciar monitoreo nativo al entrar al HUD como hijo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wallMonitorProvider.notifier).startMonitoring();
      // Suscribir navegación desde overlay nativo
      final platform = ref.read(platformServiceProvider);
      _wallNavSub = platform.navigateToWallStream.listen((_) {
        if (mounted) Navigator.of(context).pushNamed('/wall');
      });
    });
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _wallNavSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final bioCoins = ref.watch(bioCoinBalanceProvider);
    final wallState = ref.watch(wallMonitorProvider);
    final timeRemaining = wallState.remainingMinutes;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScanlineOverlay(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header con estado del piloto
              SliverToBoxAdapter(
                child: _buildHeader(user?.name ?? 'Piloto', bioCoins, timeRemaining),
              ),
              
              // Barra de tiempo restante
              SliverToBoxAdapter(
                child: _buildTimeBar(timeRemaining, user?.dailyTimeAllowedMinutes ?? 60),
              ),
              
              // Grid de módulos
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildListDelegate([
                    _buildModuleCard(
                      title: AppStrings.moduleArena,
                      description: AppStrings.moduleArenaDesc,
                      icon: Icons.fitness_center,
                      color: AppColors.moduleArena,
                      rewardCoins: 15,
                      onTap: () => _navigateToModule('arena'),
                    ),
                    _buildModuleCard(
                      title: AppStrings.moduleBiofuel,
                      description: AppStrings.moduleBiofuelDesc,
                      icon: Icons.restaurant,
                      color: AppColors.moduleBiofuel,
                      rewardCoins: 20,
                      onTap: () => _navigateToModule('biofuel'),
                    ),
                    _buildModuleCard(
                      title: AppStrings.moduleComms,
                      description: AppStrings.moduleCommsDesc,
                      icon: Icons.menu_book,
                      color: AppColors.moduleComms,
                      rewardCoins: 25,
                      onTap: () => _navigateToModule('comms'),
                    ),
                    _buildModuleCard(
                      title: AppStrings.moduleLogic,
                      description: AppStrings.moduleLogicDesc,
                      icon: Icons.extension,
                      color: AppColors.moduleLogic,
                      rewardCoins: 15,
                      onTap: () => _navigateToModule('logic'),
                    ),
                    _buildModuleCard(
                      title: AppStrings.moduleMath,
                      description: AppStrings.moduleMathDesc,
                      icon: Icons.calculate,
                      color: AppColors.moduleMath,
                      rewardCoins: 10,
                      onTap: () => _navigateToModule('math'),
                    ),
                    _buildModuleCard(
                      title: AppStrings.moduleCoding,
                      description: AppStrings.moduleCodingDesc,
                      icon: Icons.code,
                      color: AppColors.moduleCoding,
                      rewardCoins: 30,
                      onTap: () => _navigateToModule('coding'),
                    ),
                    _buildModuleCard(
                      title: AppStrings.moduleNeuro,
                      description: AppStrings.moduleNeuroDesc,
                      icon: Icons.psychology,
                      color: AppColors.moduleNeuro,
                      rewardCoins: 20,
                      onTap: () => _navigateToModule('neuro'),
                    ),
                    _buildModuleCard(
                      title: AppStrings.moduleOverride,
                      description: AppStrings.moduleOverrideDesc,
                      icon: Icons.terminal,
                      color: AppColors.moduleOverride,
                      rewardCoins: 25,
                      onTap: () => _navigateToModule('override'),
                    ),
                  ]),
                ),
              ),
              
              // Sección de tareas pendientes
              SliverToBoxAdapter(
                child: _buildPendingTasks(),
              ),
              
              // Espacio inferior
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom navigation con efecto neón
      bottomNavigationBar: _buildBottomNav(),
    );
  }
  
  /// Header con info del piloto
  Widget _buildHeader(String name, int bioCoins, int timeRemaining) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Título de bienvenida
          Row(
            children: [
              // Avatar con glow
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: AppColors.glowCyan(intensity: 0.5),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.background,
                  size: 28,
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(end: 1.05, duration: 2.seconds),
              
              const SizedBox(width: 16),
              
              // Nombre y estado
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, $name!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Sistema de misiones activo',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.neonGreen,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bio-Coins display
              BioCoinDisplay(amount: bioCoins),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Panel de estado rápido
          HudPanel(
            borderColor: AppColors.neonCyan,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.timer,
                  value: _formatTime(timeRemaining),
                  label: 'Tiempo',
                  color: timeRemaining > 30 
                      ? AppColors.neonGreen 
                      : timeRemaining > 10 
                          ? AppColors.neonYellow 
                          : AppColors.neonRed,
                ),
                _buildDivider(),
                _buildStatItem(
                  icon: Icons.trending_up,
                  value: '3',
                  label: 'Racha',
                  color: AppColors.neonMagenta,
                ),
                _buildDivider(),
                _buildStatItem(
                  icon: Icons.star,
                  value: '12',
                  label: 'Logros',
                  color: AppColors.neonYellow,
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: -0.2),
        ],
      ),
    );
  }
  
  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.border,
    );
  }
  
  /// Barra de tiempo restante
  Widget _buildTimeBar(int remaining, int total) {
    final percentage = total > 0 ? remaining / total : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TIEMPO DE MISIÓN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              Text(
                _formatTime(remaining),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: percentage > 0.5
                      ? AppColors.neonGreen
                      : percentage > 0.2
                          ? AppColors.neonYellow
                          : AppColors.neonRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          NeonProgressBar(
            value: percentage,
            height: 16,
            showGlow: true,
          ),
          
          if (remaining == 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.neonRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neonRed.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: AppColors.neonRed,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sin tiempo de red - Completa misiones para ganar más',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.neonRed,
                    ),
                  ),
                ],
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .fadeIn()
                .then()
                .shimmer(color: AppColors.neonRed.withOpacity(0.3)),
          ],
        ],
      ),
    );
  }
  
  /// Tarjeta de módulo
  Widget _buildModuleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    int? rewardCoins,
    VoidCallback? onTap,
  }) {
    return ModuleCard(
      title: title,
      description: description,
      icon: icon,
      color: color,
      rewardCoins: rewardCoins,
      onTap: onTap,
    );
  }
  
  /// Sección de tareas pendientes
  Widget _buildPendingTasks() {
    final missions = DailyMissionService.getTodaysMissions();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: HudPanel(
        borderColor: AppColors.neonMagenta,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonMagenta,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonMagenta.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(end: 1.3, duration: 1.seconds),
                const SizedBox(width: 8),
                const Text(
                  'MISIONES DEL DÍA',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonMagenta,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  'Bonus: +${DailyMissionService.totalPossibleReward()} ₿',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.neonYellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            ...missions.map((mission) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildMissionItem(mission),
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMissionItem(DailyMission mission) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(mission.icon, color: AppColors.neonCyan, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  mission.description,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mission.moduleDisplayName,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.neonCyan,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.neonYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '+${mission.reward} ₿',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.neonYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Bottom navigation bar
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.neonCyan.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'HUD', 0, true),
              _buildNavItem(Icons.factory, 'La Mina', 1, false),
              _buildNavItem(Icons.emoji_events, 'Logros', 2, false),
              _buildNavItem(Icons.person, 'Perfil', 3, false),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem(IconData icon, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        ref.read(currentNavIndexProvider.notifier).state = index;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected 
                  ? AppColors.neonCyan.withOpacity(0.1) 
                  : Colors.transparent,
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.neonCyan : AppColors.textSecondary,
              size: 24,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? AppColors.neonCyan : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Formatear tiempo
  String _formatTime(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return '${hours}h ${mins}m';
    }
    return '${minutes}m';
  }
  
  /// Navegar a módulo
  void _navigateToModule(String module) {
    Navigator.of(context).pushNamed('/$module');
  }
}
