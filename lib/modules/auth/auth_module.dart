import 'package:flutter/foundation.dart';
import 'package:multiple_result/multiple_result.dart';

import 'dto/profile/profile_dto.dart';

abstract class AuthModule {
  /// Current authentication token.
  ///
  /// Is updated automatically on initialize, login, register, and logout.
  ///
  /// Exposes the current token value and notifies listeners on changes.
  ValueNotifier<String?> get tokenNotifier;

  /// Initializes the authentication module by reading the token stored in [TokenStore].
  Future<void> initialize();

  /// Gets the user profile currently authenticated in the system.
  ///
  /// Returns a [ProfileDto] if a user is authenticated, or null if no user is logged in.
  ///
  /// Returns an [Exception] on failure.
  Future<Result<ProfileDto?, Exception>> getProfile();

  /// Logs in a user with the given [email] and [password].
  ///
  /// Returns a [ProfileDto] on success or an [IncorrectLoginCredentialsException]
  /// on incorrect credential failure.
  ///
  /// Returns an [Exception] on other failures.
  Future<Result<ProfileDto, Exception>> login(String email, String password);

  /// Registers a user with the given [name], [email] and [password].
  ///
  /// Returns a [ProfileDto] on success or an [Exception] on failure.
  ///
  /// Returns a [EmailAlreadyInUseException] if the e-mail is already registered.
  Future<Result<ProfileDto, Exception>> register(
    String name,
    String email,
    String password,
  );

  /// Logs out the currently authenticated user.
  Future<Result<void, Exception>> logout();
}

class IncorrectLoginCredentialsException implements Exception {}

class EmailAlreadyInUseException implements Exception {}
