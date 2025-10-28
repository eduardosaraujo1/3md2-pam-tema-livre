import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_dto.freezed.dart';

@freezed
sealed class ProfileDto with _$ProfileDto {
  const ProfileDto._(); // Add private constructor

  const factory ProfileDto({
    required int id,
    required String name,
    required String email,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> map) {
    return ProfileDto(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}
