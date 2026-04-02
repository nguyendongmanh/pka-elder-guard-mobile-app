class PushRegistrationResult {
  const PushRegistrationResult({
    required this.status,
    required this.playerId,
    required this.userId,
  });

  final String status;
  final String playerId;
  final String userId;

  factory PushRegistrationResult.fromJson(
    Map<String, dynamic> json, {
    required String fallbackUserId,
    required String fallbackPlayerId,
  }) {
    return PushRegistrationResult(
      status: _normalize(json['status']) ?? 'registered',
      playerId:
          _normalize(json['player_id'] ?? json['playerId']) ?? fallbackPlayerId,
      userId: _normalize(json['user_id'] ?? json['userId']) ?? fallbackUserId,
    );
  }

  static String? _normalize(dynamic value) {
    if (value is int) {
      return value.toString();
    }
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }
}
