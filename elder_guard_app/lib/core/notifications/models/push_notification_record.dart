enum PushNotificationSource { foreground, opened }

class PushNotificationRecord {
  const PushNotificationRecord({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.source,
    required this.additionalData,
    required this.opened,
    required this.isRead,
  });

  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final PushNotificationSource source;
  final Map<String, dynamic> additionalData;
  final bool opened;
  final bool isRead;

  int? get cameraId {
    final directCameraId = _readInt(
      additionalData['camera_id'] ?? additionalData['cameraId'],
    );
    if (directCameraId != null) {
      return directCameraId;
    }

    return _extractCameraIdFromText('$title $body');
  }

  String? get eventType {
    final directEventType = _normalizeString(
      additionalData['event_type'] ?? additionalData['eventType'],
    );
    if (directEventType != null) {
      return directEventType;
    }

    final combinedText = '$title $body'.toLowerCase();
    if (combinedText.contains('fall') || combinedText.contains('té ngã')) {
      return 'fall_detected';
    }
    if (combinedText.contains('violence') || combinedText.contains('bạo lực')) {
      return 'violence_detected';
    }
    if (combinedText.contains('imobile') || combinedText.contains('bất động')) {
      return 'imobile_detected';
    }

    return null;
  }

  bool get hasCameraContext => cameraId != null;

  factory PushNotificationRecord.fromJson(Map<String, dynamic> json) {
    final sourceName = json['source'] as String?;
    final source = PushNotificationSource.values.firstWhere(
      (value) => value.name == sourceName,
      orElse: () => PushNotificationSource.foreground,
    );

    final additionalData = json['additionalData'];
    final normalizedAdditionalData =
        additionalData is Map
            ? Map<String, dynamic>.from(additionalData)
            : <String, dynamic>{};

    return PushNotificationRecord(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      receivedAt:
          DateTime.tryParse(json['receivedAt'] as String? ?? '') ??
          DateTime.now(),
      source: source,
      additionalData: normalizedAdditionalData,
      opened: json['opened'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? (json['opened'] as bool? ?? false),
    );
  }

  PushNotificationRecord copyWith({
    String? title,
    String? body,
    DateTime? receivedAt,
    PushNotificationSource? source,
    Map<String, dynamic>? additionalData,
    bool? opened,
    bool? isRead,
  }) {
    return PushNotificationRecord(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      source: source ?? this.source,
      additionalData: additionalData ?? this.additionalData,
      opened: opened ?? this.opened,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'receivedAt': receivedAt.toIso8601String(),
      'source': source.name,
      'additionalData': additionalData,
      'opened': opened,
      'isRead': isRead,
    };
  }

  static int? _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  static String? _normalizeString(dynamic value) {
    if (value is! String) {
      return null;
    }

    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static int? _extractCameraIdFromText(String text) {
    final match = RegExp(
      r'camera\s+(\d+)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) {
      return null;
    }

    return int.tryParse(match.group(1) ?? '');
  }
}
