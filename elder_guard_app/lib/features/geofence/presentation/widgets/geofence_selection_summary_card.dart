import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/geofence/data/models/geofence_save_result.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class GeofenceSelectionSummaryCard extends StatelessWidget {
  const GeofenceSelectionSummaryCard({
    required this.center,
    required this.radiusMeters,
    this.lastSavedResult,
    super.key,
  });

  final LatLng center;
  final double radiusMeters;
  final GeofenceSaveResult? lastSavedResult;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.geofenceCenterCardTitle,
              style: GoogleFonts.merriweather(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.deepTeal,
              ),
            ),
            const SizedBox(height: 16),
            _SummaryRow(
              label: l10n.geofenceLatitudeLabel,
              value: center.latitude.toStringAsFixed(6),
            ),
            _SummaryRow(
              label: l10n.geofenceLongitudeLabel,
              value: center.longitude.toStringAsFixed(6),
            ),
            _SummaryRow(
              label: l10n.geofenceRadiusLabel,
              value: l10n.geofenceRadiusValue(radiusMeters.round()),
            ),
            if (lastSavedResult != null)
              _SummaryRow(
                label: l10n.geofenceBackendStatusLabel,
                value:
                    lastSavedResult!.isUpdated
                        ? l10n.geofenceStatusUpdated
                        : l10n.geofenceStatusCreated,
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textDark.withValues(alpha: 0.74),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.deepTeal,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
