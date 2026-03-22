enum AuthFailureCode {
  emailAlreadyExists,
  userNotFound,
  incorrectPassword,
  validation,
  network,
  server,
  unknown,
}

class AuthFailure implements Exception {
  const AuthFailure(this.code, {this.serverMessage});

  final AuthFailureCode code;
  final String? serverMessage;
}
