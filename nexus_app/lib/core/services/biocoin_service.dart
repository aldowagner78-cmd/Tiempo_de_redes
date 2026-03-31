/// ============================================
/// NEXUS CONTROL - BioCoin Service
/// ============================================
/// Servicio central de la economía Bio-Coin.
///
/// Responsabilidades:
///   1. Persistir transacciones en Isar (historial auditado).
///   2. Actualizar el balance en el UserEntity.
///   3. Calcular racha y multiplier.
///   4. Convertir Bio-Coins → segundos de tiempo libre
///      y notificar al WallMonitorNotifier.
///   5. Exponer providers reactivos para la UI.

import 'dart:async' show unawaited;

import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/isar_service.dart';
import '../services/wall_monitor_notifier.dart';
import '../services/firebase_sync_service.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/biocoins/domain/entities/biocoin_entity.dart';
import '../../shared/providers/global_providers.dart';

// ──────────────────────────────────────────────────────────────
// PROVIDERS
// ──────────────────────────────────────────────────────────────

/// Provider global del servicio — inyectar `ref` para acceder al Wall.
final bioCoinServiceProvider = Provider<BioCoinService>((ref) {
  return BioCoinService(ref);
});

/// Historial de transacciones del usuario actual (últimas 50)
final bioCoinHistoryProvider = FutureProvider.family<List<BioCoinTransaction>, int>(
  (ref, userId) async {
    final isar = IsarService.instance;
    final all = await isar.bioCoinTransactions
        .filter()
        .userIdEqualTo(userId)
        .offset(0)
        .findAll();
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all.take(50).toList();
  },
);

// ──────────────────────────────────────────────────────────────
// SERVICIO
// ──────────────────────────────────────────────────────────────

class BioCoinService {
  final Ref _ref;

  BioCoinService(this._ref);

  // ── API pública ──────────────────────────────────────────────

  /// Otorgar Bio-Coins por completar una actividad.
  ///
  /// [userId] — ID del usuario hijo.
  /// [coins]  — Cantidad base (antes del multiplicador de racha).
  /// [source] — Módulo que genera la recompensa.
  /// [description] — Texto para el historial.
  ///
  /// Retorna los coins reales otorgados (con multiplicador).
  Future<int> award({
    required int userId,
    required int coins,
    required TransactionSource source,
    required String description,
  }) async {
    final isar = IsarService.instance;

    // 1. Leer config para multiplicador de racha
    final config = await _getConfig();
    final actualCoins = config.calculateWithStreak(coins);

    // 2. Leer balance actual
    final user = await isar.userEntitys.get(userId);
    if (user == null) return 0;
    final newBalance = (user.bioCoins) + actualCoins;

    // 3. Guardar transacción
    final tx = BioCoinTransaction.earned(
      userId: userId,
      amount: actualCoins,
      source: source,
      description: description,
      currentBalance: user.bioCoins,
    );

    await isar.writeTxn(() async {
      await isar.bioCoinTransactions.put(tx);
      user.bioCoins = newBalance;
      await isar.userEntitys.put(user);
    });

    // 4. Actualizar racha
    await _updateStreak(config);

    // 4.5 Fire-and-forget: sincronizar con Firestore (no bloquea la UI)
    unawaited(FirebaseSyncService.instance.logTransaction(tx, user.name));
    unawaited(FirebaseSyncService.instance.syncChild(
      user,
      streakDays: config.currentStreakDays,
    ));

    // 5. Convertir automáticamente a tiempo si el muro está activo o
    //    el tiempo es < 5 minutos — para que la recompensa se sienta inmediata.
    final wallState = _ref.read(wallMonitorProvider);
    final secsPerCoin = _secondsPerCoin(config);
    final timeSeconds = actualCoins * secsPerCoin;

    if (wallState.isWallActive || wallState.remainingSeconds < 300) {
      await _ref.read(wallMonitorProvider.notifier).addTimeReward(timeSeconds);
    }

    return actualCoins;
  }

  /// Gastar Bio-Coins para comprar tiempo manualmente.
  ///
  /// Retorna `true` si había saldo suficiente.
  Future<bool> spendForTime({
    required int userId,
    required int coinsToSpend,
  }) async {
    final isar = IsarService.instance;
    final user = await isar.userEntitys.get(userId);
    if (user == null) return false;
    if (user.bioCoins < coinsToSpend) return false;

    final config = await _getConfig();
    final newBalance = user.bioCoins - coinsToSpend;
    final minutesToGain = config.coinsToMinutes(coinsToSpend);

    final tx = BioCoinTransaction.spent(
      userId: userId,
      amount: coinsToSpend,
      description: 'Compra de $minutesToGain minutos de tiempo libre',
      currentBalance: user.bioCoins,
    );

    await isar.writeTxn(() async {
      await isar.bioCoinTransactions.put(tx);
      user.bioCoins = newBalance;
      await isar.userEntitys.put(user);
    });

    // Añadir tiempo
    await _ref
        .read(wallMonitorProvider.notifier)
        .addTimeReward(minutesToGain * 60);

    return true;
  }

  /// Otorgar bonus desde el panel parental.
  Future<int> parentBonus({
    required int userId,
    required int coins,
    required String reason,
  }) async {
    final isar = IsarService.instance;
    final user = await isar.userEntitys.get(userId);
    if (user == null) return 0;

    final newBalance = user.bioCoins + coins;
    final tx = BioCoinTransaction()
      ..userId = userId
      ..amount = coins
      ..type = TransactionType.bonus
      ..source = TransactionSource.parent
      ..description = reason
      ..createdAt = DateTime.now()
      ..balanceAfter = newBalance;

    await isar.writeTxn(() async {
      await isar.bioCoinTransactions.put(tx);
      user.bioCoins = newBalance;
      await isar.userEntitys.put(user);
    });

    // Fire-and-forget: sincronizar bonus parental con Firestore
    unawaited(FirebaseSyncService.instance.logTransaction(tx, user.name));
    unawaited(FirebaseSyncService.instance.syncChild(user));

    return coins;
  }

  // ── Internos ─────────────────────────────────────────────────

  Future<BioCoinConfig> _getConfig() async {
    final isar = IsarService.instance;
    return await isar.bioCoinConfigs.where().findFirst() ?? BioCoinConfig();
  }

  Future<void> _updateStreak(BioCoinConfig config) async {
    final isar = IsarService.instance;
    final now = DateTime.now();
    final lastActivity = config.lastActivityDate;

    bool streakUpdated = false;

    if (lastActivity == null) {
      config
        ..currentStreakDays = 1
        ..lastActivityDate = now;
      streakUpdated = true;
    } else {
      final diff = now.difference(lastActivity).inDays;
      if (diff == 1) {
        // Día consecutivo
        config
          ..currentStreakDays += 1
          ..lastActivityDate = now;
        streakUpdated = true;
      } else if (diff > 1) {
        // Racha rota
        config
          ..currentStreakDays = 1
          ..lastActivityDate = now;
        streakUpdated = true;
      }
      // diff == 0 → mismo día, no cambiar racha
    }

    if (streakUpdated) {
      await isar.writeTxn(() => isar.bioCoinConfigs.put(config));
    }
  }

  /// Segundos de tiempo que vale cada Bio-Coin.
  /// Tasa base: 1 coin = 6 segundos (1 minuto = 10 coins).
  int _secondsPerCoin(BioCoinConfig config) {
    if (config.coinsPerMinute <= 0) return 6;
    return (60 / config.coinsPerMinute).round();
  }
}

// ──────────────────────────────────────────────────────────────
// EXTENSIÓN DE CONVENIENCIA PARA MÓDULOS
// ──────────────────────────────────────────────────────────────

/// Provider que expone el userId del usuario logueado (0 si no hay sesión).
final activeUserIdProvider = Provider<int>((ref) {
  return ref.watch(currentUserProvider)?.id ?? 0;
});
