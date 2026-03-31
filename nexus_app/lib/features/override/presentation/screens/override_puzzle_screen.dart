/// ============================================
/// NEXUS CONTROL - Override Puzzle Screen
/// ============================================
/// Pantalla de puzzle técnico. Recibe un PuzzleType
/// y ejecuta el desafío correspondiente. Al terminar,
/// persiste el resultado en Isar y otorga Bio-Coins reales.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/biocoin_service.dart';
import '../../../../core/services/isar_service.dart';
import '../../../../features/biocoins/domain/entities/biocoin_entity.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../override/data/models/puzzle_record_model.dart';

enum _Phase { ready, playing, results }

class OverridePuzzleScreen extends ConsumerStatefulWidget {
  final PuzzleType puzzleType;
  const OverridePuzzleScreen({required this.puzzleType, super.key});

  @override
  ConsumerState<OverridePuzzleScreen> createState() =>
      _OverridePuzzleScreenState();
}

class _OverridePuzzleScreenState
    extends ConsumerState<OverridePuzzleScreen> {
  _Phase _phase = _Phase.ready;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _earnedCoins = 0;

  final _rng = Random();

  // ── Logic Gate ────────────────────────────────────────────
  static const _gateQs = [
    ('A=1, B=1', 'AND', 1),
    ('A=1, B=0', 'AND', 0),
    ('A=0, B=0', 'OR', 0),
    ('A=1, B=0', 'OR', 1),
    ('A=1', 'NOT', 0),
    ('A=0', 'NOT', 1),
    ('A=0, B=1', 'AND', 0),
    ('A=1, B=1', 'OR', 1),
  ];
  int _gateIdx = 0;
  bool _gateAnswered = false;
  int? _gateSelected;

  // ── Sequence Sort ─────────────────────────────────────────
  static const _sortPuzzles = [
    (
      'Suma de 1 a N',
      ['suma = 0', 'para i de 1 a N:', '  suma = suma + i', 'retornar suma'],
    ),
    (
      'Validar contraseña',
      [
        'leer password',
        'si length(password) < 8: error',
        'si no tiene números: error',
        'acceso permitido',
      ],
    ),
    (
      'Encontrar el mayor',
      ['mayor = lista[0]', 'para x en lista:', '  si x > mayor: mayor = x', 'retornar mayor'],
    ),
  ];
  int _sortPuzzleIdx = 0;
  List<String> _sortItems = [];
  List<String> _sortSelected = [];

  // ── Debugging ─────────────────────────────────────────────
  static const _bugs = [
    (
      'Error en división',
      ['x = 10', 'y = 0', 'resultado = x / y', 'imprimir(resultado)'],
      2, // índice de la línea con bug (0-based)
      'División por cero — y nunca puede ser 0',
    ),
    (
      'Bucle infinito',
      ['i = 0', 'suma = 0', 'mientras i < 10:', '  suma += i'],
      3, // falta i++
      'Falta incrementar i dentro del bucle: i = i + 1',
    ),
    (
      'Asignación en condición',
      ['x = 5', 'si (x = 5):', '  imprimir("igual")', 'sino: imprimir("distinto")'],
      1,
      'Se usa = (asignación) en vez de == (comparación)',
    ),
  ];
  int _bugIdx = 0;
  bool _bugAnswered = false;
  int? _bugSelected;

  // ── Pattern Match ─────────────────────────────────────────
  static const _patterns = [
    ([2, 4, 8, 16], 32, [24, 32, 30, 20]),      // ×2 → 32
    ([1, 4, 9, 16], 25, [20, 25, 22, 28]),       // n² → 25
    ([3, 6, 9, 12], 15, [13, 14, 15, 16]),       // +3 → 15
    ([1, 1, 2, 3, 5], 8, [6, 7, 8, 9]),          // Fibonacci → 8
    ([2, 5, 10, 17], 26, [26, 27, 28, 30]),      // n²+1 → 26
  ];
  int _patIdx = 0;
  bool _patAnswered = false;
  int? _patSelected;

  // ── Flowchart ─────────────────────────────────────────────
  static const _flows = [
    (
      'INICIO → Leer N →\n[???] → SI: Imprimir "positivo" → FIN',
      '¿N > 0?',
      ['¿N > 0?', 'Leer otro N', 'Terminar', 'Dividir N'],
    ),
    (
      'INICIO → i = 0 →\n[???] →\nSI: suma += i → i++ → volver\nNO: FIN',
      '¿i < 10?',
      ['¿suma > 10?', '¿i < 10?', 'suma = 0', 'imprimir(i)'],
    ),
    (
      'INICIO → leer x →\n[???] →\nSI: x = 0 → FIN\nNO: x = x − 1 → volver',
      '¿x > 0?',
      ['¿x > 0?', 'x = x + 1', 'imprimir x', 'x = x × 2'],
    ),
  ];
  int _flowIdx = 0;
  bool _flowAnswered = false;
  String? _flowSelected;

  // ─────────────────────────────────────────────────────────

  // ── COINS PER PUZZLE TYPE ─────────────────────────────────
  static const _baseCoins = {
    PuzzleType.logicGate: 20,
    PuzzleType.debugging: 25,
    PuzzleType.flowchart: 15,
    PuzzleType.sequenceSort: 15,
    PuzzleType.patternMatch: 18,
  };

  // ── START ─────────────────────────────────────────────────
  void _start() {
    setState(() {
      _phase = _Phase.playing;
      _score = 0;
      _correct = 0;
      _total = 0;
    });
    switch (widget.puzzleType) {
      case PuzzleType.logicGate:
        _gateIdx = 0;
        _gateAnswered = false;
        _gateSelected = null;
      case PuzzleType.sequenceSort:
        _sortPuzzleIdx = 0;
        _loadSort();
      case PuzzleType.debugging:
        _bugIdx = 0;
        _bugAnswered = false;
        _bugSelected = null;
      case PuzzleType.patternMatch:
        _patIdx = 0;
        _patAnswered = false;
        _patSelected = null;
      case PuzzleType.flowchart:
        _flowIdx = 0;
        _flowAnswered = false;
        _flowSelected = null;
    }
  }

  // ── LOGIC GATE ────────────────────────────────────────────
  void _onGateAnswer(int answer) {
    if (_gateAnswered) return;
    final q = _gateQs[_gateIdx];
    final isRight = answer == q.$3;
    setState(() {
      _gateAnswered = true;
      _gateSelected = answer;
      if (isRight) _correct++;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _gateIdx++;
      _total++;
      if (_gateIdx >= _gateQs.length) {
        _score = (_correct / _gateQs.length * 100).toInt();
        _endGame();
        return;
      }
      setState(() {
        _gateAnswered = false;
        _gateSelected = null;
      });
    });
  }

  // ── SEQUENCE SORT ─────────────────────────────────────────
  void _loadSort() {
    if (_sortPuzzleIdx >= _sortPuzzles.length) {
      _score = (_correct / _sortPuzzles.length * 100).toInt();
      _endGame();
      return;
    }
    final puz = _sortPuzzles[_sortPuzzleIdx];
    setState(() {
      _sortItems = List<String>.from(puz.$2)..shuffle(_rng);
      _sortSelected = [];
      _total++;
    });
  }

  void _onSortTap(String item) {
    if (_sortSelected.contains(item)) {
      setState(() => _sortSelected.remove(item));
      return;
    }
    setState(() => _sortSelected.add(item));
    if (_sortSelected.length == _sortItems.length) {
      _checkSort();
    }
  }

  void _checkSort() {
    final correct = _sortPuzzles[_sortPuzzleIdx].$2;
    final isRight = _sortSelected.join('|') == correct.join('|');
    if (isRight) _correct++;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isRight ? '¡Correcto!' : 'Incorrecto — revisa el orden'),
      backgroundColor: isRight ? AppColors.neonGreen : Colors.red,
      duration: const Duration(milliseconds: 1500),
    ));
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      _sortPuzzleIdx++;
      _loadSort();
    });
  }

  // ── DEBUGGING ─────────────────────────────────────────────
  void _onBugAnswer(int lineIdx) {
    if (_bugAnswered) return;
    final bug = _bugs[_bugIdx];
    final isRight = lineIdx == bug.$3;
    setState(() {
      _bugAnswered = true;
      _bugSelected = lineIdx;
      if (isRight) _correct++;
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      _bugIdx++;
      _total++;
      if (_bugIdx >= _bugs.length) {
        _score = (_correct / _bugs.length * 100).toInt();
        _endGame();
        return;
      }
      setState(() {
        _bugAnswered = false;
        _bugSelected = null;
      });
    });
  }

  // ── PATTERN MATCH ─────────────────────────────────────────
  void _onPatAnswer(int value) {
    if (_patAnswered) return;
    final pat = _patterns[_patIdx];
    final isRight = value == pat.$2;
    setState(() {
      _patAnswered = true;
      _patSelected = value;
      if (isRight) _correct++;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _patIdx++;
      _total++;
      if (_patIdx >= _patterns.length) {
        _score = (_correct / _patterns.length * 100).toInt();
        _endGame();
        return;
      }
      setState(() {
        _patAnswered = false;
        _patSelected = null;
      });
    });
  }

  // ── FLOWCHART ─────────────────────────────────────────────
  void _onFlowAnswer(String opt) {
    if (_flowAnswered) return;
    final flow = _flows[_flowIdx];
    final isRight = opt == flow.$2;
    setState(() {
      _flowAnswered = true;
      _flowSelected = opt;
      if (isRight) _correct++;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _flowIdx++;
      _total++;
      if (_flowIdx >= _flows.length) {
        _score = (_correct / _flows.length * 100).toInt();
        _endGame();
        return;
      }
      setState(() {
        _flowAnswered = false;
        _flowSelected = null;
      });
    });
  }

  // ── END GAME ──────────────────────────────────────────────
  Future<void> _endGame() async {
    final base = _baseCoins[widget.puzzleType] ?? 15;
    final coins = max(1, (base * _score / 100).round());

    final user = ref.read(currentUserProvider);
    if (user != null) {
      final actual = await ref.read(bioCoinServiceProvider).award(
        userId: user.id,
        coins: coins,
        source: TransactionSource.override,
        description: 'Override: ${widget.puzzleType.name} — score $_score',
      );
      final record = PuzzleRecordModel()
        ..puzzleType = widget.puzzleType
        ..puzzleId = widget.puzzleType.name
        ..difficultyLevel = 1
        ..isCompleted = _score >= 50
        ..attempts = 1
        ..score = _score
        ..coinsEarned = actual;
      final isar = IsarService.instance;
      await isar.writeTxn(() => isar.puzzleRecordModels.put(record));
      _earnedCoins = actual;
    }

    if (mounted) setState(() => _phase = _Phase.results);
  }

  // ── BUILD ─────────────────────────────────────────────────
  String get _title {
    switch (widget.puzzleType) {
      case PuzzleType.logicGate: return 'COMPUERTAS LÓGICAS';
      case PuzzleType.debugging: return 'DEBUGGING';
      case PuzzleType.flowchart: return 'DIAGRAMAS DE FLUJO';
      case PuzzleType.sequenceSort: return 'ORDENAR SECUENCIA';
      case PuzzleType.patternMatch: return 'PATRONES';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.moduleOverride),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _title,
          style: const TextStyle(
            color: AppColors.moduleOverride,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: switch (_phase) {
        _Phase.ready => _buildReady(),
        _Phase.playing => _buildPlaying(),
        _Phase.results => _buildResults(),
      },
    );
  }

  // ── READY ─────────────────────────────────────────────────
  Widget _buildReady() {
    final descs = {
      PuzzleType.logicGate:
          'Evalúa operaciones lógicas AND, OR y NOT.\nResponde si el resultado es 0 o 1.\n${_gateQs.length} preguntas.',
      PuzzleType.debugging:
          'Cada puzzle muestra líneas de pseudocódigo.\nToca la línea que contiene el ERROR.\n${_bugs.length} bugs para encontrar.',
      PuzzleType.flowchart:
          'Completa el elemento faltante del diagrama de flujo.\nElige la opción correcta.\n${_flows.length} diagramas.',
      PuzzleType.sequenceSort:
          'Las instrucciones están desordenadas.\nTócalas en el orden CORRECTO de ejecución.\n${_sortPuzzles.length} algoritmos.',
      PuzzleType.patternMatch:
          'Observa la secuencia de números y determina cuál sigue.\n${_patterns.length} patrones a resolver.',
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.terminal,
                color: AppColors.moduleOverride, size: 72),
            const SizedBox(height: 24),
            Text(
              _title,
              style: const TextStyle(
                color: AppColors.moduleOverride,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              descs[widget.puzzleType] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.6),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.moduleOverride,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _start,
                child: const Text(
                  'COMENZAR',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaying() {
    switch (widget.puzzleType) {
      case PuzzleType.logicGate: return _buildGate();
      case PuzzleType.sequenceSort: return _buildSort();
      case PuzzleType.debugging: return _buildDebug();
      case PuzzleType.patternMatch: return _buildPattern();
      case PuzzleType.flowchart: return _buildFlow();
    }
  }

  // ── LOGIC GATE UI ─────────────────────────────────────────
  Widget _buildGate() {
    if (_gateIdx >= _gateQs.length) return const SizedBox();
    final q = _gateQs[_gateIdx];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pregunta ${_gateIdx + 1} / ${_gateQs.length}',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _gateIdx / _gateQs.length,
            backgroundColor: AppColors.surface,
            valueColor:
                const AlwaysStoppedAnimation(AppColors.moduleOverride),
          ),
          const SizedBox(height: 48),
          Text(
            q.$1,
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18),
          ),
          const SizedBox(height: 16),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.moduleOverride.withOpacity(0.4)),
            ),
            child: Text(
              '${q.$1}  ${q.$2}  ?',
              style: const TextStyle(
                color: AppColors.moduleOverride,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [0, 1].map((v) {
              Color bg = AppColors.surface;
              if (_gateAnswered && _gateSelected == v) {
                bg = v == q.$3 ? AppColors.neonGreen : Colors.red;
              }
              return GestureDetector(
                onTap: () => _onGateAnswer(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 120,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.moduleOverride, width: 2),
                  ),
                  child: Text(
                    '$v',
                    style: TextStyle(
                      color: _gateAnswered && _gateSelected == v
                          ? Colors.black
                          : AppColors.textPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Correctas: $_correct',
            style: const TextStyle(
                color: AppColors.neonGreen, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ── SEQUENCE SORT UI ──────────────────────────────────────
  Widget _buildSort() {
    if (_sortPuzzleIdx >= _sortPuzzles.length) return const SizedBox();
    final puz = _sortPuzzles[_sortPuzzleIdx];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Puzzle ${_sortPuzzleIdx + 1} / ${_sortPuzzles.length}',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            puz.$1,
            style: const TextStyle(
                color: AppColors.moduleOverride,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Toca las instrucciones en el orden correcto de ejecución:',
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: _sortItems.map((item) {
                final idx = _sortSelected.indexOf(item);
                final selected = idx != -1;
                return GestureDetector(
                  onTap: () => _onSortTap(item),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.moduleOverride.withOpacity(0.25)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected
                            ? AppColors.moduleOverride
                            : AppColors.surface.withOpacity(0.5),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (selected)
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.moduleOverride,
                              shape: BoxShape.circle,
                            ),
                            child: Text('${idx + 1}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          )
                        else
                          const SizedBox(width: 40),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: selected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (_sortSelected.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Seleccionadas: ${_sortSelected.length} / ${_sortItems.length}',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // ── DEBUG UI ──────────────────────────────────────────────
  Widget _buildDebug() {
    if (_bugIdx >= _bugs.length) return const SizedBox();
    final bug = _bugs[_bugIdx];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bug ${_bugIdx + 1} / ${_bugs.length}',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            bug.$1,
            style: const TextStyle(
                color: AppColors.moduleOverride,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toca la línea que contiene el ERROR:',
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ...List.generate(bug.$2.length, (i) {
            Color bg = AppColors.surface;
            Color border = AppColors.surface;
            if (_bugAnswered && _bugSelected == i) {
              final isRight = i == bug.$3;
              bg = isRight
                  ? AppColors.neonGreen.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2);
              border = isRight ? AppColors.neonGreen : Colors.red;
            }
            return GestureDetector(
              onTap: () => _onBugAnswer(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: border, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 12),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12),
                      ),
                    ),
                    Text(
                      bug.$2[i],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'monospace',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (_bugAnswered)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.neonCyan.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.neonCyan, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bug.$4,
                        style: const TextStyle(
                            color: AppColors.neonCyan, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── PATTERN MATCH UI ──────────────────────────────────────
  Widget _buildPattern() {
    if (_patIdx >= _patterns.length) return const SizedBox();
    final pat = _patterns[_patIdx];
    final opts = List<int>.from(pat.$3)..shuffle(_rng);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Patrón ${_patIdx + 1} / ${_patterns.length}',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _patIdx / _patterns.length,
            backgroundColor: AppColors.surface,
            valueColor:
                const AlwaysStoppedAnimation(AppColors.moduleOverride),
          ),
          const SizedBox(height: 48),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              ...pat.$1.map((n) => _numBox(n.toString(),
                  AppColors.surface, AppColors.textPrimary)),
              _numBox('?', AppColors.moduleOverride.withOpacity(0.2),
                  AppColors.moduleOverride),
            ],
          ),
          const SizedBox(height: 48),
          const Text(
            'Elige el número que completa la serie:',
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: opts.map((v) {
              Color bg = AppColors.surface;
              if (_patAnswered && _patSelected == v) {
                bg = v == pat.$2 ? AppColors.neonGreen : Colors.red;
              }
              return GestureDetector(
                onTap: () => _onPatAnswer(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 72,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.moduleOverride, width: 2),
                  ),
                  child: Text(
                    '$v',
                    style: TextStyle(
                      color: _patAnswered && _patSelected == v
                          ? Colors.black
                          : AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Correctas: $_correct',
            style: const TextStyle(
                color: AppColors.neonGreen, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _numBox(String text, Color bg, Color fg) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: AppColors.moduleOverride.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: fg, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ── FLOWCHART UI ──────────────────────────────────────────
  Widget _buildFlow() {
    if (_flowIdx >= _flows.length) return const SizedBox();
    final flow = _flows[_flowIdx];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Diagrama ${_flowIdx + 1} / ${_flows.length}',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _flowIdx / _flows.length,
            backgroundColor: AppColors.surface,
            valueColor:
                const AlwaysStoppedAnimation(AppColors.moduleOverride),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.moduleOverride.withOpacity(0.4)),
            ),
            child: Text(
              flow.$1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.8,
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Elige qué va en [???]:',
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 20),
          ...flow.$3.map((opt) {
            Color bg = AppColors.surface;
            if (_flowAnswered && _flowSelected == opt) {
              bg = opt == flow.$2
                  ? AppColors.neonGreen.withOpacity(0.25)
                  : Colors.red.withOpacity(0.25);
            }
            final borderColor = _flowAnswered && _flowSelected == opt
                ? (opt == flow.$2 ? AppColors.neonGreen : Colors.red)
                : AppColors.surface;
            return GestureDetector(
              onTap: () => _onFlowAnswer(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow,
                        color: AppColors.moduleOverride, size: 18),
                    const SizedBox(width: 12),
                    Text(
                      opt,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── RESULTS ───────────────────────────────────────────────
  Widget _buildResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _score >= 70 ? Icons.emoji_events : Icons.terminal,
              color: AppColors.moduleOverride,
              size: 72,
            ),
            const SizedBox(height: 24),
            Text(
              _score >= 70
                  ? '¡HACK EXITOSO!'
                  : _score >= 40
                      ? '¡BUEN INTENTO!'
                      : 'SIGUE ENTRENANDO',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),
            _row('Puntuación', '$_score / 100'),
            if (_total > 0) _row('Correctas', '$_correct / $_total'),
            _row('Bio-Coins ganados', '+$_earnedCoins ◈'),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.moduleOverride,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'VOLVER',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 16)),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
