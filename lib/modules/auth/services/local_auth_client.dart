import 'package:bcrypt/bcrypt.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../core/sqlite/sqlite_client.dart';
import '../dto/profile/profile_dto.dart';
import 'models/error_dictionary.dart';

class LocalAuthClient {
  LocalAuthClient({required this.sqliteClient});

  final SqliteClient sqliteClient;

  /// Logs in a user with the given [email] and [password].
  ///
  /// - Returns a [Result] containing the [ProfileDto] on success;
  /// - Returns [ErrorDictionary.userNotFound] if the user does not exist;
  /// - Returns [ErrorDictionary.incorrectPassword] if the password is incorrect.
  /// - Returns general error message on other failures.
  Future<Result<ProfileDto, String>> login(
    String email,
    String password,
  ) async {
    try {
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // Simulate network delay

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

      return Success(ProfileDto.fromJson(user));
    } catch (e) {
      return Error('Failed to login: $e');
    }
  }

  /// Registers a user with the given [name], [email] and [password].
  Future<Result<ProfileDto, String>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // Simulate network delay
      final passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

      final userId = await sqliteClient.database.insert('users', {
        'name': name,
        'email': email,
        'password_hash': passwordHash,
      }, conflictAlgorithm: ConflictAlgorithm.fail);

      if (userId == 0) {
        return Error(ErrorDictionary.emailInUse);
      }

      final List<Map<String, dynamic>> results = await sqliteClient.database
          .query('users', where: 'id = ?', whereArgs: [userId]);

      final user = results.first;

      return Success(ProfileDto.fromJson(user));
    } catch (e) {
      return Error('Failed to register user: $e');
    }
  }

  /// Logs out the user.
  ///
  /// Does not handle errors.
  Future<void> logout() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    // No-op: No tokens to delete anymore
  }
}
