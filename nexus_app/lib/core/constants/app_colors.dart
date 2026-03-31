/// ============================================
/// NEXUS CONTROL - App Colors (Cyberpunk Theme)
/// ============================================
/// Paleta de colores con estética cyberpunk/espacial
/// Dark mode con acentos neón (cyan, magenta, amarillo)

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========== COLORES BASE ==========
  /// Fondo principal oscuro (casi negro con tinte azul)
  static const Color background = Color(0xFF0A0E17);
  
  /// Fondo secundario (paneles, cards)
  static const Color surface = Color(0xFF141B2D);
  
  /// Fondo elevado (modales, overlays)
  static const Color surfaceElevated = Color(0xFF1A2332);
  
  /// Bordes y líneas sutiles
  static const Color border = Color(0xFF2A3A50);

  // ========== COLORES NEÓN PRIMARIOS ==========
  /// Cyan neón - Color principal de la UI
  static const Color neonCyan = Color(0xFF00F5FF);
  
  /// Magenta neón - Alertas y destacados
  static const Color neonMagenta = Color(0xFFFF00FF);
  
  /// Verde neón - Éxito, Bio-Coins ganados
  static const Color neonGreen = Color(0xFF00FF88);
  
  /// Amarillo neón - Advertencias, tiempo bajo
  static const Color neonYellow = Color(0xFFFFE600);
  
  /// Rojo neón - Errores, bloqueos
  static const Color neonRed = Color(0xFFFF3366);
  
  /// Naranja neón - Energía, ejercicio
  static const Color neonOrange = Color(0xFFFF6B35);

  // ========== COLORES DE TEXTO ==========
  /// Texto principal (blanco con opacidad)
  static const Color textPrimary = Color(0xFFE8E8E8);
  
  /// Texto secundario
  static const Color textSecondary = Color(0xFF8899AA);
  
  /// Texto deshabilitado
  static const Color textDisabled = Color(0xFF4A5568);

  // ========== COLORES POR MÓDULO ==========
  /// Arena (Ejercicio) - Naranja energético
  static const Color moduleArena = Color(0xFFFF6B35);
  
  /// Alimentación (Nutrición) - Verde salud
  static const Color moduleBiofuel = Color(0xFF00FF88);
  
  /// Biblioteca (Lectura) - Azul conocimiento
  static const Color moduleComms = Color(0xFF4D9FFF);
  
  /// Ingenio (Puzzles) - Púrpura mental
  static const Color moduleLogic = Color(0xFFB24BF3);
  
  /// Cálculo (Matemáticas) - Cyan precisión
  static const Color moduleMath = Color(0xFF00F5FF);
  
  /// Programación - Verde terminal
  static const Color moduleCoding = Color(0xFF39FF14);
  static const Color moduleNeuro = Color(0xFFFF00FF);
  static const Color moduleOverride = Color(0xFFFF6B35);

  // ========== GRADIENTES ==========
  /// Gradiente principal para headers/botones importantes
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonCyan, neonMagenta],
  );
  
  /// Gradiente de Bio-Coins
  static const LinearGradient coinGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
  );
  
  /// Gradiente de tiempo restante (verde a rojo)
  static LinearGradient timeGradient(double percentage) {
    if (percentage > 0.5) {
      return const LinearGradient(
        colors: [neonGreen, neonCyan],
      );
    } else if (percentage > 0.2) {
      return const LinearGradient(
        colors: [neonYellow, neonOrange],
      );
    } else {
      return const LinearGradient(
        colors: [neonOrange, neonRed],
      );
    }
  }

  // ========== EFECTOS DE BRILLO (GLOW) ==========
  /// Sombra con efecto neón cyan
  static List<BoxShadow> glowCyan({double intensity = 1.0}) => [
    BoxShadow(
      color: neonCyan.withOpacity(0.3 * intensity),
      blurRadius: 20 * intensity,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: neonCyan.withOpacity(0.1 * intensity),
      blurRadius: 40 * intensity,
      spreadRadius: 5,
    ),
  ];
  
  /// Sombra con efecto neón para módulos
  static List<BoxShadow> glowModule(Color color, {double intensity = 1.0}) => [
    BoxShadow(
      color: color.withOpacity(0.4 * intensity),
      blurRadius: 15 * intensity,
      spreadRadius: 1,
    ),
  ];
}
