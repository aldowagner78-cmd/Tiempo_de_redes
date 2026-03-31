/// ============================================
/// NEXUS CONTROL - BioFuel Module Screen
/// ============================================
/// Módulo de nutrición - "Alimentación"
/// Análisis de fotos de alimentos con IA

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/biocoin_service.dart';
import '../../../../core/services/food_analysis_service.dart';
import '../../../../core/services/parent_alert_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../features/biocoins/domain/entities/biocoin_entity.dart';

class BioFuelScreen extends ConsumerStatefulWidget {
  const BioFuelScreen({super.key});

  @override
  ConsumerState<BioFuelScreen> createState() => _BioFuelScreenState();
}

class _BioFuelScreenState extends ConsumerState<BioFuelScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isAnalyzing = false;
  bool _showResult = false;
  
  // Resultado del análisis
  FoodAnalysisResult? _analysisResult;
  String? _capturedImagePath;
  
  // Historial de comidas del día
  final List<FoodEntry> _todaysFoods = [];
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }
  
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
  
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
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
        title: const Text('ALIMENTACIÓN'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.moduleBiofuel,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: BioCoinDisplay(amount: bioCoins, size: 20),
          ),
        ],
      ),
      body: ScanlineOverlay(
        child: _showResult ? _buildResultView() : _buildCameraView(),
      ),
    );
  }
  
  Widget _buildCameraView() {
    return Column(
      children: [
        // Preview de cámara
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.moduleBiofuel, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: _isCameraInitialized
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(_cameraController!),
                        
                        // Overlay de guía
                        Center(
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.moduleBiofuel.withOpacity(0.5),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        
                        // Indicador de estado
                        if (_isAnalyzing)
                          Container(
                            color: AppColors.background.withOpacity(0.8),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(
                                    color: AppColors.moduleBiofuel,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Analizando alimento...',
                                    style: TextStyle(
                                      color: AppColors.moduleBiofuel,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.moduleBiofuel,
                      ),
                    ),
            ),
          ),
        ),
        
        // Instrucciones
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: HudPanel(
            borderColor: AppColors.moduleBiofuel,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.moduleBiofuel,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Toma una foto de tu comida para analizarla.\nLas comidas saludables te dan más Bio-Coins.',
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
        
        const SizedBox(height: 16),
        
        // Botón de captura
        GestureDetector(
          onTap: _captureAndAnalyze,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.moduleBiofuel,
              boxShadow: [
                BoxShadow(
                  color: AppColors.moduleBiofuel.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt,
              color: AppColors.background,
              size: 40,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05)),
        ),
        
        const SizedBox(height: 24),
        
        // Historial del día
        if (_todaysFoods.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'REGISTRO DEL DÍA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _todaysFoods.length,
                    itemBuilder: (context, index) => _buildFoodMiniCard(_todaysFoods[index]),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildResultView() {
    if (_analysisResult == null) return const SizedBox();
    
    final result = _analysisResult!;
    final isHealthy = result.healthScore >= 70;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Imagen capturada
          if (_capturedImagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(_capturedImagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Resultado principal
          HudPanel(
            borderColor: isHealthy ? AppColors.neonGreen : AppColors.neonOrange,
            child: Column(
              children: [
                // Puntuación
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (isHealthy ? AppColors.neonGreen : AppColors.neonOrange)
                            .withOpacity(0.1),
                        border: Border.all(
                          color: isHealthy ? AppColors.neonGreen : AppColors.neonOrange,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${result.healthScore}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isHealthy ? AppColors.neonGreen : AppColors.neonOrange,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .scale(begin: const Offset(0.5, 0.5)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.foodName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          isHealthy ? '¡Alimento Saludable!' : 'Poco Saludable',
                          style: TextStyle(
                            fontSize: 14,
                            color: isHealthy ? AppColors.neonGreen : AppColors.neonOrange,
                          ),
                        ),
                        if (result.confidence > 0)
                          Text(
                            'Confianza: ${(result.confidence * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Información nutricional
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutrientInfo('Calorías', '${result.calories}', Colors.orange),
                    _buildNutrientInfo('Proteína', '${result.protein}g', Colors.red),
                    _buildNutrientInfo('Carbos', '${result.carbs}g', Colors.blue),
                    _buildNutrientInfo('Grasas', '${result.fats}g', Colors.yellow),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Tip nutricional
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.neonYellow,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          result.tip,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Recompensa
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
                      '+${result.coinsEarned} Bio-Coins',
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
          
          const SizedBox(height: 24),
          
          // Botones de acción
          Row(
            children: [
              Expanded(
                child: NeonButton(
                  text: 'Registrar',
                  icon: Icons.check,
                  color: AppColors.neonGreen,
                  onPressed: _saveEntry,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeonButton(
                  text: 'Otro',
                  icon: Icons.refresh,
                  color: AppColors.textSecondary,
                  onPressed: _resetCamera,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }
  
  Widget _buildNutrientInfo(String label, String value, Color color) {
    return Column(
      children: [
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
  
  Widget _buildFoodMiniCard(FoodEntry entry) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.isHealthy ? AppColors.neonGreen : AppColors.neonOrange,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFoodIcon(entry.type),
            color: entry.isHealthy ? AppColors.neonGreen : AppColors.neonOrange,
          ),
          const SizedBox(height: 4),
          Text(
            '+${entry.coins}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.neonYellow,
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getFoodIcon(String type) {
    switch (type) {
      case 'fruit': return Icons.local_florist;
      case 'vegetable': return Icons.eco;
      case 'protein': return Icons.restaurant;
      case 'grain': return Icons.grain;
      default: return Icons.fastfood;
    }
  }
  
  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    
    setState(() => _isAnalyzing = true);
    
    try {
      // Capturar imagen
      final XFile image = await _cameraController!.takePicture();
      
      // Guardar imagen
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/food_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await image.saveTo(imagePath);
      
      // Análisis real con ML Kit Image Labeling
      final inputImage = InputImage.fromFilePath(imagePath);
      final imageLabeler = ImageLabeler(
        options: ImageLabelerOptions(confidenceThreshold: 0.3),
      );
      
      final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
      await imageLabeler.close();
      
      // Analizar con nuestra base de datos de alimentos
      final analysisData = FoodDatabase.analyze(labels);
      
      final result = FoodAnalysisResult(
        foodName: analysisData.foodName,
        healthScore: analysisData.healthScore,
        calories: analysisData.calories,
        protein: analysisData.protein,
        carbs: analysisData.carbs,
        fats: analysisData.fats,
        coinsEarned: analysisData.coinsEarned,
        tip: analysisData.tip,
        confidence: analysisData.confidence,
        detectedLabels: analysisData.detectedLabels,
      );
      
      setState(() {
        _capturedImagePath = imagePath;
        _analysisResult = result;
        _isAnalyzing = false;
        _showResult = true;
      });
    } catch (e) {
      debugPrint('Error analizando alimento: $e');
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al analizar: $e'),
            backgroundColor: AppColors.neonRed,
          ),
        );
      }
    }
  }
  
  void _saveEntry() {
    if (_analysisResult == null) return;
    final result = _analysisResult!;

    setState(() {
      _todaysFoods.add(FoodEntry(
        name: result.foodName,
        type: 'food',
        coins: result.coinsEarned,
        isHealthy: result.healthScore >= 70,
        timestamp: DateTime.now(),
      ));
    });

    final user = ref.read(currentUserProvider);
    if (user != null) {
      ref.read(bioCoinServiceProvider).award(
        userId: user.id,
        coins: result.coinsEarned,
        source: TransactionSource.biofuel,
        description: 'Nutrición: ${result.foodName} (puntuación ${result.healthScore})',
      ).then((actual) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Registrado! +$actual Bio-Coins'),
            backgroundColor: AppColors.neonGreen,
          ),
        );
        // Notificar al padre
        ParentAlertService.instance.notifyFoodLogged(result.foodName, result.healthScore);
      });
    }

    _resetCamera();
  }
  
  void _resetCamera() {
    setState(() {
      _showResult = false;
      _analysisResult = null;
      _capturedImagePath = null;
    });
  }
}

/// Resultado del análisis de comida
class FoodAnalysisResult {
  final String foodName;
  final int healthScore;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final int coinsEarned;
  final String tip;
  final double confidence;
  final List<String> detectedLabels;
  
  FoodAnalysisResult({
    required this.foodName,
    required this.healthScore,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.coinsEarned,
    required this.tip,
    this.confidence = 0.0,
    this.detectedLabels = const [],
  });
}

/// Entrada de registro de comida
class FoodEntry {
  final String name;
  final String type;
  final int coins;
  final bool isHealthy;
  final DateTime timestamp;
  
  FoodEntry({
    required this.name,
    required this.type,
    required this.coins,
    required this.isHealthy,
    required this.timestamp,
  });
}
