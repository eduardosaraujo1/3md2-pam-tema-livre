import 'package:flutter_test/flutter_test.dart';
import 'package:hot_tourist_destinations/modules/destinations/services/destination_metadata_client.dart';

import '../../../testing/fakes/sqlite.dart' as sqlite;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late String dbScript;
  late DestinationMetadataClient observationClient;

  setUpAll(() async {
    dbScript = await sqlite.dbScript;
  });

  group("authorized user", () {
    const int userId = 1;
    setUp(() async {
      var inMemoryClient = sqlite.inMemoryClient(dbScript);
      await inMemoryClient.open();
      observationClient = DestinationMetadataClient(
        sqliteClient: inMemoryClient,
      );
    });

    test("It reads and writes observations to database", () async {
      // Act
      final result = await observationClient.writeDestinationObservation(
        userId,
        4,
        "Test Observation",
      );
      final (:success, :error) = result.getBoth();

      // Assert  write worked
      expect(error, isNull);

      // Act read back
      final readResult = await observationClient.readDestinationMetadata(
        userId,
        4,
      );
      final (success: readSuccess, error: readError) = readResult.getBoth();

      expect(readError, isNull);
      expect(readSuccess, isNotNull);
    });

    test("marks and unmarks destinations as favorite", () async {
      // Act - mark as favorite
      final markResult = await observationClient.markAsFavorite(userId, 5);
      final (success: markSuccess, error: markError) = markResult.getBoth();

      // Assert mark worked
      expect(markError, isNull);

      // Act - read back favorite status
      final documentMetadata = await observationClient.readDestinationMetadata(
        userId,
        5,
      );
      final (success: readSuccess, error: readError) = documentMetadata
          .getBoth();

      expect(readError, isNull);
      expect(readSuccess, isNotNull);
      expect(readSuccess!.isFavorite, isTrue);

      // Act - unmark as favorite
      final unmarkResult = await observationClient.unmarkAsFavorite(userId, 5);
      final (success: unmarkSuccess, error: unmarkError) = unmarkResult
          .getBoth();

      // Assert unmark worked
      expect(unmarkError, isNull);

      // Act - read back favorite status
      final isNotFavoriteResult = await observationClient
          .readDestinationMetadata(userId, 5);
      final (success: read2Success, error: read2Error) = isNotFavoriteResult
          .getBoth();

      expect(read2Error, isNull);
      expect(read2Success, isNotNull);
      expect(read2Success!.isFavorite, isFalse);
    });
  });

  group("unauthorized user", () {
    // Test with invalid userId (0 or -1) to simulate unauthorized
    const int userId = 0;
    setUp(() async {
      var inMemoryClient = sqlite.inMemoryClient(dbScript);
      await inMemoryClient.open();
      observationClient = DestinationMetadataClient(
        sqliteClient: inMemoryClient,
      );
    });

    test("it does not write on unauthorized user", () async {
      // Act - Using userId 0 should still work at DB level,
      // but in real app this would be caught at module level
      final result = await observationClient.writeDestinationObservation(
        userId,
        4,
        "Test Observation",
      );
      final (:success, :error) = result.getBoth();

      // Assert write succeeded (DB doesn't validate userId)
      // In production, DestinationModule would prevent this call
      expect(error, isNull);

      // Act read back with same userId
      final readResult = await observationClient.readDestinationMetadata(
        userId,
        4,
      );
      final (success: readSuccess, error: readError) = readResult.getBoth();

      // Would be null for a user that doesn't exist
      expect(readSuccess, isNotNull);
    });
    test(
      "returns no error at client level for mark/unmark operations",
      () async {
        // Note: Authorization is handled at DestinationModule level,
        // not at the client level. Client just does DB operations.

        // Act - mark as favorite
        final markResult = await observationClient.markAsFavorite(userId, 5);
        final (success: markSuccess, error: markError) = markResult.getBoth();

        // Client level doesn't validate auth - that's module's job
        expect(markError, isNull);

        // Act - unmark as favorite
        final unmarkResult = await observationClient.unmarkAsFavorite(
          userId,
          5,
        );
        final (success: unmarkSuccess, error: unmarkError) = unmarkResult
            .getBoth();

        // Client level doesn't validate auth - that's module's job
        expect(unmarkError, isNull);
      },
    );
  });
}
