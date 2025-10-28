import 'package:command_it/command_it.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../modules/auth/auth_module.dart';

import '../../view_model.dart';

class LoginViewModel extends ViewModel {
  LoginViewModel({required AuthModule authModule}) : _authModule = authModule {
    loginCommand = Command.createAsync(_login, initialValue: null);
  }

  final AuthModule _authModule;

  late final Command<LoginData, Result<void, Exception>?> loginCommand;

  Future<Result<void, Exception>> _login(LoginData data) async {
    throw UnimplementedError();
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
