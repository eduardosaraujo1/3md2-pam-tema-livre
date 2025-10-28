import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projeto_livre_pam/modules/auth/dto/profile/profile_dto.dart';

part 'login_result.freezed.dart';

@freezed
sealed class LoginResult with _$LoginResult {
  const LoginResult._();

  const factory LoginResult({required ProfileDto user, required String token}) =
      _LoginResult;

  factory LoginResult.fromJson(Map<String, dynamic> map) {
    final userDto = ProfileDto.fromJson(
      Map<String, dynamic>.from(map['user'] as Map),
    );

    return LoginResult(user: userDto, token: map['token'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token};
  }
}
