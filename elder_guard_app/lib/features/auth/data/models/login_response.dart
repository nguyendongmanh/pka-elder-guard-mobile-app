import 'dart:convert';

class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    required this.tokenType,
    this.userId,
  });

  final String accessToken;
  final String tokenType;
  final String? userId;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'];
    final tokenType = json['token_type'];

    if (accessToken is! String || tokenType is! String) {
      throw const FormatException('Invalid login response format.');
    }

    return LoginResponse(
      accessToken: accessToken,
      tokenType: tokenType,
      userId: _readUserId(json) ?? _readUserIdFromJwt(accessToken),
    );
  }

  static String? _readUserId(Map<String, dynamic> json) {
    final directUserId = _normalizeId(json['user_id'] ?? json['userId']);
    if (directUserId != null) {
      return directUserId;
    }

    final user = json['user'];
    if (user is Map) {
      return _normalizeId(user['user_id'] ?? user['userId'] ?? user['id']);
    }

    return null;
  }

  static String? _readUserIdFromJwt(String accessToken) {
    final parts = accessToken.split('.');
    if (parts.length != 3) {
      return null;
    }

    try {
      final decodedPayload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payload = jsonDecode(decodedPayload);
      if (payload is Map<String, dynamic>) {
        return _normalizeId(
          payload['user_id'] ?? payload['userId'] ?? payload['sub'],
        );
      }
      if (payload is Map) {
        return _normalizeId(
          payload['user_id'] ?? payload['userId'] ?? payload['sub'],
        );
      }
    } on FormatException {
      return null;
    } on Object {
      return null;
    }

    return null;
  }

  static String? _normalizeId(dynamic value) {
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
