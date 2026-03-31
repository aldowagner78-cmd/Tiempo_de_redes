/// ============================================
/// NEXUS CONTROL - Role Selection Screen
/// ============================================
/// Pantalla para seleccionar rol (Padre/Hijo) en el primer uso

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/shared_widgets.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScanlineOverlay(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: AppColors.glowCyan(),
                  ),
                  child: const Icon(
                    Icons.shield,
                    size: 50,
                    color: AppColors.background,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.5, 0.5)),
                
                const SizedBox(height: 32),
                
                // Título
                const Text(
                  'NEXUS CONTROL',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonCyan,
                    letterSpacing: 3,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                
                const SizedBox(height: 8),
                
                const Text(
                  '¿Quién está configurando?',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(delay: 400.ms),
                
                const SizedBox(height: 48),
                
                // Opciones de rol
                Row(
                  children: [
                    // Rol Padre
                    Expanded(
                      child: _RoleCard(
                        title: AppStrings.roleParent,
                        subtitle: 'Configura y controla',
                        icon: Icons.admin_panel_settings,
                        color: AppColors.neonMagenta,
                        onTap: () => _selectRole(context, isParent: true),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Rol Hijo
                    Expanded(
                      child: _RoleCard(
                        title: AppStrings.roleChild,
                        subtitle: 'Completa misiones',
                        icon: Icons.rocket_launch,
                        color: AppColors.neonCyan,
                        onTap: () => _selectRole(context, isParent: false),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .slideY(begin: 0.3),
                
                const Spacer(),
                
                // Nota de seguridad
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.neonYellow,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'El Comandante (padre) configurará un PIN de acceso para el panel de control.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 800.ms),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _selectRole(BuildContext context, {required bool isParent}) {
    Navigator.of(context).pushNamed(
      '/pin',
      arguments: {'isSetup': true, 'isParent': isParent},
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            // Ícono
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Título
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Subtítulo
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
