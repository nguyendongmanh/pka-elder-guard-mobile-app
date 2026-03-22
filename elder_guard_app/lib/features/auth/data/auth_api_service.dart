import 'dart:convert';

import 'package:elder_guard_app/core/errors/api_exception.dart';
import 'package:elder_guard_app/core/network/api_client.dart';
import 'package:elder_guard_app/features/auth/data/models/auth_failure.dart';
import 'package:elder_guard_app/features/auth/data/models/login_response.dart';
import 'package:elder_guard_app/features/auth/data/models/register_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref.watch(apiClientProvider));
});

class AuthApiService {
  AuthApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.postFormUrlEncoded(
        path: '/auth/login',
        body: <String, String>{'username': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(_decodeMap(response.body));
      }

      throw _mapLoginFailure(response);
    } on ApiException catch (error) {
      throw _mapApiException(error);
    } on FormatException {
      throw const AuthFailure(AuthFailureCode.server);
    }
  }

  Future<RegisterResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.postJson(
        path: '/auth/register',
        body: <String, dynamic>{
          'email': email,
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResult.fromJson(_decodeMap(response.body));
      }

      throw _mapRegisterFailure(response);
    } on ApiException catch (error) {
      throw _mapApiException(error);
    } on FormatException {
      throw const AuthFailure(AuthFailureCode.server);
    }
  }

  AuthFailure _mapApiException(ApiException exception) {
    switch (exception.type) {
      case ApiExceptionType.network:
        return const AuthFailure(AuthFailureCode.network);
      case ApiExceptionType.invalidResponse:
        return AuthFailure(
          AuthFailureCode.server,
          serverMessage: exception.message,
        );
    }
  }

  AuthFailure _mapLoginFailure(http.Response response) {
    final message = _extractMessage(response.body);

    if (response.statusCode == 404) {
      return AuthFailure(AuthFailureCode.userNotFound, serverMessage: message);
    }

    if (response.statusCode == 401) {
      return AuthFailure(
        AuthFailureCode.incorrectPassword,
        serverMessage: message,
      );
    }

    if (response.statusCode == 422) {
      return AuthFailure(AuthFailureCode.validation, serverMessage: message);
    }

    return AuthFailure(AuthFailureCode.server, serverMessage: message);
  }

  AuthFailure _mapRegisterFailure(http.Response response) {
    final message = _extractMessage(response.body);

    if (response.statusCode == 400 && message == 'Email already exists') {
      return AuthFailure(
        AuthFailureCode.emailAlreadyExists,
        serverMessage: message,
      );
    }

    if (response.statusCode == 422) {
      return AuthFailure(AuthFailureCode.validation, serverMessage: message);
    }

    return AuthFailure(AuthFailureCode.server, serverMessage: message);
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
