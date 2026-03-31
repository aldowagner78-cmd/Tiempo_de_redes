/// ============================================
/// NEXUS CONTROL - Anti-Cheat Validation Service
/// ============================================
/// Valida que los datos de los sensores sean legítimos
/// y no generados por sacudir el teléfono o apps falsas.
///
/// Estrategias:
/// 1. Ritmo de pasos: humano real ~1.5-3 pasos/seg, no 50/seg
/// 2. Aceleración: patrón válido vs. sacudida aleatoria
/// 3. GPS: velocidad coherente (no teletransporte)
/// 4. Cooldowns: no puede completar todo en 1 minuto
/// 5. Sesión máxima: limita ganancia por sesión

import 'dart:math';
import 'parent_alert_service.dart';

/// Resultado de validación
class ValidationResult {
  final bool isValid;
  final String? reason;
  final double confidenceScore; // 0.0 = trampa clara, 1.0 = legítimo
  
  const ValidationResult({
    required this.isValid,
    this.reason,
    this.confidenceScore = 1.0,
  });
  
  static const valid = ValidationResult(isValid: true);
}

class AntiCheatService {
  AntiCheatService._();
  static final AntiCheatService instance = AntiCheatService._();
  
  // === Tracking de sesión ===
  DateTime? _sessionStart;
  int _totalCoinsThisSession = 0;
  final List<DateTime> _stepTimestamps = [];
  final List<double> _recentMagnitudes = [];
  
  // === Límites configurables ===
  static const int maxCoinsPerSession = 200;
  static const int maxStepsPerMinute = 200; // ~3.3 pasos/seg máx
  static const double maxSpeedKmh = 35; // Velocidad máx real (correr rápido)
  static const int minSessionSeconds = 30; // Mínimo 30s para ganar coins
  static const int maxShakesPerMinute = 300;
  
  /// Inicia una nueva sesión de ejercicio
  void startSession() {
    _sessionStart = DateTime.now();
    _totalCoinsThisSession = 0;
    _stepTimestamps.clear();
    _recentMagnitudes.clear();
  }
  
  /// Registra un paso para validación posterior
  void recordStep() {
    _stepTimestamps.add(DateTime.now());
    // Solo guardar los últimos 200 timestamps
    if (_stepTimestamps.length > 200) {
      _stepTimestamps.removeAt(0);
    }
  }
  
  /// Registra una lectura de acelerómetro
  void recordAccelerometer(double magnitude) {
    _recentMagnitudes.add(magnitude);
    if (_recentMagnitudes.length > 100) {
      _recentMagnitudes.removeAt(0);
    }
  }
  
  /// Valida pasos: ¿el ritmo es humano?
  ValidationResult validateSteps(int steps) {
    if (_stepTimestamps.length < 10) {
      return ValidationResult.valid; // Muy pocos datos para detectar
    }
    
    // Calcular pasos por minuto
    final window = _stepTimestamps.last.difference(_stepTimestamps.first);
    if (window.inSeconds < 5) return ValidationResult.valid;
    
    final stepsPerMinute = (_stepTimestamps.length / window.inMinutes.clamp(1, 999)) * 60;
    
    if (stepsPerMinute > maxStepsPerMinute) {
      _alertCheat('Ritmo de pasos sospechoso: ${stepsPerMinute.round()}/min');
      return ValidationResult(
        isValid: false,
        reason: 'Ritmo de pasos demasiado rápido (${stepsPerMinute.round()}/min)',
        confidenceScore: 0.2,
      );
    }
    
    return ValidationResult.valid;
  }
  
  /// Valida que el acelerómetro muestre un patrón humano
  /// (no sacudida caótica constante)
  ValidationResult validateAccelerometerPattern() {
    if (_recentMagnitudes.length < 20) return ValidationResult.valid;
    
    // Un patrón humano tiene varianza, pero no extrema
    final mean = _recentMagnitudes.reduce((a, b) => a + b) / _recentMagnitudes.length;
    final variance = _recentMagnitudes.map((m) => (m - mean) * (m - mean))
        .reduce((a, b) => a + b) / _recentMagnitudes.length;
    final stdDev = sqrt(variance);
    
    // Sacudir el teléfono aleatoriamente genera stdDev muy alta
    if (stdDev > 15) {
      _alertCheat('Patrón de acelerómetro sospechoso (sacudida)');
      return ValidationResult(
        isValid: false,
        reason: 'Movimiento detectado como sacudida artificial',
        confidenceScore: 0.1,
      );
    }
    
    // Si todas las lecturas son iguales (simulado), stdDev sería ~0
    if (stdDev < 0.1 && _recentMagnitudes.length > 50) {
      _alertCheat('Acelerómetro sin varianza (posible simulador)');
      return ValidationResult(
        isValid: false,
        reason: 'Datos de sensor sin variación natural',
        confidenceScore: 0.15,
      );
    }
    
    return ValidationResult.valid;
  }
  
  /// Valida velocidad GPS (no teletransporte)
  ValidationResult validateGPSSpeed(double speedMs) {
    final speedKmh = speedMs * 3.6;
    
    if (speedKmh > maxSpeedKmh) {
      _alertCheat('Velocidad GPS sospechosa: ${speedKmh.round()} km/h');
      return ValidationResult(
        isValid: false,
        reason: 'Velocidad GPS sospechosa: ${speedKmh.round()} km/h',
        confidenceScore: 0.3,
      );
    }
    
    return ValidationResult.valid;
  }
  
  /// Valida que no se ganen demasiados coins
  ValidationResult validateCoinsEarned(int newCoins) {
    _totalCoinsThisSession += newCoins;
    
    if (_totalCoinsThisSession > maxCoinsPerSession) {
      _alertCheat('Exceso de coins en sesión: $_totalCoinsThisSession');
      return ValidationResult(
        isValid: false,
        reason: 'Límite de coins por sesión alcanzado ($maxCoinsPerSession)',
        confidenceScore: 0.5,
      );
    }
    
    return ValidationResult.valid;
  }
  
  /// Valida duración mínima de sesión
  ValidationResult validateSessionDuration() {
    if (_sessionStart == null) return ValidationResult.valid;
    
    final elapsed = DateTime.now().difference(_sessionStart!);
    if (elapsed.inSeconds < minSessionSeconds) {
      return ValidationResult(
        isValid: false,
        reason: 'Sesión muy corta (${elapsed.inSeconds}s). Mínimo: ${minSessionSeconds}s',
        confidenceScore: 0.4,
      );
    }
    
    return ValidationResult.valid;
  }
  
  /// Aplica todas las validaciones y retorna el multiplicador
  /// de recompensa (0.0 = trampa, 1.0 = legítimo)
  double getRewardMultiplier(int steps, int coins) {
    double multiplier = 1.0;
    
    final stepCheck = validateSteps(steps);
    if (!stepCheck.isValid) multiplier *= stepCheck.confidenceScore;
    
    final accelCheck = validateAccelerometerPattern();
    if (!accelCheck.isValid) multiplier *= accelCheck.confidenceScore;
    
    final coinCheck = validateCoinsEarned(coins);
    if (!coinCheck.isValid) multiplier *= coinCheck.confidenceScore;
    
    final sessionCheck = validateSessionDuration();
    if (!sessionCheck.isValid) multiplier *= sessionCheck.confidenceScore;
    
    return multiplier.clamp(0.0, 1.0);
  }
  
  void _alertCheat(String detail) {
    ParentAlertService.instance.notifyCheatAttempt(detail);
  }
}
