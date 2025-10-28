import 'package:command_it/command_it.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../modules/auth/auth_module.dart';
import '../../view_model.dart';

class LoginViewModel extends ViewModel {
  LoginViewModel({required AuthModule authModule}) : _authModule = authModule {
    loginCommand = Command.createAsync(_login, initialValue: null);
  }

  final AuthModule _authModule;

  late final Command<LoginData, Result<void, String>?> loginCommand;

  Future<Result<void, String>> _login(LoginData data) async {
    try {
      final result = await _authModule.login(data.email, data.password);
      final (:success, :error) = result.getBoth();

      if (success != null) {
        return Success(null);
      }

      if (error is IncorrectLoginCredentialsException) {
        return Error(
          "Credenciais inválidas. Por favor, verifique seu e-mail e senha.",
        );
      } else {
        return Error(
          "Falha ao efetuar login. Por favor, tente novamente mais tarde.",
        );
      }
    } catch (e) {
      return Error("Ocorreu um erro desconhecido durante o login.");
    }
  }

  @override
  void dispose() {
    loginCommand.dispose();
  }
}

class LoginData {
  final String email;
  final String password;

  LoginData({required this.email, required this.password});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginData) return false;

    return other.email == email && other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
