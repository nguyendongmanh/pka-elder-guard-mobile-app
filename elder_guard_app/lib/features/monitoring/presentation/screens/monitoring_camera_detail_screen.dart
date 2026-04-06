import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/monitoring/presentation/models/demo_camera_item.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MonitoringCameraDetailScreen extends StatelessWidget {
  const MonitoringCameraDetailScreen({
    required this.camera,
    this.eventType,
    this.alertTime,
    this.openedFromAlert = false,
    super.key,
  });

  final DemoCameraItem camera;
  final String? eventType;
  final DateTime? alertTime;
  final bool openedFromAlert;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final effectiveEventType = _mapEventTypeLabel(l10n, eventType);
    final formattedAlertTime =
        alertTime == null
            ? null
            : DateFormat.yMd(localeName).add_Hm().format(alertTime!.toLocal());

    return Scaffold(
      backgroundColor: AppColors.creamLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.deepTeal,
        title: Text(
          camera.name,
          style: GoogleFonts.merriweather(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          if (openedFromAlert)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _AlertSummaryCard(
                title: l10n.monitoringCameraAlertTitle,
                eventLabel: effectiveEventType,
                alertTimeLabel: formattedAlertTime,
              ),
            ),
          _CameraPreviewCard(
            badgeLabel:
                openedFromAlert
                    ? l10n.monitoringHighlightedBadge
                    : l10n.monitoringDemoBadge,
          ),
          const SizedBox(height: 16),
          _CameraInfoCard(
            title: l10n.monitoringCameraDetailTitle,
            rows: <_InfoRowData>[
              _InfoRowData(
                label: l10n.monitoringCameraIdLabel,
                value: camera.id.toString(),
              ),
              _InfoRowData(
                label: l10n.monitoringCameraNameLabel,
                value: camera.name,
              ),
              _InfoRowData(
                label: l10n.monitoringCameraModeLabel,
                value: l10n.monitoringCameraModeDemo,
              ),
              _InfoRowData(
                label: l10n.monitoringCameraStatusLabel,
                value:
                    openedFromAlert
                        ? l10n.monitoringCameraStatusAlert
                        : l10n.monitoringCameraStatusNormal,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _CameraInfoCard(
            title: l10n.monitoringRecentActivityTitle,
            rows: <_InfoRowData>[
              _InfoRowData(
                label: l10n.monitoringRecentEventLabel,
                value: effectiveEventType,
              ),
              _InfoRowData(
                label: l10n.monitoringRecentTimeLabel,
                value:
                    formattedAlertTime ?? l10n.monitoringRecentTimeUnavailable,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _mapEventTypeLabel(AppLocalizations l10n, String? rawEventType) {
    switch (rawEventType?.trim().toLowerCase()) {
      case 'fall_detected':
        return l10n.monitoringEventFall;
      case 'violence_detected':
        return l10n.monitoringEventViolence;
      case 'imobile_detected':
        return l10n.monitoringEventImmobile;
      case null:
      case '':
        return l10n.monitoringEventNoData;
      default:
        return rawEventType!;
    }
  }
}

class _AlertSummaryCard extends StatelessWidget {
  const _AlertSummaryCard({
    required this.title,
    required this.eventLabel,
    required this.alertTimeLabel,
  });

  final String title;
  final String eventLabel;
  final String? alertTimeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.notificationBlue.withValues(alpha: 0.28),
          width: 1.4,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.notificationBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.notificationBlue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.deepTeal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  eventLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (alertTimeLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    alertTimeLabel!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textDark.withValues(alpha: 0.74),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraPreviewCard extends StatelessWidget {
  const _CameraPreviewCard({required this.badgeLabel});

  final String badgeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.tealPrimary.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badgeLabel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.deepTeal, AppColors.tealSecondary],
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam_rounded, color: Colors.white, size: 64),
                SizedBox(height: 14),
                Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraInfoCard extends StatelessWidget {
  const _CameraInfoCard({required this.title, required this.rows});

  final String title;
  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.tealPrimary.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.deepTeal,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          for (var index = 0; index < rows.length; index++) ...[
            _InfoRow(row: rows[index]),
            if (index != rows.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.row});

  final _InfoRowData row;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            row.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textDark.withValues(alpha: 0.7),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            row.value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.deepTeal,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRowData {
  const _InfoRowData({required this.label, required this.value});

  final String label;
  final String value;
}
