import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination.freezed.dart';

@freezed
sealed class Destination with _$Destination {
  const Destination._(); // Add private constructor

  const factory Destination({
    required int id,
    required String name,
    required String location,
    required String countryCode,
    required String description,
  }) = _Destination;

  factory Destination.fromJson(Map<String, dynamic> map) {
    return Destination(
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
