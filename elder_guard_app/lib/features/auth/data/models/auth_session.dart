class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.email,
    this.userId,
  });

  final String accessToken;
  final String email;
  final String? userId;
}
