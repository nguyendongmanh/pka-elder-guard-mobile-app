import 'dart:async';
import 'dart:convert';

import 'package:elder_guard_app/core/config/app_config.dart';
import 'package:elder_guard_app/core/di/core_providers.dart';
import 'package:elder_guard_app/core/errors/api_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(httpClientProvider));
});

class ApiClient {
  ApiClient(this._client);

  final http.Client _client;

  Future<http.Response> postJson({
    required String path,
    required Map<String, dynamic> body,
  }) {
    return _send(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: const <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> postFormUrlEncoded({
    required String path,
    required Map<String, String> body,
  }) {
    return _send(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: const <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body.entries
          .map(
            (entry) =>
                '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}',
          )
          .join('&'),
    );
  }

  Future<http.Response> _send(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
  }) async {
    try {
      return await _client
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 12));
    } on TimeoutException {
      throw const ApiException(ApiExceptionType.network);
    } on http.ClientException {
      throw const ApiException(ApiExceptionType.network);
    } on Object {
      throw const ApiException(ApiExceptionType.network);
    }
  }
}
