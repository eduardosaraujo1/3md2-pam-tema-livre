import 'package:multiple_result/multiple_result.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../core/sqlite/sqlite_client.dart';
import 'models/destination_meta/destination_meta.dart';

class DestinationMetadataClient {
  DestinationMetadataClient({required SqliteClient sqliteClient})
    : _sqliteClient = sqliteClient;

  final SqliteClient _sqliteClient;

  /// Read all destination metadata for the current user
  /// Returns a map of destinationId -> DestinationUser for O(1) access
  Future<Result<Map<int, DestinationMeta>, String>> listAllDestinationMetadata(
    int userId,
  ) async {
    try {
      final List<Map<String, Object?>> results = await _sqliteClient.database
          .query(
            'destination_metadata',
            where: 'user_id = ?',
            whereArgs: [userId],
          );

      final Map<int, DestinationMeta> metadataMap = {};
      for (final row in results) {
        final destinationUser = DestinationMeta.fromJson(row);
        metadataMap[destinationUser.destinationId] = destinationUser;
      }

      return Success(metadataMap);
    } catch (e) {
      return Error(e.toString());
    }
  }

  /// Read current user's destination metadata of [destinationId]
  ///
  /// May return null if no metadata exists
  Future<Result<DestinationMeta?, String>> readDestinationMetadata(
    int userId,
    int destinationId,
  ) async {
    try {
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
      return Success(DestinationMeta.fromJson(row));
    } catch (e) {
      return Error(e.toString());
    }
  }

  /// Write [destinationId] destination observation for current user
  ///
  /// Will override existing observation if it exists
  Future<Result<void, String>> writeDestinationObservation(
    int userId,
    int destinationId,
    String observation,
  ) async {
    try {
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
  Future<Result<void, String>> markAsFavorite(
    int userId,
    int destinationId,
  ) async {
    return _setFavoriteStatus(userId, destinationId, true);
  }

  /// Unmarks [destinationId] as favorite for current user
  Future<Result<void, String>> unmarkAsFavorite(
    int userId,
    int destinationId,
  ) async {
    return _setFavoriteStatus(userId, destinationId, false);
  }

  Future<Result<void, String>> _setFavoriteStatus(
    int userId,
    int destinationId,
    bool isFavorite,
  ) async {
    try {
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
