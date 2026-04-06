import 'package:elder_guard_app/features/geofence/data/models/geofence_save_result.dart';

class GeofenceState {
  const GeofenceState({required this.isSubmitting, this.lastResult});

  const GeofenceState.initial() : isSubmitting = false, lastResult = null;

  final bool isSubmitting;
  final GeofenceSaveResult? lastResult;

  GeofenceState copyWith({
    bool? isSubmitting,
    GeofenceSaveResult? lastResult,
    bool clearLastResult = false,
  }) {
    return GeofenceState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lastResult: clearLastResult ? null : lastResult ?? this.lastResult,
    );
  }
}
