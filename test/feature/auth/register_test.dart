import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hot_tourist_destinations/modules/auth/auth_module.dart';
import 'package:hot_tourist_destinations/modules/auth/dto/profile/profile_dto.dart';
import 'package:hot_tourist_destinations/ui/auth/view_models/register_view_model.dart';

import '../../../testing/dependencies.dart' as dependencies;

final _getIt = GetIt.I;

void main() {
  late RegisterViewModel viewModel;
  late AuthModule authModule;

  setUpAll(() async {
    await dependencies.setupDependencies();
  });

  setUp(() async {
    authModule = await _getIt.getAsync();
    viewModel = RegisterViewModel(authModule: authModule);
  });
  /** Requirements
   * Creates a user with valid data
   * Does not create another user with the same e-mail
   */

  test("Creates a user with valid data", () async {
    // Arrange
    final formData = RegisterFormData(
      name: "Usuário Teste",
      email: "email@example.com",
      password: "fake-password!23",
      confirmPassword: "fake-password!23",
    );

    // Act
    viewModel.registerCommand.execute(formData);
    await Future.delayed(const Duration(milliseconds: 100));

    // Assert new user is authenticated
    expect(authModule.tokenNotifier.value, isNotNull);

    // Assert user was inserted
    final (success: user, error: userError) = (await authModule.getProfile())
        .getBoth();

    expect(user, isNotNull);
    expect(user, isA<ProfileDto>());
    expect(user!.email, formData.email);
    expect(user.name, formData.name);
  });
  test("Does not create another user with the same e-mail", () async {
    // Arrange
    final formData = RegisterFormData(
      name: "Usuário Teste",
      email: "email@example.com",
      password: "fake-password!23",
      confirmPassword: "fake-password!23",
    );

    authModule.register(formData.name, formData.email, formData.password);
    authModule.logout();

    // Act: try to register with same data
    viewModel.registerCommand.execute(
      RegisterFormData(
        name: "Usuario Duplicado",
        email: formData.email,
        password: formData.password,
        confirmPassword: formData.confirmPassword,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));

    // Assert result was error
    final status = viewModel.registerCommand.value;
    expect(status, isNotNull);
    final (:success, :error) = status!.getBoth();
    expect(error, isNotNull);
  });
}
