import 'package:elder_guard_app/app/app_bootstrapper.dart';
import 'package:elder_guard_app/app/root_screen.dart';
import 'package:elder_guard_app/app/theme/app_theme.dart';
import 'package:elder_guard_app/core/localization/locale_controller.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElderGuardApp extends ConsumerWidget {
  const ElderGuardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return AppBootstrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: const RootScreen(),
      ),
    );
  }
}
