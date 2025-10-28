import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination_metadata.freezed.dart';

@freezed
sealed class DestinationMetadata with _$DestinationMetadata {
  const DestinationMetadata._();

  const factory DestinationMetadata({
    required int destinationId,
    required int userId,
    String? observation,
    @Default(false) bool isFavorite,
  }) = _DestinationMetadata;

  factory DestinationMetadata.fromJson(Map<String, dynamic> map) {
    return DestinationMetadata(
      destinationId: map['destination_id'] as int,
      userId: map['user_id'] as int,
      observation: map['observation'] as String?,
      isFavorite: map['is_favorite'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination_id': destinationId,
      'user_id': userId,
      'observation': observation,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }
}
