abstract final class AppConfig {
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');
  static const String _defaultBaseUrl =
      'https://jeane-unubiquitous-superprecariously.ngrok-free.dev/PKA_ElderGuard';

  static String get baseUrl {
    final rawBaseUrl =
        _baseUrlOverride.isNotEmpty ? _baseUrlOverride : _defaultBaseUrl;

    return _normalizeBaseUrl(rawBaseUrl);
  }

  static Map<String, String> get defaultHeaders {
    final host = Uri.tryParse(baseUrl)?.host ?? '';
    if (host.endsWith('ngrok-free.dev')) {
      return const <String, String>{'ngrok-skip-browser-warning': 'true'};
    }

    return const <String, String>{};
  }

  static String _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return _defaultBaseUrl;
    }

    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }

    return trimmed;
  }
}
