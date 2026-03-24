import 'package:elder_guard_app/app/elder_guard_app.dart';
import 'package:elder_guard_app/core/di/core_providers.dart';
import 'package:elder_guard_app/core/notifications/device_notification_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final deviceNotificationService = DeviceNotificationService();
  await deviceNotificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        deviceNotificationServiceProvider.overrideWithValue(
          deviceNotificationService,
        ),
      ],
      child: const ElderGuardApp(),
    ),
  );
}
