import 'package:elder_guard_app/core/storage/token_storage.dart';
import 'package:elder_guard_app/features/auth/data/auth_api_service.dart';
import 'package:elder_guard_app/features/auth/data/models/auth_session.dart';
import 'package:elder_guard_app/features/auth/data/models/register_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return RemoteAuthRepository(
    apiService: ref.watch(authApiServiceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

abstract class AuthRepository {
  Future<AuthSession?> restoreSession();

  Future<AuthSession> login({required String email, required String password});

  Future<RegisterResult> register({
    required String username,
    required String email,
    required String password,
  });

  Future<void> logout();
}

class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository({
    required AuthApiService apiService,
    required TokenStorage tokenStorage,
  }) : _apiService = apiService,
       _tokenStorage = tokenStorage;

  final AuthApiService _apiService;
  final TokenStorage _tokenStorage;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.login(email: email, password: password);

    await _tokenStorage.saveSession(
      accessToken: response.accessToken,
      email: email,
      userId: response.userId,
    );

    return AuthSession(
      accessToken: response.accessToken,
      email: email,
      userId: response.userId,
    );
  }

  @override
  Future<void> logout() {
    return _tokenStorage.clear();
  }

  @override
  Future<RegisterResult> register({
    required String username,
    required String email,
    required String password,
  }) {
    return _apiService.register(
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final token = await _tokenStorage.readAccessToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    return AuthSession(
      accessToken: token,
      email: await _tokenStorage.readUserEmail() ?? '',
      userId: await _tokenStorage.readUserId(),
    );
  }
}
