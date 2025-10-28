import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_livre_pam/modules/destinations/services/destination_metadata_client.dart';

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
        getCurrentUserId: () => userId,
      );
    });

    test("It reads and writes observations to database", () async {
      // Act
      final result = await observationClient.writeDestinationObservation(
        4,
        "Test Observation",
      );
      final (:success, :error) = result.getBoth();

      // Assert  write worked
      expect(error, isNull);

      // Act read back
      final readResult = await observationClient.readDestinationMetadata(4);
      final (success: readSuccess, error: readError) = readResult.getBoth();

      expect(readError, isNull);
      expect(readSuccess, isNotNull);
    });

    test("marks and unmarks destinations as favorite", () async {
      // Act - mark as favorite
      final markResult = await observationClient.markAsFavorite(5);
      final (success: markSuccess, error: markError) = markResult.getBoth();

      // Assert mark worked
      expect(markError, isNull);

      // Act - read back favorite status
      final documentMetadata = await observationClient.readDestinationMetadata(
        5,
      );
      final (success: readSuccess, error: readError) = documentMetadata
          .getBoth();

      expect(readError, isNull);
      expect(readSuccess, isNotNull);
      expect(readSuccess!.isFavorite, isTrue);

      // Act - unmark as favorite
      final unmarkResult = await observationClient.unmarkAsFavorite(5);
      final (success: unmarkSuccess, error: unmarkError) = unmarkResult
          .getBoth();

      // Assert unmark worked
      expect(unmarkError, isNull);

      // Act - read back favorite status
      final isNotFavoriteResult = await observationClient
          .readDestinationMetadata(5);
      final (success: read2Success, error: read2Error) = isNotFavoriteResult
          .getBoth();

      expect(read2Error, isNull);
      expect(read2Success, isNotNull);
      expect(read2Success!.isFavorite, isFalse);
    });
  });

  group("unauthorized user", () {
    setUp(() async {
      var inMemoryClient = sqlite.inMemoryClient(dbScript);
      await inMemoryClient.open();
      observationClient = DestinationMetadataClient(
        sqliteClient: inMemoryClient,
        getCurrentUserId: () => null,
      );
    });

    test("it does not write on unauthorized user", () async {
      // Act
      final result = await observationClient.writeDestinationObservation(
        4,
        "Test Observation",
      );
      final (:success, :error) = result.getBoth();

      // Assert write failed
      expect(error, isNotNull);

      // Act read fails as well
      final readResult = await observationClient.readDestinationMetadata(4);
      final (success: readSuccess, error: readError) = readResult.getBoth();

      expect(readError, isNotNull);
    });
    test("returns error trying to mark or unmark as favorite", () async {
      // Act - mark as favorite
      final markResult = await observationClient.markAsFavorite(5);
      final (success: markSuccess, error: markError) = markResult.getBoth();

      // Assert mark failed worked
      expect(markError, isNotNull);

      // Act - unmark as favorite
      final unmarkResult = await observationClient.unmarkAsFavorite(5);
      final (success: unmarkSuccess, error: unmarkError) = unmarkResult
          .getBoth();

      // Assert unmark worked
      expect(unmarkError, isNotNull);
    });
  });
}
