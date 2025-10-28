import 'package:command_it/command_it.dart';
import 'package:logging/logging.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../modules/auth/auth_module.dart';
import '../../view_model.dart';

class RegisterViewModel extends ViewModel {
  RegisterViewModel({required AuthModule authModule})
    : _authModule = authModule {
    registerCommand = Command.createAsync(_register, initialValue: null);
  }

  final AuthModule _authModule;

  late final Command<RegisterFormData, Result<void, String>?> registerCommand;
  final Logger _logger = Logger("Register View Model");

  Future<Result<void, String>> _register(RegisterFormData formData) async {
    try {
      // Validate passwords
      if (formData.password != formData.confirmPassword) {
        return Error("As senhas não coincidem.");
      }

      // Attempt registration
      final registerResult = await _authModule.register(
        formData.name,
        formData.email,
        formData.password,
      );
      final (:success, :error) = registerResult.getBoth();

      if (success != null) {
        return Success(null);
      }

      if (error is EmailAlreadyInUseException) {
        return Error("O e-mail já está em uso.");
      }

      _logger.severe("Não foi possível registrar o usuário: $error");
      return Error("Não foi possível registrar o usuário");
    } catch (e) {
      return Error("Ocorreu um erro inesperado ao registrar o usuário.");
    }
  }

  @override
  void dispose() {
    registerCommand.dispose();
  }
}

class RegisterFormData {
  RegisterFormData({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterFormData &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      confirmPassword.hashCode;
}
