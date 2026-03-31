/// ============================================
/// NEXUS CONTROL - Biblioteca Module Screen
/// ============================================
/// Módulo de lectura - "Biblioteca"
/// OCR para escanear libros y generar quizzes

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/biocoin_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../features/biocoins/domain/entities/biocoin_entity.dart';

class CommsScreen extends ConsumerStatefulWidget {
  const CommsScreen({super.key});

  @override
  ConsumerState<CommsScreen> createState() => _CommsScreenState();
}

class _CommsScreenState extends ConsumerState<CommsScreen> {
  // Estados de la pantalla
  PageState _pageState = PageState.camera;
  
  // Cámara
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  
  // OCR
  final TextRecognizer _textRecognizer = TextRecognizer();
  String _scannedText = '';
  
  // Quiz
  List<QuizQuestion> _quizQuestions = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int? _selectedAnswer;
  bool _showQuizResult = false;
  
  // Estadísticas
  int _pagesScanned = 0;
  int _quizzesCompleted = 0;
  int _earnedCoins = 0;
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  
  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }
  
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      debugPrint('Error inicializando cámara: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bioCoins = ref.watch(bioCoinBalanceProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('BIBLIOTECA'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.moduleComms,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: BioCoinDisplay(amount: bioCoins, size: 20),
          ),
        ],
      ),
      body: ScanlineOverlay(
        child: _buildCurrentPage(),
      ),
    );
  }
  
  Widget _buildCurrentPage() {
    switch (_pageState) {
      case PageState.camera:
        return _buildCameraPage();
      case PageState.reading:
        return _buildReadingPage();
      case PageState.quiz:
        return _buildQuizPage();
      case PageState.result:
        return _buildResultPage();
    }
  }
  
  /// ========== PÁGINA DE CÁMARA ==========
  Widget _buildCameraPage() {
    return Column(
      children: [
        // Estadísticas rápidas
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  'Páginas',
                  '$_pagesScanned',
                  Icons.menu_book,
                  AppColors.moduleComms,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniStat(
                  'Quizzes',
                  '$_quizzesCompleted',
                  Icons.quiz,
                  AppColors.neonMagenta,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniStat(
                  'Coins',
                  '+$_earnedCoins',
                  Icons.monetization_on,
                  AppColors.neonYellow,
                ),
              ),
            ],
          ),
        ),
        
        // Preview de cámara
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.moduleComms, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: _isCameraInitialized
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(_cameraController!),
                        
                        // Guía de escaneo
                        CustomPaint(
                          painter: ScanGuidePainter(
                            color: AppColors.moduleComms.withOpacity(0.5),
                          ),
                        ),
                        
                        // Indicador de procesamiento
                        if (_isProcessing)
                          Container(
                            color: AppColors.background.withOpacity(0.8),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(
                                    color: AppColors.moduleComms,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Reconociendo texto...',
                                    style: TextStyle(
                                      color: AppColors.moduleComms,
                                    ),
                                  ),
                                ]
                                    .animate(interval: 100.ms)
                                    .fadeIn()
                                    .slideY(begin: 0.2),
                              ),
                            ),
                          ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.moduleComms,
                      ),
                    ),
            ),
          ),
        ),
        
        // Instrucciones
        Padding(
          padding: const EdgeInsets.all(16),
          child: HudPanel(
            borderColor: AppColors.moduleComms,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.moduleComms),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Coloca el libro frente a la cámara.\nEl texto será reconocido automáticamente.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Botón de captura
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: GestureDetector(
            onTap: _captureAndRecognize,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.moduleComms,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.moduleComms.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.document_scanner,
                color: AppColors.background,
                size: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  /// ========== PÁGINA DE LECTURA ==========
  Widget _buildReadingPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          HudPanel(
            borderColor: AppColors.moduleComms,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.moduleComms.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: AppColors.moduleComms,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Texto Escaneado',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Lee el texto y prepárate para el quiz',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Texto escaneado
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              _scannedText.isEmpty 
                  ? 'No se encontró texto en la imagen.'
                  : _scannedText,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botones de acción
          if (_scannedText.isNotEmpty) ...[
            NeonButton(
              text: 'COMENZAR QUIZ',
              icon: Icons.quiz,
              color: AppColors.neonGreen,
              onPressed: _startQuiz,
              width: double.infinity,
            ),
            const SizedBox(height: 12),
          ],
          
          NeonButton(
            text: 'Escanear otra página',
            icon: Icons.refresh,
            color: AppColors.textSecondary,
            onPressed: () => setState(() => _pageState = PageState.camera),
            width: double.infinity,
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }
  
  /// ========== PÁGINA DE QUIZ ==========
  Widget _buildQuizPage() {
    if (_quizQuestions.isEmpty) {
      return const Center(
        child: Text('Error generando quiz'),
      );
    }
    
    final question = _quizQuestions[_currentQuestionIndex];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progreso
          Row(
            children: [
              Text(
                'Pregunta ${_currentQuestionIndex + 1} de ${_quizQuestions.length}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '$_correctAnswers correctas',
                style: const TextStyle(
                  color: AppColors.neonGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          NeonProgressBar(
            value: (_currentQuestionIndex + 1) / _quizQuestions.length,
            height: 8,
            color: AppColors.moduleComms,
          ),
          
          const SizedBox(height: 24),
          
          // Pregunta
          HudPanel(
            borderColor: AppColors.moduleComms,
            child: Column(
              children: [
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                // Opciones
                ...List.generate(question.options.length, (index) {
                  final isSelected = _selectedAnswer == index;
                  final showResult = _showQuizResult;
                  final isCorrect = index == question.correctIndex;
                  
                  Color borderColor = AppColors.border;
                  Color bgColor = AppColors.surface;
                  
                  if (showResult) {
                    if (isCorrect) {
                      borderColor = AppColors.neonGreen;
                      bgColor = AppColors.neonGreen.withOpacity(0.1);
                    } else if (isSelected && !isCorrect) {
                      borderColor = AppColors.neonRed;
                      bgColor = AppColors.neonRed.withOpacity(0.1);
                    }
                  } else if (isSelected) {
                    borderColor = AppColors.moduleComms;
                    bgColor = AppColors.moduleComms.withOpacity(0.1);
                  }
                  
                  return GestureDetector(
                    onTap: showResult ? null : () => _selectAnswer(index),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: borderColor.withOpacity(0.2),
                              border: Border.all(color: borderColor),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: borderColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (showResult && isCorrect)
                            const Icon(Icons.check_circle, color: AppColors.neonGreen),
                          if (showResult && isSelected && !isCorrect)
                            const Icon(Icons.cancel, color: AppColors.neonRed),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botón de acción
          if (!_showQuizResult && _selectedAnswer != null)
            NeonButton(
              text: 'VERIFICAR',
              icon: Icons.check,
              color: AppColors.moduleComms,
              onPressed: _verifyAnswer,
              width: double.infinity,
            ),
          
          if (_showQuizResult)
            NeonButton(
              text: _currentQuestionIndex < _quizQuestions.length - 1
                  ? 'SIGUIENTE'
                  : 'VER RESULTADOS',
              icon: Icons.arrow_forward,
              color: AppColors.neonGreen,
              onPressed: _nextQuestion,
              width: double.infinity,
            ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }
  
  /// ========== PÁGINA DE RESULTADOS ==========
  Widget _buildResultPage() {
    final totalQuestions = _quizQuestions.length;
    final percentage = ((_correctAnswers / totalQuestions) * 100).round();
    final coinsEarned = _correctAnswers * 5;
    final isPassed = percentage >= 60;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 32),
          
          // Resultado principal
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isPassed ? AppColors.neonGreen : AppColors.neonRed)
                  .withOpacity(0.1),
              border: Border.all(
                color: isPassed ? AppColors.neonGreen : AppColors.neonRed,
                width: 4,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isPassed ? AppColors.neonGreen : AppColors.neonRed,
                  ),
                ),
                Text(
                  '$_correctAnswers/$totalQuestions',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .scale(begin: const Offset(0.5, 0.5)),
          
          const SizedBox(height: 24),
          
          Text(
            isPassed ? '¡Quiz Completado!' : 'Sigue practicando',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isPassed ? AppColors.neonGreen : AppColors.neonRed,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Recompensa
          if (isPassed)
            HudPanel(
              borderColor: AppColors.neonYellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: AppColors.neonYellow,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      const Text(
                        'Recompensa',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '+$coinsEarned Bio-Coins',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neonYellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms)
                .shimmer(color: AppColors.neonYellow.withOpacity(0.3)),
          
          const SizedBox(height: 32),
          
          // Botones
          NeonButton(
            text: 'ESCANEAR OTRA PÁGINA',
            icon: Icons.document_scanner,
            color: AppColors.moduleComms,
            onPressed: () {
              setState(() {
                _pagesScanned++;
                _quizzesCompleted++;
                _earnedCoins += coinsEarned;

                final user = ref.read(currentUserProvider);
                if (user != null) {
                  ref.read(bioCoinServiceProvider).award(
                    userId: user.id,
                    coins: coinsEarned,
                    source: TransactionSource.comms,
                    description: 'Comms: quiz de lectura completado ($_correctAnswers respuestas correctas)',
                  );
                }
                _pageState = PageState.camera;
                _scannedText = '';
                _quizQuestions = [];
                _currentQuestionIndex = 0;
                _correctAnswers = 0;
              });
            },
            width: double.infinity,
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }
  
  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
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
              fontSize: 16,
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
  
  Future<void> _captureAndRecognize() async {
    if (!_isCameraInitialized || _isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    try {
      // Capturar imagen
      final XFile image = await _cameraController!.takePicture();
      
      // Guardar imagen
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await image.saveTo(imagePath);
      
      // Reconocer texto con ML Kit
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      setState(() {
        _scannedText = recognizedText.text;
        _isProcessing = false;
        _pageState = PageState.reading;
      });
    } catch (e) {
      debugPrint('Error en OCR: $e');
      setState(() => _isProcessing = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al escanear. Intenta de nuevo.'),
          backgroundColor: AppColors.neonRed,
        ),
      );
    }
  }
  
  void _startQuiz() {
    // Generar preguntas basadas en el texto (simulado)
    _quizQuestions = _generateQuestions(_scannedText);
    
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _selectedAnswer = null;
      _showQuizResult = false;
      _pageState = PageState.quiz;
    });
  }
  
  List<QuizQuestion> _generateQuestions(String text) {
    // En producción, esto usaría Gemini API para generar preguntas
    // Por ahora, generamos preguntas genéricas de comprensión
    
    final words = text.split(' ').where((w) => w.length > 4).toList();
    
    return [
      QuizQuestion(
        question: '¿Cuál es el tema principal del texto?',
        options: [
          'Una historia de aventuras',
          'Un texto informativo',
          'Una noticia actual',
          'Un cuento de hadas',
        ],
        correctIndex: 1,
      ),
      QuizQuestion(
        question: '¿Qué tipo de texto acabas de leer?',
        options: [
          'Narrativo',
          'Descriptivo',
          'Instructivo',
          'Argumentativo',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        question: '¿Cuántas palabras aproximadamente tiene el texto?',
        options: [
          'Menos de 50',
          'Entre 50 y 100',
          'Entre 100 y 200',
          'Más de 200',
        ],
        correctIndex: words.length < 50 ? 0 : words.length < 100 ? 1 : 2,
      ),
      QuizQuestion(
        question: '¿Qué aprendiste del texto?',
        options: [
          'Información nueva',
          'Algo que ya sabía',
          'Nada en particular',
          'Conceptos confusos',
        ],
        correctIndex: 0,
      ),
      QuizQuestion(
        question: '¿Recomendarías este texto a un amigo?',
        options: [
          'Sí, es interesante',
          'No, es aburrido',
          'Depende del tema',
          'No estoy seguro',
        ],
        correctIndex: 0,
      ),
    ];
  }
  
  void _selectAnswer(int index) {
    setState(() => _selectedAnswer = index);
  }
  
  void _verifyAnswer() {
    if (_selectedAnswer == null) return;
    
    final question = _quizQuestions[_currentQuestionIndex];
    final isCorrect = _selectedAnswer == question.correctIndex;
    
    if (isCorrect) {
      _correctAnswers++;
    }
    
    setState(() => _showQuizResult = true);
  }
  
  void _nextQuestion() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showQuizResult = false;
      });
    } else {
      setState(() => _pageState = PageState.result);
    }
  }
}

enum PageState { camera, reading, quiz, result }

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  
  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

/// Painter para guía de escaneo
class ScanGuidePainter extends CustomPainter {
  final Color color;
  
  ScanGuidePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final cornerLength = 30.0;
    final margin = 40.0;
    
    // Esquinas
    // Superior izquierda
    canvas.drawLine(
      Offset(margin, margin + cornerLength),
      Offset(margin, margin),
      paint,
    );
    canvas.drawLine(
      Offset(margin, margin),
      Offset(margin + cornerLength, margin),
      paint,
    );
    
    // Superior derecha
    canvas.drawLine(
      Offset(size.width - margin - cornerLength, margin),
      Offset(size.width - margin, margin),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin, margin + cornerLength),
      paint,
    );
    
    // Inferior izquierda
    canvas.drawLine(
      Offset(margin, size.height - margin - cornerLength),
      Offset(margin, size.height - margin),
      paint,
    );
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin + cornerLength, size.height - margin),
      paint,
    );
    
    // Inferior derecha
    canvas.drawLine(
      Offset(size.width - margin - cornerLength, size.height - margin),
      Offset(size.width - margin, size.height - margin),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin, size.height - margin - cornerLength),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
