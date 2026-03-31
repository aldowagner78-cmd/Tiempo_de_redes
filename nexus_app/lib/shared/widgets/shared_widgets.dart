/// ============================================
/// NEXUS CONTROL - Shared Widgets
/// ============================================
/// Widgets reutilizables con estética cyberpunk

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// ========================================
/// NeonButton - Botón con efecto neón
/// ========================================
class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  
  const NeonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = AppColors.neonCyan,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 52,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: onPressed != null ? [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ] : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.background,
          disabledBackgroundColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.background,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// ========================================
/// HudPanel - Panel con borde cyberpunk
/// ========================================
class HudPanel extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final EdgeInsets padding;
  final bool showCorners;
  final double? width;
  final double? height;
  
  const HudPanel({
    super.key,
    required this.child,
    this.borderColor = AppColors.neonCyan,
    this.padding = const EdgeInsets.all(16),
    this.showCorners = true,
    this.width,
    this.height,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Contenido principal
          Padding(
            padding: padding,
            child: child,
          ),
          
          // Esquinas decorativas
          if (showCorners) ...[
            // Esquina superior izquierda
            Positioned(
              top: 0,
              left: 0,
              child: _buildCorner(borderColor, topLeft: true),
            ),
            // Esquina superior derecha
            Positioned(
              top: 0,
              right: 0,
              child: _buildCorner(borderColor, topRight: true),
            ),
            // Esquina inferior izquierda
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildCorner(borderColor, bottomLeft: true),
            ),
            // Esquina inferior derecha
            Positioned(
              bottom: 0,
              right: 0,
              child: _buildCorner(borderColor, bottomRight: true),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildCorner(Color color, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: 12,
      height: 12,
      child: CustomPaint(
        painter: _CornerPainter(
          color: color,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;
  
  _CornerPainter({
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    
    if (topLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (topRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (bottomRight) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ========================================
/// NeonProgressBar - Barra de progreso neón
/// ========================================
class NeonProgressBar extends StatelessWidget {
  final double value; // 0.0 - 1.0
  final double height;
  final Color? color;
  final bool showGlow;
  final bool animate;
  
  const NeonProgressBar({
    super.key,
    required this.value,
    this.height = 12,
    this.color,
    this.showGlow = true,
    this.animate = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? _getColorForValue(value);
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(
          color: progressColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Stack(
          children: [
            // Barra de progreso
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      progressColor.withOpacity(0.8),
                      progressColor,
                    ],
                  ),
                  boxShadow: showGlow ? [
                    BoxShadow(
                      color: progressColor.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ] : null,
                ),
              ),
            )
                .animate(onPlay: (c) => animate ? c.repeat() : null)
                .shimmer(
                  duration: 2.seconds,
                  color: Colors.white.withOpacity(0.2),
                ),
          ],
        ),
      ),
    );
  }
  
  Color _getColorForValue(double val) {
    if (val > 0.5) return AppColors.neonGreen;
    if (val > 0.2) return AppColors.neonYellow;
    return AppColors.neonRed;
  }
}

/// ========================================
/// BioCoinDisplay - Muestra de Bio-Coins
/// ========================================
class BioCoinDisplay extends StatelessWidget {
  final int amount;
  final double size;
  final bool showLabel;
  
  const BioCoinDisplay({
    super.key,
    required this.amount,
    this.size = 24,
    this.showLabel = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ícono de moneda
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.coinGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '₿',
              style: TextStyle(
                fontSize: size * 0.6,
                fontWeight: FontWeight.bold,
                color: AppColors.background,
              ),
            ),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .shimmer(
              duration: 3.seconds,
              color: Colors.white.withOpacity(0.3),
            ),
        
        const SizedBox(width: 8),
        
        // Cantidad
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amount.toString(),
              style: TextStyle(
                fontSize: size * 0.8,
                fontWeight: FontWeight.bold,
                color: AppColors.neonYellow,
              ),
            ),
            if (showLabel)
              Text(
                'Bio-Coins',
                style: TextStyle(
                  fontSize: size * 0.4,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// ========================================
/// ModuleCard - Tarjeta de módulo hexagonal
/// ========================================
class ModuleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final int? rewardCoins;
  final bool isLocked;
  
  const ModuleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onTap,
    this.rewardCoins,
    this.isLocked = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLocked ? AppColors.textDisabled : color.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: isLocked ? null : [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLocked 
                    ? AppColors.textDisabled.withOpacity(0.2)
                    : color.withOpacity(0.2),
                border: Border.all(
                  color: isLocked ? AppColors.textDisabled : color,
                  width: 2,
                ),
              ),
              child: Icon(
                isLocked ? Icons.lock : icon,
                color: isLocked ? AppColors.textDisabled : color,
                size: 28,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Título
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isLocked ? AppColors.textDisabled : AppColors.textPrimary,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 4),
            
            // Descripción
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Recompensa
            if (rewardCoins != null && !isLocked) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 12,
                      color: AppColors.neonYellow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+$rewardCoins',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neonYellow,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

/// ========================================
/// ScanlineOverlay - Efecto de líneas de escaneo
/// ========================================
class ScanlineOverlay extends StatelessWidget {
  final Widget child;
  final double opacity;
  
  const ScanlineOverlay({
    super.key,
    required this.child,
    this.opacity = 0.03,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _ScanlinePainter(opacity: opacity),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  final double opacity;
  
  _ScanlinePainter({required this.opacity});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(opacity)
      ..strokeWidth = 1;
    
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
