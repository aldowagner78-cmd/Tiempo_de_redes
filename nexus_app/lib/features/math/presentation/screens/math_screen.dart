/// ============================================
/// NEXUS CONTROL - Cálculo Module Screen
/// ============================================
/// Módulo de matemáticas - "Cálculo"
/// Problemas matemáticos adaptativos

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/biocoin_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../features/biocoins/domain/entities/biocoin_entity.dart';

class MathScreen extends ConsumerStatefulWidget {
  const MathScreen({super.key});

  @override
  ConsumerState<MathScreen> createState() => _MathScreenState();
}

class _MathScreenState extends ConsumerState<MathScreen> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();
  
  // Estado del juego
  int _level = 1;
  int _streak = 0;
  int _correctCount = 0;
  int _totalAttempts = 0;
  int _earnedCoins = 0;
  
  // Problema actual
  late MathProblem _currentProblem;
  bool _showResult = false;
  bool _isCorrect = false;
  
  @override
  void initState() {
    super.initState();
    _generateProblem();
  }
  
  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bioCoins = ref.watch(bioCoinBalanceProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('CÁLCULO'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.moduleMath,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: BioCoinDisplay(amount: bioCoins, size: 20),
          ),
        ],
      ),
      body: ScanlineOverlay(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Panel de estadísticas
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      label: 'Nivel',
                      value: '$_level',
                      color: AppColors.neonCyan,
                      icon: Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Racha',
                      value: '$_streak',
                      color: AppColors.neonMagenta,
                      icon: Icons.local_fire_department,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Coins',
                      value: '+$_earnedCoins',
                      color: AppColors.neonYellow,
                      icon: Icons.monetization_on,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Panel del problema
              HudPanel(
                borderColor: AppColors.moduleMath,
                child: Column(
                  children: [
                    // Tipo de operación
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.moduleMath.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentProblem.operationName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.moduleMath,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Problema
                    Text(
                      _currentProblem.display,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 4,
                      ),
                    )
                        .animate(key: ValueKey(_currentProblem.hashCode))
                        .fadeIn()
                        .scale(begin: const Offset(0.8, 0.8)),
                    
                    const SizedBox(height: 24),
                    
                    // Campo de respuesta
                    if (!_showResult)
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _answerController,
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neonCyan,
                          ),
                          decoration: InputDecoration(
                            hintText: '?',
                            hintStyle: TextStyle(
                              color: AppColors.textDisabled,
                              fontSize: 32,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.moduleMath),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.moduleMath,
                                width: 2,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _checkAnswer(),
                        ),
                      )
                    else
                      // Resultado
                      Column(
                        children: [
                          Icon(
                            _isCorrect ? Icons.check_circle : Icons.cancel,
                            color: _isCorrect ? AppColors.neonGreen : AppColors.neonRed,
                            size: 64,
                          )
                              .animate()
                              .scale(begin: const Offset(0.5, 0.5))
                              .then()
                              .shake(hz: _isCorrect ? 0 : 4),
                          const SizedBox(height: 8),
                          Text(
                            _isCorrect ? '¡Correcto!' : 'Incorrecto',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isCorrect ? AppColors.neonGreen : AppColors.neonRed,
                            ),
                          ),
                          if (!_isCorrect) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Respuesta: ${_currentProblem.answer}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                          if (_isCorrect) ...[
                            const SizedBox(height: 8),
                            Text(
                              '+10 Bio-Coins',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neonYellow,
                              ),
                            ),
                          ],
                        ],
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Botón de acción
                    NeonButton(
                      text: _showResult ? 'SIGUIENTE' : 'VERIFICAR',
                      icon: _showResult ? Icons.arrow_forward : Icons.check,
                      color: AppColors.moduleMath,
                      onPressed: _showResult ? _nextProblem : _checkAnswer,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Historial de respuestas
              HudPanel(
                borderColor: AppColors.border,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ESTADÍSTICAS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMiniStat(
                          'Correctos',
                          '$_correctCount',
                          AppColors.neonGreen,
                        ),
                        _buildMiniStat(
                          'Total',
                          '$_totalAttempts',
                          AppColors.textSecondary,
                        ),
                        _buildMiniStat(
                          'Precisión',
                          _totalAttempts > 0
                              ? '${((_correctCount / _totalAttempts) * 100).toStringAsFixed(0)}%'
                              : '-',
                          AppColors.neonCyan,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Barra de progreso de nivel
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progreso nivel $_level',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${_correctCount % 10}/10',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.moduleMath,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        NeonProgressBar(
                          value: (_correctCount % 10) / 10,
                          height: 8,
                          color: AppColors.moduleMath,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Selector de dificultad
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDifficultyButton('Fácil', 1),
                  const SizedBox(width: 8),
                  _buildDifficultyButton('Normal', 2),
                  const SizedBox(width: 8),
                  _buildDifficultyButton('Difícil', 3),
                ],
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
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
      ),
    );
  }
  
  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
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
  
  Widget _buildDifficultyButton(String label, int level) {
    final isSelected = _level == level;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _level = level;
          _generateProblem();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.moduleMath : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.moduleMath,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.background : AppColors.moduleMath,
          ),
        ),
      ),
    );
  }
  
  void _generateProblem() {
    setState(() {
      _currentProblem = MathProblem.generate(_level, _random);
      _showResult = false;
      _answerController.clear();
    });
  }
  
  void _checkAnswer() {
    final userAnswer = int.tryParse(_answerController.text);
    
    if (userAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un número válido'),
          backgroundColor: AppColors.neonRed,
        ),
      );
      return;
    }
    
    setState(() {
      _totalAttempts++;
      _isCorrect = userAnswer == _currentProblem.answer;
      _showResult = true;
      
      if (_isCorrect) {
        _correctCount++;
        _streak++;
        _earnedCoins += 10;

        // Subir de nivel cada 10 correctos
        if (_correctCount % 10 == 0 && _level < 5) {
          _level++;
        }

        // Persistir recompensa real
        final user = ref.read(currentUserProvider);
        if (user != null) {
          ref.read(bioCoinServiceProvider).award(
            userId: user.id,
            coins: 10,
            source: TransactionSource.math,
            description: 'Math: ${_currentProblem.display} correcto (nivel $_level)',
          );
        }
      } else {
        _streak = 0;
      }
    });
  }
  
  void _nextProblem() {
    _generateProblem();
  }
}

/// Modelo de problema matemático
class MathProblem {
  final int num1;
  final int num2;
  final String operator;
  final int answer;
  
  MathProblem({
    required this.num1,
    required this.num2,
    required this.operator,
    required this.answer,
  });
  
  String get display => '$num1 $operator $num2 = ?';
  
  String get operationName {
    switch (operator) {
      case '+': return 'SUMA';
      case '-': return 'RESTA';
      case '×': return 'MULTIPLICACIÓN';
      case '÷': return 'DIVISIÓN';
      default: return 'OPERACIÓN';
    }
  }
  
  factory MathProblem.generate(int level, Random random) {
    int num1, num2, answer;
    String op;
    
    // Rango según nivel
    final maxNum = switch (level) {
      1 => 10,
      2 => 50,
      3 => 100,
      4 => 200,
      _ => 500,
    };
    
    // Seleccionar operación
    final operations = level <= 1 
        ? ['+', '-'] 
        : level <= 2 
            ? ['+', '-', '×'] 
            : ['+', '-', '×', '÷'];
    
    op = operations[random.nextInt(operations.length)];
    
    switch (op) {
      case '+':
        num1 = random.nextInt(maxNum) + 1;
        num2 = random.nextInt(maxNum) + 1;
        answer = num1 + num2;
        break;
      case '-':
        num1 = random.nextInt(maxNum) + 1;
        num2 = random.nextInt(num1) + 1; // Evitar negativos
        answer = num1 - num2;
        break;
      case '×':
        num1 = random.nextInt(12) + 1;
        num2 = random.nextInt(12) + 1;
        answer = num1 * num2;
        break;
      case '÷':
        num2 = random.nextInt(12) + 1;
        answer = random.nextInt(12) + 1;
        num1 = num2 * answer; // Garantizar división exacta
        break;
      default:
        num1 = 1;
        num2 = 1;
        answer = 2;
    }
    
    return MathProblem(
      num1: num1,
      num2: num2,
      operator: op,
      answer: answer,
    );
  }
}
