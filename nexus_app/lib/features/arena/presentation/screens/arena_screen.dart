/// ============================================
/// NEXUS CONTROL - Entrenamiento Module Screen
/// ============================================
/// Módulo de ejercicio físico - "Entrenamiento"
/// Valida pasos, ejercicios y actividad física

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/biocoin_service.dart';
import '../../../../core/services/parent_alert_service.dart';
import '../../../../core/services/anti_cheat_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../features/biocoins/domain/entities/biocoin_entity.dart';

class ArenaScreen extends ConsumerStatefulWidget {
  const ArenaScreen({super.key});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen>
    with SingleTickerProviderStateMixin {
  // Estado del ejercicio
  bool _isExercising = false;
  int _steps = 0;
  int _targetSteps = 1000;
  int _calories = 0;
  int _shakeCount = 0;
  int _squatCount = 0;
  
  // GPS tracking
  bool _gpsEnabled = false;
  double _distanceMeters = 0;
  double _currentSpeed = 0; // m/s
  Position? _lastPosition;
  StreamSubscription<Position>? _gpsSubscription;
  String _gpsStatus = '';
  
  // Giroscopio
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  int _balanceSeconds = 0; // segundos en equilibrio
  bool _isBalanced = false;
  int _twistCount = 0; // giros de tronco
  bool _twistRight = false;
  
  // Detección de movimiento
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _lastMagnitude = 0;
  DateTime? _lastStepTime;
  
  // Detección de sentadillas
  bool _isSquatDown = false;
  
  // Timer
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  
  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gpsSubscription?.cancel();
    _gyroSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bioCoins = ref.watch(bioCoinBalanceProvider);
    final progress = _steps / _targetSteps;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ENTRENAMIENTO'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.moduleArena,
      ),
      body: ScanlineOverlay(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header con Bio-Coins
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BioCoinDisplay(amount: bioCoins),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Panel principal de ejercicio
              HudPanel(
                borderColor: AppColors.moduleArena,
                child: Column(
                  children: [
                    // Círculo de progreso
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Fondo del círculo
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 12,
                              color: AppColors.surface,
                            ),
                          ),
                          // Progreso
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: progress.clamp(0, 1),
                              strokeWidth: 12,
                              color: AppColors.moduleArena,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          // Contenido central
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isExercising 
                                    ? Icons.directions_run 
                                    : Icons.fitness_center,
                                size: 48,
                                color: AppColors.moduleArena,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_steps',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'de $_targetSteps pasos',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                        .animate(target: _isExercising ? 1 : 0)
                        .shake(hz: 2, duration: 500.ms, curve: Curves.easeInOut),
                    
                    const SizedBox(height: 24),
                    
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          icon: Icons.local_fire_department,
                          value: '$_calories',
                          label: 'Calorías',
                          color: Colors.orange,
                        ),
                        _buildStat(
                          icon: Icons.timer,
                          value: _formatDuration(_stopwatch.elapsed),
                          label: 'Tiempo',
                          color: AppColors.neonCyan,
                        ),
                        _buildStat(
                          icon: Icons.straighten,
                          value: _formatDistance(_distanceMeters),
                          label: 'Distancia',
                          color: AppColors.neonGreen,
                        ),
                        _buildStat(
                          icon: Icons.bolt,
                          value: '$_shakeCount',
                          label: 'Sacudidas',
                          color: AppColors.neonYellow,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Botón iniciar/detener
                    NeonButton(
                      text: _isExercising ? 'DETENER' : 'INICIAR EJERCICIO',
                      icon: _isExercising ? Icons.stop : Icons.play_arrow,
                      color: _isExercising ? AppColors.neonRed : AppColors.moduleArena,
                      onPressed: _toggleExercise,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Panel de ejercicios disponibles
              const Text(
                'EJERCICIOS DISPONIBLES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildExerciseCard(
                      title: 'Caminar',
                      description: '1000 pasos = 15 coins',
                      icon: Icons.directions_walk,
                      isActive: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildExerciseCard(
                      title: 'Sentadillas',
                      description: '20 = 10 coins',
                      icon: Icons.accessibility_new,
                      count: _squatCount,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildExerciseCard(
                      title: 'Saltar',
                      description: '50 = 15 coins',
                      icon: Icons.height,
                      count: _shakeCount ~/ 3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildExerciseCard(
                      title: 'Agitar',
                      description: '100 = 5 coins',
                      icon: Icons.vibration,
                      count: _shakeCount,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // GPS Outdoor
              Row(
                children: [
                  Expanded(
                    child: _buildExerciseCard(
                      title: 'Correr (GPS)',
                      description: '500m = 20 coins',
                      icon: Icons.gps_fixed,
                      isActive: _gpsEnabled,
                      count: (_distanceMeters / 500).floor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGpsToggleCard(),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Giroscopio exercises
              Row(
                children: [
                  Expanded(
                    child: _buildExerciseCard(
                      title: 'Equilibrio',
                      description: '30s = 10 coins',
                      icon: Icons.balance,
                      isActive: _isBalanced,
                      count: _balanceSeconds,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildExerciseCard(
                      title: 'Giros tronco',
                      description: '20 = 10 coins',
                      icon: Icons.rotate_right,
                      count: _twistCount,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Recompensa estimada
              HudPanel(
                borderColor: AppColors.neonYellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: AppColors.neonYellow,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recompensa estimada',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '+${_calculateReward()} Bio-Coins',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neonYellow,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (_steps >= _targetSteps)
                      NeonButton(
                        text: 'Reclamar',
                        color: AppColors.neonGreen,
                        onPressed: _claimReward,
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStat({
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
  
  Widget _buildExerciseCard({
    required String title,
    required String description,
    required IconData icon,
    bool isActive = false,
    int count = 0,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive 
              ? AppColors.moduleArena.withOpacity(0.5) 
              : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.moduleArena : AppColors.textSecondary,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.neonGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  void _toggleExercise() {
    setState(() {
      _isExercising = !_isExercising;
    });
    
    if (_isExercising) {
      _startExercise();
    } else {
      _stopExercise();
    }
  }
  
  void _startExercise() {
    _stopwatch.start();
    AntiCheatService.instance.startSession();
    
    // Timer para actualizar UI
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        // Calcular calorías (pasos + distancia)
        _calories = (_steps * 0.04 + _distanceMeters * 0.06).round();
      });
    });
    
    // GPS tracking si está habilitado
    if (_gpsEnabled) {
      _startGPS();
    }
    
    // Giroscopio para equilibrio y giros
    _startGyroscope();
    
    // Iniciar detección de movimiento con acelerómetro
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      
      AntiCheatService.instance.recordAccelerometer(magnitude);
      
      // Detectar pasos (simplificado)
      if (magnitude > 12 && 
          magnitude - _lastMagnitude > 2 &&
          (_lastStepTime == null || 
           DateTime.now().difference(_lastStepTime!) > const Duration(milliseconds: 300))) {
        setState(() {
          _steps++;
          _lastStepTime = DateTime.now();
        });
        AntiCheatService.instance.recordStep();
      }
      
      // Detectar sacudidas
      if (magnitude > 20) {
        setState(() {
          _shakeCount++;
        });
      }
      
      // Detectar sentadillas (basado en eje Y)
      if (event.y < -2 && !_isSquatDown) {
        _isSquatDown = true;
      } else if (event.y > 2 && _isSquatDown) {
        _isSquatDown = false;
        setState(() {
          _squatCount++;
        });
      }
      
      _lastMagnitude = magnitude;
    });
  }
  
  void _stopExercise() {
    _stopwatch.stop();
    _timer?.cancel();
    _accelerometerSubscription?.cancel();
    _stopGPS();
    _stopGyroscope();
  }
  
  // ============ GPS Methods ============
  
  Future<void> _startGPS() async {
    try {
      // Verificar que el servicio de ubicación esté activo
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _gpsStatus = 'GPS desactivado');
        return;
      }
      
      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _gpsStatus = 'Permiso denegado');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _gpsStatus = 'Permiso bloqueado');
        return;
      }
      
      setState(() => _gpsStatus = 'Buscando señal...');
      
      // Posición inicial
      _lastPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() => _gpsStatus = 'GPS activo');
      
      // Stream continuo de posiciones
      _gpsSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // Actualizar cada 5 metros mínimo
        ),
      ).listen((Position position) {
        if (_lastPosition != null) {
          // Calcular distancia entre puntos
          final distance = Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );
          
          // Filtrar drift GPS: ignorar movimientos < 2m o > 50m (saltos)
          if (distance >= 2 && distance <= 50) {
            // Validar velocidad anti-cheat
            final speedCheck = AntiCheatService.instance.validateGPSSpeed(position.speed >= 0 ? position.speed : 0);
            if (speedCheck.isValid) {
              setState(() {
                _distanceMeters += distance;
                _currentSpeed = position.speed >= 0 ? position.speed : 0;
              });
            }
          }
        }
        _lastPosition = position;
      }, onError: (e) {
        setState(() => _gpsStatus = 'Error GPS');
      });
    } catch (e) {
      setState(() => _gpsStatus = 'Error: $e');
    }
  }
  
  void _stopGPS() {
    _gpsSubscription?.cancel();
    _gpsSubscription = null;
    _lastPosition = null;
    _currentSpeed = 0;
    _gpsStatus = '';
  }
  
  void _toggleGPS() {
    setState(() {
      _gpsEnabled = !_gpsEnabled;
    });
    
    // Si ya estamos ejercitando, iniciar/detener GPS en caliente
    if (_isExercising) {
      if (_gpsEnabled) {
        _startGPS();
      } else {
        _stopGPS();
      }
    }
  }
  
  Widget _buildGpsToggleCard() {
    return GestureDetector(
      onTap: _toggleGPS,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _gpsEnabled ? AppColors.moduleArena.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _gpsEnabled ? AppColors.neonGreen : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _gpsEnabled ? Icons.gps_fixed : Icons.gps_off,
              color: _gpsEnabled ? AppColors.neonGreen : AppColors.textSecondary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              _gpsEnabled ? 'GPS ON' : 'GPS OFF',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _gpsEnabled ? AppColors.neonGreen : AppColors.textSecondary,
              ),
            ),
            Text(
              _gpsEnabled
                  ? (_gpsStatus.isNotEmpty ? _gpsStatus : '${_currentSpeed.toStringAsFixed(1)} m/s')
                  : 'Toca para activar',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // ============ Gyroscope Methods ============
  
  void _startGyroscope() {
    DateTime? lastBalanceTick;
    
    _gyroSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      // Equilibrio: el teléfono debe estar quieto (gyro bajo)
      final totalRotation = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      
      if (totalRotation < 0.3) {
        // Está en equilibrio (quieto)
        if (!_isBalanced) {
          setState(() => _isBalanced = true);
          lastBalanceTick = DateTime.now();
        } else if (lastBalanceTick != null) {
          final elapsed = DateTime.now().difference(lastBalanceTick!);
          if (elapsed >= const Duration(seconds: 1)) {
            setState(() => _balanceSeconds++);
            lastBalanceTick = DateTime.now();
          }
        }
      } else {
        if (_isBalanced) {
          setState(() => _isBalanced = false);
        }
      }
      
      // Giros de tronco: rotación significativa en eje Z (yaw)
      if (event.z > 2.0 && !_twistRight) {
        _twistRight = true;
      } else if (event.z < -2.0 && _twistRight) {
        _twistRight = false;
        setState(() => _twistCount++);
      }
    });
  }
  
  void _stopGyroscope() {
    _gyroSubscription?.cancel();
    _gyroSubscription = null;
    _isBalanced = false;
  }
  
  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()}m';
    }
    return '${(meters / 1000).toStringAsFixed(2)}km';
  }
  
  int _calculateReward() {
    int reward = 0;
    
    // Pasos: 15 coins por cada 1000
    reward += (_steps ~/ 1000) * 15;
    
    // Sentadillas: 10 coins por cada 20
    reward += (_squatCount ~/ 20) * 10;
    
    // Sacudidas: 5 coins por cada 100
    reward += (_shakeCount ~/ 100) * 5;
    
    // Distancia GPS: 20 coins por cada 500m
    reward += ((_distanceMeters / 500).floor()) * 20;
    
    // Equilibrio: 10 coins por cada 30 segundos
    reward += (_balanceSeconds ~/ 30) * 10;
    
    // Giros de tronco: 10 coins por cada 20
    reward += (_twistCount ~/ 20) * 10;
    
    return reward;
  }
  
  void _claimReward() {
    final rawReward = _calculateReward();
    if (rawReward <= 0) return;

    // Anti-cheat: aplicar multiplicador de confianza
    final multiplier = AntiCheatService.instance.getRewardMultiplier(_steps, rawReward);
    final reward = (rawReward * multiplier).round();
    if (reward <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Actividad sospechosa detectada. Recompensa anulada.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final wasReduced = multiplier < 1.0;
    ref.read(bioCoinServiceProvider).award(
      userId: user.id,
      coins: reward,
      source: TransactionSource.arena,
      description: 'Ejercicio: $_steps pasos, $_squatCount sentadillas, ${_formatDistance(_distanceMeters)}, ${_balanceSeconds}s equilibrio, $_twistCount giros',
    ).then((actual) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(wasReduced
            ? '¡Entrenamiento completado! +$actual Bio-Coins (ajustado por validación)'
            : '¡Entrenamiento completado! +$actual Bio-Coins'),
          backgroundColor: wasReduced ? Colors.orange : AppColors.neonGreen,
        ),
      );
      // Notificar al padre
      ParentAlertService.instance.notifyExerciseMilestone(_steps, _distanceMeters);
    });

    setState(() {
      _steps = 0;
      _shakeCount = 0;
      _squatCount = 0;
      _calories = 0;
      _distanceMeters = 0;
      _currentSpeed = 0;
      _balanceSeconds = 0;
      _twistCount = 0;
      _stopwatch.reset();
    });
  }
  
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
