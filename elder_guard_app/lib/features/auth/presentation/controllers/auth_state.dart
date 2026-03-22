import 'package:elder_guard_app/features/auth/data/models/auth_session.dart';

class AuthState {
  const AuthState({
    required this.isBootstrapping,
    required this.isSubmitting,
    this.session,
  });

  const AuthState.initial()
    : isBootstrapping = true,
      isSubmitting = false,
      session = null;

  const AuthState.unauthenticated()
    : isBootstrapping = false,
      isSubmitting = false,
      session = null;

  const AuthState.authenticated(AuthSession this.session)
    : isBootstrapping = false,
      isSubmitting = false;

  final bool isBootstrapping;
  final bool isSubmitting;
  final AuthSession? session;

  bool get isAuthenticated => session != null;

  AuthState copyWith({
    bool? isBootstrapping,
    bool? isSubmitting,
    AuthSession? session,
    bool clearSession = false,
  }) {
    return AuthState(
      isBootstrapping: isBootstrapping ?? this.isBootstrapping,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      session: clearSession ? null : session ?? this.session,
    );
  }
}
