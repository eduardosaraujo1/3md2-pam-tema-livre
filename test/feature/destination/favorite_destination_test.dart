import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module.dart';
import 'package:hot_tourist_destinations/modules/destinations/destination_module.dart';
import 'package:hot_tourist_destinations/ui/destinations/view_models/destination_list_view_model.dart';

import '../../../testing/dependencies.dart';

final _getIt = GetIt.I;

void main() {
  /**Requirements:
   * It lists all documents from destination module
   * It fails when no user is authenticated
   */

  late DestinationModule destinationModule;
  late DestinationListViewModel viewModel;

  setUp(() async {
    await setupDependencies();

    destinationModule = _getIt();
    viewModel = DestinationListViewModel(
      favoritesOnly: true,
      destinationModule: destinationModule,
    );
  });

  group('Favorite Destinations List', () {
    test('marks destinations as favorite', () async {
      // Arrange: authenticate user
      await _authenticateTestUser();

      // Arrange: mark some destinations as favorite
      await viewModel.markFavorite(1, true);

      // Act
      viewModel.loadDestinationsCommand.execute();

      // Wait for the command to complete
      await Future.delayed(Duration(milliseconds: 1000));

      // Assert
      expect(viewModel.loadDestinationsCommand.value, isNotNull);
      expect(viewModel.loadDestinationsCommand.value!.isSuccess(), true);

      final destinations = viewModel.loadDestinationsCommand.value!
          .tryGetSuccess()!;
      expect(destinations, isNotEmpty);
      expect(destinations.first.id, equals(1));
    });

    test('unmarks destinations as favorite', () async {
      // Arrange: authenticate user
      await _authenticateTestUser();

      // Arrange: mark some destinations as favorite
      await viewModel.markFavorite(1, true);
      await viewModel.markFavorite(3, true);
      await viewModel.markFavorite(1, false);

      // Act
      viewModel.loadDestinationsCommand.execute();

      // Wait for the command to complete
      await Future.delayed(Duration(milliseconds: 1000));

      // Assert
      expect(viewModel.loadDestinationsCommand.value, isNotNull);
      expect(viewModel.loadDestinationsCommand.value!.isSuccess(), true);

      final destinations = viewModel.loadDestinationsCommand.value!
          .tryGetSuccess()!;
      expect(destinations, isNotEmpty);
      expect(destinations.first.id, equals(3));
    });
  });
}

Future<void> _authenticateTestUser() async {
  final authModule = _getIt<AuthModule>();

  const testName = 'Test User';
  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  await authModule.register(testName, testEmail, testPassword);
}
