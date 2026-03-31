/// ============================================
/// NEXUS CONTROL - Food Analysis Service
/// ============================================
/// Análisis real de alimentos usando Google ML Kit
/// Image Labeling (on-device, sin API key)

import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

/// Categoría de alimento detectado
enum FoodCategory {
  fruit,
  vegetable,
  protein,
  grain,
  dairy,
  junkFood,
  drink,
  dessert,
  unknown,
}

/// Base de datos local de alimentos y su info nutricional
class FoodDatabase {
  /// Mapeo de etiquetas ML Kit → categoría + datos
  static final Map<String, _FoodInfo> _labelToFood = {
    // Frutas
    'fruit': _FoodInfo('Fruta', FoodCategory.fruit, 85, 90, 1, 21, 0, 'Las frutas son ricas en vitaminas y fibra natural.'),
    'apple': _FoodInfo('Manzana', FoodCategory.fruit, 95, 92, 0, 25, 0, 'Una manzana al día aporta fibra y vitamina C.'),
    'banana': _FoodInfo('Banana', FoodCategory.fruit, 105, 88, 1, 27, 0, 'Excelente fuente de potasio y energía natural.'),
    'orange': _FoodInfo('Naranja', FoodCategory.fruit, 62, 91, 1, 15, 0, 'Rica en vitamina C, fortalece el sistema inmune.'),
    'strawberry': _FoodInfo('Fresa', FoodCategory.fruit, 49, 92, 1, 12, 0, 'Baja en calorías y rica en antioxidantes.'),
    'grape': _FoodInfo('Uvas', FoodCategory.fruit, 104, 86, 1, 27, 0, 'Contienen resveratrol, un potente antioxidante.'),
    'watermelon': _FoodInfo('Sandía', FoodCategory.fruit, 86, 91, 2, 22, 0, 'Muy hidratante, ideal para días calurosos.'),
    'pineapple': _FoodInfo('Piña', FoodCategory.fruit, 82, 89, 1, 22, 0, 'Contiene bromelina que ayuda a la digestión.'),
    'mango': _FoodInfo('Mango', FoodCategory.fruit, 99, 88, 1, 25, 1, 'Rico en vitamina A y C, excelente para la piel.'),
    
    // Vegetales  
    'vegetable': _FoodInfo('Vegetal', FoodCategory.vegetable, 50, 95, 3, 8, 0, 'Los vegetales son esenciales para una dieta equilibrada.'),
    'salad': _FoodInfo('Ensalada', FoodCategory.vegetable, 120, 95, 5, 12, 6, '¡Excelente elección! Rica en fibra y nutrientes.'),
    'broccoli': _FoodInfo('Brócoli', FoodCategory.vegetable, 55, 96, 4, 11, 1, 'Superalimento rico en vitamina K y hierro.'),
    'carrot': _FoodInfo('Zanahoria', FoodCategory.vegetable, 41, 93, 1, 10, 0, 'Rica en betacaroteno, excelente para la vista.'),
    'tomato': _FoodInfo('Tomate', FoodCategory.vegetable, 22, 94, 1, 5, 0, 'Rico en licopeno, un potente antioxidante.'),
    'corn': _FoodInfo('Maíz', FoodCategory.grain, 132, 78, 5, 29, 2, 'Buena fuente de fibra y carbohidratos complejos.'),
    
    // Proteínas
    'meat': _FoodInfo('Carne', FoodCategory.protein, 250, 72, 26, 0, 15, 'Buena fuente de proteína y hierro. Modera las porciones.'),
    'chicken': _FoodInfo('Pollo', FoodCategory.protein, 165, 80, 31, 0, 4, 'Excelente proteína magra, baja en grasa.'),
    'fish': _FoodInfo('Pescado', FoodCategory.protein, 206, 82, 22, 0, 12, 'Rico en omega-3, excelente para el cerebro.'),
    'egg': _FoodInfo('Huevo', FoodCategory.protein, 155, 78, 13, 1, 11, 'Proteína completa con todos los aminoácidos esenciales.'),
    'seafood': _FoodInfo('Mariscos', FoodCategory.protein, 85, 81, 18, 1, 1, 'Bajo en calorías y rico en minerales.'),
    'steak': _FoodInfo('Bistec', FoodCategory.protein, 271, 70, 26, 0, 18, 'Alto en proteína y hierro. Consume con moderación.'),
    
    // Granos y carbohidratos
    'bread': _FoodInfo('Pan', FoodCategory.grain, 265, 68, 9, 49, 3, 'Prefiere pan integral para más fibra y nutrientes.'),
    'rice': _FoodInfo('Arroz', FoodCategory.grain, 206, 75, 4, 45, 0, 'Fuente de energía. El arroz integral es más nutritivo.'),
    'pasta': _FoodInfo('Pasta', FoodCategory.grain, 220, 70, 8, 43, 1, 'Buena energía. Acompáñala con verduras y proteína.'),
    'cereal': _FoodInfo('Cereal', FoodCategory.grain, 379, 65, 7, 84, 1, 'Elige cereales integrales sin azúcar añadida.'),
    
    // Lácteos
    'cheese': _FoodInfo('Queso', FoodCategory.dairy, 402, 72, 25, 1, 33, 'Rico en calcio. Prefiere versiones bajas en grasa.'),
    'milk': _FoodInfo('Leche', FoodCategory.dairy, 149, 85, 8, 12, 8, 'Excelente fuente de calcio para huesos fuertes.'),
    'yogurt': _FoodInfo('Yogurt', FoodCategory.dairy, 100, 82, 17, 6, 1, 'Probióticos naturales que mejoran la digestión.'),
    
    // Comida rápida / chatarra
    'pizza': _FoodInfo('Pizza', FoodCategory.junkFood, 266, 40, 11, 33, 10, 'Modera el consumo. Agrega más vegetales como topping.'),
    'hamburger': _FoodInfo('Hamburguesa', FoodCategory.junkFood, 550, 45, 25, 45, 30, 'Intenta elegir opciones con más vegetales.'),
    'hot dog': _FoodInfo('Hot Dog', FoodCategory.junkFood, 290, 38, 10, 24, 18, 'Alto en sodio y grasas procesadas. Consumir con moderación.'),
    'french fries': _FoodInfo('Papas Fritas', FoodCategory.junkFood, 312, 35, 3, 41, 15, 'Muy calóricas. Prueba hornear en vez de freír.'),
    'candy': _FoodInfo('Dulce', FoodCategory.dessert, 400, 25, 0, 98, 0, 'Alto en azúcar. Limita su consumo a ocasiones especiales.'),
    'cake': _FoodInfo('Pastel', FoodCategory.dessert, 350, 30, 5, 50, 15, 'Reserva los postres para celebraciones especiales.'),
    'ice cream': _FoodInfo('Helado', FoodCategory.dessert, 207, 35, 4, 24, 11, 'Prueba alternativas con fruta congelada.'),
    'cookie': _FoodInfo('Galleta', FoodCategory.dessert, 502, 28, 5, 65, 25, 'Las galletas caseras con avena son mejor opción.'),
    'donut': _FoodInfo('Dona', FoodCategory.dessert, 452, 30, 5, 51, 25, 'Muy alta en azúcar y grasas. Consumir ocasionalmente.'),
    'chocolate': _FoodInfo('Chocolate', FoodCategory.dessert, 546, 32, 5, 60, 31, 'El chocolate oscuro (>70%) tiene antioxidantes.'),
    
    // Bebidas
    'coffee': _FoodInfo('Café', FoodCategory.drink, 2, 80, 0, 0, 0, 'Sin azúcar es muy bajo en calorías.'),
    'juice': _FoodInfo('Jugo', FoodCategory.drink, 112, 78, 1, 26, 0, 'Prefiere fruta entera por la fibra.'),
    'soda': _FoodInfo('Refresco', FoodCategory.drink, 140, 20, 0, 39, 0, 'Muy alto en azúcar. El agua es siempre mejor opción.'),
    'water': _FoodInfo('Agua', FoodCategory.drink, 0, 100, 0, 0, 0, '¡La mejor bebida! Mantente siempre hidratado.'),
    
    // Genéricos
    'food': _FoodInfo('Comida', FoodCategory.unknown, 200, 65, 10, 25, 8, 'Intenta incluir verduras en cada comida.'),
    'snack': _FoodInfo('Snack', FoodCategory.junkFood, 250, 45, 3, 35, 12, 'Elige snacks saludables como frutos secos o fruta.'),
    'sandwich': _FoodInfo('Sándwich', FoodCategory.grain, 250, 68, 12, 30, 9, 'Agrega más vegetales al sándwich para más nutrientes.'),
    'soup': _FoodInfo('Sopa', FoodCategory.vegetable, 100, 85, 6, 12, 3, 'Las sopas caseras son nutritivas y reconfortantes.'),
  };

  /// Busca el mejor match entre las etiquetas detectadas
  static FoodAnalysisData analyze(List<ImageLabel> labels) {
    _FoodInfo? bestMatch;
    double bestConfidence = 0;
    
    for (final label in labels) {
      final key = label.label.toLowerCase();
      
      // Buscar match exacto
      if (_labelToFood.containsKey(key) && label.confidence > bestConfidence) {
        bestMatch = _labelToFood[key];
        bestConfidence = label.confidence;
      }
      
      // Buscar match parcial
      for (final entry in _labelToFood.entries) {
        if ((key.contains(entry.key) || entry.key.contains(key)) &&
            label.confidence > bestConfidence * 0.8) {
          bestMatch = entry.value;
          bestConfidence = label.confidence;
        }
      }
    }
    
    // Si no hay match, usar el genérico con las etiquetas
    if (bestMatch == null) {
      final topLabels = labels.take(3).map((l) => l.label).join(', ');
      return FoodAnalysisData(
        foodName: 'Alimento Detectado',
        category: FoodCategory.unknown,
        healthScore: 60,
        calories: 200,
        protein: 10,
        carbs: 25,
        fats: 8,
        coinsEarned: 10,
        tip: 'No pude identificar el alimento exacto. Detecté: $topLabels. ¡Intenta con más luz!',
        confidence: 0.3,
        detectedLabels: labels.map((l) => '${l.label} (${(l.confidence * 100).round()}%)').toList(),
      );
    }
    
    // Calcular coins basado en salud
    final coins = _calculateCoins(bestMatch.healthScore);
    
    return FoodAnalysisData(
      foodName: bestMatch.name,
      category: bestMatch.category,
      healthScore: bestMatch.healthScore,
      calories: bestMatch.calories,
      protein: bestMatch.protein,
      carbs: bestMatch.carbs,
      fats: bestMatch.fats,
      coinsEarned: coins,
      tip: bestMatch.tip,
      confidence: bestConfidence,
      detectedLabels: labels.map((l) => '${l.label} (${(l.confidence * 100).round()}%)').toList(),
    );
  }
  
  static int _calculateCoins(int healthScore) {
    if (healthScore >= 90) return 25;
    if (healthScore >= 80) return 20;
    if (healthScore >= 70) return 15;
    if (healthScore >= 50) return 10;
    if (healthScore >= 30) return 5;
    return 3;
  }
}

class _FoodInfo {
  final String name;
  final FoodCategory category;
  final int calories;
  final int healthScore;
  final int protein;
  final int carbs;
  final int fats;
  final String tip;
  
  const _FoodInfo(this.name, this.category, this.calories, this.healthScore,
      this.protein, this.carbs, this.fats, this.tip);
}

/// Resultado del análisis real de comida
class FoodAnalysisData {
  final String foodName;
  final FoodCategory category;
  final int healthScore;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final int coinsEarned;
  final String tip;
  final double confidence;
  final List<String> detectedLabels;
  
  FoodAnalysisData({
    required this.foodName,
    required this.category,
    required this.healthScore,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.coinsEarned,
    required this.tip,
    required this.confidence,
    required this.detectedLabels,
  });
}
