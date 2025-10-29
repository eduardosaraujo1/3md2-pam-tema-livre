// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'destination_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DestinationMeta {

 int get userId; int get destinationId; String? get observation; bool get isFavorite;
/// Create a copy of DestinationMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DestinationMetaCopyWith<DestinationMeta> get copyWith => _$DestinationMetaCopyWithImpl<DestinationMeta>(this as DestinationMeta, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DestinationMeta&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.destinationId, destinationId) || other.destinationId == destinationId)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,userId,destinationId,observation,isFavorite);

@override
String toString() {
  return 'DestinationMeta(userId: $userId, destinationId: $destinationId, observation: $observation, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $DestinationMetaCopyWith<$Res>  {
  factory $DestinationMetaCopyWith(DestinationMeta value, $Res Function(DestinationMeta) _then) = _$DestinationMetaCopyWithImpl;
@useResult
$Res call({
 int userId, int destinationId, String? observation, bool isFavorite
});




}
/// @nodoc
class _$DestinationMetaCopyWithImpl<$Res>
    implements $DestinationMetaCopyWith<$Res> {
  _$DestinationMetaCopyWithImpl(this._self, this._then);

  final DestinationMeta _self;
  final $Res Function(DestinationMeta) _then;

/// Create a copy of DestinationMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? destinationId = null,Object? observation = freezed,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,destinationId: null == destinationId ? _self.destinationId : destinationId // ignore: cast_nullable_to_non_nullable
as int,observation: freezed == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DestinationMeta].
extension DestinationMetaPatterns on DestinationMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DestinationMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DestinationMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DestinationMeta value)  $default,){
final _that = this;
switch (_that) {
case _DestinationMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DestinationMeta value)?  $default,){
final _that = this;
switch (_that) {
case _DestinationMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  int destinationId,  String? observation,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DestinationMeta() when $default != null:
return $default(_that.userId,_that.destinationId,_that.observation,_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  int destinationId,  String? observation,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _DestinationMeta():
return $default(_that.userId,_that.destinationId,_that.observation,_that.isFavorite);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  int destinationId,  String? observation,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _DestinationMeta() when $default != null:
return $default(_that.userId,_that.destinationId,_that.observation,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc


class _DestinationMeta extends DestinationMeta {
  const _DestinationMeta({required this.userId, required this.destinationId, this.observation, this.isFavorite = false}): super._();
  

@override final  int userId;
@override final  int destinationId;
@override final  String? observation;
@override@JsonKey() final  bool isFavorite;

/// Create a copy of DestinationMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DestinationMetaCopyWith<_DestinationMeta> get copyWith => __$DestinationMetaCopyWithImpl<_DestinationMeta>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DestinationMeta&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.destinationId, destinationId) || other.destinationId == destinationId)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,userId,destinationId,observation,isFavorite);

@override
String toString() {
  return 'DestinationMeta(userId: $userId, destinationId: $destinationId, observation: $observation, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$DestinationMetaCopyWith<$Res> implements $DestinationMetaCopyWith<$Res> {
  factory _$DestinationMetaCopyWith(_DestinationMeta value, $Res Function(_DestinationMeta) _then) = __$DestinationMetaCopyWithImpl;
@override @useResult
$Res call({
 int userId, int destinationId, String? observation, bool isFavorite
});




}
/// @nodoc
class __$DestinationMetaCopyWithImpl<$Res>
    implements _$DestinationMetaCopyWith<$Res> {
  __$DestinationMetaCopyWithImpl(this._self, this._then);

  final _DestinationMeta _self;
  final $Res Function(_DestinationMeta) _then;

/// Create a copy of DestinationMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? destinationId = null,Object? observation = freezed,Object? isFavorite = null,}) {
  return _then(_DestinationMeta(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,destinationId: null == destinationId ? _self.destinationId : destinationId // ignore: cast_nullable_to_non_nullable
as int,observation: freezed == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
