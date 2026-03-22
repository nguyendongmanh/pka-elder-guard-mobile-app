import 'package:elder_guard_app/l10n/generated/app_localizations.dart';

abstract final class AuthValidators {
  static String? email(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return l10n.requiredFieldError;
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(trimmed)) {
      return l10n.invalidEmailError;
    }

    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return l10n.requiredFieldError;
    }

    if (trimmed.length < 6) {
      return l10n.passwordTooShortError;
    }

    return null;
  }

  static String? username(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return l10n.requiredFieldError;
    }

    if (trimmed.length < 3) {
      return l10n.usernameTooShortError;
    }

    return null;
  }
}
