import 'dart:async';

import 'package:elder_guard_app/core/errors/api_exception.dart';
import 'package:elder_guard_app/core/notifications/models/push_registration_result.dart';
import 'package:elder_guard_app/core/notifications/one_signal_service.dart';
import 'package:elder_guard_app/core/notifications/push_registration_api_service.dart';
import 'package:elder_guard_app/core/notifications/push_registration_status.dart';
import 'package:elder_guard_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:elder_guard_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pushRegistrationCoordinatorProvider =
    Provider<PushRegistrationCoordinator>((ref) {
      final coordinator = PushRegistrationCoordinator(
        oneSignalService: ref.watch(oneSignalServiceProvider),
        apiService: ref.watch(pushRegistrationApiServiceProvider),
        statusController: ref.read(pushRegistrationStatusProvider.notifier),
      );

      ref.listen<AuthState>(
        authControllerProvider,
        coordinator.handleAuthStateChanged,
        fireImmediately: true,
      );
      ref.onDispose(coordinator.dispose);

      return coordinator;
    });

class PushRegistrationCoordinator {
  static const bool _syncOneSignalExternalUser = false;

  PushRegistrationCoordinator({
    required OneSignalService oneSignalService,
    required PushRegistrationApiService apiService,
    required PushRegistrationStatusController statusController,
  }) : _oneSignalService = oneSignalService,
       _apiService = apiService,
       _statusController = statusController;

  final OneSignalService _oneSignalService;
  final PushRegistrationApiService _apiService;
  final PushRegistrationStatusController _statusController;

  bool _isStarted = false;
  bool _isDisposed = false;
  StreamSubscription<String?>? _subscriptionIdSubscription;

  String? _currentUserId;
  String? _currentSubscriptionId;
  String? _lastRegisteredUserId;
  String? _lastRegisteredSubscriptionId;
  Future<void> _operationChain = Future<void>.value();

  Future<void> start() async {
    if (_isStarted) {
      return;
    }

    _isStarted = true;
    _currentSubscriptionId = _normalize(_oneSignalService.subscriptionId);
    _syncStatusContext();
    _subscriptionIdSubscription = _oneSignalService.subscriptionIdStream.listen(
      _handleSubscriptionIdChanged,
    );

    await _oneSignalService.requestPermissionIfNeeded();
    _enqueue(() => _syncRegistration(force: true));
  }

  void handleAuthStateChanged(AuthState? previous, AuthState next) {
    final previousWasAuthenticated = previous?.isAuthenticated ?? false;
    final nextIsAuthenticated = next.isAuthenticated;
    final nextUserId = _normalize(next.session?.userId);

    if (previousWasAuthenticated && !nextIsAuthenticated) {
      _currentUserId = null;
      _enqueue(() async {
        await _removeCurrentRegistration();
        if (_syncOneSignalExternalUser) {
          await _oneSignalService.logout();
        }
      });
      return;
    }

    if (!nextIsAuthenticated) {
      _currentUserId = null;
      _syncStatusContext();
      return;
    }

    if (nextUserId == null) {
      _currentUserId = null;
      _statusController.setFailure(
        userId: null,
        subscriptionId: _deviceSubscriptionId,
        message: 'Missing user_id from backend login response.',
      );
      return;
    }

    _currentUserId = nextUserId;
    _syncStatusContext();
    _enqueue(() async {
      if (_syncOneSignalExternalUser) {
        await _oneSignalService.login(nextUserId);
      } else {
        debugPrint(
          'Skipping OneSignal.login for user_id=$nextUserId. Backend push mapping uses subscription_id only.',
        );
      }

      await _syncRegistration(force: previous?.session?.userId != nextUserId);
    });
  }

  void dispose() {
    _isDisposed = true;
    _subscriptionIdSubscription?.cancel();
  }

  void _handleSubscriptionIdChanged(String? subscriptionId) {
    final normalizedSubscriptionId = _normalize(subscriptionId);
    if (_currentSubscriptionId == normalizedSubscriptionId) {
      return;
    }

    _currentSubscriptionId = normalizedSubscriptionId;
    _syncStatusContext();
    _enqueue(() => _syncRegistration(force: true));
  }

  void _enqueue(Future<void> Function() operation) {
    _operationChain = _operationChain
        .catchError((Object _, StackTrace __) {})
        .then((_) async {
          if (_isDisposed) {
            return;
          }

          await operation();
        });
  }

  Future<void> _syncRegistration({required bool force}) async {
    final userId = _normalize(_currentUserId);
    final subscriptionId = _deviceSubscriptionId;
    if (userId == null || subscriptionId == null) {
      return;
    }

    if (!force &&
        _lastRegisteredUserId == userId &&
        _lastRegisteredSubscriptionId == subscriptionId) {
      return;
    }

    try {
      final result = await _apiService.registerDevice(
        userId: userId,
        subscriptionId: subscriptionId,
      );
      _lastRegisteredUserId = userId;
      _lastRegisteredSubscriptionId = subscriptionId;
      _statusController.setRegistered(result);
      _logRegistrationSuccess(result);
    } on ApiException catch (error) {
      _statusController.setFailure(
        userId: userId,
        subscriptionId: subscriptionId,
        message: error.message ?? error.type.name,
      );
      _logSyncFailure(
        'register push subscription',
        error.message ?? error.type.name,
      );
    } on Object catch (error) {
      _statusController.setFailure(
        userId: userId,
        subscriptionId: subscriptionId,
        message: error.toString(),
      );
      _logSyncFailure('register push subscription', error.toString());
    }
  }

  Future<void> _removeCurrentRegistration() async {
    final subscriptionId =
        _deviceSubscriptionId ?? _normalize(_lastRegisteredSubscriptionId);
    if (subscriptionId == null) {
      _lastRegisteredUserId = null;
      _lastRegisteredSubscriptionId = null;
      return;
    }

    try {
      await _apiService.removeDevice(subscriptionId: subscriptionId);
    } on ApiException catch (error) {
      _statusController.setFailure(
        userId: null,
        subscriptionId: subscriptionId,
        message: error.message ?? error.type.name,
      );
      _logSyncFailure(
        'remove push subscription',
        error.message ?? error.type.name,
      );
    } on Object catch (error) {
      _statusController.setFailure(
        userId: null,
        subscriptionId: subscriptionId,
        message: error.toString(),
      );
      _logSyncFailure('remove push subscription', error.toString());
    } finally {
      _lastRegisteredUserId = null;
      _lastRegisteredSubscriptionId = null;
      _statusController.setWaitingForLogin(subscriptionId: subscriptionId);
    }
  }

  String? get _deviceSubscriptionId =>
      _normalize(_currentSubscriptionId) ??
      _normalize(_oneSignalService.subscriptionId);

  void _logSyncFailure(String action, String details) {
    debugPrint('Failed to $action: $details');
  }

  void _logRegistrationSuccess(PushRegistrationResult result) {
    debugPrint(
      'Push registered successfully: status=${result.status}, player_id=${result.playerId}, user_id=${result.userId}',
    );
  }

  void _syncStatusContext() {
    final subscriptionId = _deviceSubscriptionId;
    final userId = _normalize(_currentUserId);

    if (userId == null) {
      _statusController.setWaitingForLogin(subscriptionId: subscriptionId);
      return;
    }

    _statusController.setWaitingForSubscription(
      userId: userId,
      subscriptionId: subscriptionId,
    );
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
