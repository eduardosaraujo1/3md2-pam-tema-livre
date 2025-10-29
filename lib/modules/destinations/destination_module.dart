import 'package:multiple_result/multiple_result.dart';

import 'dto/destination_dto.dart';
import 'services/models/destination_meta/destination_meta.dart';

abstract class DestinationModule {
  /// Lists all destinations available
  /// Returns a list of [DestinationDto] on success
  Future<Result<List<DestinationDto>, Exception>> listDestinations();

  /// Writes an observation for a given destination
  /// - [destinationId]: The ID of the destination
  /// - [observation]: The observation text
  ///
  /// Returns [Success] or [Error]
  Future<Result<void, Exception>> writeDestinationObservation(
    int destinationId,
    String observation,
  );

  /// Marks a destination as favorite
  /// - [destinationId]: The ID of the destination
  ///
  /// Returns [Success] or [Error]
  Future<Result<void, Exception>> markAsFavorite(int destinationId);

  /// Unmarks a destination as favorite
  /// - [destinationId]: The ID of the destination
  ///
  /// Returns [Success] or [Error]
  Future<Result<void, Exception>> unmarkAsFavorite(int destinationId);

  /// Reads metadata for a given destination
  /// - [destinationId]: The ID of the destination
  ///
  /// Returns [Success] with the [DestinationMeta] or [Error]
  Future<Result<DestinationDto, Exception>> getDestination(int destinationId);
}
