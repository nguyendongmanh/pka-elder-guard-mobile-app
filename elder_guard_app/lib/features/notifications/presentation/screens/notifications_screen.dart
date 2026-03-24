import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/notifications/data/models/event_failure.dart';
import 'package:elder_guard_app/features/notifications/data/models/event_read.dart';
import 'package:elder_guard_app/features/notifications/presentation/controllers/event_notifications_controller.dart';
import 'package:elder_guard_app/features/notifications/presentation/screens/notification_detail_screen.dart';
import 'package:elder_guard_app/features/notifications/presentation/utils/event_failure_message.dart';
import 'package:elder_guard_app/features/notifications/presentation/utils/event_notification_content.dart';
import 'package:elder_guard_app/features/notifications/presentation/widgets/app_notification_tile.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifications = ref.watch(eventNotificationsControllerProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: notifications.when(
        data: (events) => _NotificationsList(events: events),
        loading:
            () => Center(
              child: Text(
                l10n.notificationLoadingList,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
        error: (error, _) {
          final message =
              error is EventFailure
                  ? eventFailureMessage(l10n, error)
                  : l10n.serverErrorMessage;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed:
                      () =>
                          ref
                              .read(
                                eventNotificationsControllerProvider.notifier,
                              )
                              .refresh(),
                  child: Text(l10n.notificationRetryAction),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NotificationsList extends ConsumerWidget {
  const _NotificationsList({required this.events});

  final List<EventRead> events;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (events.isEmpty) {
      return RefreshIndicator(
        onRefresh:
            () =>
                ref
                    .read(eventNotificationsControllerProvider.notifier)
                    .refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.45,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.notificationCenterTitle,
                      style: GoogleFonts.merriweather(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepTeal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.notificationEmptyMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh:
          () =>
              ref.read(eventNotificationsControllerProvider.notifier).refresh(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 28),
        itemCount: events.length + 1,
        separatorBuilder:
            (_, index) =>
                index == 0
                    ? const SizedBox(height: 0)
                    : const SizedBox(height: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.notificationCenterTitle,
                    style: GoogleFonts.merriweather(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepTeal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.notificationCenterSubtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }

          final event = events[index - 1];

          return AppNotificationTile(
            title: EventNotificationContent.title(l10n, event),
            body: EventNotificationContent.body(l10n, event),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => NotificationDetailScreen(eventId: event.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
