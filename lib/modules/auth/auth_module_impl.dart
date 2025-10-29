import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:multiple_result/multiple_result.dart';

import 'auth_module.dart';
import 'dto/profile/profile_dto.dart';
import 'services/local_auth_client.dart';
import 'services/models/error_dictionary.dart';

class AuthModuleImpl implements AuthModule {
  AuthModuleImpl({required this.apiClient});

  final LocalAuthClient apiClient;

  final ValueNotifier<ProfileDto?> _profileNotifier = ValueNotifier(null);

  @override
  ValueNotifier<ProfileDto?> get profileNotifier => _profileNotifier;

  // Dirty but I don't care
  static const String _autoLoginKey = 'autoLoginId';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<int?> get autoLoginId async {
    final value = await _secureStorage.read(key: _autoLoginKey);

    if (value == null) return null;

    return int.tryParse(value);
  }

  /// Gets the current user ID from the profile.
  ///
  /// Returns null if no user is logged in.
  int? getUserId() {
    return _profileNotifier.value?.id;
  }

  @override
  Future<void> initialize() async {
    final userId = await autoLoginId;
    if (userId == null) return;

    final result = await apiClient.getProfile(userId);
    final (:success, :error) = result.getBoth();
    if (success != null) {
      _profileNotifier.value = success;
    }
  }

  @override
  ProfileDto? getProfile() {
    return _profileNotifier.value;
  }

  @override
  Future<Result<ProfileDto, Exception>> login(
    String email,
    String password,
  ) async {
    try {
      final (:success, :error) = (await apiClient.login(
        email,
        password,
      )).getBoth();

      if (success != null) {
        _profileNotifier.value = success;
        return Success(success);
      }

      if (error == ErrorDictionary.incorrectPassword ||
          error == ErrorDictionary.userNotFound) {
        return Error(IncorrectLoginCredentialsException());
      }

      _secureStorage.write(key: _autoLoginKey, value: success?.id.toString());

      return Error(Exception(error));
    } catch (e) {
      return Error(Exception('Login Module Error - $e'));
    }
  }

  @override
  Future<Result<void, Exception>> logout() async {
    try {
      await apiClient.logout();
      _profileNotifier.value = null;
      _secureStorage.delete(key: _autoLoginKey);

      return Success(null);
    } catch (e) {
      return Error(Exception('Failed to logout: $e'));
    }
  }

  @override
  Future<Result<ProfileDto, Exception>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final (:success, :error) = (await apiClient.register(
        name,
        email,
        password,
      )).getBoth();

      if (success != null) {
        _profileNotifier.value = success;
        return Success(success);
      }

      if (error == ErrorDictionary.emailInUse) {
        return Error(EmailAlreadyInUseException());
      }

      return Error(Exception('Failed to register: $error'));
    } catch (e) {
      return Error(Exception('Failed to register: $e'));
    }
  }
}
