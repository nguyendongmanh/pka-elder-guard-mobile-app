import 'package:elder_guard_app/core/storage/storage_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return SecureTokenStorage(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
});

abstract class TokenStorage {
  Future<void> saveSession({
    required String accessToken,
    required String email,
    String? userId,
  });

  Future<String?> readAccessToken();

  Future<String?> readUserEmail();

  Future<String?> readUserId();

  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> clear() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.userEmail);
    await _storage.delete(key: StorageKeys.userId);
  }

  @override
  Future<String?> readAccessToken() {
    return _storage.read(key: StorageKeys.accessToken);
  }

  @override
  Future<String?> readUserEmail() {
    return _storage.read(key: StorageKeys.userEmail);
  }

  @override
  Future<String?> readUserId() {
    return _storage.read(key: StorageKeys.userId);
  }

  @override
  Future<void> saveSession({
    required String accessToken,
    required String email,
    String? userId,
  }) async {
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.userEmail, value: email);
    final normalizedUserId = userId?.trim();
    if (normalizedUserId == null || normalizedUserId.isEmpty) {
      await _storage.delete(key: StorageKeys.userId);
      return;
    }

    await _storage.write(key: StorageKeys.userId, value: normalizedUserId);
  }
}
