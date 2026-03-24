import 'dart:convert';

import 'package:elder_guard_app/core/errors/api_exception.dart';
import 'package:elder_guard_app/core/network/api_client.dart';
import 'package:elder_guard_app/core/storage/token_storage.dart';
import 'package:elder_guard_app/features/notifications/data/models/event_failure.dart';
import 'package:elder_guard_app/features/notifications/data/models/event_read.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final eventsApiServiceProvider = Provider<EventsApiService>((ref) {
  return EventsApiService(
    apiClient: ref.watch(apiClientProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

class EventsApiService {
  EventsApiService({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  }) : _apiClient = apiClient,
       _tokenStorage = tokenStorage;

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  Future<List<EventRead>> listEvents() async {
    try {
      final response = await _apiClient.get(
        path: '/events',
        headers: await _buildHeaders(),
      );

      if (response.statusCode == 200) {
        return _decodeList(response.body);
      }

      throw _mapFailure(response);
    } on ApiException catch (error) {
      throw _mapApiException(error);
    } on FormatException {
      throw const EventFailure(EventFailureCode.server);
    }
  }

  Future<EventRead> getEvent(int eventId) async {
    try {
      final response = await _apiClient.get(
        path: '/events/$eventId',
        headers: await _buildHeaders(),
      );

      if (response.statusCode == 200) {
        return EventRead.fromJson(_decodeMap(response.body));
      }

      throw _mapFailure(response);
    } on ApiException catch (error) {
      throw _mapApiException(error);
    } on FormatException {
      throw const EventFailure(EventFailureCode.server);
    }
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await _tokenStorage.readAccessToken();
    return <String, String>{
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  List<EventRead> _decodeList(String body) {
    if (body.trim().isEmpty) {
      throw const FormatException('Response body is empty.');
    }

    final decoded = jsonDecode(body);
    if (decoded is! List) {
      throw const FormatException('Response body is not a JSON array.');
    }

    return decoded
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Event item is not a JSON object.');
          }
          return EventRead.fromJson(item);
        })
        .toList(growable: false);
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

  EventFailure _mapApiException(ApiException exception) {
    switch (exception.type) {
      case ApiExceptionType.network:
        return const EventFailure(EventFailureCode.network);
      case ApiExceptionType.invalidResponse:
        return EventFailure(
          EventFailureCode.server,
          message: exception.message,
        );
    }
  }

  EventFailure _mapFailure(http.Response response) {
    if (response.statusCode == 404) {
      return EventFailure(
        EventFailureCode.notFound,
        message: _extractMessage(response.body),
      );
    }

    return EventFailure(
      EventFailureCode.server,
      message: _extractMessage(response.body),
    );
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
