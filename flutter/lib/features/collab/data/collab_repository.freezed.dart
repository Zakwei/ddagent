// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collab_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollabUser {

 int get id; String get username; String? get role; String? get displayName;
/// Create a copy of CollabUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollabUserCopyWith<CollabUser> get copyWith => _$CollabUserCopyWithImpl<CollabUser>(this as CollabUser, _$identity);

  /// Serializes this CollabUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CollabUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollabUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CollabUser;
  return Object.hash(runtimeType,_this.id,_this.username,_this.role,_this.displayName);
}

@override
String toString() {
  final _this = this as CollabUser;
  return 'CollabUser(id: ${_this.id}, username: ${_this.username}, role: ${_this.role}, displayName: ${_this.displayName})';
}


}

/// @nodoc
abstract mixin class $CollabUserCopyWith<$Res>  {
  factory $CollabUserCopyWith(CollabUser value, $Res Function(CollabUser) _then) = _$CollabUserCopyWithImpl;
@useResult
$Res call({
 int id, String username, String? role, String? displayName
});




}
/// @nodoc
class _$CollabUserCopyWithImpl<$Res>
    implements $CollabUserCopyWith<$Res> {
  _$CollabUserCopyWithImpl(this._self, this._then);

  final CollabUser _self;
  final $Res Function(CollabUser) _then;

/// Create a copy of CollabUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? role = freezed,Object? displayName = freezed,}) {
  return _then(CollabUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollabUser].
extension CollabUserPatterns on CollabUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollabUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollabUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollabUser value)  $default,){
final _that = this;
switch (_that) {
case _CollabUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollabUser value)?  $default,){
final _that = this;
switch (_that) {
case _CollabUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username,  String? role,  String? displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollabUser() when $default != null:
return $default(_that.id,_that.username,_that.role,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username,  String? role,  String? displayName)  $default,) {final _that = this;
switch (_that) {
case _CollabUser():
return $default(_that.id,_that.username,_that.role,_that.displayName);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username,  String? role,  String? displayName)?  $default,) {final _that = this;
switch (_that) {
case _CollabUser() when $default != null:
return $default(_that.id,_that.username,_that.role,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollabUser implements CollabUser {
  const _CollabUser({required this.id, required this.username, this.role, this.displayName});
  factory _CollabUser.fromJson(Map<String, dynamic> json) => _$CollabUserFromJson(json);

@override final  int id;
@override final  String username;
@override final  String? role;
@override final  String? displayName;

/// Create a copy of CollabUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollabUserCopyWith<_CollabUser> get copyWith => __$CollabUserCopyWithImpl<_CollabUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollabUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollabUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.role, role) || other.role == role)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,username,role,displayName);
}

@override
String toString() {
    return 'CollabUser(id: $id, username: $username, role: $role, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$CollabUserCopyWith<$Res> implements $CollabUserCopyWith<$Res> {
  factory _$CollabUserCopyWith(_CollabUser value, $Res Function(_CollabUser) _then) = __$CollabUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, String? role, String? displayName
});




}
/// @nodoc
class __$CollabUserCopyWithImpl<$Res>
    implements _$CollabUserCopyWith<$Res> {
  __$CollabUserCopyWithImpl(this._self, this._then);

  final _CollabUser _self;
  final $Res Function(_CollabUser) _then;

/// Create a copy of CollabUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? role = freezed,Object? displayName = freezed,}) {
  return _then(_CollabUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
