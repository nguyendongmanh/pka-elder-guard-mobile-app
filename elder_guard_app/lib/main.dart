import 'package:elder_guard_app/app/elder_guard_app.dart';
import 'package:elder_guard_app/core/di/core_providers.dart';
import 'package:elder_guard_app/core/notifications/device_notification_service.dart';
import 'package:elder_guard_app/core/notifications/one_signal_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _oneSignalAppId = '3bbb254c-1d79-4426-9b93-1d380749f289';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final deviceNotificationService = DeviceNotificationService();
  final oneSignalService = OneSignalService(appId: _oneSignalAppId);

  await oneSignalService.initialize();
  await deviceNotificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        oneSignalServiceProvider.overrideWithValue(oneSignalService),
        deviceNotificationServiceProvider.overrideWithValue(
          deviceNotificationService,
        ),
      ],
      child: const ElderGuardApp(),
    ),
  );
}
