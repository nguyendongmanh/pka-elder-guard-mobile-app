import 'dart:async';

import 'package:elder_guard_app/features/auth/data/auth_repository.dart';
import 'package:elder_guard_app/features/auth/data/models/auth_failure.dart';
import 'package:elder_guard_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    Future.microtask(_restoreSession);
    return const AuthState.initial();
  }

  Future<AuthActionResult> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isSubmitting: true);

    try {
      final session = await _repository.login(email: email, password: password);

      state = AuthState.authenticated(session);
      return const AuthActionResult.success();
    } on AuthFailure catch (error) {
      state = state.copyWith(isSubmitting: false);
      return AuthActionResult.failure(error);
    } on Object {
      state = state.copyWith(isSubmitting: false);
      return const AuthActionResult.failure(
        AuthFailure(AuthFailureCode.unknown),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isSubmitting: true);
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }

  Future<AuthActionResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isSubmitting: true);

    try {
      await _repository.register(
        username: username,
        email: email,
        password: password,
      );

      state = state.copyWith(isSubmitting: false);
      return const AuthActionResult.success();
    } on AuthFailure catch (error) {
      state = state.copyWith(isSubmitting: false);
      return AuthActionResult.failure(error);
    } on Object {
      state = state.copyWith(isSubmitting: false);
      return const AuthActionResult.failure(
        AuthFailure(AuthFailureCode.unknown),
      );
    }
  }

  Future<void> _restoreSession() async {
    try {
      final session = await _repository.restoreSession();
      state =
          session == null
              ? const AuthState.unauthenticated()
              : AuthState.authenticated(session);
    } on Object {
      state = const AuthState.unauthenticated();
    }
  }
}

class AuthActionResult {
  const AuthActionResult._({required this.isSuccess, this.error});

  const AuthActionResult.success() : this._(isSuccess: true);

  const AuthActionResult.failure(AuthFailure error)
    : this._(isSuccess: false, error: error);

  final bool isSuccess;
  final AuthFailure? error;
}
