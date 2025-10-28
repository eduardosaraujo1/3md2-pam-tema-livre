import 'package:flutter/src/foundation/basic_types.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FakeFlutterSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _storage = <String, String>{};

  @override
  AndroidOptions get aOptions => AndroidOptions();

  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage.containsKey(key);
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.clear();
  }

  @override
  IOSOptions get iOptions => IOSOptions();

  @override
  Future<bool?> isCupertinoProtectedDataAvailable() async {
    return true;
  }

  @override
  LinuxOptions get lOptions => LinuxOptions();

  @override
  MacOsOptions get mOptions => MacOsOptions();

  @override
  Stream<bool>? get onCupertinoProtectedDataAvailabilityChanged => null;

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return Map<String, String>.from(_storage);
  }

  @override
  void registerListener({
    required String key,
    required ValueChanged<String?> listener,
  }) {
    // No-op for fake implementation
  }

  @override
  void unregisterAllListeners() {
    // No-op for fake implementation
  }

  @override
  void unregisterAllListenersForKey({required String key}) {
    // No-op for fake implementation
  }

  @override
  void unregisterListener({
    required String key,
    required ValueChanged<String?> listener,
  }) {
    // No-op for fake implementation
  }

  @override
  WindowsOptions get wOptions => WindowsOptions();

  @override
  WebOptions get webOptions => WebOptions();

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _storage.remove(key);
    } else {
      _storage[key] = value;
    }
  }
}
