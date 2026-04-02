import 'dart:async';

import 'package:elder_guard_app/core/notifications/models/push_notification_record.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final oneSignalServiceProvider = Provider<OneSignalService>((ref) {
  throw UnimplementedError('OneSignalService must be initialized first.');
});

class OneSignalService {
  OneSignalService({required String appId})
    : _appId = appId,
      _subscriptionIdController = StreamController<String?>.broadcast(),
      _foregroundNotificationController =
          StreamController<PushNotificationRecord>.broadcast(),
      _openedNotificationController =
          StreamController<PushNotificationRecord>.broadcast();

  final String _appId;
  final StreamController<String?> _subscriptionIdController;
  final StreamController<PushNotificationRecord>
  _foregroundNotificationController;
  final StreamController<PushNotificationRecord> _openedNotificationController;

  bool _isInitialized = false;
  OnPushSubscriptionChangeObserver? _pushSubscriptionObserver;
  OnNotificationWillDisplayListener? _foregroundWillDisplayListener;
  OnNotificationClickListener? _clickListener;
  String? _subscriptionId;
  final List<PushNotificationRecord> _pendingOpenedNotifications =
      <PushNotificationRecord>[];

  Stream<String?> get subscriptionIdStream => _subscriptionIdController.stream;
  Stream<PushNotificationRecord> get foregroundNotificationStream =>
      _foregroundNotificationController.stream;
  Stream<PushNotificationRecord> get openedNotificationStream =>
      _openedNotificationController.stream;

  String? get subscriptionId {
    return _subscriptionId ?? _normalize(OneSignal.User.pushSubscription.id);
  }

  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> initialize() async {
    if (_isInitialized || !isSupported) {
      return;
    }

    await OneSignal.initialize(_appId);
    _subscriptionId = _normalize(OneSignal.User.pushSubscription.id);
    debugPrint(
      'OneSignal initialized. subscription_id=${_subscriptionId ?? 'null'}',
    );

    _pushSubscriptionObserver = _handlePushSubscriptionChange;
    _foregroundWillDisplayListener = _handleForegroundNotification;
    _clickListener = _handleNotificationClick;
    OneSignal.User.pushSubscription.addObserver(_pushSubscriptionObserver!);
    OneSignal.Notifications.addForegroundWillDisplayListener(
      _foregroundWillDisplayListener!,
    );
    OneSignal.Notifications.addClickListener(_clickListener!);
    _subscriptionIdController.add(_subscriptionId);

    _isInitialized = true;
  }

  Future<void> requestPermissionIfNeeded() async {
    await initialize();
    if (!isSupported || OneSignal.Notifications.permission) {
      return;
    }

    final canRequestPermission = await OneSignal.Notifications.canRequest();
    if (!canRequestPermission) {
      return;
    }

    await OneSignal.Notifications.requestPermission(false);
  }

  Future<void> login(String userId) async {
    await initialize();
    final normalizedUserId = _normalize(userId);
    if (!isSupported || normalizedUserId == null) {
      return;
    }

    await OneSignal.login(normalizedUserId);
  }

  Future<void> logout() async {
    if (!isSupported || !_isInitialized) {
      return;
    }

    await OneSignal.logout();
  }

  List<PushNotificationRecord> drainPendingOpenedNotifications() {
    final pendingNotifications = List<PushNotificationRecord>.from(
      _pendingOpenedNotifications,
    );
    _pendingOpenedNotifications.clear();
    return pendingNotifications;
  }

  void dispose() {
    if (isSupported) {
      final pushObserver = _pushSubscriptionObserver;
      if (pushObserver != null) {
        OneSignal.User.pushSubscription.removeObserver(pushObserver);
      }

      final foregroundListener = _foregroundWillDisplayListener;
      if (foregroundListener != null) {
        OneSignal.Notifications.removeForegroundWillDisplayListener(
          foregroundListener,
        );
      }

      final clickListener = _clickListener;
      if (clickListener != null) {
        OneSignal.Notifications.removeClickListener(clickListener);
      }
    }

    _pushSubscriptionObserver = null;
    _foregroundWillDisplayListener = null;
    _clickListener = null;
    _subscriptionIdController.close();
    _foregroundNotificationController.close();
    _openedNotificationController.close();
  }

  void _handlePushSubscriptionChange(OSPushSubscriptionChangedState state) {
    _subscriptionId = _normalize(state.current.id);
    debugPrint(
      'OneSignal subscription changed: previous=${state.previous.id ?? 'null'} current=${_subscriptionId ?? 'null'}',
    );
    if (_subscriptionIdController.isClosed) {
      return;
    }

    _subscriptionIdController.add(_subscriptionId);
  }

  void _handleForegroundNotification(OSNotificationWillDisplayEvent event) {
    event.preventDefault();
    final notification = _mapNotification(
      event.notification,
      source: PushNotificationSource.foreground,
      opened: false,
    );
    debugPrint(
      'OneSignal foreground notification: id=${notification.id}, title=${notification.title}',
    );
    if (_foregroundNotificationController.isClosed) {
      return;
    }

    _foregroundNotificationController.add(notification);
  }

  void _handleNotificationClick(OSNotificationClickEvent event) {
    final notification = _mapNotification(
      event.notification,
      source: PushNotificationSource.opened,
      opened: true,
    );
    debugPrint(
      'OneSignal notification opened: id=${notification.id}, title=${notification.title}',
    );
    _pendingOpenedNotifications.add(notification);
    if (_openedNotificationController.isClosed) {
      return;
    }

    _openedNotificationController.add(notification);
  }

  PushNotificationRecord _mapNotification(
    OSNotification notification, {
    required PushNotificationSource source,
    required bool opened,
  }) {
    return PushNotificationRecord(
      id: notification.notificationId,
      title: _normalize(notification.title) ?? 'New notification',
      body: _normalize(notification.body) ?? '',
      receivedAt: DateTime.now(),
      source: source,
      additionalData:
          notification.additionalData == null
              ? const <String, dynamic>{}
              : Map<String, dynamic>.from(notification.additionalData!),
      opened: opened,
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
