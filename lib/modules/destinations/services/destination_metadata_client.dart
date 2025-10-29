import 'package:multiple_result/multiple_result.dart';

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
      // Use INSERT OR IGNORE to create the row if it doesn't exist,
      // then UPDATE to set only the observation field
      await _sqliteClient.database.rawInsert(
        '''
        INSERT INTO destination_metadata (user_id, destination_id, observation, is_favorite)
        VALUES (?, ?, ?, 0)
        ON CONFLICT(user_id, destination_id)
        DO UPDATE SET observation = ?
      ''',
        [userId, destinationId, observation, observation],
      );

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
      // Use INSERT OR IGNORE to create the row if it doesn't exist,
      // then UPDATE to set only the is_favorite field
      await _sqliteClient.database.rawInsert(
        '''
        INSERT INTO destination_metadata (user_id, destination_id, observation, is_favorite)
        VALUES (?, ?, NULL, ?)
        ON CONFLICT(user_id, destination_id)
        DO UPDATE SET is_favorite = ?
      ''',
        [userId, destinationId, isFavorite ? 1 : 0, isFavorite ? 1 : 0],
      );

      return Success(null);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
