import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/models/destination/destination.dart';
import '../services/models/destination_meta/destination_meta.dart';

part 'destination_dto.freezed.dart';

@freezed
sealed class DestinationDto with _$DestinationDto {
  const DestinationDto._(); // Allows method customization

  const factory DestinationDto({
    required int id,
    required String name,
    required String location,
    required String countryCode,
    required String description,
    required String userNotes,
    required bool isFavorite,
  }) = _DestinationDto;

  factory DestinationDto.fromJson(Map<String, dynamic> map) {
    return DestinationDto(
      id: map['id'] as int,
      name: map['name'] as String,
      location: map['location'] as String,
      countryCode: map['countryCode'] as String,
      description: map['description'] as String,
      userNotes: map['userNotes'] as String? ?? '',
      isFavorite: map['isFavorite'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'countryCode': countryCode,
      'description': description,
      'userNotes': userNotes,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory DestinationDto.fromParts(
    Destination destination,
    DestinationMeta destinationUser,
  ) {
    return DestinationDto(
      id: destination.id,
      countryCode: destination.countryCode,
      description: destination.description,
      name: destination.name,
      location: destination.location,
      isFavorite: destinationUser.isFavorite,
      userNotes: destinationUser.observation ?? '',
    );
  }
}
