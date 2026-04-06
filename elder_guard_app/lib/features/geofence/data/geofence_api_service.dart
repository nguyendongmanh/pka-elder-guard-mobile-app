import 'dart:convert';

import 'package:elder_guard_app/core/errors/api_exception.dart';
import 'package:elder_guard_app/core/network/api_client.dart';
import 'package:elder_guard_app/features/geofence/data/models/geofence_request.dart';
import 'package:elder_guard_app/features/geofence/data/models/geofence_save_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geofenceApiServiceProvider = Provider<GeofenceApiService>((ref) {
  return GeofenceApiService(ref.watch(apiClientProvider));
});

class GeofenceApiService {
  GeofenceApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<GeofenceSaveResult> saveGeofence(GeofenceRequest request) async {
    try {
      final response = await _apiClient.postJson(
        path: '/geofences',
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GeofenceSaveResult.fromJson(_decodeMap(response.body));
      }

      throw ApiException(
        ApiExceptionType.invalidResponse,
        message: _extractMessage(response.body),
      );
    } on ApiException {
      rethrow;
    } on FormatException catch (error) {
      throw ApiException(
        ApiExceptionType.invalidResponse,
        message: error.message,
      );
    } on Object {
      throw const ApiException(ApiExceptionType.invalidResponse);
    }
  }

  Map<String, dynamic> _decodeMap(String body) {
    if (body.trim().isEmpty) {
      throw const FormatException('Response body is empty.');
    }

    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Response body is not a JSON object.');
    }

    return decoded;
  }

  String? _extractMessage(String body) {
    try {
      final json = _decodeMap(body);
      final detail = json['detail'];
      final error = json['error'];
      final message = json['message'];

      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }
      if (error is String && error.trim().isNotEmpty) {
        return error;
      }
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    } on Object {
      return null;
    }

    return null;
  }
}
