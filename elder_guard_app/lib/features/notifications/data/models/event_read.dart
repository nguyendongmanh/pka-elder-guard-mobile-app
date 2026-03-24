class EventRead {
  const EventRead({
    required this.id,
    required this.cameraId,
    required this.timestamp,
    required this.eventType,
    required this.confidence,
  });

  final int id;
  final int cameraId;
  final DateTime timestamp;
  final String eventType;
  final double confidence;

  factory EventRead.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final cameraId = json['camera_id'];
    final timestamp = json['timestamp'];
    final eventType = json['event_type'];
    final confidence = json['confidence'];

    if (id is! num ||
        cameraId is! num ||
        timestamp is! String ||
        eventType is! String ||
        confidence is! num) {
      throw const FormatException('Invalid event response format.');
    }

    return EventRead(
      id: id.toInt(),
      cameraId: cameraId.toInt(),
      timestamp: DateTime.parse(timestamp).toLocal(),
      eventType: eventType,
      confidence: confidence.toDouble(),
    );
  }
}
