import 'package:command_it/command_it.dart';
import 'package:logging/logging.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../modules/auth/auth_module.dart';
import '../../../modules/auth/dto/profile/profile_dto.dart';
import '../../view_model.dart';

class ProfileViewModel extends ViewModel {
  final AuthModule _authModule;

  ProfileViewModel({required AuthModule authModule})
    : _authModule = authModule {
    loadProfileCommand = Command.createAsyncNoParam(
      _loadProfile,
      initialValue: null,
    );
  }

  late final Command<void, Result<ProfileDto, String>?> loadProfileCommand;

  final Logger _logger = Logger('ProfileViewModel');

  Future<Result<ProfileDto, String>?> _loadProfile() async {
    try {
      final profile = _authModule.getProfile();
      if (profile != null) {
        return Success(profile);
      } else {
        return Error('Usuário não autenticado');
      }
    } catch (e) {
      _logger.severe('Error loading profile', e);
      return Error('Ocorreu um erro ao carregar o perfil');
    }
  }

  void logout() {
    _authModule.logout();
  }

  @override
  void dispose() {
    loadProfileCommand.dispose();
  }
}
