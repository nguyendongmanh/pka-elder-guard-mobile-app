import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/notifications/data/models/event_failure.dart';
import 'package:elder_guard_app/features/notifications/data/models/event_read.dart';
import 'package:elder_guard_app/features/notifications/presentation/controllers/event_notifications_controller.dart';
import 'package:elder_guard_app/features/notifications/presentation/utils/event_failure_message.dart';
import 'package:elder_guard_app/features/notifications/presentation/utils/event_notification_content.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationDetailScreen extends ConsumerWidget {
  const NotificationDetailScreen({required this.eventId, super.key});

  final int eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final eventAsyncValue = ref.watch(eventDetailProvider(eventId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationDetailTitle(eventId))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: eventAsyncValue.when(
            data: (event) => _NotificationDetailView(event: event),
            loading:
                () => Center(
                  child: Text(
                    l10n.notificationLoadingDetails,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
                              ref.refresh(eventDetailProvider(eventId).future),
                      child: Text(l10n.notificationRetryAction),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NotificationDetailView extends StatelessWidget {
  const _NotificationDetailView({required this.event});

  final EventRead event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.tealPrimary.withValues(alpha: 0.20),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepTeal.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                EventNotificationContent.title(l10n, event),
                style: GoogleFonts.merriweather(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepTeal,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                EventNotificationContent.body(l10n, event),
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark.withValues(alpha: 0.84),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              _DetailRow(
                label: l10n.notificationFieldEventId,
                value: event.id.toString(),
              ),
              _DetailRow(
                label: l10n.notificationFieldCameraId,
                value: event.cameraId.toString(),
              ),
              _DetailRow(
                label: l10n.notificationFieldEventType,
                value: event.eventType,
              ),
              _DetailRow(
                label: l10n.notificationFieldConfidence,
                value: EventNotificationContent.formatConfidence(
                  event.confidence,
                ),
              ),
              _DetailRow(
                label: l10n.notificationFieldTimestamp,
                value: EventNotificationContent.formatTimestamp(
                  l10n,
                  event.timestamp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.tealPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
