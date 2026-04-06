import 'dart:async';
import 'dart:convert';

import 'package:elder_guard_app/core/di/core_providers.dart';
import 'package:elder_guard_app/core/notifications/device_notification_service.dart';
import 'package:elder_guard_app/core/notifications/models/push_notification_record.dart';
import 'package:elder_guard_app/core/notifications/one_signal_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationCenterControllerProvider =
    NotifierProvider<NotificationCenterController, NotificationCenterState>(
      NotificationCenterController.new,
    );

class NotificationPopupRequest {
  const NotificationPopupRequest({
    required this.sequence,
    required this.notification,
  });

  final int sequence;
  final PushNotificationRecord notification;
}

class NotificationOpenRequest {
  const NotificationOpenRequest({
    required this.sequence,
    required this.notificationId,
  });

  final int sequence;
  final String notificationId;
}

class NotificationCenterState {
  const NotificationCenterState({
    required this.notifications,
    this.subscriptionId,
    this.pendingPopup,
    this.pendingOpenRequest,
  });

  final List<PushNotificationRecord> notifications;
  final String? subscriptionId;
  final NotificationPopupRequest? pendingPopup;
  final NotificationOpenRequest? pendingOpenRequest;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;
}

class NotificationCenterController extends Notifier<NotificationCenterState> {
  static const String _storageKey = 'notifications.push_inbox';
  static const int _maxNotifications = 40;

  late final SharedPreferences _sharedPreferences;
  late final DeviceNotificationService _deviceNotificationService;
  late final OneSignalService _oneSignalService;

  StreamSubscription<String?>? _subscriptionIdSubscription;
  StreamSubscription<PushNotificationRecord>?
  _foregroundNotificationSubscription;
  StreamSubscription<PushNotificationRecord>? _openedNotificationSubscription;
  int _popupSequence = 0;
  int _openSequence = 0;

  @override
  NotificationCenterState build() {
    _sharedPreferences = ref.read(sharedPreferencesProvider);
    _deviceNotificationService = ref.read(deviceNotificationServiceProvider);
    _oneSignalService = ref.read(oneSignalServiceProvider);
    ref.onDispose(_dispose);

    final notifications = _loadNotifications();

    _subscriptionIdSubscription = _oneSignalService.subscriptionIdStream.listen(
      _handleSubscriptionIdChanged,
    );
    _foregroundNotificationSubscription = _oneSignalService
        .foregroundNotificationStream
        .listen(_handleForegroundNotification);
    _openedNotificationSubscription = _oneSignalService.openedNotificationStream
        .listen(_handleOpenedNotification);

    var initialState = NotificationCenterState(
      notifications: notifications,
      subscriptionId: _oneSignalService.subscriptionId,
    );

    final pendingOpenedNotifications =
        _oneSignalService.drainPendingOpenedNotifications();
    for (final notification in pendingOpenedNotifications) {
      initialState = _mergeNotificationIntoState(
        initialState,
        notification,
        triggerPopup: false,
        triggerOpenRequest: true,
      );
    }

    return initialState;
  }

  void consumePopup(int sequence) {
    final pendingPopup = state.pendingPopup;
    if (pendingPopup == null || pendingPopup.sequence != sequence) {
      return;
    }

    state = NotificationCenterState(
      notifications: state.notifications,
      subscriptionId: state.subscriptionId,
      pendingOpenRequest: state.pendingOpenRequest,
    );
  }

  void consumeOpenRequest(int sequence) {
    final pendingOpenRequest = state.pendingOpenRequest;
    if (pendingOpenRequest == null || pendingOpenRequest.sequence != sequence) {
      return;
    }

    state = NotificationCenterState(
      notifications: state.notifications,
      subscriptionId: state.subscriptionId,
      pendingPopup: state.pendingPopup,
    );
  }

  Future<void> refreshInbox() async {
    final reloadedNotifications = _loadNotifications();
    state = NotificationCenterState(
      notifications: reloadedNotifications,
      subscriptionId: state.subscriptionId,
      pendingPopup: state.pendingPopup,
      pendingOpenRequest: state.pendingOpenRequest,
    );
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  void requestOpenNotification(String notificationId) {
    final normalizedNotificationId = notificationId.trim();
    if (normalizedNotificationId.isEmpty) {
      return;
    }

    markAsRead(normalizedNotificationId);
    state = NotificationCenterState(
      notifications: state.notifications,
      subscriptionId: state.subscriptionId,
      pendingPopup: state.pendingPopup,
      pendingOpenRequest: NotificationOpenRequest(
        sequence: ++_openSequence,
        notificationId: normalizedNotificationId,
      ),
    );
  }

  void markAsRead(String notificationId) {
    final notifications = List<PushNotificationRecord>.from(
      state.notifications,
    );
    final notificationIndex = notifications.indexWhere(
      (notification) => notification.id == notificationId,
    );
    if (notificationIndex < 0 || notifications[notificationIndex].isRead) {
      return;
    }

    notifications[notificationIndex] = notifications[notificationIndex]
        .copyWith(isRead: true);
    _persistNotifications(notifications);
    state = NotificationCenterState(
      notifications: notifications,
      subscriptionId: state.subscriptionId,
      pendingPopup: state.pendingPopup,
      pendingOpenRequest: state.pendingOpenRequest,
    );
  }

  void _handleSubscriptionIdChanged(String? subscriptionId) {
    state = NotificationCenterState(
      notifications: state.notifications,
      subscriptionId: _normalize(subscriptionId),
      pendingPopup: state.pendingPopup,
      pendingOpenRequest: state.pendingOpenRequest,
    );
  }

  void _handleForegroundNotification(PushNotificationRecord notification) {
    debugPrint(
      'Push pipeline: foreground callback received id=${notification.id}, title=${notification.title}',
    );
    unawaited(_showDeviceNotification(notification));
    state = _mergeNotificationIntoState(
      state,
      notification,
      triggerPopup: true,
      triggerOpenRequest: false,
    );
  }

  void _handleOpenedNotification(PushNotificationRecord notification) {
    debugPrint(
      'Push pipeline: opened callback received id=${notification.id}, title=${notification.title}',
    );
    state = _mergeNotificationIntoState(
      state,
      notification,
      triggerPopup: false,
      triggerOpenRequest: true,
    );
  }

  NotificationCenterState _mergeNotificationIntoState(
    NotificationCenterState currentState,
    PushNotificationRecord notification, {
    required bool triggerPopup,
    required bool triggerOpenRequest,
  }) {
    final notifications = List<PushNotificationRecord>.from(
      currentState.notifications,
    );
    final existingIndex = notifications.indexWhere(
      (item) => item.id == notification.id,
    );

    if (existingIndex >= 0) {
      final existingNotification = notifications.removeAt(existingIndex);
      notifications.insert(
        0,
        existingNotification.copyWith(
          title:
              notification.title.isEmpty
                  ? existingNotification.title
                  : notification.title,
          body:
              notification.body.isEmpty
                  ? existingNotification.body
                  : notification.body,
          receivedAt: notification.receivedAt,
          source: notification.source,
          additionalData: <String, dynamic>{
            ...existingNotification.additionalData,
            ...notification.additionalData,
          },
          opened: existingNotification.opened || notification.opened,
          isRead: existingNotification.isRead || notification.isRead,
        ),
      );
    } else {
      notifications.insert(0, notification);
    }

    if (notifications.length > _maxNotifications) {
      notifications.removeRange(_maxNotifications, notifications.length);
    }

    _persistNotifications(notifications);

    if (triggerPopup) {
      debugPrint(
        'Push pipeline: queued in-app popup id=${notifications.first.id}',
      );
    }
    if (triggerOpenRequest) {
      debugPrint(
        'Push pipeline: queued notification-center open id=${notifications.first.id}',
      );
    }

    return NotificationCenterState(
      notifications: notifications,
      subscriptionId: currentState.subscriptionId,
      pendingPopup:
          triggerPopup
              ? NotificationPopupRequest(
                sequence: ++_popupSequence,
                notification: notifications.first,
              )
              : currentState.pendingPopup,
      pendingOpenRequest:
          triggerOpenRequest
              ? NotificationOpenRequest(
                sequence: ++_openSequence,
                notificationId: notifications.first.id,
              )
              : currentState.pendingOpenRequest,
    );
  }

  List<PushNotificationRecord> _loadNotifications() {
    final encodedNotifications = _sharedPreferences.getStringList(_storageKey);
    if (encodedNotifications == null || encodedNotifications.isEmpty) {
      return const <PushNotificationRecord>[];
    }

    final notifications = <PushNotificationRecord>[];
    for (final encodedNotification in encodedNotifications) {
      try {
        notifications.add(
          PushNotificationRecord.fromJson(
            jsonDecode(encodedNotification) as Map<String, dynamic>,
          ),
        );
      } on FormatException {
        continue;
      } on Object {
        continue;
      }
    }

    return notifications;
  }

  void _persistNotifications(List<PushNotificationRecord> notifications) {
    final encodedNotifications = notifications
        .map((notification) => jsonEncode(notification.toJson()))
        .toList(growable: false);
    unawaited(
      _sharedPreferences.setStringList(_storageKey, encodedNotifications),
    );
  }

  Future<void> _showDeviceNotification(
    PushNotificationRecord notification,
  ) async {
    try {
      await _deviceNotificationService.showPushNotification(
        notificationId: notification.id,
        title: notification.title,
        body: notification.body,
      );
    } on Object {
      debugPrint(
        'Push pipeline: failed to display device notification id=${notification.id}',
      );
      // Ignore local notification failures so push inbox updates still succeed.
    }
  }

  void _dispose() {
    _subscriptionIdSubscription?.cancel();
    _foregroundNotificationSubscription?.cancel();
    _openedNotificationSubscription?.cancel();
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
