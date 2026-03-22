import 'package:flutter/foundation.dart';

abstract final class AppConfig {
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');
  static const String _localhostBaseUrl =
      'http://localhost:8000/PKA_ElderGuard';
  static const String _androidEmulatorBaseUrl =
      'http://10.0.2.2:8000/PKA_ElderGuard';

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) {
      return _baseUrlOverride;
    }

    if (kIsWeb) {
      return _localhostBaseUrl;
    }

    return defaultTargetPlatform == TargetPlatform.android
        ? _androidEmulatorBaseUrl
        : _localhostBaseUrl;
  }
}
