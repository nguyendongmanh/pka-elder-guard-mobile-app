import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/notifications/models/push_notification_record.dart';
import 'package:elder_guard_app/features/notifications/presentation/controllers/notification_center_controller.dart';
import 'package:elder_guard_app/features/notifications/presentation/widgets/push_notification_tile.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notificationCenter = ref.watch(notificationCenterControllerProvider);
    final notificationCenterController = ref.read(
      notificationCenterControllerProvider.notifier,
    );
    final content = <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 22),
        child: Text(
          l10n.notificationCenterTitle,
          style: GoogleFonts.merriweather(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.deepTeal,
          ),
        ),
      ),
    ];

    if (notificationCenter.notifications.isEmpty) {
      content.add(
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.tealPrimary.withValues(alpha: 0.14),
            ),
          ),
          child: Text(
            l10n.notificationEmptyMessage,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      );
    } else {
      content.addAll(
        _buildGroupedNotificationWidgets(
          context,
          notificationCenter.notifications,
          onTapNotification: (notificationId) {
            notificationCenterController.requestOpenNotification(
              notificationId,
            );
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: RefreshIndicator(
        color: AppColors.notificationBlue,
        onRefresh: notificationCenterController.refreshInbox,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 28),
          children: content,
        ),
      ),
    );
  }

  List<Widget> _buildGroupedNotificationWidgets(
    BuildContext context,
    List<PushNotificationRecord> notifications, {
    required ValueChanged<String> onTapNotification,
  }) {
    final groupedWidgets = <Widget>[];
    DateTime? previousDate;

    for (final notification in notifications) {
      final localDate = notification.receivedAt.toLocal();
      if (previousDate == null || !_isSameDay(previousDate, localDate)) {
        groupedWidgets.add(
          Padding(
            padding: EdgeInsets.only(
              top: previousDate == null ? 0 : 10,
              bottom: 14,
            ),
            child: _DateDivider(date: localDate),
          ),
        );
      }

      groupedWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: PushNotificationTile(
            notification: notification,
            onTap: () => onTapNotification(notification.id),
          ),
        ),
      );
      previousDate = localDate;
    }

    return groupedWidgets;
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final formattedDate = DateFormat.yMMMMd(localeName).format(date);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.tealPrimary.withValues(alpha: 0.16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            formattedDate,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.deepTeal,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.tealPrimary.withValues(alpha: 0.16),
          ),
        ),
      ],
    );
  }
}
