enum AuthMode { login, register }

extension AuthModeX on AuthMode {
  bool get isLogin => this == AuthMode.login;
}
