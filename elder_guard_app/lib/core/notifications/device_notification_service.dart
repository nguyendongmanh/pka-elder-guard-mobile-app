import 'dart:async';

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

  static const AndroidNotificationChannel _eventsChannel =
      AndroidNotificationChannel(
        'elder_guard_events',
        'ElderGuard Events',
        description: 'Notifications for new monitoring events.',
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
        'elder_guard_events',
        'ElderGuard Events',
        channelDescription: 'Notifications for new monitoring events.',
        icon: 'ic_notification',
        importance: Importance.max,
        priority: Priority.high,
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
}
