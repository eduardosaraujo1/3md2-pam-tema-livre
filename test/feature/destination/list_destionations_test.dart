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
  });

  group('List Destinations', () {
    setUp(() {
      viewModel = DestinationListViewModel(
        favoritesOnly: false,
        destinationModule: destinationModule,
      );
    });
    test('should list all destinations successfully', () async {
      // Arrange: authenticate user
      await _authenticateTestUser();

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
    });

    test(
      'should fail to list destinations when no user is authenticated',
      () async {
        // Skip authentication
        // Act
        viewModel.loadDestinationsCommand.execute();

        // Wait for the command to complete
        await Future.delayed(Duration(milliseconds: 1000));

        // Assert
        expect(viewModel.loadDestinationsCommand.value, isNotNull);
        expect(viewModel.loadDestinationsCommand.value!.isError(), true);

        final errorMessage = viewModel.loadDestinationsCommand.value!
            .tryGetError()!;
        expect(errorMessage, isNotEmpty);
      },
    );
  });

  group('Favorite Destinations List', () {
    setUp(() {
      viewModel = DestinationListViewModel(
        favoritesOnly: true,
        destinationModule: destinationModule,
      );
    });
    test('should list all destinations successfully', () async {
      // Arrange: authenticate user
      await _authenticateTestUser();

      // Arrange: mark some destinations as favorite
      viewModel.markFavorite(1, true);
      viewModel.markFavorite(3, true);

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
      for (var destination in destinations) {
        expect(destination.isFavorite, true);
      }
    });

    test(
      'should fail to list destinations when no user is authenticated',
      () async {
        // Skip authentication
        // Act
        viewModel.loadDestinationsCommand.execute();

        // Wait for the command to complete
        await Future.delayed(Duration(milliseconds: 1000));

        // Assert
        expect(viewModel.loadDestinationsCommand.value, isNotNull);
        expect(viewModel.loadDestinationsCommand.value!.isError(), true);

        final errorMessage = viewModel.loadDestinationsCommand.value!
            .tryGetError()!;
        expect(errorMessage, isNotEmpty);
      },
    );

    test(
      'should fail to list destinations when no user is authenticated',
      () async {
        // Skip authentication
        // Act
        viewModel.loadDestinationsCommand.execute();

        // Wait for the command to complete
        await Future.delayed(Duration(milliseconds: 1000));

        // Assert
        expect(viewModel.loadDestinationsCommand.value, isNotNull);
        expect(viewModel.loadDestinationsCommand.value!.isError(), true);

        final errorMessage = viewModel.loadDestinationsCommand.value!
            .tryGetError()!;
        expect(errorMessage, isNotEmpty);
      },
    );
  });
}

Future<void> _authenticateTestUser() async {
  final authModule = _getIt<AuthModule>();

  const testName = 'Test User';
  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  await authModule.register(testName, testEmail, testPassword);
}
