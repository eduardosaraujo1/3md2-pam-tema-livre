// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'destination_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DestinationDto {

 int get id; String get name; String get location; String get countryCode; String get description; String get userNotes; bool get isFavorite;
/// Create a copy of DestinationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DestinationDtoCopyWith<DestinationDto> get copyWith => _$DestinationDtoCopyWithImpl<DestinationDto>(this as DestinationDto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DestinationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.userNotes, userNotes) || other.userNotes == userNotes)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,location,countryCode,description,userNotes,isFavorite);

@override
String toString() {
  return 'DestinationDto(id: $id, name: $name, location: $location, countryCode: $countryCode, description: $description, userNotes: $userNotes, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $DestinationDtoCopyWith<$Res>  {
  factory $DestinationDtoCopyWith(DestinationDto value, $Res Function(DestinationDto) _then) = _$DestinationDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String location, String countryCode, String description, String userNotes, bool isFavorite
});




}
/// @nodoc
class _$DestinationDtoCopyWithImpl<$Res>
    implements $DestinationDtoCopyWith<$Res> {
  _$DestinationDtoCopyWithImpl(this._self, this._then);

  final DestinationDto _self;
  final $Res Function(DestinationDto) _then;

/// Create a copy of DestinationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? location = null,Object? countryCode = null,Object? description = null,Object? userNotes = null,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,userNotes: null == userNotes ? _self.userNotes : userNotes // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DestinationDto].
extension DestinationDtoPatterns on DestinationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DestinationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DestinationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DestinationDto value)  $default,){
final _that = this;
switch (_that) {
case _DestinationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DestinationDto value)?  $default,){
final _that = this;
switch (_that) {
case _DestinationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String location,  String countryCode,  String description,  String userNotes,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DestinationDto() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.countryCode,_that.description,_that.userNotes,_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String location,  String countryCode,  String description,  String userNotes,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _DestinationDto():
return $default(_that.id,_that.name,_that.location,_that.countryCode,_that.description,_that.userNotes,_that.isFavorite);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String location,  String countryCode,  String description,  String userNotes,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _DestinationDto() when $default != null:
return $default(_that.id,_that.name,_that.location,_that.countryCode,_that.description,_that.userNotes,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc


class _DestinationDto extends DestinationDto {
  const _DestinationDto({required this.id, required this.name, required this.location, required this.countryCode, required this.description, required this.userNotes, required this.isFavorite}): super._();
  

@override final  int id;
@override final  String name;
@override final  String location;
@override final  String countryCode;
@override final  String description;
@override final  String userNotes;
@override final  bool isFavorite;

/// Create a copy of DestinationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DestinationDtoCopyWith<_DestinationDto> get copyWith => __$DestinationDtoCopyWithImpl<_DestinationDto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DestinationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.description, description) || other.description == description)&&(identical(other.userNotes, userNotes) || other.userNotes == userNotes)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,location,countryCode,description,userNotes,isFavorite);

@override
String toString() {
  return 'DestinationDto(id: $id, name: $name, location: $location, countryCode: $countryCode, description: $description, userNotes: $userNotes, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$DestinationDtoCopyWith<$Res> implements $DestinationDtoCopyWith<$Res> {
  factory _$DestinationDtoCopyWith(_DestinationDto value, $Res Function(_DestinationDto) _then) = __$DestinationDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String location, String countryCode, String description, String userNotes, bool isFavorite
});




}
/// @nodoc
class __$DestinationDtoCopyWithImpl<$Res>
    implements _$DestinationDtoCopyWith<$Res> {
  __$DestinationDtoCopyWithImpl(this._self, this._then);

  final _DestinationDto _self;
  final $Res Function(_DestinationDto) _then;

/// Create a copy of DestinationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? location = null,Object? countryCode = null,Object? description = null,Object? userNotes = null,Object? isFavorite = null,}) {
  return _then(_DestinationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,userNotes: null == userNotes ? _self.userNotes : userNotes // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
