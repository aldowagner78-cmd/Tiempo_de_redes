/// ============================================
/// NEXUS CONTROL - Parent Alert Service
/// ============================================
/// Envía alertas/notificaciones al padre vía Firestore.
/// El panel web del padre lee estas alertas en tiempo real.
///
/// Tipos de alerta:
/// - Logro completado (módulo, misión)
/// - Tiempo agotado
/// - Intento de desbloqueo/trampa
/// - Comida registrada
/// - Hitos de ejercicio

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../constants/firebase_config.dart';
import 'firebase_sync_service.dart';

/// Tipo de alerta
enum AlertType {
  achievement,    // Logro completado
  timeExpired,    // Tiempo agotado
  cheatAttempt,   // Intento de trampa
  foodLogged,     // Comida registrada
  exerciseMilestone, // Hito de ejercicio
  missionComplete,   // Misión diaria completada
  levelUp,        // Subió de nivel
}

class ParentAlertService {
  ParentAlertService._();
  static final ParentAlertService instance = ParentAlertService._();
  
  final _uuid = const Uuid();
  
  /// Envía una alerta al padre vía Firestore.
  /// Fire-and-forget: no bloquea al hijo.
  Future<void> sendAlert({
    required AlertType type,
    required String title,
    required String message,
    String? childName,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final sync = FirebaseSyncService.instance;
      final ok = await sync.ensureAuthenticated();
      if (!ok || sync.deviceUid.isEmpty) return;
      
      final alertId = _uuid.v4();
      final now = DateTime.now().toUtc().toIso8601String();
      
      final fields = <String, Map<String, dynamic>>{
        'type': {'stringValue': type.name},
        'title': {'stringValue': title},
        'message': {'stringValue': message},
        'childName': {'stringValue': childName ?? 'Hijo'},
        'timestamp': {'timestampValue': now},
        'read': {'booleanValue': false},
      };
      
      // Agregar metadata si existe
      if (metadata != null) {
        fields['metadata'] = {'stringValue': jsonEncode(metadata)};
      }
      
      final fieldMask = fields.keys.map((k) => 'updateMask.fieldPaths=$k').join('&');
      final url = Uri.parse(
        '${FirebaseConfig.firestoreBase}/nexus_devices/${sync.deviceUid}/alerts/$alertId?$fieldMask',
      );
      
      await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sync.idToken}',
        },
        body: jsonEncode({'fields': fields}),
      );
    } catch (_) {
      // Silencioso: no queremos que un error de notificación afecte al hijo
    }
  }
  
  // === Métodos de conveniencia ===
  
  Future<void> notifyAchievement(String module, String achievement, int coins) {
    return sendAlert(
      type: AlertType.achievement,
      title: '🏆 ¡Logro en $module!',
      message: '$achievement — Ganó $coins Bio-Coins',
      metadata: {'module': module, 'coins': coins},
    );
  }
  
  Future<void> notifyTimeExpired(String childName) {
    return sendAlert(
      type: AlertType.timeExpired,
      title: '⏰ Tiempo agotado',
      message: '$childName ha agotado su tiempo de pantalla',
      childName: childName,
    );
  }
  
  Future<void> notifyCheatAttempt(String detail) {
    return sendAlert(
      type: AlertType.cheatAttempt,
      title: '⚠️ Alerta de seguridad',
      message: 'Se detectó un posible intento de trampa: $detail',
    );
  }
  
  Future<void> notifyFoodLogged(String foodName, int healthScore) {
    return sendAlert(
      type: AlertType.foodLogged,
      title: '🍎 Comida registrada',
      message: '$foodName — Puntuación de salud: $healthScore/100',
      metadata: {'food': foodName, 'score': healthScore},
    );
  }
  
  Future<void> notifyExerciseMilestone(int steps, double distance) {
    return sendAlert(
      type: AlertType.exerciseMilestone,
      title: '🏃 Hito de ejercicio',
      message: '$steps pasos, ${(distance / 1000).toStringAsFixed(1)}km recorridos',
      metadata: {'steps': steps, 'distance': distance},
    );
  }
  
  Future<void> notifyMissionComplete(String missionTitle, int reward) {
    return sendAlert(
      type: AlertType.missionComplete,
      title: '✅ Misión completada',
      message: '$missionTitle — +$reward Bio-Coins',
      metadata: {'mission': missionTitle, 'reward': reward},
    );
  }
}
