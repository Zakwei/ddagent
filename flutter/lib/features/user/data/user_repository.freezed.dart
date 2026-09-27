// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GitConfig {

 String? get gitName; String? get gitEmail;
/// Create a copy of GitConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GitConfigCopyWith<GitConfig> get copyWith => _$GitConfigCopyWithImpl<GitConfig>(this as GitConfig, _$identity);

  /// Serializes this GitConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GitConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GitConfig&&(identical(other.gitName, _this.gitName) || other.gitName == _this.gitName)&&(identical(other.gitEmail, _this.gitEmail) || other.gitEmail == _this.gitEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GitConfig;
  return Object.hash(runtimeType,_this.gitName,_this.gitEmail);
}

@override
String toString() {
  final _this = this as GitConfig;
  return 'GitConfig(gitName: ${_this.gitName}, gitEmail: ${_this.gitEmail})';
}


}

/// @nodoc
abstract mixin class $GitConfigCopyWith<$Res>  {
  factory $GitConfigCopyWith(GitConfig value, $Res Function(GitConfig) _then) = _$GitConfigCopyWithImpl;
@useResult
$Res call({
 String? gitName, String? gitEmail
});




}
/// @nodoc
class _$GitConfigCopyWithImpl<$Res>
    implements $GitConfigCopyWith<$Res> {
  _$GitConfigCopyWithImpl(this._self, this._then);

  final GitConfig _self;
  final $Res Function(GitConfig) _then;

/// Create a copy of GitConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gitName = freezed,Object? gitEmail = freezed,}) {
  return _then(GitConfig(
gitName: freezed == gitName ? _self.gitName : gitName // ignore: cast_nullable_to_non_nullable
as String?,gitEmail: freezed == gitEmail ? _self.gitEmail : gitEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GitConfig].
extension GitConfigPatterns on GitConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GitConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GitConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GitConfig value)  $default,){
final _that = this;
switch (_that) {
case _GitConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GitConfig value)?  $default,){
final _that = this;
switch (_that) {
case _GitConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? gitName,  String? gitEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GitConfig() when $default != null:
return $default(_that.gitName,_that.gitEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? gitName,  String? gitEmail)  $default,) {final _that = this;
switch (_that) {
case _GitConfig():
return $default(_that.gitName,_that.gitEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? gitName,  String? gitEmail)?  $default,) {final _that = this;
switch (_that) {
case _GitConfig() when $default != null:
return $default(_that.gitName,_that.gitEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GitConfig implements GitConfig {
  const _GitConfig({this.gitName, this.gitEmail});
  factory _GitConfig.fromJson(Map<String, dynamic> json) => _$GitConfigFromJson(json);

@override final  String? gitName;
@override final  String? gitEmail;

/// Create a copy of GitConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GitConfigCopyWith<_GitConfig> get copyWith => __$GitConfigCopyWithImpl<_GitConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GitConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GitConfig&&(identical(other.gitName, gitName) || other.gitName == gitName)&&(identical(other.gitEmail, gitEmail) || other.gitEmail == gitEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,gitName,gitEmail);
}

@override
String toString() {
    return 'GitConfig(gitName: $gitName, gitEmail: $gitEmail)';
}


}

/// @nodoc
abstract mixin class _$GitConfigCopyWith<$Res> implements $GitConfigCopyWith<$Res> {
  factory _$GitConfigCopyWith(_GitConfig value, $Res Function(_GitConfig) _then) = __$GitConfigCopyWithImpl;
@override @useResult
$Res call({
 String? gitName, String? gitEmail
});




}
/// @nodoc
class __$GitConfigCopyWithImpl<$Res>
    implements _$GitConfigCopyWith<$Res> {
  __$GitConfigCopyWithImpl(this._self, this._then);

  final _GitConfig _self;
  final $Res Function(_GitConfig) _then;

/// Create a copy of GitConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gitName = freezed,Object? gitEmail = freezed,}) {
  return _then(_GitConfig(
gitName: freezed == gitName ? _self.gitName : gitName // ignore: cast_nullable_to_non_nullable
as String?,gitEmail: freezed == gitEmail ? _self.gitEmail : gitEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OnboardingStatus {

 bool get completed;
/// Create a copy of OnboardingStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStatusCopyWith<OnboardingStatus> get copyWith => _$OnboardingStatusCopyWithImpl<OnboardingStatus>(this as OnboardingStatus, _$identity);

  /// Serializes this OnboardingStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OnboardingStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStatus&&(identical(other.completed, _this.completed) || other.completed == _this.completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OnboardingStatus;
  return Object.hash(runtimeType,_this.completed);
}

@override
String toString() {
  final _this = this as OnboardingStatus;
  return 'OnboardingStatus(completed: ${_this.completed})';
}


}

/// @nodoc
abstract mixin class $OnboardingStatusCopyWith<$Res>  {
  factory $OnboardingStatusCopyWith(OnboardingStatus value, $Res Function(OnboardingStatus) _then) = _$OnboardingStatusCopyWithImpl;
@useResult
$Res call({
 bool completed
});




}
/// @nodoc
class _$OnboardingStatusCopyWithImpl<$Res>
    implements $OnboardingStatusCopyWith<$Res> {
  _$OnboardingStatusCopyWithImpl(this._self, this._then);

  final OnboardingStatus _self;
  final $Res Function(OnboardingStatus) _then;

/// Create a copy of OnboardingStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completed = null,}) {
  return _then(OnboardingStatus(
completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingStatus].
extension OnboardingStatusPatterns on OnboardingStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingStatus value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingStatus value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStatus() when $default != null:
return $default(_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool completed)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatus():
return $default(_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool completed)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatus() when $default != null:
return $default(_that.completed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingStatus implements OnboardingStatus {
  const _OnboardingStatus({this.completed = false});
  factory _OnboardingStatus.fromJson(Map<String, dynamic> json) => _$OnboardingStatusFromJson(json);

@override@JsonKey() final  bool completed;

/// Create a copy of OnboardingStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStatusCopyWith<_OnboardingStatus> get copyWith => __$OnboardingStatusCopyWithImpl<_OnboardingStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStatus&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,completed);
}

@override
String toString() {
    return 'OnboardingStatus(completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStatusCopyWith<$Res> implements $OnboardingStatusCopyWith<$Res> {
  factory _$OnboardingStatusCopyWith(_OnboardingStatus value, $Res Function(_OnboardingStatus) _then) = __$OnboardingStatusCopyWithImpl;
@override @useResult
$Res call({
 bool completed
});




}
/// @nodoc
class __$OnboardingStatusCopyWithImpl<$Res>
    implements _$OnboardingStatusCopyWith<$Res> {
  __$OnboardingStatusCopyWithImpl(this._self, this._then);

  final _OnboardingStatus _self;
  final $Res Function(_OnboardingStatus) _then;

/// Create a copy of OnboardingStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completed = null,}) {
  return _then(_OnboardingStatus(
completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
