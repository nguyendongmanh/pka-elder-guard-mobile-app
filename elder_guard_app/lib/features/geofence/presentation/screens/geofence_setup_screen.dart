import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/core/errors/api_exception.dart';
import 'package:elder_guard_app/features/geofence/data/models/geofence_request.dart';
import 'package:elder_guard_app/features/geofence/presentation/controllers/geofence_controller.dart';
import 'package:elder_guard_app/features/geofence/presentation/widgets/geofence_details_card.dart';
import 'package:elder_guard_app/features/geofence/presentation/widgets/geofence_map_card.dart';
import 'package:elder_guard_app/features/geofence/presentation/widgets/geofence_selection_summary_card.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class GeofenceSetupScreen extends ConsumerStatefulWidget {
  const GeofenceSetupScreen({required this.initialDeviceId, super.key});

  final String initialDeviceId;

  @override
  ConsumerState<GeofenceSetupScreen> createState() =>
      _GeofenceSetupScreenState();
}

class _GeofenceSetupScreenState extends ConsumerState<GeofenceSetupScreen> {
  static const LatLng _defaultCenter = LatLng(10.776889, 106.700806);

  late final TextEditingController _deviceIdController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  LatLng _selectedCenter = _defaultCenter;
  double _radiusMeters = 150;

  @override
  void initState() {
    super.initState();
    _deviceIdController = TextEditingController(text: widget.initialDeviceId);
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _syncCoordinateControllers();
  }

  @override
  void dispose() {
    _deviceIdController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final geofenceState = ref.watch(geofenceControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.creamLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.deepTeal,
        title: Text(
          l10n.geofenceScreenTitle,
          style: GoogleFonts.merriweather(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Text(
            l10n.geofenceScreenSubtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          GeofenceMapCard(
            center: _selectedCenter,
            radiusMeters: _radiusMeters,
            onCenterChanged: _updateSelectedCenter,
          ),
          const SizedBox(height: 14),
          GeofenceSelectionSummaryCard(
            center: _selectedCenter,
            radiusMeters: _radiusMeters,
            lastSavedResult: geofenceState.lastResult,
          ),
          const SizedBox(height: 14),
          GeofenceDetailsCard(
            deviceIdController: _deviceIdController,
            latitudeController: _latitudeController,
            longitudeController: _longitudeController,
            radiusMeters: _radiusMeters,
            isSubmitting: geofenceState.isSubmitting,
            onApplyCoordinates: _applyManualCoordinates,
            onRadiusChanged: (value) {
              setState(() {
                _radiusMeters = value;
              });
            },
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: geofenceState.isSubmitting ? null : _submitGeofence,
            icon:
                geofenceState.isSubmitting
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Icon(Icons.save_rounded),
            label: Text(
              geofenceState.isSubmitting
                  ? l10n.geofenceSavingAction
                  : l10n.geofenceSaveAction,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitGeofence() async {
    final l10n = AppLocalizations.of(context)!;
    final deviceId = _deviceIdController.text.trim();
    if (deviceId.isEmpty) {
      _showSnackBar(l10n.requiredFieldError);
      return;
    }

    FocusScope.of(context).unfocus();

    try {
      final result = await ref
          .read(geofenceControllerProvider.notifier)
          .saveGeofence(
            GeofenceRequest(
              deviceId: deviceId,
              anchorLatitude: _selectedCenter.latitude,
              anchorLongitude: _selectedCenter.longitude,
              radiusMeters: _radiusMeters,
            ),
          );

      if (!mounted) {
        return;
      }

      _showSnackBar(
        result.isUpdated ? l10n.geofenceSaveUpdated : l10n.geofenceSaveCreated,
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showSnackBar(_mapErrorMessage(error, l10n));
    } on Object {
      if (!mounted) {
        return;
      }

      _showSnackBar(l10n.serverErrorMessage);
    }
  }

  String _mapErrorMessage(ApiException error, AppLocalizations l10n) {
    switch (error.type) {
      case ApiExceptionType.network:
        return l10n.networkErrorMessage;
      case ApiExceptionType.invalidResponse:
        final message = error.message?.trim();
        if (message != null && message.isNotEmpty) {
          return message;
        }
        return l10n.serverErrorMessage;
    }
  }

  void _applyManualCoordinates() {
    final l10n = AppLocalizations.of(context)!;
    final latitude = double.tryParse(_latitudeController.text.trim());
    final longitude = double.tryParse(_longitudeController.text.trim());

    final isValidLatitude =
        latitude != null && latitude >= -90 && latitude <= 90;
    final isValidLongitude =
        longitude != null && longitude >= -180 && longitude <= 180;

    if (!isValidLatitude || !isValidLongitude) {
      _showSnackBar(l10n.geofenceInvalidCoordinatesMessage);
      return;
    }

    _updateSelectedCenter(LatLng(latitude, longitude));
  }

  void _updateSelectedCenter(LatLng point) {
    setState(() {
      _selectedCenter = point;
      _syncCoordinateControllers();
    });
  }

  void _syncCoordinateControllers() {
    _latitudeController.text = _selectedCenter.latitude.toStringAsFixed(6);
    _longitudeController.text = _selectedCenter.longitude.toStringAsFixed(6);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
