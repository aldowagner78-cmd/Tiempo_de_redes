/// ============================================
/// NEXUS CONTROL - Neuro Game Screen
/// ============================================
/// Pantalla de juego cognitivo. Recibe un CognitiveGameType
/// y ejecuta el mini-juego correspondiente. Al terminar,
/// persiste el resultado en Isar y otorga Bio-Coins reales.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/biocoin_service.dart';
import '../../../../core/services/isar_service.dart';
import '../../../../features/biocoins/domain/entities/biocoin_entity.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../neuro/data/models/cognitive_game_model.dart';

enum _Phase { ready, playing, results }

class NeuroGameScreen extends ConsumerStatefulWidget {
  final CognitiveGameType gameType;
  const NeuroGameScreen({required this.gameType, super.key});

  @override
  ConsumerState<NeuroGameScreen> createState() => _NeuroGameScreenState();
}

class _NeuroGameScreenState extends ConsumerState<NeuroGameScreen> {
  _Phase _phase = _Phase.ready;
  int _score = 0;
  int _correct = 0;
  int _total = 0;
  int _earnedCoins = 0;

  final _rng = Random();

  // ── Reaction Time ─────────────────────────────────────────
  bool _rtGreen = false;
  bool _rtTooEarly = false;
  Timer? _rtTimer;
  final _rtWatch = Stopwatch();
  final List<int> _rtTimes = [];

  // ── Stroop Test ───────────────────────────────────────────
  static const _stropData = [
    ('ROJO', Color(0xFF2196F3), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
    ('AZUL', Color(0xFFF44336), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
    ('VERDE', Color(0xFFFFEB3B), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
    ('AMARILLO', Color(0xFF4CAF50), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
    ('AZUL', Color(0xFF4CAF50), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
    ('ROJO', Color(0xFFFFEB3B), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
    ('VERDE', Color(0xFF2196F3), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
    ('AMARILLO', Color(0xFFF44336), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
    ('ROJO', Color(0xFF4CAF50), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
    ('AZUL', Color(0xFFFFEB3B), [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFFEB3B)]),
  ];
  int _stropRound = 0;
  late String _stropWord;
  late Color _stropInk;
  late List<Color> _stropOptions;
  bool _stropAnswered = false;
  Color? _stropSelected;

  // ── Simon / Pattern Memory ────────────────────────────────
  static const _simonColors = [
    Color(0xFFF44336),
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFFEB3B),
  ];
  final List<int> _simonSeq = [];
  final List<int> _simonInput = [];
  int _simonHighlight = -1;
  bool _simonShowing = false;
  int _simonLevel = 1;
  bool _simonFailed = false;

  // ── N-Back ────────────────────────────────────────────────
  final List<int> _nHistory = [];
  int _nCurrent = 0;
  bool _nAnswered = false;
  int _nCorrect = 0;
  int _nRound = 0;
  static const _nTotal = 10;
  Timer? _nTimer;

  // ── Divided Attention ─────────────────────────────────────
  static const _daColorRed = Color(0xFFF44336);
  static const _daColorBlue = Color(0xFF2196F3);
  static const _daColorGrey = Color(0xFF616161);
  List<Color> _daItems = [];
  int _daIdx = 0;
  int _daRedCount = 0;
  int _daBlueTapped = 0;
  int _daTotalBlue = 0;
  bool _daCounting = false;
  Timer? _daTimer;
  final _daCtrl = TextEditingController();

  // ─────────────────────────────────────────────────────────

  @override
  void dispose() {
    _rtTimer?.cancel();
    _nTimer?.cancel();
    _daTimer?.cancel();
    _daCtrl.dispose();
    super.dispose();
  }

  // ── START ─────────────────────────────────────────────────
  void _start() {
    setState(() {
      _phase = _Phase.playing;
      _score = 0;
      _correct = 0;
      _total = 0;
    });
    switch (widget.gameType) {
      case CognitiveGameType.reactionTime:
        _rtTimes.clear();
        _startRtRound();
      case CognitiveGameType.stroopTest:
        _stropRound = 0;
        _loadStrop();
      case CognitiveGameType.simonSays:
      case CognitiveGameType.patternMemory:
        _simonSeq.clear();
        _simonInput.clear();
        _simonLevel = 1;
        _simonFailed = false;
        _addSimonStep();
      case CognitiveGameType.nBack:
        _nHistory.clear();
        _nRound = 0;
        _nCorrect = 0;
        _nextNBack();
      case CognitiveGameType.dividedAttention:
        _buildDaItems();
        _daIdx = 0;
        _daBlueTapped = 0;
        _daCounting = false;
        _runDaItem();
    }
  }

  // ── REACTION TIME ─────────────────────────────────────────
  void _startRtRound() {
    if (_rtTimes.length >= 5) {
      _finishReaction();
      return;
    }
    setState(() {
      _rtGreen = false;
      _rtTooEarly = false;
    });
    final ms = 1000 + _rng.nextInt(2000);
    _rtTimer = Timer(Duration(milliseconds: ms), () {
      if (!mounted) return;
      setState(() => _rtGreen = true);
      _rtWatch.reset();
      _rtWatch.start();
    });
  }

  void _onRtTap() {
    if (_rtTooEarly) return;
    if (!_rtGreen) {
      _rtTimer?.cancel();
      setState(() => _rtTooEarly = true);
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) _startRtRound();
      });
      return;
    }
    _rtWatch.stop();
    final ms = _rtWatch.elapsedMilliseconds;
    _rtTimes.add(ms);
    setState(() => _rtGreen = false);
    if (_rtTimes.length < 5) {
      Future.delayed(const Duration(milliseconds: 900), _startRtRound);
    } else {
      _finishReaction();
    }
  }

  void _finishReaction() {
    final avg = _rtTimes.fold(0, (a, b) => a + b) ~/ _rtTimes.length;
    _score = ((800 - avg) / 550 * 100).clamp(0, 100).toInt();
    _correct = _rtTimes.where((t) => t < 450).length;
    _total = 5;
    _endGame();
  }

  // ── STROOP TEST ───────────────────────────────────────────
  void _loadStrop() {
    if (_stropRound >= _stropData.length) {
      _score = (_correct / _stropData.length * 100).toInt();
      _total = _stropData.length;
      _endGame();
      return;
    }
    final item = _stropData[_stropRound];
    final opts = List<Color>.from(item.$3)..shuffle(_rng);
    setState(() {
      _stropWord = item.$1;
      _stropInk = item.$2;
      _stropOptions = opts;
      _stropAnswered = false;
      _stropSelected = null;
    });
  }

  void _onStrop(Color picked) {
    if (_stropAnswered) return;
    final correct = picked == _stropInk;
    setState(() {
      _stropAnswered = true;
      _stropSelected = picked;
      if (correct) _correct++;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _stropRound++;
      _loadStrop();
    });
  }

  // ── SIMON / PATTERN MEMORY ────────────────────────────────
  void _addSimonStep() {
    _simonSeq.add(_rng.nextInt(4));
    _simonInput.clear();
    _showSimon();
  }

  Future<void> _showSimon() async {
    setState(() => _simonShowing = true);
    await Future.delayed(const Duration(milliseconds: 500));
    for (int i = 0; i < _simonSeq.length; i++) {
      if (!mounted) return;
      setState(() => _simonHighlight = _simonSeq[i]);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() => _simonHighlight = -1);
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (mounted) setState(() => _simonShowing = false);
  }

  void _onSimonTap(int idx) {
    if (_simonShowing || _simonFailed) return;
    _simonInput.add(idx);
    final pos = _simonInput.length - 1;
    if (_simonInput[pos] != _simonSeq[pos]) {
      setState(() => _simonFailed = true);
      _score = max(0, _simonLevel - 1);
      _correct = max(0, _simonLevel - 1);
      _total = _simonLevel;
      Future.delayed(const Duration(milliseconds: 900), _endGame);
      return;
    }
    if (_simonInput.length == _simonSeq.length) {
      _simonLevel++;
      _correct++;
      _total++;
      if (_simonLevel > 8) {
        _score = 100;
        _endGame();
        return;
      }
      Future.delayed(const Duration(milliseconds: 600), _addSimonStep);
    }
  }

  // ── N-BACK ────────────────────────────────────────────────
  void _nextNBack() {
    if (_nRound >= _nTotal) {
      _score = (_nCorrect / _nTotal * 100).toInt();
      _correct = _nCorrect;
      _total = _nTotal;
      _endGame();
      return;
    }
    final n = 1 + _rng.nextInt(9);
    setState(() {
      _nCurrent = n;
      _nAnswered = false;
    });
    _nHistory.add(n);
    _nTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted || _nAnswered) return;
      _nRound++;
      _nextNBack();
    });
  }

  void _onNBack(bool saidMatch) {
    if (_nAnswered) return;
    _nTimer?.cancel();
    setState(() => _nAnswered = true);
    final isMatch = _nHistory.length >= 2 &&
        _nHistory[_nHistory.length - 2] == _nCurrent;
    if (saidMatch == isMatch) _nCorrect++;
    _nRound++;
    Future.delayed(const Duration(milliseconds: 600), _nextNBack);
  }

  // ── DIVIDED ATTENTION ─────────────────────────────────────
  void _buildDaItems() {
    _daItems = List.generate(20, (_) {
      final r = _rng.nextDouble();
      if (r < 0.35) return _daColorRed;
      if (r < 0.60) return _daColorBlue;
      return _daColorGrey;
    });
    _daRedCount = _daItems.where((c) => c == _daColorRed).length;
    _daTotalBlue = _daItems.where((c) => c == _daColorBlue).length;
  }

  void _runDaItem() {
    if (_daIdx >= _daItems.length) {
      setState(() => _daCounting = true);
      return;
    }
    setState(() {});
    _daTimer = Timer(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      _daIdx++;
      _runDaItem();
    });
  }

  Color get _daCurrentColor =>
      _daIdx < _daItems.length ? _daItems[_daIdx] : Colors.transparent;

  void _onDaTapBlue() {
    if (_daIdx < _daItems.length && _daCurrentColor == _daColorBlue) {
      _daBlueTapped++;
    }
  }

  void _onDaSubmit() {
    final userRed = int.tryParse(_daCtrl.text) ?? -1;
    final redErr = (userRed - _daRedCount).abs();
    final redAcc = 1.0 - (redErr / _daRedCount.clamp(1, 999));
    final blueAcc = _daTotalBlue > 0 ? _daBlueTapped / _daTotalBlue : 1.0;
    _score = ((redAcc * 0.5 + blueAcc * 0.5) * 100).clamp(0, 100).toInt();
    _correct = _score >= 60 ? 1 : 0;
    _total = 1;
    _endGame();
  }

  // ── COINS PER GAME TYPE ───────────────────────────────────
  static const _baseCoins = {
    CognitiveGameType.nBack: 15,
    CognitiveGameType.stroopTest: 10,
    CognitiveGameType.dividedAttention: 20,
    CognitiveGameType.reactionTime: 8,
    CognitiveGameType.patternMemory: 12,
    CognitiveGameType.simonSays: 10,
  };

  // ── END GAME ──────────────────────────────────────────────
  Future<void> _endGame() async {
    final base = _baseCoins[widget.gameType] ?? 10;
    final coins = max(1, (base * _score / 100).round());

    final user = ref.read(currentUserProvider);
    if (user != null) {
      final actual = await ref.read(bioCoinServiceProvider).award(
        userId: user.id,
        coins: coins,
        source: TransactionSource.neuro,
        description: 'Neuro: ${widget.gameType.name} — score $_score',
      );
      final record = CognitiveGameModel()
        ..gameType = widget.gameType
        ..score = _score
        ..accuracy = _total > 0 ? _correct / _total * 100 : 0
        ..coinsEarned = actual
        ..levelReached = _simonLevel
        ..sessionDurationSeconds = 0;
      final isar = IsarService.instance;
      await isar.writeTxn(() => isar.cognitiveGameModels.put(record));
      _earnedCoins = actual;
    }

    if (mounted) setState(() => _phase = _Phase.results);
  }

  // ── BUILD ─────────────────────────────────────────────────
  String get _title {
    switch (widget.gameType) {
      case CognitiveGameType.nBack: return 'N-BACK';
      case CognitiveGameType.stroopTest: return 'STROOP TEST';
      case CognitiveGameType.dividedAttention: return 'ATENCIÓN DIVIDIDA';
      case CognitiveGameType.reactionTime: return 'TIEMPO DE REACCIÓN';
      case CognitiveGameType.patternMemory: return 'MEMORIA DE PATRONES';
      case CognitiveGameType.simonSays: return 'SIMON SAYS';
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
          icon:
              const Icon(Icons.arrow_back_ios, color: AppColors.moduleNeuro),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _title,
          style: const TextStyle(
            color: AppColors.moduleNeuro,
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

  // ── READY SCREEN ──────────────────────────────────────────
  Widget _buildReady() {
    final descs = {
      CognitiveGameType.reactionTime:
          'Toca la pantalla en cuanto el fondo se ponga VERDE.\n5 rondas. ¿Puedes bajar de 250 ms?',
      CognitiveGameType.stroopTest:
          'Verás un nombre de color escrito en otro color.\nToca el círculo que coincida con el color de la TINTA.',
      CognitiveGameType.simonSays:
          'Memoriza la secuencia de colores y repítela.\nCada nivel añade un color más.',
      CognitiveGameType.patternMemory:
          'Recuerda el patrón de botones y repítelo.\nSobrevive la mayor cantidad de rondas.',
      CognitiveGameType.nBack:
          'Verás números de forma secuencial.\nPulsa SÍ si el número es igual al ANTERIOR.\n10 rondas.',
      CognitiveGameType.dividedAttention:
          'Cuenta los círculos ROJOS (solo mentalmente).\nAl mismo tiempo, TOCA cada círculo AZUL cuando aparezca.',
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology, color: AppColors.moduleNeuro, size: 72),
            const SizedBox(height: 24),
            Text(
              _title,
              style: const TextStyle(
                color: AppColors.moduleNeuro,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              descs[widget.gameType] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.moduleNeuro,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
    switch (widget.gameType) {
      case CognitiveGameType.reactionTime:
        return _buildReactionGame();
      case CognitiveGameType.stroopTest:
        return _buildStroopGame();
      case CognitiveGameType.simonSays:
      case CognitiveGameType.patternMemory:
        return _buildSimonGame();
      case CognitiveGameType.nBack:
        return _buildNBackGame();
      case CognitiveGameType.dividedAttention:
        return _buildDividedGame();
    }
  }

  // ── REACTION TIME GAME ────────────────────────────────────
  Widget _buildReactionGame() {
    final bgColor = _rtTooEarly
        ? const Color(0xFFE65100)
        : _rtGreen
            ? AppColors.neonGreen
            : const Color(0xFF7B0000);
    final label = _rtTooEarly
        ? '¡Demasiado pronto!'
        : _rtGreen
            ? '¡AHORA!'
            : _rtTimes.isEmpty
                ? 'Toca cuando cambie a verde\nPrepárate...'
                : 'Ronda ${_rtTimes.length}/5\nÚltimo: ${_rtTimes.last} ms';
    return GestureDetector(
      onTap: _rtTooEarly ? null : _onRtTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: bgColor,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _rtGreen ? Colors.black : Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              if (_rtTimes.isNotEmpty) ...[
                const SizedBox(height: 32),
                ...List.generate(
                    _rtTimes.length,
                    (i) => Text(
                          'Ronda ${i + 1}: ${_rtTimes[i]} ms',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 14),
                        )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── STROOP GAME ───────────────────────────────────────────
  Widget _buildStroopGame() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ronda ${_stropRound + 1} / ${_stropData.length}',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _stropRound / _stropData.length,
            backgroundColor: AppColors.surface,
            valueColor:
                const AlwaysStoppedAnimation(AppColors.moduleNeuro),
          ),
          const SizedBox(height: 48),
          const Text(
            'Toca el color de la TINTA',
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 32),
          Text(
            _stropWord,
            style: TextStyle(
              color: _stropInk,
              fontSize: 56,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _stropOptions.map((c) {
              final selected = _stropSelected == c;
              final isCorrect = c == _stropInk;
              final borderColor = !_stropAnswered
                  ? Colors.transparent
                  : selected
                      ? (isCorrect ? AppColors.neonGreen : Colors.red)
                      : Colors.transparent;
              return GestureDetector(
                onTap: () => _onStrop(c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 4),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '✓ $_correct',
                style: const TextStyle(
                    color: AppColors.neonGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 24),
              Text(
                '✗ ${_stropRound - _correct}',
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── SIMON GAME ────────────────────────────────────────────
  Widget _buildSimonGame() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _simonFailed ? '✗ INCORRECTO' : 'Nivel $_simonLevel',
          style: TextStyle(
            color: _simonFailed ? Colors.red : AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _simonShowing ? 'Mira la secuencia...' : 'Tu turno',
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: 260,
          height: 260,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(4, (i) {
              final lit = _simonHighlight == i;
              return GestureDetector(
                onTap: () => _onSimonTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: lit
                        ? _simonColors[i]
                        : _simonColors[i].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _simonColors[i].withOpacity(0.8), width: 2),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${_simonSeq.length} pasos en secuencia',
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  // ── N-BACK GAME ───────────────────────────────────────────
  Widget _buildNBackGame() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ronda ${_nRound + 1} / $_nTotal',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _nRound / _nTotal,
            backgroundColor: AppColors.surface,
            valueColor:
                const AlwaysStoppedAnimation(AppColors.moduleNeuro),
          ),
          const SizedBox(height: 12),
          Text(
            'Correctas: $_nCorrect',
            style: const TextStyle(
                color: AppColors.neonGreen, fontSize: 14),
          ),
          const SizedBox(height: 48),
          const Text(
            '¿Es igual al número anterior?',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                letterSpacing: 1),
          ),
          const SizedBox(height: 32),
          Container(
            width: 120,
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.moduleNeuro, width: 3),
              color: AppColors.surface,
            ),
            child: Text(
              '$_nCurrent',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 56,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _nBtn('SÍ', AppColors.neonGreen, Colors.black,
                  () => _onNBack(true)),
              _nBtn('NO', Colors.red, Colors.white,
                  () => _onNBack(false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nBtn(
      String label, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: _nAnswered ? null : onTap,
      child: Container(
        width: 120,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _nAnswered ? AppColors.surface : bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                color: fg,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ── DIVIDED ATTENTION GAME ────────────────────────────────
  Widget _buildDividedGame() {
    if (_daCounting) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Cuántos círculos ROJOS viste?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Azules tocados: $_daBlueTapped / $_daTotalBlue',
              style: const TextStyle(
                  color: AppColors.neonCyan, fontSize: 14),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _daCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 32),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColors.moduleNeuro),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.moduleNeuro,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _onDaSubmit,
                child: const Text(
                  'CONFIRMAR',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final color = _daCurrentColor;
    return GestureDetector(
      onTap: color == _daColorBlue ? _onDaTapBlue : null,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_daIdx + 1} / ${_daItems.length}',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _daIdx / _daItems.length,
                backgroundColor: AppColors.surface,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.moduleNeuro),
              ),
            ),
            const SizedBox(height: 64),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: color),
            ),
            const SizedBox(height: 40),
            if (color == _daColorBlue)
              const Text('¡TOCA!',
                  style: TextStyle(
                      color: AppColors.neonCyan,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            if (color == _daColorRed)
              const Text('cuenta mentalmente',
                  style: TextStyle(
                      color: Color(0xFFF44336), fontSize: 15)),
            if (color == _daColorGrey)
              const Text('ignora',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // ── RESULTS SCREEN ────────────────────────────────────────
  Widget _buildResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _score >= 70 ? Icons.emoji_events : Icons.psychology,
              color: AppColors.moduleNeuro,
              size: 72,
            ),
            const SizedBox(height: 24),
            Text(
              _score >= 70
                  ? '¡EXCELENTE!'
                  : _score >= 40
                      ? '¡BIEN HECHO!'
                      : 'SIGUE PRACTICANDO',
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
                  backgroundColor: AppColors.moduleNeuro,
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
