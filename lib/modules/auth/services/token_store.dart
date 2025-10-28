import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStore {
  static const String key = 'auth_token';

  final FlutterSecureStorage _secureStorage;

  TokenStore({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  final ValueNotifier<String?> tokenNotifier = ValueNotifier<String?>(null);

  /// Saves the given [token] in FlutterSecureStorage.
  ///
  /// Caches result for faster future access
  Future<void> saveToken(String token) async {
    tokenNotifier.value = token;
    await _secureStorage.write(key: key, value: token);
  }

  /// Gets the stored token in FlutterSecureStorage.
  ///
  /// Caches result for faster future access
  Future<String?> getToken() async {
    tokenNotifier.value ??= await _secureStorage.read(key: key);
    return tokenNotifier.value;
  }

  /// Synchronous version of [getToken].
  ///
  /// Does not perform any I/O operations. Uses in-memory cache entry.
  String? getTokenSync() {
    return tokenNotifier.value;
  }

  /// Deletes the stored token in FlutterSecureStorage.
  Future<void> deleteToken() async {
    tokenNotifier.value = null;
    await _secureStorage.delete(key: key);
  }
}
