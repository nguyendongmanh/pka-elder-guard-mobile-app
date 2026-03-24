import 'package:elder_guard_app/features/notifications/data/models/event_failure.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';

String eventFailureMessage(AppLocalizations l10n, EventFailure failure) {
  switch (failure.code) {
    case EventFailureCode.network:
      return l10n.networkErrorMessage;
    case EventFailureCode.notFound:
      return l10n.notificationNotFoundMessage;
    case EventFailureCode.server:
      return failure.message ?? l10n.serverErrorMessage;
  }
}
