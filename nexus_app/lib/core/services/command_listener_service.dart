// ============================================
// NEXUS CONTROL - Command Listener Service
// ============================================
// Polling periódico de comandos del padre desde Firestore.
// Lee nexus_devices/{deviceId}/commands donde status == 'pending'.
// Ejecuta cada comando y marca como 'executed'.
//
// Este servicio cierra la brecha padre→hijo que antes no existía.

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firebase_config.dart';
import 'firebase_sync_service.dart';

// ──────────────────────────────────────────────────────────────
// Tipos de comando soportados
// ──────────────────────────────────────────────────────────────
enum CommandType {
  setTimeLimit,
  updateBlacklist,
  emergencyLock,
  emergencyUnlock,
  addTime,
  blockApp,
  unblockApp,
}

CommandType? _parseCommandType(String raw) {
  switch (raw) {
    case 'SET_TIME_LIMIT':
      return CommandType.setTimeLimit;
    case 'UPDATE_BLACKLIST':
      return CommandType.updateBlacklist;
    case 'EMERGENCY_LOCK':
      return CommandType.emergencyLock;
    case 'EMERGENCY_UNLOCK':
      return CommandType.emergencyUnlock;
    case 'ADD_TIME':
      return CommandType.addTime;
    case 'BLOCK_APP':
      return CommandType.blockApp;
    case 'UNBLOCK_APP':
      return CommandType.unblockApp;
    default:
      return null;
  }
}

// ──────────────────────────────────────────────────────────────
// Callback que el WallMonitorNotifier registra para ejecutar
// acciones cuando llega un comando del padre.
// ──────────────────────────────────────────────────────────────
typedef CommandExecutor = Future<void> Function(
    CommandType type, Map<String, dynamic> payload);

// ──────────────────────────────────────────────────────────────
// Servicio (singleton)
// ──────────────────────────────────────────────────────────────
class CommandListenerService {
  CommandListenerService._();
  static final CommandListenerService instance = CommandListenerService._();

  Timer? _pollTimer;
  CommandExecutor? _executor;

  /// Intervalo de polling (30 segundos)
  static const Duration _pollInterval = Duration(seconds: 30);

  /// Registra el callback que ejecuta los comandos.
  void setExecutor(CommandExecutor executor) {
    _executor = executor;
  }

  /// Arranca el polling de comandos.
  void start() {
    if (_pollTimer != null) return;
    _pollTimer = Timer.periodic(_pollInterval, (_) => _pollCommands());
    // Primera consulta inmediata
    _pollCommands();
  }

  /// Detiene el polling.
  void stop() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  // ── Polling ────────────────────────────────────────────────

  Future<void> _pollCommands() async {
    try {
      final sync = FirebaseSyncService.instance;
      final ok = await sync.ensureAuthenticated();
      if (!ok || sync.deviceUid.isEmpty) return;

      final commands = await _fetchPendingCommands(sync.deviceUid);
      for (final cmd in commands) {
        await _executeCommand(cmd, sync.deviceUid);
      }
    } catch (_) {
      // Polling no es crítico — silenciar errores
    }
  }

  /// Consulta Firestore REST por documentos en commands/ con status == 'pending'.
  Future<List<Map<String, dynamic>>> _fetchPendingCommands(
      String deviceUid) async {
    // Acceder al token autenticado
    final token = await _getToken();
    if (token == null) return [];

    // Firestore REST: runQuery con filtro estructurado
    final url = Uri.parse(
        '${FirebaseConfig.firestoreBase}:runQuery');

    final body = jsonEncode({
      'structuredQuery': {
        'from': [
          {'collectionId': 'commands'}
        ],
        'where': {
          'fieldFilter': {
            'field': {'fieldPath': 'status'},
            'op': 'EQUAL',
            'value': {'stringValue': 'pending'}
          }
        },
        'orderBy': [
          {
            'field': {'fieldPath': 'createdAt'},
            'direction': 'ASCENDING'
          }
        ],
        'limit': 10
      },
      'parent':
          '${FirebaseConfig.firestoreBase}/nexus_devices/$deviceUid'
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200) return [];

    final results = jsonDecode(response.body) as List<dynamic>;
    final commands = <Map<String, dynamic>>[];

    for (final result in results) {
      final doc = result['document'];
      if (doc == null) continue;

      final fields = doc['fields'] as Map<String, dynamic>? ?? {};
      final docName = doc['name'] as String;
      // Extraer el commandId del path
      final commandId = docName.split('/').last;

      commands.add({
        'commandId': commandId,
        'type': _extractStringValue(fields['type']),
        'payload': _extractMapValue(fields['payload']),
        'status': _extractStringValue(fields['status']),
        'createdAt': _extractStringValue(fields['createdAt']),
      });
    }

    return commands;
  }

  /// Ejecuta un comando y lo marca como 'executed'.
  Future<void> _executeCommand(
      Map<String, dynamic> cmd, String deviceUid) async {
    final typeStr = cmd['type'] as String? ?? '';
    final type = _parseCommandType(typeStr);
    if (type == null) return;

    final payload = cmd['payload'] as Map<String, dynamic>? ?? {};
    final commandId = cmd['commandId'] as String;

    try {
      // Ejecutar via callback
      if (_executor != null) {
        await _executor!(type, payload);
      }

      // Marcar como ejecutado en Firestore
      await _markExecuted(deviceUid, commandId);
    } catch (_) {
      // Si falla, se reintentará en el próximo poll
    }
  }

  /// PATCH el comando para marcarlo como executed
  Future<void> _markExecuted(String deviceUid, String commandId) async {
    final token = await _getToken();
    if (token == null) return;

    final docPath =
        'nexus_devices/$deviceUid/commands/$commandId';
    final fieldMask =
        'updateMask.fieldPaths=status&updateMask.fieldPaths=executedAt';
    final url = Uri.parse('${FirebaseConfig.firestoreBase}/$docPath?$fieldMask');

    await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fields': {
          'status': {'stringValue': 'executed'},
          'executedAt': {
            'timestampValue': DateTime.now().toUtc().toIso8601String()
          },
        }
      }),
    );
  }

  // ── Helpers ────────────────────────────────────────────────

  Future<String?> _getToken() async {
    final sync = FirebaseSyncService.instance;
    final ok = await sync.ensureAuthenticated();
    if (!ok) return null;
    // Acceder al token via shared prefs (mismo patrón que FirebaseSyncService)
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nexus_id_token');
  }

  String _extractStringValue(dynamic field) {
    if (field is Map<String, dynamic>) {
      return field['stringValue'] as String? ??
          field['timestampValue'] as String? ??
          '';
    }
    return '';
  }

  Map<String, dynamic> _extractMapValue(dynamic field) {
    if (field is Map<String, dynamic> && field.containsKey('mapValue')) {
      final mapFields =
          field['mapValue']?['fields'] as Map<String, dynamic>? ?? {};
      final result = <String, dynamic>{};
      for (final entry in mapFields.entries) {
        final val = entry.value as Map<String, dynamic>?;
        if (val == null) continue;
        if (val.containsKey('stringValue')) {
          result[entry.key] = val['stringValue'];
        } else if (val.containsKey('integerValue')) {
          result[entry.key] = int.tryParse(val['integerValue'].toString()) ?? 0;
        } else if (val.containsKey('booleanValue')) {
          result[entry.key] = val['booleanValue'];
        } else if (val.containsKey('arrayValue')) {
          final items = val['arrayValue']?['values'] as List<dynamic>? ?? [];
          result[entry.key] = items
              .map((i) =>
                  (i as Map<String, dynamic>?)?['stringValue']?.toString() ??
                  '')
              .where((s) => s.isNotEmpty)
              .toList();
        }
      }
      return result;
    }
    return {};
  }
}
