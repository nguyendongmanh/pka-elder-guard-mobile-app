import 'package:elder_guard_app/features/auth/data/models/auth_failure.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';

String authFailureMessage(AppLocalizations l10n, AuthFailure failure) {
  switch (failure.code) {
    case AuthFailureCode.emailAlreadyExists:
      return l10n.emailAlreadyExistsError;
    case AuthFailureCode.userNotFound:
      return l10n.userNotFoundError;
    case AuthFailureCode.incorrectPassword:
      return l10n.incorrectPasswordError;
    case AuthFailureCode.validation:
      return l10n.validationErrorMessage;
    case AuthFailureCode.network:
      return l10n.networkErrorMessage;
    case AuthFailureCode.server:
      return failure.serverMessage?.trim().isNotEmpty == true
          ? failure.serverMessage!
          : l10n.serverErrorMessage;
    case AuthFailureCode.unknown:
      return failure.serverMessage?.trim().isNotEmpty == true
          ? failure.serverMessage!
          : l10n.unknownErrorMessage;
  }
}
