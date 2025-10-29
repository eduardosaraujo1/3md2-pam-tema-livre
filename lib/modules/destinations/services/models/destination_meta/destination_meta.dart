import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination_meta.freezed.dart';

@freezed
sealed class DestinationMeta with _$DestinationMeta {
  const DestinationMeta._();

  const factory DestinationMeta({
    required int userId,
    required int destinationId,
    String? observation,
    @Default(false) bool isFavorite,
  }) = _DestinationMeta;

  factory DestinationMeta.fromJson(Map<String, dynamic> map) {
    return DestinationMeta(
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
