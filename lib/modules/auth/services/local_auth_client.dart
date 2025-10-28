import 'package:bcrypt/bcrypt.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:projeto_livre_pam/core/sqlite/sqlite_client.dart';
import 'package:projeto_livre_pam/modules/auth/services/models/error_dictionary.dart';

import '../dto/profile/profile_dto.dart';
import 'models/login_result.dart';

class LocalAuthClient {
  LocalAuthClient({required this.sqliteClient});

  final SqliteClient sqliteClient;

  /// Logs in a user with the given [email] and [password].
  ///
  /// - Returns a [Result] containing the [LoginResult] on success;
  /// - Returns [ErrorDictionary.userNotFound] if the user does not exist;
  /// - Returns [ErrorDictionary.incorrectPassword] if the password is incorrect.
  /// - Returns general error message on other failures.
  Future<Result<LoginResult, String>> login(
    String email,
    String password,
  ) async {
    try {
      final List<Map<String, dynamic>> results = await sqliteClient.database
          .query('users', where: 'email = ?', whereArgs: [email]);

      if (results.isEmpty) {
        return Error(ErrorDictionary.userNotFound);
      }

      final user = results.first;
      final passwordHash = user['password_hash'] as String?;

      if (passwordHash == null ||
          BCrypt.checkpw(password, passwordHash) == false) {
        return Error(ErrorDictionary.incorrectPassword);
      }

      return Success(
        LoginResult(
          user: ProfileDto.fromJson(user),
          token: await _generateToken(user['id'] as int),
        ),
      );
    } catch (e) {
      return Error('Failed to login: $e');
    }
  }

  /// Registers a user with the given [name], [email] and [password].
  Future<Result<LoginResult, String>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

      final userId = await sqliteClient.database.insert('users', {
        'name': name,
        'email': email,
        'password_hash': passwordHash,
      });

      final List<Map<String, dynamic>> results = await sqliteClient.database
          .query('users', where: 'id = ?', whereArgs: [userId]);

      final user = results.first;

      return Success(
        LoginResult(
          user: ProfileDto.fromJson(user),
          token: await _generateToken(userId),
        ),
      );
    } catch (e) {
      return Error('Failed to register user: $e');
    }
  }

  /// Logs out the user associated with the given [token].
  ///
  /// Does not handle errors.
  Future<void> logout(String token) async {
    await sqliteClient.database.delete(
      'tokens',
      where: 'token = ?',
      whereArgs: [token],
    );
  }

  Future<String> _generateToken(int userId) async {
    final token = BCrypt.gensalt();

    await sqliteClient.database.insert('tokens', {
      'user_id': userId,
      'token': token,
    });

    return token;
  }

  Future<Result<ProfileDto, String>> getProfile(String token) async {
    try {
      final List<Map<String, dynamic>> tokenResults = await sqliteClient
          .database
          .query('tokens', where: 'token = ?', whereArgs: [token]);

      if (tokenResults.isEmpty) {
        return Error(ErrorDictionary.unauthenticated);
      }

      final userId = tokenResults.first['user_id'] as int;

      final List<Map<String, dynamic>> userResults = await sqliteClient.database
          .query('users', where: 'id = ?', whereArgs: [userId]);

      if (userResults.isEmpty) {
        return Error(ErrorDictionary.userNotFound);
      }

      final user = userResults.first;

      return Success(ProfileDto.fromJson(user));
    } catch (e) {
      return Error('Failed to get profile: $e');
    }
  }
}
