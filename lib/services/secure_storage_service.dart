// lib/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for sensitive data (tokens, credentials).
/// Uses platform-specific secure storage (Keychain/Keystore).
class SecureStorageService {
  static const SecureStorageService _instance = SecureStorageService._();
  factory SecureStorageService() => _instance;

  const SecureStorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const _keyAuthToken = 'auth_token';
  static const _keyUserId = 'user_id';

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  Future<String?> getAuthToken() async {
    return _storage.read(key: _keyAuthToken);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  Future<String?> getUserId() async {
    return _storage.read(key: _keyUserId);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
