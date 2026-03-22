class LoginResponse {
  const LoginResponse({required this.accessToken, required this.tokenType});

  final String accessToken;
  final String tokenType;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'];
    final tokenType = json['token_type'];

    if (accessToken is! String || tokenType is! String) {
      throw const FormatException('Invalid login response format.');
    }

    return LoginResponse(accessToken: accessToken, tokenType: tokenType);
  }
}
