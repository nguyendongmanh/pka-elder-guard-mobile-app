class RegisterResult {
  const RegisterResult({required this.message, required this.id});

  final String message;
  final int id;

  factory RegisterResult.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    final id = json['id'];

    if (message is! String || id is! int) {
      throw const FormatException('Invalid register response format.');
    }

    return RegisterResult(message: message, id: id);
  }
}
