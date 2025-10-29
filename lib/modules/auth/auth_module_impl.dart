import 'package:flutter/foundation.dart';
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

  /// Gets the current user ID from the profile.
  ///
  /// Returns null if no user is logged in.
  int? getUserId() {
    return _profileNotifier.value?.id;
  }

  @override
  Future<void> initialize() async {
    // No initialization needed - profile is managed in memory
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
