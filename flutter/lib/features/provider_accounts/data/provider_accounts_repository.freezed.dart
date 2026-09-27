// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_accounts_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderAccount {

 String get id; String? get provider; String? get label; Map<String, dynamic> get usage;
/// Create a copy of ProviderAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderAccountCopyWith<ProviderAccount> get copyWith => _$ProviderAccountCopyWithImpl<ProviderAccount>(this as ProviderAccount, _$identity);

  /// Serializes this ProviderAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProviderAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderAccount&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.label, _this.label) || other.label == _this.label)&&const DeepCollectionEquality().equals(other.usage, _this.usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProviderAccount;
  return Object.hash(runtimeType,_this.id,_this.provider,_this.label,const DeepCollectionEquality().hash(_this.usage));
}

@override
String toString() {
  final _this = this as ProviderAccount;
  return 'ProviderAccount(id: ${_this.id}, provider: ${_this.provider}, label: ${_this.label}, usage: ${_this.usage})';
}


}

/// @nodoc
abstract mixin class $ProviderAccountCopyWith<$Res>  {
  factory $ProviderAccountCopyWith(ProviderAccount value, $Res Function(ProviderAccount) _then) = _$ProviderAccountCopyWithImpl;
@useResult
$Res call({
 String id, String? provider, String? label, Map<String, dynamic> usage
});




}
/// @nodoc
class _$ProviderAccountCopyWithImpl<$Res>
    implements $ProviderAccountCopyWith<$Res> {
  _$ProviderAccountCopyWithImpl(this._self, this._then);

  final ProviderAccount _self;
  final $Res Function(ProviderAccount) _then;

/// Create a copy of ProviderAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? provider = freezed,Object? label = freezed,Object? usage = null,}) {
  return _then(ProviderAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderAccount].
extension ProviderAccountPatterns on ProviderAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderAccount value)  $default,){
final _that = this;
switch (_that) {
case _ProviderAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderAccount value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? provider,  String? label,  Map<String, dynamic> usage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderAccount() when $default != null:
return $default(_that.id,_that.provider,_that.label,_that.usage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? provider,  String? label,  Map<String, dynamic> usage)  $default,) {final _that = this;
switch (_that) {
case _ProviderAccount():
return $default(_that.id,_that.provider,_that.label,_that.usage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? provider,  String? label,  Map<String, dynamic> usage)?  $default,) {final _that = this;
switch (_that) {
case _ProviderAccount() when $default != null:
return $default(_that.id,_that.provider,_that.label,_that.usage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderAccount implements ProviderAccount {
  const _ProviderAccount({required this.id, this.provider, this.label,  Map<String, dynamic> usage = const {}}): _usage = usage;
  factory _ProviderAccount.fromJson(Map<String, dynamic> json) => _$ProviderAccountFromJson(json);

@override final  String id;
@override final  String? provider;
@override final  String? label;
 final  Map<String, dynamic> _usage;
@override@JsonKey() Map<String, dynamic> get usage {
  if (_usage is EqualUnmodifiableMapView) return _usage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_usage);
}


/// Create a copy of ProviderAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderAccountCopyWith<_ProviderAccount> get copyWith => __$ProviderAccountCopyWithImpl<_ProviderAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderAccountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.usage, _usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,provider,label,const DeepCollectionEquality().hash(_usage));
}

@override
String toString() {
    return 'ProviderAccount(id: $id, provider: $provider, label: $label, usage: $usage)';
}


}

/// @nodoc
abstract mixin class _$ProviderAccountCopyWith<$Res> implements $ProviderAccountCopyWith<$Res> {
  factory _$ProviderAccountCopyWith(_ProviderAccount value, $Res Function(_ProviderAccount) _then) = __$ProviderAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String? provider, String? label, Map<String, dynamic> usage
});




}
/// @nodoc
class __$ProviderAccountCopyWithImpl<$Res>
    implements _$ProviderAccountCopyWith<$Res> {
  __$ProviderAccountCopyWithImpl(this._self, this._then);

  final _ProviderAccount _self;
  final $Res Function(_ProviderAccount) _then;

/// Create a copy of ProviderAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? provider = freezed,Object? label = freezed,Object? usage = null,}) {
  return _then(_ProviderAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,usage: null == usage ? _self._usage : usage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
