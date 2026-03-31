/// ============================================
/// NEXUS CONTROL - Programación Module Screen
/// ============================================
/// Módulo de programación básica - "Programación"
/// Enseña conceptos de programación con bloques

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/biocoin_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../features/biocoins/domain/entities/biocoin_entity.dart';

class CodingScreen extends ConsumerStatefulWidget {
  const CodingScreen({super.key});

  @override
  ConsumerState<CodingScreen> createState() => _CodingScreenState();
}

class _CodingScreenState extends ConsumerState<CodingScreen> {
  // Estado del juego
  int _currentLevel = 0;
  int _earnedCoins = 0;
  
  // Bloques disponibles para el nivel actual
  List<CodeBlock> _availableBlocks = [];
  List<CodeBlock> _solutionBlocks = [];
  
  // Niveles
  late List<CodingLevel> _levels;
  
  @override
  void initState() {
    super.initState();
    _initializeLevels();
    _loadLevel(0);
  }
  
  void _initializeLevels() {
    _levels = [
      // === BLOQUE 1: SECUENCIAS (niveles 1-3) ===
      CodingLevel(
        title: 'Primeros Pasos',
        description: 'El robot debe llegar a la estrella. Usa AVANZAR para moverlo.',
        gridSize: 4,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(3, 0),
        obstacles: [],
        solution: ['AVANZAR', 'AVANZAR', 'AVANZAR'],
        availableBlocks: ['AVANZAR'],
        reward: 25,
      ),
      CodingLevel(
        title: 'Giros Básicos',
        description: 'Ahora el robot debe girar para llegar a la meta.',
        gridSize: 4,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(0, 3),
        obstacles: [],
        solution: ['GIRAR_DERECHA', 'AVANZAR', 'AVANZAR', 'AVANZAR'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA'],
        reward: 30,
      ),
      CodingLevel(
        title: 'Camino en L',
        description: 'Llega a la estrella haciendo forma de L.',
        gridSize: 5,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(2, 3),
        obstacles: [],
        solution: ['AVANZAR', 'AVANZAR', 'GIRAR_DERECHA', 'AVANZAR', 'AVANZAR', 'AVANZAR'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA'],
        reward: 30,
      ),
      
      // === BLOQUE 2: OBSTÁCULOS (niveles 4-5) ===
      CodingLevel(
        title: 'Primer Obstáculo',
        description: 'Esquiva el obstáculo rojo para llegar a la meta.',
        gridSize: 4,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(3, 0),
        obstacles: [const Offset(1, 0)],
        solution: ['GIRAR_DERECHA', 'AVANZAR', 'GIRAR_IZQUIERDA', 'AVANZAR', 'AVANZAR', 'GIRAR_IZQUIERDA', 'AVANZAR', 'GIRAR_DERECHA'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA'],
        reward: 35,
      ),
      CodingLevel(
        title: 'Laberinto',
        description: 'Navega entre los obstáculos para alcanzar la estrella.',
        gridSize: 5,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(4, 4),
        obstacles: [const Offset(1, 0), const Offset(2, 2), const Offset(3, 3)],
        solution: ['GIRAR_DERECHA', 'AVANZAR', 'GIRAR_IZQUIERDA', 'AVANZAR', 'AVANZAR',
                   'GIRAR_DERECHA', 'AVANZAR', 'AVANZAR', 'GIRAR_IZQUIERDA', 'AVANZAR', 'AVANZAR'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA'],
        reward: 40,
      ),
      
      // === BLOQUE 3: BUCLES (niveles 6-8) ===
      CodingLevel(
        title: 'Repetir',
        description: 'Usa REPETIR para hacer el código más corto. ¡Menos bloques = más puntos!',
        gridSize: 5,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(4, 0),
        obstacles: [],
        solution: ['REPETIR_4', 'AVANZAR'],
        availableBlocks: ['AVANZAR', 'REPETIR_2', 'REPETIR_3', 'REPETIR_4'],
        reward: 45,
      ),
      CodingLevel(
        title: 'Patrón Repetido',
        description: 'Repite un patrón de avanzar y girar para hacer un cuadrado.',
        gridSize: 5,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(0, 0),
        obstacles: [],
        solution: ['REPETIR_4', 'AVANZAR', 'AVANZAR', 'GIRAR_DERECHA'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'REPETIR_2', 'REPETIR_3', 'REPETIR_4'],
        reward: 50,
      ),
      CodingLevel(
        title: 'Espiral',
        description: 'Crea una espiral usando repeticiones dentro de giros.',
        gridSize: 6,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(3, 3),
        obstacles: [],
        solution: ['REPETIR_3', 'AVANZAR', 'GIRAR_DERECHA', 'REPETIR_2', 'AVANZAR'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA', 'REPETIR_2', 'REPETIR_3'],
        reward: 50,
      ),
      
      // === BLOQUE 4: CONDICIONALES (niveles 9-11) ===
      CodingLevel(
        title: 'Si Hay Obstáculo',
        description: 'Usa SI_OBSTACULO para girar automáticamente cuando hay pared.',
        gridSize: 5,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(4, 0),
        obstacles: [const Offset(2, 0)],
        solution: ['REPETIR_4', 'SI_OBSTACULO', 'GIRAR_DERECHA', 'AVANZAR'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA', 'SI_OBSTACULO', 'REPETIR_4'],
        reward: 55,
      ),
      CodingLevel(
        title: 'Decisiones',
        description: 'Combina SI_OBSTACULO con avanzar para navegar un camino con muros.',
        gridSize: 6,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(5, 5),
        obstacles: [const Offset(1, 0), const Offset(3, 2), const Offset(4, 4)],
        solution: ['REPETIR_4', 'SI_OBSTACULO', 'GIRAR_DERECHA', 'AVANZAR', 'AVANZAR'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA', 'SI_OBSTACULO', 'REPETIR_3', 'REPETIR_4'],
        reward: 60,
      ),
      CodingLevel(
        title: 'Camino Inteligente',
        description: 'El robot debe tomar decisiones en cada paso. ¡Piensa como un programador!',
        gridSize: 6,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(5, 5),
        obstacles: [const Offset(1, 0), const Offset(1, 1), const Offset(3, 3), const Offset(4, 2), const Offset(5, 4)],
        solution: ['REPETIR_4', 'SI_OBSTACULO', 'GIRAR_DERECHA', 'AVANZAR', 'SI_OBSTACULO', 'GIRAR_IZQUIERDA'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA', 'SI_OBSTACULO', 'REPETIR_3', 'REPETIR_4'],
        reward: 65,
      ),
      
      // === BLOQUE 5: FUNCIONES (niveles 12-14) ===
      CodingLevel(
        title: 'Mi Primera Función',
        description: 'Define FUNCIÓN_A como una secuencia y úsala varias veces.',
        gridSize: 5,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(4, 4),
        obstacles: [],
        solution: ['FUNCIÓN_A', 'FUNCIÓN_A'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'FUNCIÓN_A', 'REPETIR_2'],
        reward: 70,
      ),
      CodingLevel(
        title: 'Dos Funciones',
        description: 'Usa FUNCIÓN_A y FUNCIÓN_B para resolver el puzzle de forma elegante.',
        gridSize: 6,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(5, 5),
        obstacles: [const Offset(2, 0), const Offset(4, 3)],
        solution: ['FUNCIÓN_A', 'FUNCIÓN_B', 'FUNCIÓN_A'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA', 'FUNCIÓN_A', 'FUNCIÓN_B'],
        reward: 75,
      ),
      CodingLevel(
        title: 'Funciones + Bucles',
        description: 'Combina funciones con repeticiones. ¡Código limpio y eficiente!',
        gridSize: 6,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(5, 0),
        obstacles: [const Offset(1, 0), const Offset(3, 0)],
        solution: ['REPETIR_2', 'FUNCIÓN_A', 'SI_OBSTACULO', 'GIRAR_DERECHA'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA', 'SI_OBSTACULO', 'FUNCIÓN_A', 'REPETIR_2', 'REPETIR_3'],
        reward: 80,
      ),
      
      // === BLOQUE 6: DESAFÍO FINAL (niveles 15-16) ===
      CodingLevel(
        title: 'Gran Laberinto',
        description: 'Usa todas tus habilidades para resolver este laberinto complejo.',
        gridSize: 7,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(6, 6),
        obstacles: [const Offset(1, 0), const Offset(1, 1), const Offset(3, 2), 
                    const Offset(3, 3), const Offset(5, 4), const Offset(5, 5)],
        solution: ['REPETIR_3', 'FUNCIÓN_A', 'SI_OBSTACULO', 'GIRAR_DERECHA', 'AVANZAR'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA', 'SI_OBSTACULO', 
                          'FUNCIÓN_A', 'REPETIR_2', 'REPETIR_3', 'REPETIR_4'],
        reward: 90,
      ),
      CodingLevel(
        title: 'Maestro Programador',
        description: '¡El desafío final! Demuestra que dominas secuencias, bucles, condicionales y funciones.',
        gridSize: 8,
        robotStart: const Offset(0, 0),
        goalPosition: const Offset(7, 7),
        obstacles: [const Offset(1, 0), const Offset(2, 1), const Offset(3, 0),
                    const Offset(4, 3), const Offset(5, 2), const Offset(6, 5),
                    const Offset(5, 6), const Offset(7, 6)],
        solution: ['REPETIR_4', 'FUNCIÓN_A', 'SI_OBSTACULO', 'FUNCIÓN_B', 'AVANZAR'],
        availableBlocks: ['AVANZAR', 'GIRAR_DERECHA', 'GIRAR_IZQUIERDA', 'SI_OBSTACULO',
                          'FUNCIÓN_A', 'FUNCIÓN_B', 'REPETIR_2', 'REPETIR_3', 'REPETIR_4'],
        reward: 100,
      ),
    ];
  }
  
  void _loadLevel(int index) {
    if (index >= _levels.length) {
      // Completó todos los niveles
      _showCompletionDialog();
      return;
    }
    
    final level = _levels[index];
    
    setState(() {
      _currentLevel = index;
      _solutionBlocks = [];
      _availableBlocks = level.availableBlocks.map((name) => CodeBlock(
        name: name,
        color: _getBlockColor(name),
        icon: _getBlockIcon(name),
      )).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bioCoins = ref.watch(bioCoinBalanceProvider);
    final level = _levels[_currentLevel];
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PROGRAMACIÓN'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.moduleCoding,
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
            // Barra de progreso de nivel
            _buildLevelProgress(),
            
            // Panel del nivel actual
            Padding(
              padding: const EdgeInsets.all(16),
              child: HudPanel(
                borderColor: AppColors.moduleCoding,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.moduleCoding,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Nivel ${_currentLevel + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            level.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.neonYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.neonYellow),
                          ),
                          child: Text(
                            '+${level.reward}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neonYellow,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      level.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Grid del juego
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildGameGrid(level),
              ),
            ),
            
            // Área de código
            _buildCodeArea(),
            
            // Bloques disponibles
            _buildBlockPalette(),
            
            // Botones de acción
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: NeonButton(
                      text: 'EJECUTAR',
                      icon: Icons.play_arrow,
                      color: AppColors.neonGreen,
                      onPressed: _runCode,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeonButton(
                      text: 'LIMPIAR',
                      icon: Icons.delete_outline,
                      color: AppColors.neonRed,
                      onPressed: _clearCode,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLevelProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(_levels.length, (index) {
          final completed = index < _currentLevel;
          final current = index == _currentLevel;
          
          return Expanded(
            child: Container(
              height: 8,
              margin: EdgeInsets.only(right: index < _levels.length - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: completed 
                    ? AppColors.neonGreen 
                    : current 
                        ? AppColors.moduleCoding 
                        : AppColors.surface,
                borderRadius: BorderRadius.circular(4),
                border: current ? Border.all(color: AppColors.moduleCoding) : null,
              ),
            ),
          );
        }),
      ),
    );
  }
  
  Widget _buildGameGrid(CodingLevel level) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: level.gridSize,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: level.gridSize * level.gridSize,
          itemBuilder: (context, index) {
            final x = index % level.gridSize;
            final y = index ~/ level.gridSize;
            final pos = Offset(x.toDouble(), y.toDouble());
            
            final isRobot = pos == level.robotStart;
            final isGoal = pos == level.goalPosition;
            final isObstacle = level.obstacles.contains(pos);
            
            return Container(
              decoration: BoxDecoration(
                color: isObstacle 
                    ? AppColors.neonRed.withOpacity(0.3)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isGoal 
                      ? AppColors.neonYellow 
                      : AppColors.border.withOpacity(0.3),
                  width: isGoal ? 2 : 1,
                ),
              ),
              child: Center(
                child: isRobot
                    ? Icon(Icons.smart_toy, color: AppColors.moduleCoding, size: 24)
                    : isGoal
                        ? Icon(Icons.star, color: AppColors.neonYellow, size: 24)
                        : isObstacle
                            ? Icon(Icons.block, color: AppColors.neonRed, size: 20)
                            : null,
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildCodeArea() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.moduleCoding.withOpacity(0.5)),
      ),
      child: _solutionBlocks.isEmpty
          ? Center(
              child: Text(
                'Arrastra bloques aquí',
                style: TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 12,
                ),
              ),
            )
          : ReorderableListView(
              scrollDirection: Axis.horizontal,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final block = _solutionBlocks.removeAt(oldIndex);
                  _solutionBlocks.insert(newIndex, block);
                });
              },
              children: _solutionBlocks.asMap().entries.map((entry) {
                final index = entry.key;
                final block = entry.value;
                
                return GestureDetector(
                  key: ValueKey('$index-${block.name}'),
                  onDoubleTap: () {
                    setState(() {
                      _solutionBlocks.removeAt(index);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: block.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(block.icon, size: 16, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          _getBlockLabel(block.name),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
  
  Widget _buildBlockPalette() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _availableBlocks.map((block) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _solutionBlocks.add(CodeBlock(
                  name: block.name,
                  color: block.color,
                  icon: block.icon,
                ));
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: block.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: block.color.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(block.icon, color: Colors.white, size: 20),
                  const SizedBox(height: 2),
                  Text(
                    _getBlockLabel(block.name),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(delay: Duration(milliseconds: 100 * _availableBlocks.indexOf(block)))
              .slideY(begin: 0.3);
        }).toList(),
      ),
    );
  }
  
  void _runCode() {
    final level = _levels[_currentLevel];
    
    // Verificar si la solución es correcta (simplificado)
    final userSolution = _solutionBlocks.map((b) => b.name).toList();
    
    // Para simplificar, verificamos longitud mínima de pasos
    final minSteps = level.solution.length;
    
    if (userSolution.length >= minSteps - 1 && userSolution.isNotEmpty) {
      // Éxito
      setState(() {
        _earnedCoins += level.reward;
      });

      final user = ref.read(currentUserProvider);
      if (user != null) {
        ref.read(bioCoinServiceProvider).award(
          userId: user.id,
          coins: level.reward,
          source: TransactionSource.coding,
          description: 'Coding: nivel ${_currentLevel + 1} completado',
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Nivel completado! +${level.reward} Bio-Coins'),
          backgroundColor: AppColors.neonGreen,
        ),
      );
      
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _loadLevel(_currentLevel + 1);
        }
      });
    } else {
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El código no es correcto. Intenta de nuevo.'),
          backgroundColor: AppColors.neonRed,
        ),
      );
    }
  }
  
  void _clearCode() {
    setState(() {
      _solutionBlocks = [];
    });
  }
  
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: const Text('¡Felicitaciones!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: AppColors.neonYellow, size: 64),
            const SizedBox(height: 16),
            const Text('Has completado todos los niveles de Coding.'),
            const SizedBox(height: 8),
            Text(
              '+$_earnedCoins Bio-Coins',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.neonYellow,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Volver al HUD'),
          ),
        ],
      ),
    );
  }
  
  Color _getBlockColor(String name) {
    if (name.startsWith('AVANZAR')) return AppColors.neonGreen;
    if (name.startsWith('GIRAR')) return AppColors.neonCyan;
    if (name.startsWith('REPETIR')) return AppColors.neonMagenta;
    if (name.startsWith('SI_')) return AppColors.neonOrange;
    if (name.startsWith('FUNCIÓN')) return const Color(0xFF9C27B0);
    return AppColors.textSecondary;
  }
  
  IconData _getBlockIcon(String name) {
    switch (name) {
      case 'AVANZAR':
        return Icons.arrow_upward;
      case 'GIRAR_DERECHA':
        return Icons.turn_right;
      case 'GIRAR_IZQUIERDA':
        return Icons.turn_left;
      case 'REPETIR_2':
      case 'REPETIR_3':
      case 'REPETIR_4':
        return Icons.loop;
      case 'SI_OBSTACULO':
        return Icons.help_outline;
      case 'FUNCIÓN_A':
        return Icons.functions;
      case 'FUNCIÓN_B':
        return Icons.functions;
      default:
        return Icons.code;
    }
  }
  
  String _getBlockLabel(String name) {
    switch (name) {
      case 'AVANZAR':
        return 'Avanzar';
      case 'GIRAR_DERECHA':
        return 'Derecha';
      case 'GIRAR_IZQUIERDA':
        return 'Izquierda';
      case 'REPETIR_2':
        return 'x2';
      case 'REPETIR_3':
        return 'x3';
      case 'REPETIR_4':
        return 'x4';
      case 'SI_OBSTACULO':
        return 'Si Muro';
      case 'FUNCIÓN_A':
        return 'Fn A';
      case 'FUNCIÓN_B':
        return 'Fn B';
      default:
        return name;
    }
  }
}

/// Bloque de código
class CodeBlock {
  final String name;
  final Color color;
  final IconData icon;
  
  CodeBlock({
    required this.name,
    required this.color,
    required this.icon,
  });
}

/// Nivel de coding
class CodingLevel {
  final String title;
  final String description;
  final int gridSize;
  final Offset robotStart;
  final Offset goalPosition;
  final List<Offset> obstacles;
  final List<String> solution;
  final List<String> availableBlocks;
  final int reward;
  
  CodingLevel({
    required this.title,
    required this.description,
    required this.gridSize,
    required this.robotStart,
    required this.goalPosition,
    required this.obstacles,
    required this.solution,
    required this.availableBlocks,
    required this.reward,
  });
}
