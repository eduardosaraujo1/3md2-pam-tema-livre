import 'package:multiple_result/multiple_result.dart';

import 'destination_module.dart';
import 'dto/destination_dto.dart';
import 'services/models/destination_meta/destination_meta.dart';
import 'services/destination_api_client.dart';
import 'services/destination_metadata_client.dart';

class DestinationModuleImpl implements DestinationModule {
  DestinationModuleImpl({
    required DestinationMetadataClient metadataClient,
    required DestinationApiClient apiClient,
    required int? Function() userIdProvider,
  }) : _metadataClient = metadataClient,
       _apiClient = apiClient,
       _userIdProvider = userIdProvider;

  final DestinationMetadataClient _metadataClient;
  final DestinationApiClient _apiClient;
  final int? Function() _userIdProvider;

  int? get _userId => _userIdProvider();
  bool get _isAuthenticated => _userId != null;

  @override
  Future<Result<List<DestinationDto>, Exception>> listDestinations() async {
    try {
      if (!_isAuthenticated) {
        return Error(Exception('User not authenticated'));
      }

      final (success: destinations, error: apiError) =
          (await _apiClient.listDestinations()).getBoth();

      final (
        success: userDestinations,
        error: metadataError,
      ) = (await _metadataClient.listAllDestinationMetadata(
        _userId!,
      )).getBoth();

      if (apiError != null) {
        return Error(apiError);
      }
      if (metadataError != null) {
        return Error(Exception(metadataError));
      }

      final dtos = destinations!.map((destination) {
        final destinationUser =
            userDestinations![destination.id] ??
            DestinationMeta(
              userId: _userId!,
              destinationId: destination.id,
              isFavorite: false,
              observation: null,
            );
        return DestinationDto.fromParts(destination, destinationUser);
      }).toList();

      return Success(dtos);
    } catch (e) {
      return Error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void, Exception>> markAsFavorite(int destinationId) async {
    if (!_isAuthenticated) {
      return Error(Exception('User not authenticated'));
    }
    final result = await _metadataClient.markAsFavorite(
      _userId!,
      destinationId,
    );

    return result.when(
      (success) => Success(null),
      (error) => Error(Exception(error)),
    );
  }

  @override
  Future<Result<DestinationDto, Exception>> getDestination(
    int destinationId,
  ) async {
    if (!_isAuthenticated) {
      return Error(Exception('User not authenticated'));
    }

    final (success: destination, error: destinationError) =
        (await _apiClient.getDestination(destinationId)).getBoth();

    if (destinationError != null) {
      return Error(Exception(destinationError));
    }

    final (
      success: metadata,
      error: metaError,
    ) = (await _metadataClient.readDestinationMetadata(
      _userId!,
      destinationId,
    )).getBoth();

    if (metaError != null) {
      return Error(Exception(metaError));
    }

    if (metadata == null) {
      var emptyMetadata = DestinationMeta(
        userId: _userId!,
        destinationId: destinationId,
        isFavorite: false,
        observation: null,
      );
      return Success(DestinationDto.fromParts(destination!, emptyMetadata));
    }

    return Success(DestinationDto.fromParts(destination!, metadata));
  }

  @override
  Future<Result<void, Exception>> unmarkAsFavorite(int destinationId) async {
    if (!_isAuthenticated) {
      return Error(Exception('User not authenticated'));
    }

    final result = await _metadataClient.unmarkAsFavorite(
      _userId!,
      destinationId,
    );

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
    if (!_isAuthenticated) {
      return Error(Exception('User not authenticated'));
    }

    final result = await _metadataClient.writeDestinationObservation(
      _userId!,
      destinationId,
      observation,
    );

    return result.when(
      (success) => Success(null),
      (error) => Error(Exception(error)),
    );
  }
}
