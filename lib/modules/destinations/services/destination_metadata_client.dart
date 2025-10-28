import 'package:multiple_result/multiple_result.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../core/sqlite/sqlite_client.dart';
import '../dto/destination_metadata.dart';

class DestinationMetadataClient {
  DestinationMetadataClient({
    required SqliteClient sqliteClient,
    required int? Function() getCurrentUserId,
  }) : _sqliteClient = sqliteClient,
       _getCurrentUserId = getCurrentUserId;

  final SqliteClient _sqliteClient;

  /// Callback to get the current logged-in user's ID
  final int? Function() _getCurrentUserId;

  /// Read current user's destination metadata of [destinationId]
  ///
  /// May return null if no metadata exists
  Future<Result<DestinationMetadata?, String>> readDestinationMetadata(
    int destinationId,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) return Error("No user logged in");

      final List<Map<String, Object?>> results = await _sqliteClient.database
          .query(
            'destination_metadata',
            where: 'destination_id = ? AND user_id = ?',
            whereArgs: [destinationId, userId],
          );

      if (results.isEmpty) {
        return Success(null);
      }

      final row = results.first;

      // Throws if data is malformed, falling back to catch block
      return Success(DestinationMetadata.fromJson(row));
    } catch (e) {
      return Error(e.toString());
    }
  }

  /// Write [destinationId] destination observation for current user
  ///
  /// Will override existing observation if it exists
  Future<Result<void, String>> writeDestinationObservation(
    int destinationId,
    String observation,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) return Error("No user logged in");

      await _sqliteClient.database.insert('destination_metadata', {
        'destination_id': destinationId,
        'user_id': userId,
        'observation': observation,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return Success(null);
    } catch (e) {
      return Error(e.toString());
    }
  }

  /// Marks [destinationId] as favorite for current user
  Future<Result<void, String>> markAsFavorite(int destinationId) async {
    return _setFavoriteStatus(destinationId, true);
  }

  /// Unmarks [destinationId] as favorite for current user
  Future<Result<void, String>> unmarkAsFavorite(int destinationId) async {
    return _setFavoriteStatus(destinationId, false);
  }

  Future<Result<void, String>> _setFavoriteStatus(
    int destinationId,
    bool isFavorite,
  ) async {
    try {
      final userId = _getCurrentUserId();
      if (userId == null) return Error("No user logged in");

      await _sqliteClient.database.insert('destination_metadata', {
        'destination_id': destinationId,
        'user_id': userId,
        'is_favorite': isFavorite ? 1 : 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return Success(null);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
