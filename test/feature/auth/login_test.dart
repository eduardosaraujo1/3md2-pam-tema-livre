import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_livre_pam/modules/auth/auth_module.dart';
import 'package:projeto_livre_pam/modules/auth/auth_module_impl.dart';
import 'package:projeto_livre_pam/modules/auth/services/local_auth_client.dart';
import 'package:projeto_livre_pam/modules/auth/services/token_store.dart';
import 'package:projeto_livre_pam/ui/auth/view_models/login_view_model.dart';

import '../dependencies.dart' as dependencies;

final _getIt = GetIt.I;

void main() {
  late LoginViewModel viewModel;
  late AuthModule authModule;

  setUpAll(() async {
    await dependencies.setupDependencies();
  });

  setUp(() {
    authModule = AuthModuleImpl(
      apiClient: LocalAuthClient(sqliteClient: _getIt()),
      tokenStore: TokenStore(secureStorage: _getIt()),
    );
    viewModel = LoginViewModel(authModule: authModule);
  });

  /**Requirements
   * - Login with valid credentials (arrange: register user through auth module)
   * - Show error message with invalid credentials
   */
}
