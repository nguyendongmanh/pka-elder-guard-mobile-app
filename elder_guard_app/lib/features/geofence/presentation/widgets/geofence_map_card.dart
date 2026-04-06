import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class GeofenceMapCard extends StatelessWidget {
  const GeofenceMapCard({
    required this.center,
    required this.radiusMeters,
    required this.onCenterChanged,
    super.key,
  });

  final LatLng center;
  final double radiusMeters;
  final ValueChanged<LatLng> onCenterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealPrimary.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.geofenceMapTitle,
              style: GoogleFonts.merriweather(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.deepTeal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.geofenceMapHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textDark.withValues(alpha: 0.78),
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: 320,
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: center,
                        initialZoom: 15,
                        minZoom: 5,
                        maxZoom: 18,
                        onTap: (_, point) => onCenterChanged(point),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.elder_guard_app',
                        ),
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: center,
                              radius: radiusMeters,
                              useRadiusInMeter: true,
                              color: AppColors.tealSecondary.withValues(
                                alpha: 0.18,
                              ),
                              borderColor: AppColors.deepTeal.withValues(
                                alpha: 0.82,
                              ),
                              borderStrokeWidth: 2.2,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: center,
                              width: 52,
                              height: 52,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.deepTeal.withValues(
                                        alpha: 0.18,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.place_rounded,
                                  color: AppColors.deepTeal,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Text(
                            l10n.geofenceMapAttribution,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium?.copyWith(
                              color: AppColors.textDark.withValues(alpha: 0.74),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
