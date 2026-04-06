class GeofenceRecord {
  const GeofenceRecord({
    required this.id,
    required this.deviceId,
    required this.anchorLatitude,
    required this.anchorLongitude,
    required this.radiusMeters,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String deviceId;
  final double anchorLatitude;
  final double anchorLongitude;
  final double radiusMeters;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory GeofenceRecord.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final deviceId = json['device_id'];

    if (id is! int || deviceId is! String) {
      throw const FormatException('Invalid geofence response format.');
    }

    return GeofenceRecord(
      id: id,
      deviceId: deviceId,
      anchorLatitude: _readDouble(json['anchor_latitude']),
      anchorLongitude: _readDouble(json['anchor_longitude']),
      radiusMeters: _readDouble(json['radius_meters']),
      createdAt: _readDateTime(json['created_at']),
      updatedAt: _readDateTime(json['updated_at']),
    );
  }

  static double _readDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    throw const FormatException('Expected a numeric geofence field.');
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }
}
