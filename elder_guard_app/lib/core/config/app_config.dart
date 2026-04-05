abstract final class AppConfig {
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');
  static const String _defaultBaseUrl =
      'https://jeane-unubiquitous-superprecariously.ngrok-free.dev/PKA_ElderGuard';

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) {
      return _baseUrlOverride;
    }

    return _defaultBaseUrl;
  }

  static Map<String, String> get defaultHeaders {
    final host = Uri.tryParse(baseUrl)?.host ?? '';
    if (host.endsWith('ngrok-free.dev')) {
      return const <String, String>{'ngrok-skip-browser-warning': 'true'};
    }

    return const <String, String>{};
  }
}
