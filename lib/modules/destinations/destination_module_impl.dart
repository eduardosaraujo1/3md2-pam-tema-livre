import 'package:multiple_result/multiple_result.dart';

import 'destination_module.dart';
import 'dto/destination_dto.dart';
import 'dto/destination_metadata.dart';
import 'services/destination_api_client.dart';
import 'services/destination_metadata_client.dart';

class DestinationModuleImpl implements DestinationModule {
  DestinationModuleImpl({
    required DestinationMetadataClient metadataClient,
    required DestinationApiClient apiClient,
  }) : _metadataClient = metadataClient,
       _apiClient = apiClient;

  final DestinationMetadataClient _metadataClient;
  final DestinationApiClient _apiClient;

  @override
  Future<Result<List<DestinationDto>, Exception>> listDestinations() async {
    return await _apiClient.listDestinations();
  }

  @override
  Future<Result<void, Exception>> markAsFavorite(int destinationId) async {
    final result = await _metadataClient.markAsFavorite(destinationId);

    return result.when(
      (success) => Success(null),
      (error) => Error(Exception(error)),
    );
  }

  @override
  Future<Result<DestinationMetadata, Exception>> readDestinationMetadata(
    int destinationId,
  ) async {
    final result = await _metadataClient.readDestinationMetadata(destinationId);

    return result.when((metadata) {
      // If no metadata exists, return error since we need authentication
      if (metadata == null) {
        return Error(Exception('No metadata found for destination'));
      }
      return Success(metadata);
    }, (error) => Error(Exception(error)));
  }

  @override
  Future<Result<void, Exception>> unmarkAsFavorite(int destinationId) async {
    final result = await _metadataClient.unmarkAsFavorite(destinationId);

    return result.when(
      (success) => Success(null),
      (error) => Error(Exception(error)),
    );
  }

  @override
  Future<Result<void, Exception>> writeDestinationObservation(
    int destinationId,
    String observation,
  ) async {
    final result = await _metadataClient.writeDestinationObservation(
      destinationId,
      observation,
    );

    return result.when(
      (success) => Success(null),
      (error) => Error(Exception(error)),
    );
  }
}
