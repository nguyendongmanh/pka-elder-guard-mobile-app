import 'package:elder_guard_app/features/notifications/data/models/event_read.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';

abstract final class EventNotificationContent {
  static String title(AppLocalizations l10n, EventRead event) {
    return l10n.notificationItemTitle(event.cameraId);
  }

  static String body(AppLocalizations l10n, EventRead event) {
    return l10n.notificationItemBody(
      _humanizeEventType(event.eventType),
      _formatTimestamp(l10n, event.timestamp),
    );
  }

  static String detailTitle(AppLocalizations l10n, EventRead event) {
    return l10n.notificationDetailTitle(event.id);
  }

  static String formatConfidence(double confidence) {
    final normalized = confidence <= 1 ? confidence * 100 : confidence;
    return '${normalized.toStringAsFixed(1)}%';
  }

  static String formatTimestamp(AppLocalizations l10n, DateTime timestamp) {
    return _formatTimestamp(l10n, timestamp);
  }

  static String _formatTimestamp(AppLocalizations l10n, DateTime timestamp) {
    return DateFormat.yMMMd(l10n.localeName).add_Hm().format(timestamp);
  }

  static String _humanizeEventType(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return value;
    }

    return normalized
        .split(RegExp(r'[_\-\s]+'))
        .where((segment) => segment.isNotEmpty)
        .map(
          (segment) =>
              '${segment[0].toUpperCase()}${segment.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
