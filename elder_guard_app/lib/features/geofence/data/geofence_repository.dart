import 'package:elder_guard_app/features/geofence/data/geofence_api_service.dart';
import 'package:elder_guard_app/features/geofence/data/models/geofence_request.dart';
import 'package:elder_guard_app/features/geofence/data/models/geofence_save_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geofenceRepositoryProvider = Provider<GeofenceRepository>((ref) {
  return RemoteGeofenceRepository(
    apiService: ref.watch(geofenceApiServiceProvider),
  );
});

abstract class GeofenceRepository {
  Future<GeofenceSaveResult> saveGeofence(GeofenceRequest request);
}

class RemoteGeofenceRepository implements GeofenceRepository {
  RemoteGeofenceRepository({required GeofenceApiService apiService})
    : _apiService = apiService;

  final GeofenceApiService _apiService;

  @override
  Future<GeofenceSaveResult> saveGeofence(GeofenceRequest request) {
    return _apiService.saveGeofence(request);
  }
}
