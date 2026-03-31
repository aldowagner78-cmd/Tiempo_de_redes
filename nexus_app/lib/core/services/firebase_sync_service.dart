// ============================================
// NEXUS CONTROL - Firebase Sync Service
// ============================================
// Sincroniza datos del dispositivo Android con Firestore
// usando la REST API (sin SDK nativo — no requiere
// google-services.json ni registro de app en consola).
//
// Flujo:
//   1. Sign-in anónimo via Firebase Auth REST → obtiene un UID único del dispositivo.
//   2. Token guardado en SharedPreferences, se refresca automáticamente.
//   3. Datos escritos en nexus_devices/{deviceUid}/children/{childId}
//      y nexus_devices/{deviceUid}/transactions/{txId}.
//   4. El padre vincula en la web introduciendo el Device ID del dispositivo.
//
// Uso: llamadas fire-and-forget desde BioCoinService — errores silenciados.

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../constants/firebase_config.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/biocoins/domain/entities/biocoin_entity.dart';

// ──────────────────────────────────────────────────────────────
// Claves de SharedPreferences
// ──────────────────────────────────────────────────────────────
const _kDeviceUid = 'nexus_device_uid';
const _kIdToken = 'nexus_id_token';
const _kRefreshToken = 'nexus_refresh_token';
const _kTokenExpiry = 'nexus_token_expiry';

// ──────────────────────────────────────────────────────────────
// Servicio (singleton ligero — no usa Riverpod)
// ──────────────────────────────────────────────────────────────
class FirebaseSyncService {
  FirebaseSyncService._();
  static final FirebaseSyncService instance = FirebaseSyncService._();

  String? _deviceUid;
  String? _idToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  // ── Device ID público ──────────────────────────────────────
  /// UID anónimo del dispositivo (28 chars). Mostrar al padre para vincular.
  String get deviceUid => _deviceUid ?? '';

  /// Token de autenticación actual (para otros servicios como alertas).
  String? get idToken => _idToken;

  /// Código corto de 8 chars para facilitar la vinculación.
  String get linkCode =>
      (_deviceUid != null && _deviceUid!.length >= 8)
          ? _deviceUid!.substring(0, 8).toUpperCase()
          : 'PENDIENTE';

  // ── Autenticación ──────────────────────────────────────────

  /// Garantiza que el token está vigente antes de cada llamada REST.
  Future<bool> ensureAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Leer estado guardado
      _deviceUid ??= prefs.getString(_kDeviceUid);
      _idToken ??= prefs.getString(_kIdToken);
      _refreshToken ??= prefs.getString(_kRefreshToken);
      final expiryStr = prefs.getString(_kTokenExpiry);
      _tokenExpiry ??= expiryStr != null ? DateTime.tryParse(expiryStr) : null;

      // Primera vez — crear cuenta anónima
      if (_deviceUid == null) {
        return await _signUpAnonymously(prefs);
      }

      // Token expirado — refrescar
      if (_tokenExpiry == null || DateTime.now().isAfter(_tokenExpiry!)) {
        return await _refreshIdToken(prefs);
      }

      return _idToken != null;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _signUpAnonymously(SharedPreferences prefs) async {
    final response = await http.post(
      Uri.parse('${FirebaseConfig.authSignUpAnon}?key=${FirebaseConfig.apiKey}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'returnSecureToken': true}),
    );
    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    _deviceUid = data['localId'] as String;
    _idToken = data['idToken'] as String;
    _refreshToken = data['refreshToken'] as String;
    _tokenExpiry = DateTime.now().add(
      Duration(seconds: int.parse(data['expiresIn'] as String) - 60),
    );

    await prefs.setString(_kDeviceUid, _deviceUid!);
    await prefs.setString(_kIdToken, _idToken!);
    await prefs.setString(_kRefreshToken, _refreshToken!);
    await prefs.setString(_kTokenExpiry, _tokenExpiry!.toIso8601String());
    return true;
  }

  Future<bool> _refreshIdToken(SharedPreferences prefs) async {
    if (_refreshToken == null) return _signUpAnonymously(prefs);

    final response = await http.post(
      Uri.parse('${FirebaseConfig.authRefreshToken}?key=${FirebaseConfig.apiKey}'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'grant_type=refresh_token&refresh_token=$_refreshToken',
    );
    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    _idToken = data['id_token'] as String;
    _refreshToken = data['refresh_token'] as String;
    _tokenExpiry = DateTime.now().add(
      Duration(seconds: int.parse(data['expires_in'] as String) - 60),
    );

    await prefs.setString(_kIdToken, _idToken!);
    await prefs.setString(_kRefreshToken, _refreshToken!);
    await prefs.setString(_kTokenExpiry, _tokenExpiry!.toIso8601String());
    return true;
  }

  // ── Escritura Firestore REST ──────────────────────────────

  Future<void> _patch(
    String docPath,
    Map<String, Map<String, dynamic>> fields,
  ) async {
    if (_idToken == null) return;
    final fieldMask = fields.keys.map((k) => 'updateMask.fieldPaths=$k').join('&');
    final url = Uri.parse('${FirebaseConfig.firestoreBase}/$docPath?$fieldMask');
    await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_idToken',
      },
      body: jsonEncode({'fields': fields}),
    );
  }

  // ── API pública ───────────────────────────────────────────

  /// Sincroniza los datos de un hijo al Firestore.
  /// Llama fire-and-forget: `unawaited(FirebaseSyncService.instance.syncChild(...))`.
  Future<void> syncChild(
    UserEntity user, {
    int remainingSeconds = 0,
    bool isWallActive = false,
    int streakDays = 0,
  }) async {
    try {
      final ok = await ensureAuthenticated();
      if (!ok || _deviceUid == null) return;

      // Actualiza el documento raíz del dispositivo
      await _patch(
        'nexus_devices/$_deviceUid',
        {
          'deviceId': {'stringValue': _deviceUid!},
          'linkCode': {'stringValue': linkCode},
          'lastSync': {'timestampValue': DateTime.now().toUtc().toIso8601String()},
        },
      );

      // Actualiza el documento del hijo
      await _patch(
        'nexus_devices/$_deviceUid/children/${user.id}',
        {
          'id': {'integerValue': '${user.id}'},
          'name': {'stringValue': user.name},
          'bioCoins': {'integerValue': '${user.bioCoins}'},
          'currentStreak': {'integerValue': '$streakDays'},
          'isWallActive': {'booleanValue': isWallActive},
          'remainingTimeSeconds': {'integerValue': '$remainingSeconds'},
          'lastSync': {'timestampValue': DateTime.now().toUtc().toIso8601String()},
        },
      );
    } catch (_) {
      // Sync no es crítico — silenciar errores
    }
  }

  /// Registra una transacción Bio-Coin en el historial de Firestore.
  Future<void> logTransaction(
    BioCoinTransaction tx,
    String childName,
  ) async {
    try {
      final ok = await ensureAuthenticated();
      if (!ok || _deviceUid == null) return;

      final txId = const Uuid().v4();
      await _patch(
        'nexus_devices/$_deviceUid/transactions/$txId',
        {
          'childId': {'integerValue': '${tx.userId}'},
          'childName': {'stringValue': childName},
          'amount': {'integerValue': '${tx.amount}'},
          'source': {'stringValue': tx.source.name},
          'description': {'stringValue': tx.description},
          'createdAt': {
            'timestampValue': tx.createdAt.toUtc().toIso8601String()
          },
          'balanceAfter': {'integerValue': '${tx.balanceAfter}'},
        },
      );
    } catch (_) {
      // Sync no es crítico — silenciar errores
    }
  }

  /// Reporta el estado en vivo del dispositivo (app actual, batería, muro).
  /// Se llama cada 30s desde el servicio de monitoreo.
  Future<void> reportLiveStatus({
    String? currentApp,
    String? currentAppName,
    bool isBlocked = false,
    int remainingSeconds = 0,
    bool isWallActive = false,
    int batteryLevel = -1,
  }) async {
    try {
      final ok = await ensureAuthenticated();
      if (!ok || _deviceUid == null) return;

      await _patch(
        'nexus_devices/$_deviceUid/live_status/current',
        {
          'currentApp': {'stringValue': currentApp ?? ''},
          'currentAppName': {'stringValue': currentAppName ?? ''},
          'isBlocked': {'booleanValue': isBlocked},
          'remainingSeconds': {'integerValue': '$remainingSeconds'},
          'isWallActive': {'booleanValue': isWallActive},
          'batteryLevel': {'integerValue': '$batteryLevel'},
          'lastUpdate': {
            'timestampValue': DateTime.now().toUtc().toIso8601String()
          },
        },
      );
    } catch (_) {
      // Live status no es crítico
    }
  }
}
