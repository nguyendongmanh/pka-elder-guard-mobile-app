class GeofenceRequest {
  const GeofenceRequest({
    required this.deviceId,
    required this.anchorLatitude,
    required this.anchorLongitude,
    required this.radiusMeters,
  });

  final String deviceId;
  final double anchorLatitude;
  final double anchorLongitude;
  final double radiusMeters;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'device_id': deviceId,
      'anchor_latitude': anchorLatitude,
      'anchor_longitude': anchorLongitude,
      'radius_meters': radiusMeters,
    };
  }
}
