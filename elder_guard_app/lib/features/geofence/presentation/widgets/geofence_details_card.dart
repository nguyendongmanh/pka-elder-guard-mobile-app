import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeofenceDetailsCard extends StatelessWidget {
  const GeofenceDetailsCard({
    required this.deviceIdController,
    required this.latitudeController,
    required this.longitudeController,
    required this.radiusMeters,
    required this.isSubmitting,
    required this.onApplyCoordinates,
    required this.onRadiusChanged,
    super.key,
  });

  final TextEditingController deviceIdController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final double radiusMeters;
  final bool isSubmitting;
  final VoidCallback onApplyCoordinates;
  final ValueChanged<double> onRadiusChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealPrimary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.geofenceFormTitle,
              style: GoogleFonts.merriweather(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.deepTeal,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deviceIdController,
              enabled: !isSubmitting,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.geofenceDeviceIdLabel,
                hintText: l10n.geofenceDeviceIdHint,
                prefixIcon: const Icon(Icons.phonelink_lock_rounded),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              l10n.geofenceCenterInputTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.deepTeal,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: latitudeController,
                    enabled: !isSubmitting,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.geofenceLatitudeLabel,
                      hintText: l10n.geofenceLatitudeHint,
                      prefixIcon: const Icon(Icons.north_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: longitudeController,
                    enabled: !isSubmitting,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.geofenceLongitudeLabel,
                      hintText: l10n.geofenceLongitudeHint,
                      prefixIcon: const Icon(Icons.east_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: isSubmitting ? null : onApplyCoordinates,
              icon: const Icon(Icons.my_location_rounded),
              label: Text(l10n.geofenceApplyCoordinatesAction),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.geofenceRadiusLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.deepTeal,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  l10n.geofenceRadiusValue(radiusMeters.round()),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.tealPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Slider(
              value: radiusMeters.clamp(50, 1000).toDouble(),
              min: 50,
              max: 1000,
              divisions: 38,
              label: l10n.geofenceRadiusValue(radiusMeters.round()),
              onChanged: isSubmitting ? null : onRadiusChanged,
            ),
            Row(
              children: [
                Text(
                  l10n.geofenceRadiusValue(50),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark.withValues(alpha: 0.72),
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.geofenceRadiusValue(1000),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
