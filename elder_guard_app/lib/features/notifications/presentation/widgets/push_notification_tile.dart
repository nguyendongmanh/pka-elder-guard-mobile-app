import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/notifications/models/push_notification_record.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PushNotificationTile extends StatelessWidget {
  const PushNotificationTile({
    required this.notification,
    this.onTap,
    super.key,
  });

  final PushNotificationRecord notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final timestamp = DateFormat.yMd(
      localeName,
    ).add_Hm().format(notification.receivedAt.toLocal());

    final isUnread = !notification.isRead;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color:
                isUnread
                    ? Colors.white.withValues(alpha: 0.94)
                    : Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color:
                  isUnread
                      ? AppColors.notificationBlue.withValues(alpha: 0.28)
                      : AppColors.tealPrimary.withValues(alpha: 0.14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isUnread) ...[
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 6, right: 10),
                      decoration: const BoxDecoration(
                        color: AppColors.notificationBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.deepTeal,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _SourceChip(
                    label:
                        notification.source == PushNotificationSource.foreground
                            ? l10n.notificationSourceForeground
                            : l10n.notificationSourceOpened,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textDark.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                timestamp,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textDark.withValues(alpha: 0.64),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tealPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.tealPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
