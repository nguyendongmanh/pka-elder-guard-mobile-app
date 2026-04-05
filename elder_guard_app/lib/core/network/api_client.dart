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

  Future<http.Response> get({
    required String path,
    Map<String, String>? headers,
  }) {
    return _sendGet(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: <String, String>{
        'Accept': 'application/json',
        ...AppConfig.defaultHeaders,
        ...?headers,
      },
    );
  }

  Future<http.Response> post({
    required String path,
    Map<String, String>? headers,
  }) {
    return _sendPost(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: <String, String>{
        'Accept': 'application/json',
        ...AppConfig.defaultHeaders,
        ...?headers,
      },
    );
  }

  Future<http.Response> postJson({
    required String path,
    required Map<String, dynamic> body,
  }) {
    return _sendPost(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        ...AppConfig.defaultHeaders,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete({
    required String path,
    Map<String, String>? headers,
  }) {
    return _sendDelete(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: <String, String>{
        'Accept': 'application/json',
        ...AppConfig.defaultHeaders,
        ...?headers,
      },
    );
  }

  Future<http.Response> postFormUrlEncoded({
    required String path,
    required Map<String, String> body,
  }) {
    return _sendPost(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        ...AppConfig.defaultHeaders,
      },
      body: body.entries
          .map(
            (entry) =>
                '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}',
          )
          .join('&'),
    );
  }

  Future<http.Response> _sendGet(
    Uri uri, {
    required Map<String, String> headers,
  }) async {
    try {
      return await _client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 12));
    } on TimeoutException {
      throw const ApiException(ApiExceptionType.network);
    } on http.ClientException {
      throw const ApiException(ApiExceptionType.network);
    } on Object {
      throw const ApiException(ApiExceptionType.network);
    }
  }

  Future<http.Response> _sendPost(
    Uri uri, {
    required Map<String, String> headers,
    String? body,
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

  Future<http.Response> _sendDelete(
    Uri uri, {
    required Map<String, String> headers,
  }) async {
    try {
      return await _client
          .delete(uri, headers: headers)
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
