import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module.dart';
import 'package:hot_tourist_destinations/modules/destinations/destination_module.dart';
import 'package:hot_tourist_destinations/modules/destinations/dto/destination_dto.dart';
import 'package:hot_tourist_destinations/ui/destinations/view_models/destination_view_model.dart';

import '../../../testing/dependencies.dart';

final _getIt = GetIt.I;

void main() {
  /**Requirements:
   * It saves destination info successfully
   */

  late DestinationModule destinationModule;
  late DestinationViewModel viewModel;
  const id = 5;

  setUp(() async {
    await setupDependencies();

    destinationModule = _getIt();
    viewModel = DestinationViewModel(
      destinationModule: destinationModule,
      id: id,
    );
  });

  test("should load existing destination info successfully", () async {
    // Arrange: authenticate user
    await _authenticateTestUser();

    // Arrange: load destination info
    const mockObservation = "Beautiful place";
    destinationModule.writeDestinationObservation(id, mockObservation);

    // Act
    viewModel.loadDestinationCommand.execute();
    await Future.delayed(Duration(milliseconds: 1000));

    // Assert
    final result = viewModel.loadDestinationCommand.value;
    expect(result, isNotNull);
    expect(result!.isSuccess(), true);
    expect(result.tryGetSuccess(), isNotNull);
    expect(result.tryGetSuccess()!, isA<DestinationDto>());
    expect(result.tryGetSuccess()!.id, id);
    expect(result.tryGetSuccess()!.userNotes, mockObservation);
  });

  test("should override existing destination info successfully", () async {
    const oldMockObservation = "Beautiful place";
    const newMockObservation = "I liked it a lot";

    // Arrange: authenticate user
    await _authenticateTestUser();

    // Arrange: load destination info
    destinationModule.writeDestinationObservation(id, oldMockObservation);
    viewModel.loadDestinationCommand.execute();
    await Future.delayed(Duration(milliseconds: 1000));

    // Act: override destination info
    viewModel.saveDestinationInfoCommand.execute(newMockObservation);

    // Assert
    final result = viewModel.loadDestinationCommand.value;
    expect(result, isNotNull);
    expect(result!.isSuccess(), true);
    expect(result.tryGetSuccess(), isNotNull);
    expect(result.tryGetSuccess()!, isA<DestinationDto>());
    expect(result.tryGetSuccess()!.id, id);
    expect(result.tryGetSuccess()!.userNotes, oldMockObservation);
  });
  test("should write new destination info successfully", () async {
    const mockObservation = "I liked it a lot";

    // Arrange: authenticate user
    await _authenticateTestUser();
    await Future.delayed(Duration(milliseconds: 500));

    // Arrange: load destination info
    viewModel.loadDestinationCommand.execute();
    await Future.delayed(Duration(seconds: 5));

    final result = viewModel.loadDestinationCommand.value;
    expect(result, isNotNull);
    expect(
      result!.tryGetSuccess(),
      isNotNull,
      reason: result.tryGetError()?.toString() ?? 'Unknown error',
    );

    // Act: write destination info
    viewModel.saveDestinationInfoCommand.execute(mockObservation);
    await Future.delayed(Duration(seconds: 1));

    // Assert: verify save was successful
    final saveResult = viewModel.saveDestinationInfoCommand.value;
    expect(saveResult, isNotNull);
    expect(saveResult!.isSuccess(), true);

    // Reload and verify the notes were saved
    viewModel.loadDestinationCommand.execute();
    await Future.delayed(Duration(seconds: 1));

    final reloadedResult = viewModel.loadDestinationCommand.value;
    expect(reloadedResult, isNotNull);
    expect(reloadedResult!.tryGetSuccess(), isNotNull);
    expect(reloadedResult.tryGetSuccess()!, isA<DestinationDto>());
    expect(reloadedResult.tryGetSuccess()!.id, id);
    expect(reloadedResult.tryGetSuccess()!.userNotes, mockObservation);
  });
}

Future<void> _authenticateTestUser() async {
  final authModule = _getIt<AuthModule>();

  const testName = 'Test User';
  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  await authModule.register(testName, testEmail, testPassword);
}
