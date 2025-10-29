import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module.dart';
import 'package:hot_tourist_destinations/ui/auth/view_models/login_view_model.dart';

import '../../../testing/dependencies.dart' as dependencies;

final _getIt = GetIt.I;

void main() {
  late LoginViewModel viewModel;
  late AuthModule authModule;

  setUp(() async {
    await dependencies.setupDependencies();

    authModule = await _getIt.getAsync();
    viewModel = LoginViewModel(authModule: authModule);
  });

  /**Requirements
   * - Login with valid credentials (arrange: register user through auth module)
   * - Show error message with invalid credentials
   */

  group('Login', () {
    test('should login successfully with valid credentials', () async {
      // Arrange: Register a user first
      const testName = 'Test User';
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      final registerResult = await authModule.register(
        testName,
        testEmail,
        testPassword,
      );

      expect(registerResult.isSuccess(), true);

      // Logout to prepare for login test
      await authModule.logout();

      // Act: Attempt to login with the registered credentials
      viewModel.loginCommand.execute(
        LoginData(email: testEmail, password: testPassword),
      );

      // Wait for the command to complete
      await Future.delayed(Duration(milliseconds: 1000));

      // Assert: Verify login was successful
      expect(viewModel.loginCommand.isExecuting.value, false);
      expect(viewModel.loginCommand.value, isNotNull);
      expect(viewModel.loginCommand.value!.isSuccess(), true);

      // Verify profile was stored
      expect(authModule.profileNotifier.value, isNotNull);
    });

    test('should return error with invalid credentials', () async {
      // Arrange: Register a user first
      const testName = 'Test User 2';
      const testEmail = 'test2@example.com';
      const testPassword = 'password123';

      await authModule.register(testName, testEmail, testPassword);
      await authModule.logout();

      // Act: Attempt to login with wrong password
      viewModel.loginCommand.execute(
        LoginData(email: testEmail, password: 'wrongpassword'),
      );

      // Wait for the command to complete
      await Future.delayed(Duration(milliseconds: 1000));

      // Assert: Verify login failed with appropriate error
      expect(viewModel.loginCommand.isExecuting.value, false);
      expect(viewModel.loginCommand.value, isNotNull);
      expect(viewModel.loginCommand.value!.isError(), true);

      // Verify it's an error message
      final error = viewModel.loginCommand.value!.tryGetError();
      expect(error, isA<String>());
    });

    test('should return error with non-existent user', () async {
      // Act: Attempt to login with non-existent user
      viewModel.loginCommand.execute(
        LoginData(email: 'nonexistent@example.com', password: 'password'),
      );

      // Wait for the command to complete
      await Future.delayed(Duration(milliseconds: 1000));

      // Assert: Verify login failed
      expect(viewModel.loginCommand.isExecuting.value, false);
      expect(viewModel.loginCommand.value, isNotNull);
      expect(viewModel.loginCommand.value!.isError(), true);

      // Verify it's an error message
      final error = viewModel.loginCommand.value!.tryGetError();
      expect(error, isA<String>());
    });
  });
}
