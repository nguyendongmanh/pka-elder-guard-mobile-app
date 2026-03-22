import 'package:elder_guard_app/core/widgets/app_loading_screen.dart';
import 'package:elder_guard_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:elder_guard_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:elder_guard_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    if (authState.isBootstrapping) {
      return const AppLoadingScreen();
    }

    if (authState.isAuthenticated) {
      return const HomeScreen();
    }

    return const AuthScreen();
  }
}
