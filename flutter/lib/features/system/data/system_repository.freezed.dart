// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Release {

 String get tagName; String? get name; String? get body; String? get publishedAt; String? get htmlUrl; List<ReleaseAsset> get assets;
/// Create a copy of Release
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReleaseCopyWith<Release> get copyWith => _$ReleaseCopyWithImpl<Release>(this as Release, _$identity);

  /// Serializes this Release to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Release;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Release&&(identical(other.tagName, _this.tagName) || other.tagName == _this.tagName)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&(identical(other.htmlUrl, _this.htmlUrl) || other.htmlUrl == _this.htmlUrl)&&const DeepCollectionEquality().equals(other.assets, _this.assets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Release;
  return Object.hash(runtimeType,_this.tagName,_this.name,_this.body,_this.publishedAt,_this.htmlUrl,const DeepCollectionEquality().hash(_this.assets));
}

@override
String toString() {
  final _this = this as Release;
  return 'Release(tagName: ${_this.tagName}, name: ${_this.name}, body: ${_this.body}, publishedAt: ${_this.publishedAt}, htmlUrl: ${_this.htmlUrl}, assets: ${_this.assets})';
}


}

/// @nodoc
abstract mixin class $ReleaseCopyWith<$Res>  {
  factory $ReleaseCopyWith(Release value, $Res Function(Release) _then) = _$ReleaseCopyWithImpl;
@useResult
$Res call({
 String tagName, String? name, String? body, String? publishedAt, String? htmlUrl, List<ReleaseAsset> assets
});




}
/// @nodoc
class _$ReleaseCopyWithImpl<$Res>
    implements $ReleaseCopyWith<$Res> {
  _$ReleaseCopyWithImpl(this._self, this._then);

  final Release _self;
  final $Res Function(Release) _then;

/// Create a copy of Release
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tagName = null,Object? name = freezed,Object? body = freezed,Object? publishedAt = freezed,Object? htmlUrl = freezed,Object? assets = null,}) {
  return _then(Release(
tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,htmlUrl: freezed == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as String?,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<ReleaseAsset>,
  ));
}

}


/// Adds pattern-matching-related methods to [Release].
extension ReleasePatterns on Release {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Release value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Release() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Release value)  $default,){
final _that = this;
switch (_that) {
case _Release():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Release value)?  $default,){
final _that = this;
switch (_that) {
case _Release() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tagName,  String? name,  String? body,  String? publishedAt,  String? htmlUrl,  List<ReleaseAsset> assets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Release() when $default != null:
return $default(_that.tagName,_that.name,_that.body,_that.publishedAt,_that.htmlUrl,_that.assets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tagName,  String? name,  String? body,  String? publishedAt,  String? htmlUrl,  List<ReleaseAsset> assets)  $default,) {final _that = this;
switch (_that) {
case _Release():
return $default(_that.tagName,_that.name,_that.body,_that.publishedAt,_that.htmlUrl,_that.assets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tagName,  String? name,  String? body,  String? publishedAt,  String? htmlUrl,  List<ReleaseAsset> assets)?  $default,) {final _that = this;
switch (_that) {
case _Release() when $default != null:
return $default(_that.tagName,_that.name,_that.body,_that.publishedAt,_that.htmlUrl,_that.assets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Release implements Release {
  const _Release({required this.tagName, this.name, this.body, this.publishedAt, this.htmlUrl,  List<ReleaseAsset> assets = const <ReleaseAsset>[]}): _assets = assets;
  factory _Release.fromJson(Map<String, dynamic> json) => _$ReleaseFromJson(json);

@override final  String tagName;
@override final  String? name;
@override final  String? body;
@override final  String? publishedAt;
@override final  String? htmlUrl;
 final  List<ReleaseAsset> _assets;
@override@JsonKey() List<ReleaseAsset> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}


/// Create a copy of Release
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReleaseCopyWith<_Release> get copyWith => __$ReleaseCopyWithImpl<_Release>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReleaseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Release&&(identical(other.tagName, tagName) || other.tagName == tagName)&&(identical(other.name, name) || other.name == name)&&(identical(other.body, body) || other.body == body)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl)&&const DeepCollectionEquality().equals(other.assets, _assets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tagName,name,body,publishedAt,htmlUrl,const DeepCollectionEquality().hash(_assets));
}

@override
String toString() {
    return 'Release(tagName: $tagName, name: $name, body: $body, publishedAt: $publishedAt, htmlUrl: $htmlUrl, assets: $assets)';
}


}

/// @nodoc
abstract mixin class _$ReleaseCopyWith<$Res> implements $ReleaseCopyWith<$Res> {
  factory _$ReleaseCopyWith(_Release value, $Res Function(_Release) _then) = __$ReleaseCopyWithImpl;
@override @useResult
$Res call({
 String tagName, String? name, String? body, String? publishedAt, String? htmlUrl, List<ReleaseAsset> assets
});




}
/// @nodoc
class __$ReleaseCopyWithImpl<$Res>
    implements _$ReleaseCopyWith<$Res> {
  __$ReleaseCopyWithImpl(this._self, this._then);

  final _Release _self;
  final $Res Function(_Release) _then;

/// Create a copy of Release
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tagName = null,Object? name = freezed,Object? body = freezed,Object? publishedAt = freezed,Object? htmlUrl = freezed,Object? assets = null,}) {
  return _then(_Release(
tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,htmlUrl: freezed == htmlUrl ? _self.htmlUrl : htmlUrl // ignore: cast_nullable_to_non_nullable
as String?,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<ReleaseAsset>,
  ));
}


}


/// @nodoc
mixin _$ReleaseAsset {

 String get name; String get downloadUrl; int? get size;
/// Create a copy of ReleaseAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReleaseAssetCopyWith<ReleaseAsset> get copyWith => _$ReleaseAssetCopyWithImpl<ReleaseAsset>(this as ReleaseAsset, _$identity);

  /// Serializes this ReleaseAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReleaseAsset;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReleaseAsset&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.downloadUrl, _this.downloadUrl) || other.downloadUrl == _this.downloadUrl)&&(identical(other.size, _this.size) || other.size == _this.size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReleaseAsset;
  return Object.hash(runtimeType,_this.name,_this.downloadUrl,_this.size);
}

@override
String toString() {
  final _this = this as ReleaseAsset;
  return 'ReleaseAsset(name: ${_this.name}, downloadUrl: ${_this.downloadUrl}, size: ${_this.size})';
}


}

/// @nodoc
abstract mixin class $ReleaseAssetCopyWith<$Res>  {
  factory $ReleaseAssetCopyWith(ReleaseAsset value, $Res Function(ReleaseAsset) _then) = _$ReleaseAssetCopyWithImpl;
@useResult
$Res call({
 String name, String downloadUrl, int? size
});




}
/// @nodoc
class _$ReleaseAssetCopyWithImpl<$Res>
    implements $ReleaseAssetCopyWith<$Res> {
  _$ReleaseAssetCopyWithImpl(this._self, this._then);

  final ReleaseAsset _self;
  final $Res Function(ReleaseAsset) _then;

/// Create a copy of ReleaseAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? downloadUrl = null,Object? size = freezed,}) {
  return _then(ReleaseAsset(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReleaseAsset].
extension ReleaseAssetPatterns on ReleaseAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReleaseAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReleaseAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReleaseAsset value)  $default,){
final _that = this;
switch (_that) {
case _ReleaseAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReleaseAsset value)?  $default,){
final _that = this;
switch (_that) {
case _ReleaseAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String downloadUrl,  int? size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReleaseAsset() when $default != null:
return $default(_that.name,_that.downloadUrl,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String downloadUrl,  int? size)  $default,) {final _that = this;
switch (_that) {
case _ReleaseAsset():
return $default(_that.name,_that.downloadUrl,_that.size);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String downloadUrl,  int? size)?  $default,) {final _that = this;
switch (_that) {
case _ReleaseAsset() when $default != null:
return $default(_that.name,_that.downloadUrl,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReleaseAsset implements ReleaseAsset {
  const _ReleaseAsset({required this.name, required this.downloadUrl, this.size});
  factory _ReleaseAsset.fromJson(Map<String, dynamic> json) => _$ReleaseAssetFromJson(json);

@override final  String name;
@override final  String downloadUrl;
@override final  int? size;

/// Create a copy of ReleaseAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReleaseAssetCopyWith<_ReleaseAsset> get copyWith => __$ReleaseAssetCopyWithImpl<_ReleaseAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReleaseAssetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReleaseAsset&&(identical(other.name, name) || other.name == name)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,downloadUrl,size);
}

@override
String toString() {
    return 'ReleaseAsset(name: $name, downloadUrl: $downloadUrl, size: $size)';
}


}

/// @nodoc
abstract mixin class _$ReleaseAssetCopyWith<$Res> implements $ReleaseAssetCopyWith<$Res> {
  factory _$ReleaseAssetCopyWith(_ReleaseAsset value, $Res Function(_ReleaseAsset) _then) = __$ReleaseAssetCopyWithImpl;
@override @useResult
$Res call({
 String name, String downloadUrl, int? size
});




}
/// @nodoc
class __$ReleaseAssetCopyWithImpl<$Res>
    implements _$ReleaseAssetCopyWith<$Res> {
  __$ReleaseAssetCopyWithImpl(this._self, this._then);

  final _ReleaseAsset _self;
  final $Res Function(_ReleaseAsset) _then;

/// Create a copy of ReleaseAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? downloadUrl = null,Object? size = freezed,}) {
  return _then(_ReleaseAsset(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
