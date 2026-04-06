import 'package:elder_guard_app/features/geofence/data/models/geofence_record.dart';

class GeofenceSaveResult {
  const GeofenceSaveResult({required this.status, required this.geofence});

  final String status;
  final GeofenceRecord geofence;

  bool get isUpdated => status.trim().toLowerCase() == 'updated';

  factory GeofenceSaveResult.fromJson(Map<String, dynamic> json) {
    final status = json['status'];
    final geofence = json['geofence'];

    if (status is! String || geofence is! Map<String, dynamic>) {
      throw const FormatException('Invalid geofence save response format.');
    }

    return GeofenceSaveResult(
      status: status,
      geofence: GeofenceRecord.fromJson(geofence),
    );
  }
}
