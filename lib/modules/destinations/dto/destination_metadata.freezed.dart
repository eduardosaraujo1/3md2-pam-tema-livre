// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'destination_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DestinationMetadata {

 int get destinationId; int get userId; String? get observation; bool get isFavorite;
/// Create a copy of DestinationMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DestinationMetadataCopyWith<DestinationMetadata> get copyWith => _$DestinationMetadataCopyWithImpl<DestinationMetadata>(this as DestinationMetadata, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DestinationMetadata&&(identical(other.destinationId, destinationId) || other.destinationId == destinationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,destinationId,userId,observation,isFavorite);

@override
String toString() {
  return 'DestinationMetadata(destinationId: $destinationId, userId: $userId, observation: $observation, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $DestinationMetadataCopyWith<$Res>  {
  factory $DestinationMetadataCopyWith(DestinationMetadata value, $Res Function(DestinationMetadata) _then) = _$DestinationMetadataCopyWithImpl;
@useResult
$Res call({
 int destinationId, int userId, String? observation, bool isFavorite
});




}
/// @nodoc
class _$DestinationMetadataCopyWithImpl<$Res>
    implements $DestinationMetadataCopyWith<$Res> {
  _$DestinationMetadataCopyWithImpl(this._self, this._then);

  final DestinationMetadata _self;
  final $Res Function(DestinationMetadata) _then;

/// Create a copy of DestinationMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? destinationId = null,Object? userId = null,Object? observation = freezed,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
destinationId: null == destinationId ? _self.destinationId : destinationId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,observation: freezed == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DestinationMetadata].
extension DestinationMetadataPatterns on DestinationMetadata {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DestinationMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DestinationMetadata() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DestinationMetadata value)  $default,){
final _that = this;
switch (_that) {
case _DestinationMetadata():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DestinationMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _DestinationMetadata() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int destinationId,  int userId,  String? observation,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DestinationMetadata() when $default != null:
return $default(_that.destinationId,_that.userId,_that.observation,_that.isFavorite);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int destinationId,  int userId,  String? observation,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _DestinationMetadata():
return $default(_that.destinationId,_that.userId,_that.observation,_that.isFavorite);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int destinationId,  int userId,  String? observation,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _DestinationMetadata() when $default != null:
return $default(_that.destinationId,_that.userId,_that.observation,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc


class _DestinationMetadata extends DestinationMetadata {
  const _DestinationMetadata({required this.destinationId, required this.userId, this.observation, this.isFavorite = false}): super._();
  

@override final  int destinationId;
@override final  int userId;
@override final  String? observation;
@override@JsonKey() final  bool isFavorite;

/// Create a copy of DestinationMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DestinationMetadataCopyWith<_DestinationMetadata> get copyWith => __$DestinationMetadataCopyWithImpl<_DestinationMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DestinationMetadata&&(identical(other.destinationId, destinationId) || other.destinationId == destinationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,destinationId,userId,observation,isFavorite);

@override
String toString() {
  return 'DestinationMetadata(destinationId: $destinationId, userId: $userId, observation: $observation, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$DestinationMetadataCopyWith<$Res> implements $DestinationMetadataCopyWith<$Res> {
  factory _$DestinationMetadataCopyWith(_DestinationMetadata value, $Res Function(_DestinationMetadata) _then) = __$DestinationMetadataCopyWithImpl;
@override @useResult
$Res call({
 int destinationId, int userId, String? observation, bool isFavorite
});




}
/// @nodoc
class __$DestinationMetadataCopyWithImpl<$Res>
    implements _$DestinationMetadataCopyWith<$Res> {
  __$DestinationMetadataCopyWithImpl(this._self, this._then);

  final _DestinationMetadata _self;
  final $Res Function(_DestinationMetadata) _then;

/// Create a copy of DestinationMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? destinationId = null,Object? userId = null,Object? observation = freezed,Object? isFavorite = null,}) {
  return _then(_DestinationMetadata(
destinationId: null == destinationId ? _self.destinationId : destinationId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,observation: freezed == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
