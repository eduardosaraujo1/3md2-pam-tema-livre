import 'package:flutter/foundation.dart';
import 'package:multiple_result/multiple_result.dart';

import 'auth_module.dart';
import 'dto/profile/profile_dto.dart';
import 'services/local_auth_client.dart';
import 'services/models/error_dictionary.dart';
import 'services/token_store.dart';

class AuthModuleImpl implements AuthModule {
  const AuthModuleImpl({required this.apiClient, required this.tokenStore});

  final LocalAuthClient apiClient;
  final TokenStore tokenStore;

  @override
  ValueNotifier<String?> get tokenNotifier => tokenStore.tokenNotifier;

  @override
  Future<void> initialize() async {
    tokenNotifier.value = await tokenStore.getToken();
  }

  @override
  Future<Result<ProfileDto?, Exception>> getProfile() async {
    try {
      final token = await tokenStore.getToken();

      if (token == null) {
        return Success(null);
      }

      final (:error, :success) = (await apiClient.getProfile(token)).getBoth();

      if (error != null) {
        return Error(Exception('Failed to get profile: $error'));
      }

      return Success(success);
    } catch (e) {
      return Error(Exception('Failed to get profile: $e'));
    }
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
        await tokenStore.saveToken(success.token);

        return Success(success.user);
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
      final token = await tokenStore.getToken();

      if (token != null) {
        await apiClient.logout(token);
        await tokenStore.deleteToken();
      }

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
        await tokenStore.saveToken(success.token);

        return Success(success.user);
      }

      return Error(Exception('Failed to register: $error'));
    } catch (e) {
      return Error(Exception('Failed to register: $e'));
    }
  }
}
