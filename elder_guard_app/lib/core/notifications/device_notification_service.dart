import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceNotificationServiceProvider = Provider<DeviceNotificationService>((
  ref,
) {
  throw UnimplementedError('DeviceNotificationService must be initialized.');
});

class DeviceNotificationService {
  DeviceNotificationService()
    : _plugin = FlutterLocalNotificationsPlugin(),
      _tapPayloadController = StreamController<String>.broadcast();

  static const String _pushChannelId = 'elder_guard_push_alerts_v2';
  static const String _pushChannelName = 'ElderGuard Push Alerts';
  static const String _pushChannelDescription =
      'Heads-up notifications for important ElderGuard alerts.';

  static const AndroidNotificationChannel _eventsChannel =
      AndroidNotificationChannel(
        _pushChannelId,
        _pushChannelName,
        description: _pushChannelDescription,
        importance: Importance.max,
      );

  final FlutterLocalNotificationsPlugin _plugin;
  final StreamController<String> _tapPayloadController;

  bool _isInitialized = false;
  String? _pendingPayload;

  Stream<String> get tapPayloadStream => _tapPayloadController.stream;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    final androidImplementation =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImplementation?.createNotificationChannel(_eventsChannel);

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    final launchPayload = launchDetails?.notificationResponse?.payload;
    if ((launchDetails?.didNotificationLaunchApp ?? false) &&
        launchPayload != null &&
        launchPayload.isNotEmpty) {
      _pendingPayload = launchPayload;
    }

    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    await initialize();

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> showEventNotification({
    required int eventId,
    required String title,
    required String body,
  }) async {
    await initialize();

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _pushChannelId,
        _pushChannelName,
        channelDescription: _pushChannelDescription,
        icon: 'ic_notification',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.alarm,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      eventId,
      title,
      body,
      notificationDetails,
      payload: eventId.toString(),
    );
  }

  Future<void> showPushNotification({
    required String notificationId,
    required String title,
    required String body,
  }) async {
    await initialize();
    debugPrint(
      'Push pipeline: scheduling device notification id=$notificationId, title=$title',
    );

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _pushChannelId,
        _pushChannelName,
        channelDescription: _pushChannelDescription,
        icon: 'ic_notification',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        category: AndroidNotificationCategory.message,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      _notificationIdFromString(notificationId),
      title,
      body,
      notificationDetails,
      payload: notificationId,
    );
    debugPrint(
      'Push pipeline: device notification displayed id=$notificationId',
    );
  }

  String? takePendingPayload() {
    final payload = _pendingPayload;
    _pendingPayload = null;
    return payload;
  }

  void _handleNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) {
      return;
    }

    if (_tapPayloadController.hasListener) {
      _tapPayloadController.add(payload);
      return;
    }

    _pendingPayload = payload;
  }

  int _notificationIdFromString(String value) {
    var hash = 17;
    for (final codeUnit in value.codeUnits) {
      hash = 37 * hash + codeUnit;
    }

    return hash & 0x7fffffff;
  }
}
