import 'package:elder_guard_app/features/geofence/data/geofence_repository.dart';
import 'package:elder_guard_app/features/geofence/data/models/geofence_request.dart';
import 'package:elder_guard_app/features/geofence/data/models/geofence_save_result.dart';
import 'package:elder_guard_app/features/geofence/presentation/controllers/geofence_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geofenceControllerProvider =
    NotifierProvider<GeofenceController, GeofenceState>(GeofenceController.new);

class GeofenceController extends Notifier<GeofenceState> {
  late final GeofenceRepository _repository;

  @override
  GeofenceState build() {
    _repository = ref.watch(geofenceRepositoryProvider);
    return const GeofenceState.initial();
  }

  Future<GeofenceSaveResult> saveGeofence(GeofenceRequest request) async {
    state = state.copyWith(isSubmitting: true);

    try {
      final result = await _repository.saveGeofence(request);
      state = state.copyWith(isSubmitting: false, lastResult: result);
      return result;
    } on Object {
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }
  }
}
