import 'dart:async';

import 'package:elder_guard_app/core/notifications/push_registration_coordinator.dart';
import 'package:elder_guard_app/features/notifications/presentation/controllers/notification_center_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBootstrapper extends ConsumerStatefulWidget {
  const AppBootstrapper({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends ConsumerState<AppBootstrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      unawaited(ref.read(pushRegistrationCoordinatorProvider).start());
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(pushRegistrationCoordinatorProvider);
    ref.watch(notificationCenterControllerProvider);
    return widget.child;
  }
}
