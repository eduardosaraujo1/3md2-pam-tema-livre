import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module.dart';
import 'package:hot_tourist_destinations/ui/profile/view_models/profile_view_model.dart';

import '../../testing/dependencies.dart' as dependencies;

final _getIt = GetIt.I;

const name = "Test User";
const email = "example@gmail.com";
const password = "password123";

void main() {
  late AuthModule authModule;
  late ProfileViewModel viewModel;

  setUpAll(() async {
    dependencies.setupDependencies();
  });

  setUp(() async {
    authModule = await _getIt.getAsync<AuthModule>();
    viewModel = ProfileViewModel(authModule: authModule);
  });

  test("it loads profile when user is authenticated", () async {
    // Arrange
    await authModule.register(name, email, password);

    // Act
    viewModel.loadProfileCommand.execute();
    await Future.delayed(const Duration(milliseconds: 600));

    // Assert
    final result = viewModel.loadProfileCommand.value;
    expect(result, isNotNull);
    final (:success, :error) = result!.getBoth();
    expect(success, isNotNull);
  });

  test("it fails when no user is authenticated", () async {
    // Arrange
    // Here you would ensure no user is authenticated in the authModule

    // Act
    viewModel.loadProfileCommand.execute();
    await Future.delayed(const Duration(milliseconds: 600));

    // Assert
    final result = viewModel.loadProfileCommand.value;
    expect(result, isNotNull);
    final (:success, :error) = result!.getBoth();
    expect(error, isNotNull);
  });
}
