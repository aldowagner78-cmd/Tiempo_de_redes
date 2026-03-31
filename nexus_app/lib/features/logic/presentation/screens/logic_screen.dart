/// ============================================
/// NEXUS CONTROL - Ingenio Module Screen
/// ============================================
/// Módulo de lógica e ingenio - "Ingenio"
/// Puzzles, patrones y juegos de pensamiento

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/biocoin_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../features/biocoins/domain/entities/biocoin_entity.dart';

class LogicScreen extends ConsumerStatefulWidget {
  const LogicScreen({super.key});

  @override
  ConsumerState<LogicScreen> createState() => _LogicScreenState();
}

class _LogicScreenState extends ConsumerState<LogicScreen> {
  final Random _random = Random();
  
  // Estado del juego
  GameType _currentGame = GameType.pattern;
  int _level = 1;
  int _score = 0;
  int _streak = 0;
  int _earnedCoins = 0;
  
  // Pattern game
  List<int> _patternSequence = [];
  List<int> _userSequence = [];
  bool _showingPattern = false;
  int _patternIndex = 0;
  
  // Memory game (Dual N-Back simplificado)
  List<int> _memorySequence = [];
  int _memoryTarget = 0;
  int _memoryAttempts = 0;
  int _memoryCorrect = 0;
  
  // Puzzle numbers
  int _targetNumber = 0;
  List<int> _puzzleNumbers = [];
  int? _selectedFirst;
  String? _selectedOperation;
  
  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  @override
  Widget build(BuildContext context) {
    final bioCoins = ref.watch(bioCoinBalanceProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('INGENIO'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.moduleLogic,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: BioCoinDisplay(amount: bioCoins, size: 20),
          ),
        ],
      ),
      body: ScanlineOverlay(
        child: Column(
          children: [
            // Barra de estadísticas
            _buildStatsBar(),
            
            // Selector de juego
            _buildGameSelector(),
            
            // Área de juego
            Expanded(
              child: _buildGameArea(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatChip('Nivel', '$_level', AppColors.neonCyan),
          const SizedBox(width: 8),
          _buildStatChip('Racha', '$_streak', AppColors.neonMagenta),
          const SizedBox(width: 8),
          _buildStatChip('Score', '$_score', AppColors.neonGreen),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.neonYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.neonYellow),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on, 
                    color: AppColors.neonYellow, size: 16),
                const SizedBox(width: 4),
                Text(
                  '+$_earnedCoins',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonYellow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGameSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildGameTab('Patrón', GameType.pattern, Icons.grid_view),
          const SizedBox(width: 8),
          _buildGameTab('Memoria', GameType.memory, Icons.psychology),
          const SizedBox(width: 8),
          _buildGameTab('Números', GameType.numbers, Icons.calculate),
        ],
      ),
    );
  }
  
  Widget _buildGameTab(String label, GameType type, IconData icon) {
    final isSelected = _currentGame == type;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentGame = type;
            _startNewGame();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.moduleLogic 
                : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.moduleLogic,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected 
                    ? AppColors.background 
                    : AppColors.moduleLogic,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected 
                      ? AppColors.background 
                      : AppColors.moduleLogic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGameArea() {
    switch (_currentGame) {
      case GameType.pattern:
        return _buildPatternGame();
      case GameType.memory:
        return _buildMemoryGame();
      case GameType.numbers:
        return _buildNumbersGame();
    }
  }
  
  /// ========== JUEGO DE PATRÓN (Simon Says) ==========
  Widget _buildPatternGame() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Instrucciones
          HudPanel(
            borderColor: AppColors.moduleLogic,
            padding: const EdgeInsets.all(12),
            child: Text(
              _showingPattern 
                  ? 'Observa el patrón...'
                  : 'Repite la secuencia',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const Spacer(),
          
          // Grid de colores 2x2
          SizedBox(
            width: 280,
            height: 280,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final colors = [
                  AppColors.neonRed,
                  AppColors.neonGreen,
                  AppColors.neonCyan,
                  AppColors.neonYellow,
                ];
                
                final isHighlighted = _showingPattern && 
                    _patternIndex < _patternSequence.length &&
                    _patternSequence[_patternIndex] == index;
                
                return GestureDetector(
                  onTap: _showingPattern ? null : () => _handlePatternTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isHighlighted 
                          ? colors[index] 
                          : colors[index].withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors[index],
                        width: 3,
                      ),
                      boxShadow: isHighlighted ? [
                        BoxShadow(
                          color: colors[index].withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ] : null,
                    ),
                  )
                      .animate(target: isHighlighted ? 1 : 0)
                      .scale(end: const Offset(1.1, 1.1)),
                );
              },
            ),
          ),
          
          const Spacer(),
          
          // Progreso de secuencia
          Text(
            'Secuencia: ${_patternSequence.length} elementos',
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Botón de reinicio
          NeonButton(
            text: 'Nueva Secuencia',
            icon: Icons.refresh,
            color: AppColors.moduleLogic,
            onPressed: _startPatternGame,
          ),
        ],
      ),
    );
  }
  
  /// ========== JUEGO DE MEMORIA ==========
  Widget _buildMemoryGame() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Instrucciones
          HudPanel(
            borderColor: AppColors.moduleLogic,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  '¿Este número apareció hace $_memoryTarget posiciones?',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Correctas: $_memoryCorrect / $_memoryAttempts',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Número actual
          if (_memorySequence.isNotEmpty)
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(
                  color: AppColors.moduleLogic,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.moduleLogic.withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${_memorySequence.last}',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            )
                .animate(key: ValueKey(_memorySequence.length))
                .fadeIn()
                .scale(begin: const Offset(0.8, 0.8)),
          
          const Spacer(),
          
          // Botones de respuesta
          Row(
            children: [
              Expanded(
                child: NeonButton(
                  text: 'SÍ',
                  icon: Icons.check,
                  color: AppColors.neonGreen,
                  onPressed: () => _handleMemoryAnswer(true),
                  height: 60,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: NeonButton(
                  text: 'NO',
                  icon: Icons.close,
                  color: AppColors.neonRed,
                  onPressed: () => _handleMemoryAnswer(false),
                  height: 60,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Historial reciente
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: min(_memorySequence.length - 1, 10),
              itemBuilder: (context, index) {
                final seqIndex = _memorySequence.length - 2 - index;
                final isTarget = index == _memoryTarget - 1;
                
                return Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isTarget 
                        ? AppColors.moduleLogic.withOpacity(0.3)
                        : AppColors.surface,
                    border: Border.all(
                      color: isTarget 
                          ? AppColors.moduleLogic 
                          : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${_memorySequence[seqIndex]}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isTarget 
                            ? AppColors.moduleLogic 
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  /// ========== JUEGO DE NÚMEROS ==========
  Widget _buildNumbersGame() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Objetivo
          HudPanel(
            borderColor: AppColors.neonYellow,
            child: Column(
              children: [
                const Text(
                  'Llega al número:',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '$_targetNumber',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonYellow,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Números disponibles
          const Text(
            'Combina estos números:',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _puzzleNumbers.asMap().entries.map((entry) {
              final index = entry.key;
              final number = entry.value;
              final isSelected = _selectedFirst == index;
              
              return GestureDetector(
                onTap: () => _selectNumber(index),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.moduleLogic 
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.moduleLogic,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected 
                            ? AppColors.background 
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Operaciones
          if (_selectedFirst != null) ...[
            const Text(
              'Selecciona operación:',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['+', '-', '×', '÷'].map((op) {
                final isSelected = _selectedOperation == op;
                
                return GestureDetector(
                  onTap: () => _selectOperation(op),
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.neonCyan 
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neonCyan),
                    ),
                    child: Center(
                      child: Text(
                        op,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isSelected 
                              ? AppColors.background 
                              : AppColors.neonCyan,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          
          const Spacer(),
          
          // Botón de nuevo puzzle
          NeonButton(
            text: 'Nuevo Puzzle',
            icon: Icons.refresh,
            color: AppColors.moduleLogic,
            onPressed: _startNumbersGame,
          ),
        ],
      ),
    );
  }
  
  // ========== LÓGICA DE JUEGOS ==========
  
  void _startNewGame() {
    switch (_currentGame) {
      case GameType.pattern:
        _startPatternGame();
        break;
      case GameType.memory:
        _startMemoryGame();
        break;
      case GameType.numbers:
        _startNumbersGame();
        break;
    }
  }
  
  void _startPatternGame() {
    setState(() {
      _patternSequence = List.generate(
        3 + (_level - 1),
        (_) => _random.nextInt(4),
      );
      _userSequence = [];
      _patternIndex = 0;
    });
    
    _showPattern();
  }
  
  Future<void> _showPattern() async {
    setState(() => _showingPattern = true);
    
    for (int i = 0; i < _patternSequence.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() => _patternIndex = i);
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
    }
    
    setState(() {
      _showingPattern = false;
      _patternIndex = -1;
    });
  }
  
  void _handlePatternTap(int index) {
    _userSequence.add(index);
    
    // Verificar si es correcto
    final currentIndex = _userSequence.length - 1;
    if (_patternSequence[currentIndex] != index) {
      // Error
      setState(() => _streak = 0);
      _showError();
      _startPatternGame();
      return;
    }
    
    // Verificar si completó la secuencia
    if (_userSequence.length == _patternSequence.length) {
      _handleSuccess();
    }
  }
  
  void _startMemoryGame() {
    setState(() {
      _memorySequence = [_random.nextInt(9) + 1];
      _memoryTarget = min(2 + (_level - 1) ~/ 2, 5);
      _memoryAttempts = 0;
      _memoryCorrect = 0;
    });
    
    _addMemoryNumber();
  }
  
  void _addMemoryNumber() {
    setState(() {
      _memorySequence.add(_random.nextInt(9) + 1);
    });
  }
  
  void _handleMemoryAnswer(bool saidYes) {
    if (_memorySequence.length <= _memoryTarget) {
      _addMemoryNumber();
      return;
    }
    
    final targetIndex = _memorySequence.length - 1 - _memoryTarget;
    final isMatch = _memorySequence.last == _memorySequence[targetIndex];
    final isCorrect = saidYes == isMatch;
    
    setState(() {
      _memoryAttempts++;
      if (isCorrect) {
        _memoryCorrect++;
        _score += 10;
      } else {
        _streak = 0;
      }
    });
    
    if (_memoryAttempts >= 10) {
      if (_memoryCorrect >= 7) {
        _handleSuccess();
      } else {
        _startMemoryGame();
      }
    } else {
      _addMemoryNumber();
    }
  }
  
  void _startNumbersGame() {
    // Generar números y target alcanzable
    final a = _random.nextInt(20) + 1;
    final b = _random.nextInt(20) + 1;
    final c = _random.nextInt(10) + 1;
    
    setState(() {
      _puzzleNumbers = [a, b, c, a + b, a * c];
      _puzzleNumbers.shuffle();
      _targetNumber = a + b + c;
      _selectedFirst = null;
      _selectedOperation = null;
    });
  }
  
  void _selectNumber(int index) {
    if (_selectedFirst == null) {
      setState(() => _selectedFirst = index);
    } else if (_selectedFirst == index) {
      setState(() => _selectedFirst = null);
    } else if (_selectedOperation != null) {
      _performOperation(index);
    }
  }
  
  void _selectOperation(String op) {
    setState(() => _selectedOperation = op);
  }
  
  void _performOperation(int secondIndex) {
    if (_selectedFirst == null || _selectedOperation == null) return;
    
    final a = _puzzleNumbers[_selectedFirst!];
    final b = _puzzleNumbers[secondIndex];
    int result;
    
    switch (_selectedOperation) {
      case '+':
        result = a + b;
        break;
      case '-':
        result = a - b;
        break;
      case '×':
        result = a * b;
        break;
      case '÷':
        if (b == 0 || a % b != 0) {
          setState(() {
            _selectedFirst = null;
            _selectedOperation = null;
          });
          return;
        }
        result = a ~/ b;
        break;
      default:
        return;
    }
    
    // Actualizar números
    final newNumbers = <int>[];
    for (int i = 0; i < _puzzleNumbers.length; i++) {
      if (i != _selectedFirst && i != secondIndex) {
        newNumbers.add(_puzzleNumbers[i]);
      }
    }
    newNumbers.add(result);
    
    setState(() {
      _puzzleNumbers = newNumbers;
      _selectedFirst = null;
      _selectedOperation = null;
    });
    
    // Verificar si ganó
    if (_puzzleNumbers.contains(_targetNumber)) {
      _handleSuccess();
    }
  }
  
  void _handleSuccess() {
    setState(() {
      _streak++;
      _score += 50;
      _earnedCoins += 15;

      if (_streak >= 3) {
        _level++;
      }
    });

    final user = ref.read(currentUserProvider);
    if (user != null) {
      ref.read(bioCoinServiceProvider).award(
        userId: user.id,
        coins: 15,
        source: TransactionSource.logic,
        description: 'Logic: puzzle resuelto (nivel $_level)',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('¡Correcto! +15 Bio-Coins'),
        backgroundColor: AppColors.neonGreen,
      ),
    );
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _startNewGame();
    });
  }
  
  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Error! Intenta de nuevo'),
        backgroundColor: AppColors.neonRed,
      ),
    );
  }
}

enum GameType { pattern, memory, numbers }
