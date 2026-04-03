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
}
