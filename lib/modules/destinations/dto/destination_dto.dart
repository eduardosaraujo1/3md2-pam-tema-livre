import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination_dto.freezed.dart';

@freezed
sealed class DestinationDto with _$DestinationDto {
  const DestinationDto._(); // Add private constructor

  const factory DestinationDto({
    required int id,
    required String name,
    required String location,
    required String countryCode,
    required String description,
  }) = _DestinationDto;

  factory DestinationDto.fromJson(Map<String, dynamic> map) {
    return DestinationDto(
      id: map['id'] as int,
      name: map['name'] as String,
      location: map['location'] as String,
      countryCode: map['countryCode'] as String,
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'countryCode': countryCode,
      'description': description,
    };
  }
}
