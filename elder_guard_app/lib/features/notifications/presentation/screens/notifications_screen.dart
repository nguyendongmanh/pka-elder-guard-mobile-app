import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/notifications/push_registration_status.dart';
import 'package:elder_guard_app/features/notifications/presentation/controllers/notification_center_controller.dart';
import 'package:elder_guard_app/features/notifications/presentation/widgets/notification_status_card.dart';
import 'package:elder_guard_app/features/notifications/presentation/widgets/push_notification_tile.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notificationCenter = ref.watch(notificationCenterControllerProvider);
    final registrationStatus = ref.watch(pushRegistrationStatusProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
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
          ),
          NotificationStatusCard(
            registrationStatus: registrationStatus,
            subscriptionId: notificationCenter.subscriptionId,
          ),
          const SizedBox(height: 18),
          if (notificationCenter.notifications.isEmpty)
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
            )
          else
            ...notificationCenter.notifications.map(
              (notification) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: PushNotificationTile(notification: notification),
              ),
            ),
        ],
      ),
    );
  }
}
