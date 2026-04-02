import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/notifications/push_registration_status.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class NotificationStatusCard extends StatelessWidget {
  const NotificationStatusCard({
    required this.registrationStatus,
    required this.subscriptionId,
    super.key,
  });

  final PushRegistrationStatus registrationStatus;
  final String? subscriptionId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.tealPrimary.withValues(alpha: 0.18),
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
            l10n.notificationStatusTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.deepTeal,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _StatusRow(
            label: l10n.notificationRegistrationLabel,
            value: _statusLabel(l10n),
          ),
          _StatusRow(
            label: l10n.notificationUserLabel,
            value: registrationStatus.userId ?? '-',
          ),
          _StatusRow(
            label: l10n.notificationSubscriptionLabel,
            value: subscriptionId ?? registrationStatus.subscriptionId ?? '-',
          ),
          if (registrationStatus.message != null &&
              registrationStatus.message!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                registrationStatus.message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n) {
    switch (registrationStatus.phase) {
      case PushRegistrationPhase.waitingForLogin:
        return l10n.notificationStatusWaitingForLogin;
      case PushRegistrationPhase.waitingForSubscription:
        return l10n.notificationStatusWaitingForSubscription;
      case PushRegistrationPhase.registered:
        final backendStatus = registrationStatus.backendStatus;
        if (backendStatus != null && backendStatus.isNotEmpty) {
          return '${l10n.notificationStatusRegistered} ($backendStatus)';
        }
        return l10n.notificationStatusRegistered;
      case PushRegistrationPhase.failed:
        return l10n.notificationStatusFailed;
    }
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.tealPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
