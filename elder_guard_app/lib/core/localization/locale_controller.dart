import 'dart:ui';

import 'package:elder_guard_app/core/di/core_providers.dart';
import 'package:elder_guard_app/core/storage/storage_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  static const Locale _fallbackLocale = Locale('vi');

  @override
  Locale build() {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    final savedCode = sharedPreferences.getString(StorageKeys.localeCode);

    if (savedCode == 'en') {
      return const Locale('en');
    }

    return _fallbackLocale;
  }

  Future<void> toggleLocale() async {
    final nextLocale =
        state.languageCode == 'vi' ? const Locale('en') : const Locale('vi');
    await setLocale(nextLocale);
  }

  Future<void> setLocale(Locale locale) async {
    await ref
        .read(sharedPreferencesProvider)
        .setString(StorageKeys.localeCode, locale.languageCode);
    state = locale;
  }
}
