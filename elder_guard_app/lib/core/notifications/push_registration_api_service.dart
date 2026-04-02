import 'dart:convert';

import 'package:elder_guard_app/core/errors/api_exception.dart';
import 'package:elder_guard_app/core/network/api_client.dart';
import 'package:elder_guard_app/core/notifications/models/push_registration_result.dart';
import 'package:elder_guard_app/core/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pushRegistrationApiServiceProvider = Provider<PushRegistrationApiService>(
  (ref) {
    return PushRegistrationApiService(
      apiClient: ref.watch(apiClientProvider),
      tokenStorage: ref.watch(tokenStorageProvider),
    );
  },
);

class PushRegistrationApiService {
  PushRegistrationApiService({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  }) : _apiClient = apiClient,
       _tokenStorage = tokenStorage;

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  Future<PushRegistrationResult> registerDevice({
    required String userId,
    required String subscriptionId,
  }) async {
    try {
      final response = await _apiClient.post(
        path: _buildPath('/notify/register', <String, String>{
          'user_id': userId,
          'player_id': subscriptionId,
        }),
        headers: await _buildHeaders(),
      );

      if (_isSuccessful(response.statusCode)) {
        return _parseRegistrationResult(
          response.body,
          fallbackUserId: userId,
          fallbackPlayerId: subscriptionId,
        );
      }

      throw ApiException(
        ApiExceptionType.invalidResponse,
        message:
            _extractMessage(response.body) ??
            'Failed to register push subscription.',
      );
    } on ApiException {
      rethrow;
    }
  }

  Future<void> removeDevice({required String subscriptionId}) async {
    try {
      final response = await _apiClient.delete(
        path: _buildPath('/notify/remove', <String, String>{
          'player_id': subscriptionId,
        }),
        headers: await _buildHeaders(),
      );

      if (_isSuccessful(response.statusCode)) {
        return;
      }

      throw ApiException(
        ApiExceptionType.invalidResponse,
        message:
            _extractMessage(response.body) ??
            'Failed to remove push subscription.',
      );
    } on ApiException {
      rethrow;
    }
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await _tokenStorage.readAccessToken();
    return <String, String>{
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  String _buildPath(String path, Map<String, String> queryParameters) {
    final query = queryParameters.entries
        .map(
          (entry) =>
              '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}',
        )
        .join('&');
    return '$path?$query';
  }

  bool _isSuccessful(int statusCode) => statusCode >= 200 && statusCode < 300;

  PushRegistrationResult _parseRegistrationResult(
    String body, {
    required String fallbackUserId,
    required String fallbackPlayerId,
  }) {
    if (body.trim().isEmpty) {
      return PushRegistrationResult(
        status: 'registered',
        playerId: fallbackPlayerId,
        userId: fallbackUserId,
      );
    }

    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException(
        ApiExceptionType.invalidResponse,
        message: 'Invalid register response format.',
      );
    }

    return PushRegistrationResult.fromJson(
      decoded,
      fallbackUserId: fallbackUserId,
      fallbackPlayerId: fallbackPlayerId,
    );
  }

  String? _extractMessage(String body) {
    if (body.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map) {
        return null;
      }

      final detail = decoded['detail'];
      final error = decoded['error'];
      final message = decoded['message'];

      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }
      if (error is String && error.trim().isNotEmpty) {
        return error;
      }
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    } on FormatException {
      return null;
    } on Object {
      return null;
    }

    return null;
  }
}
