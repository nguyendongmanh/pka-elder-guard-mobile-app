enum ApiExceptionType { network, invalidResponse }

class ApiException implements Exception {
  const ApiException(this.type, {this.message});

  final ApiExceptionType type;
  final String? message;
}
