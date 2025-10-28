import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_livre_pam/modules/destinations/destination_module.dart';
import 'package:projeto_livre_pam/modules/destinations/destination_module_impl.dart';
import 'package:projeto_livre_pam/modules/destinations/dto/destination_dto.dart';
import 'package:projeto_livre_pam/modules/destinations/services/destination_api_client.dart';
import 'package:projeto_livre_pam/modules/destinations/services/destination_metadata_client.dart';

import '../../../testing/fakes/sqlite.dart' as sqlite;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DestinationApiClient apiClient;
  late DestinationMetadataClient metadataClient;
  late DestinationModule destinationModule;

  int? currentUser;

  late final String createDbScript;

  setUpAll(() async {
    createDbScript = await sqlite.dbScript;
  });

  setUp(() async {
    final sqliteClient = sqlite.inMemoryClient(createDbScript);
    await sqliteClient.open();

    apiClient = DestinationApiClient();
    metadataClient = DestinationMetadataClient(
      getCurrentUserId: () => currentUser,
      sqliteClient: sqliteClient,
    );
    destinationModule = DestinationModuleImpl(
      apiClient: apiClient,
      metadataClient: metadataClient,
    );
  });

  /**
   * Requirements:
   *
   * 1. listDestinations():
   *    - Should fetch all destinations from the API client
   *    - Should return Success with list of destinations on success
   *    - Should return Error with exception on failure
   *    - Should work for both authenticated and unauthenticated users
   *
   * 2. writeDestinationObservation():
   *    - Should write an observation for a destination when user is authenticated
   *    - Should delegate to metadata client with destinationId and observation text
   *    - Should return Success on successful write
   *    - Should return Error with Exception(unauthorized) when user is not authenticated
   *    - Should return Error with Exception when database operation fails
   *
   * 3. markAsFavorite():
   *    - Should mark a destination as favorite when user is authenticated
   *    - Should delegate to metadata client with destinationId
   *    - Should return Success on successful marking
   *    - Should return Error with Exception(unauthorized) when user is not authenticated
   *    - Should return Error with Exception when database operation fails
   *
   * 4. unmarkAsFavorite():
   *    - Should unmark a destination as favorite when user is authenticated
   *    - Should delegate to metadata client with destinationId
   *    - Should return Success on successful unmarking
   *    - Should return Error with Exception(unauthorized) when user is not authenticated
   *    - Should return Error with Exception when database operation fails
   *
   * 5. readDestinationMetadata():
   *    - Should read metadata for a destination when user is authenticated
   *    - Should delegate to metadata client with destinationId
   *    - Should return Success with DestinationMetadata on success
   *    - Should return Error with Exception(unauthorized) when user is not authenticated
   *    - Should return Error with Exception when database operation fails
   *    - Should handle null metadata (no metadata exists for destination)
   */

  group("Authenticated user", () {
    setUp(() {
      currentUser = 1; // Simulate an authenticated user
    });

    test(
      'listDestinations should return list of destinations from API',
      () async {
        // Act
        final result = await destinationModule.listDestinations();

        // Assert
        expect(result.isSuccess(), true);
        result.when((destinations) {
          expect(destinations, isA<List<DestinationDto>>());
          expect(destinations.isNotEmpty, true);
        }, (error) => fail('Should not return error'));
      },
    );

    test(
      'writeDestinationObservation should write observation successfully',
      () async {
        // Arrange
        const destinationId = 1;
        const observation = 'This is a test observation';

        // Act
        final result = await destinationModule.writeDestinationObservation(
          destinationId,
          observation,
        );

        // Assert
        expect(result.isSuccess(), true);
      },
    );

    test(
      'markAsFavorite should mark destination as favorite successfully',
      () async {
        // Arrange
        const destinationId = 2;

        // Act
        final result = await destinationModule.markAsFavorite(destinationId);

        // Assert
        expect(result.isSuccess(), true);
      },
    );

    test(
      'unmarkAsFavorite should unmark destination as favorite successfully',
      () async {
        // Arrange
        const destinationId = 3;

        // First mark as favorite
        await destinationModule.markAsFavorite(destinationId);

        // Act
        final result = await destinationModule.unmarkAsFavorite(destinationId);

        // Assert
        expect(result.isSuccess(), true);
      },
    );

    test(
      'readDestinationMetadata should return metadata after writing observation',
      () async {
        // Arrange
        const destinationId = 4;
        const observation = 'Test observation';
        await destinationModule.writeDestinationObservation(
          destinationId,
          observation,
        );

        // Act
        final result = await destinationModule.readDestinationMetadata(
          destinationId,
        );

        // Assert
        expect(result.isSuccess(), true);
        result.when((metadata) {
          expect(metadata.destinationId, destinationId);
          expect(metadata.userId, currentUser);
          expect(metadata.observation, observation);
        }, (error) => fail('Should not return error'));
      },
    );

    test(
      'readDestinationMetadata should return metadata after marking as favorite',
      () async {
        // Arrange
        const destinationId = 5;
        await destinationModule.markAsFavorite(destinationId);

        // Act
        final result = await destinationModule.readDestinationMetadata(
          destinationId,
        );

        // Assert
        expect(result.isSuccess(), true);
        result.when((metadata) {
          expect(metadata.destinationId, destinationId);
          expect(metadata.userId, currentUser);
          expect(metadata.isFavorite, true);
        }, (error) => fail('Should not return error'));
      },
    );

    test(
      'readDestinationMetadata should handle when no metadata exists',
      () async {
        // Arrange
        const destinationId = 999; // Non-existent metadata

        // Act
        final result = await destinationModule.readDestinationMetadata(
          destinationId,
        );

        // Assert
        // When no metadata exists, we expect an error since nothing was written yet
        expect(result.isError(), true);
      },
    );
  });

  group("Unauthenticated user", () {
    setUp(() {
      currentUser = null; // Simulate an unauthenticated user
    });

    test('listDestinations should work for unauthenticated users', () async {
      // Act
      final result = await destinationModule.listDestinations();

      // Assert
      expect(result.isSuccess(), true);
      result.when((destinations) {
        expect(destinations, isA<List<DestinationDto>>());
        expect(destinations.isNotEmpty, true);
      }, (error) => fail('Should not return error'));
    });

    test(
      'writeDestinationObservation should return unauthorized error',
      () async {
        // Arrange
        const destinationId = 1;
        const observation = 'This should fail';

        // Act
        final (
          :success,
          :error,
        ) = (await destinationModule.writeDestinationObservation(
          destinationId,
          observation,
        )).getBoth();

        // Assert
        expect(error, isNotNull);
      },
    );

    test('markAsFavorite should return unauthorized error', () async {
      // Arrange
      const destinationId = 1;

      // Act
      final result = await destinationModule.markAsFavorite(destinationId);

      // Assert
      expect(result.tryGetError(), isNotNull);
      expect(result.isError(), true);
    });

    test('unmarkAsFavorite should return unauthorized error', () async {
      // Arrange
      const destinationId = 1;

      // Act
      final result = await destinationModule.unmarkAsFavorite(destinationId);

      // Assert
      expect(result.tryGetError(), isNotNull);
      expect(result.isError(), true);
    });

    test('readDestinationMetadata should return unauthorized error', () async {
      // Arrange
      const destinationId = 1;

      // Act
      final result = await destinationModule.readDestinationMetadata(
        destinationId,
      );

      // Assert
      expect(result.tryGetError(), isNotNull);
      expect(result.isError(), true);
    });
  });
}
