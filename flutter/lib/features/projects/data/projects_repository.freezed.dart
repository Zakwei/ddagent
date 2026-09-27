// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projects_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Project {

 String get projectId; String get path; String get displayName; String? get fullPath; String? get customName; bool get isArchived; bool get isStarred; List<Map<String, dynamic>> get sessions; SessionMeta? get sessionMeta;
/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectCopyWith<Project> get copyWith => _$ProjectCopyWithImpl<Project>(this as Project, _$identity);

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Project;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Project&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.fullPath, _this.fullPath) || other.fullPath == _this.fullPath)&&(identical(other.customName, _this.customName) || other.customName == _this.customName)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived)&&(identical(other.isStarred, _this.isStarred) || other.isStarred == _this.isStarred)&&const DeepCollectionEquality().equals(other.sessions, _this.sessions)&&(identical(other.sessionMeta, _this.sessionMeta) || other.sessionMeta == _this.sessionMeta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Project;
  return Object.hash(runtimeType,_this.projectId,_this.path,_this.displayName,_this.fullPath,_this.customName,_this.isArchived,_this.isStarred,const DeepCollectionEquality().hash(_this.sessions),_this.sessionMeta);
}

@override
String toString() {
  final _this = this as Project;
  return 'Project(projectId: ${_this.projectId}, path: ${_this.path}, displayName: ${_this.displayName}, fullPath: ${_this.fullPath}, customName: ${_this.customName}, isArchived: ${_this.isArchived}, isStarred: ${_this.isStarred}, sessions: ${_this.sessions}, sessionMeta: ${_this.sessionMeta})';
}


}

/// @nodoc
abstract mixin class $ProjectCopyWith<$Res>  {
  factory $ProjectCopyWith(Project value, $Res Function(Project) _then) = _$ProjectCopyWithImpl;
@useResult
$Res call({
 String projectId, String path, String displayName, String? fullPath, String? customName, bool isArchived, bool isStarred, List<Map<String, dynamic>> sessions, SessionMeta? sessionMeta
});


$SessionMetaCopyWith<$Res>? get sessionMeta;

}
/// @nodoc
class _$ProjectCopyWithImpl<$Res>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._self, this._then);

  final Project _self;
  final $Res Function(Project) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? path = null,Object? displayName = null,Object? fullPath = freezed,Object? customName = freezed,Object? isArchived = null,Object? isStarred = null,Object? sessions = null,Object? sessionMeta = freezed,}) {
  return _then(Project(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,fullPath: freezed == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String?,customName: freezed == customName ? _self.customName : customName // ignore: cast_nullable_to_non_nullable
as String?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isStarred: null == isStarred ? _self.isStarred : isStarred // ignore: cast_nullable_to_non_nullable
as bool,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,sessionMeta: freezed == sessionMeta ? _self.sessionMeta : sessionMeta // ignore: cast_nullable_to_non_nullable
as SessionMeta?,
  ));
}
/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionMetaCopyWith<$Res>? get sessionMeta {
    if (_self.sessionMeta == null) {
    return null;
  }

  return $SessionMetaCopyWith<$Res>(_self.sessionMeta!, (value) {
    return _then(_self.copyWith(sessionMeta: value));
  });
}
}


/// Adds pattern-matching-related methods to [Project].
extension ProjectPatterns on Project {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Project value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Project() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Project value)  $default,){
final _that = this;
switch (_that) {
case _Project():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Project value)?  $default,){
final _that = this;
switch (_that) {
case _Project() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  String path,  String displayName,  String? fullPath,  String? customName,  bool isArchived,  bool isStarred,  List<Map<String, dynamic>> sessions,  SessionMeta? sessionMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Project() when $default != null:
return $default(_that.projectId,_that.path,_that.displayName,_that.fullPath,_that.customName,_that.isArchived,_that.isStarred,_that.sessions,_that.sessionMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  String path,  String displayName,  String? fullPath,  String? customName,  bool isArchived,  bool isStarred,  List<Map<String, dynamic>> sessions,  SessionMeta? sessionMeta)  $default,) {final _that = this;
switch (_that) {
case _Project():
return $default(_that.projectId,_that.path,_that.displayName,_that.fullPath,_that.customName,_that.isArchived,_that.isStarred,_that.sessions,_that.sessionMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  String path,  String displayName,  String? fullPath,  String? customName,  bool isArchived,  bool isStarred,  List<Map<String, dynamic>> sessions,  SessionMeta? sessionMeta)?  $default,) {final _that = this;
switch (_that) {
case _Project() when $default != null:
return $default(_that.projectId,_that.path,_that.displayName,_that.fullPath,_that.customName,_that.isArchived,_that.isStarred,_that.sessions,_that.sessionMeta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Project implements Project {
  const _Project({required this.projectId, required this.path, required this.displayName, this.fullPath, this.customName, this.isArchived = false, this.isStarred = false,  List<Map<String, dynamic>> sessions = const [], this.sessionMeta}): _sessions = sessions;
  factory _Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

@override final  String projectId;
@override final  String path;
@override final  String displayName;
@override final  String? fullPath;
@override final  String? customName;
@override@JsonKey() final  bool isArchived;
@override@JsonKey() final  bool isStarred;
 final  List<Map<String, dynamic>> _sessions;
@override@JsonKey() List<Map<String, dynamic>> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

@override final  SessionMeta? sessionMeta;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectCopyWith<_Project> get copyWith => __$ProjectCopyWithImpl<_Project>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Project&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.path, path) || other.path == path)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.fullPath, fullPath) || other.fullPath == fullPath)&&(identical(other.customName, customName) || other.customName == customName)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.isStarred, isStarred) || other.isStarred == isStarred)&&const DeepCollectionEquality().equals(other.sessions, _sessions)&&(identical(other.sessionMeta, sessionMeta) || other.sessionMeta == sessionMeta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,projectId,path,displayName,fullPath,customName,isArchived,isStarred,const DeepCollectionEquality().hash(_sessions),sessionMeta);
}

@override
String toString() {
    return 'Project(projectId: $projectId, path: $path, displayName: $displayName, fullPath: $fullPath, customName: $customName, isArchived: $isArchived, isStarred: $isStarred, sessions: $sessions, sessionMeta: $sessionMeta)';
}


}

/// @nodoc
abstract mixin class _$ProjectCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$ProjectCopyWith(_Project value, $Res Function(_Project) _then) = __$ProjectCopyWithImpl;
@override @useResult
$Res call({
 String projectId, String path, String displayName, String? fullPath, String? customName, bool isArchived, bool isStarred, List<Map<String, dynamic>> sessions, SessionMeta? sessionMeta
});


@override $SessionMetaCopyWith<$Res>? get sessionMeta;

}
/// @nodoc
class __$ProjectCopyWithImpl<$Res>
    implements _$ProjectCopyWith<$Res> {
  __$ProjectCopyWithImpl(this._self, this._then);

  final _Project _self;
  final $Res Function(_Project) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? path = null,Object? displayName = null,Object? fullPath = freezed,Object? customName = freezed,Object? isArchived = null,Object? isStarred = null,Object? sessions = null,Object? sessionMeta = freezed,}) {
  return _then(_Project(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,fullPath: freezed == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String?,customName: freezed == customName ? _self.customName : customName // ignore: cast_nullable_to_non_nullable
as String?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isStarred: null == isStarred ? _self.isStarred : isStarred // ignore: cast_nullable_to_non_nullable
as bool,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,sessionMeta: freezed == sessionMeta ? _self.sessionMeta : sessionMeta // ignore: cast_nullable_to_non_nullable
as SessionMeta?,
  ));
}

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionMetaCopyWith<$Res>? get sessionMeta {
    if (_self.sessionMeta == null) {
    return null;
  }

  return $SessionMetaCopyWith<$Res>(_self.sessionMeta!, (value) {
    return _then(_self.copyWith(sessionMeta: value));
  });
}
}


/// @nodoc
mixin _$SessionMeta {

 bool get hasMore; int get total;
/// Create a copy of SessionMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionMetaCopyWith<SessionMeta> get copyWith => _$SessionMetaCopyWithImpl<SessionMeta>(this as SessionMeta, _$identity);

  /// Serializes this SessionMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SessionMeta;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionMeta&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SessionMeta;
  return Object.hash(runtimeType,_this.hasMore,_this.total);
}

@override
String toString() {
  final _this = this as SessionMeta;
  return 'SessionMeta(hasMore: ${_this.hasMore}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $SessionMetaCopyWith<$Res>  {
  factory $SessionMetaCopyWith(SessionMeta value, $Res Function(SessionMeta) _then) = _$SessionMetaCopyWithImpl;
@useResult
$Res call({
 bool hasMore, int total
});




}
/// @nodoc
class _$SessionMetaCopyWithImpl<$Res>
    implements $SessionMetaCopyWith<$Res> {
  _$SessionMetaCopyWithImpl(this._self, this._then);

  final SessionMeta _self;
  final $Res Function(SessionMeta) _then;

/// Create a copy of SessionMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasMore = null,Object? total = null,}) {
  return _then(SessionMeta(
hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionMeta].
extension SessionMetaPatterns on SessionMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionMeta value)  $default,){
final _that = this;
switch (_that) {
case _SessionMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionMeta value)?  $default,){
final _that = this;
switch (_that) {
case _SessionMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasMore,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionMeta() when $default != null:
return $default(_that.hasMore,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasMore,  int total)  $default,) {final _that = this;
switch (_that) {
case _SessionMeta():
return $default(_that.hasMore,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasMore,  int total)?  $default,) {final _that = this;
switch (_that) {
case _SessionMeta() when $default != null:
return $default(_that.hasMore,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionMeta implements SessionMeta {
  const _SessionMeta({this.hasMore = false, this.total = 0});
  factory _SessionMeta.fromJson(Map<String, dynamic> json) => _$SessionMetaFromJson(json);

@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  int total;

/// Create a copy of SessionMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionMetaCopyWith<_SessionMeta> get copyWith => __$SessionMetaCopyWithImpl<_SessionMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionMetaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionMeta&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,hasMore,total);
}

@override
String toString() {
    return 'SessionMeta(hasMore: $hasMore, total: $total)';
}


}

/// @nodoc
abstract mixin class _$SessionMetaCopyWith<$Res> implements $SessionMetaCopyWith<$Res> {
  factory _$SessionMetaCopyWith(_SessionMeta value, $Res Function(_SessionMeta) _then) = __$SessionMetaCopyWithImpl;
@override @useResult
$Res call({
 bool hasMore, int total
});




}
/// @nodoc
class __$SessionMetaCopyWithImpl<$Res>
    implements _$SessionMetaCopyWith<$Res> {
  __$SessionMetaCopyWithImpl(this._self, this._then);

  final _SessionMeta _self;
  final $Res Function(_SessionMeta) _then;

/// Create a copy of SessionMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasMore = null,Object? total = null,}) {
  return _then(_SessionMeta(
hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProjectSessionsPage {

 String get projectId; List<Map<String, dynamic>> get sessions; SessionMeta? get sessionMeta;
/// Create a copy of ProjectSessionsPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectSessionsPageCopyWith<ProjectSessionsPage> get copyWith => _$ProjectSessionsPageCopyWithImpl<ProjectSessionsPage>(this as ProjectSessionsPage, _$identity);

  /// Serializes this ProjectSessionsPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProjectSessionsPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectSessionsPage&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&const DeepCollectionEquality().equals(other.sessions, _this.sessions)&&(identical(other.sessionMeta, _this.sessionMeta) || other.sessionMeta == _this.sessionMeta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectSessionsPage;
  return Object.hash(runtimeType,_this.projectId,const DeepCollectionEquality().hash(_this.sessions),_this.sessionMeta);
}

@override
String toString() {
  final _this = this as ProjectSessionsPage;
  return 'ProjectSessionsPage(projectId: ${_this.projectId}, sessions: ${_this.sessions}, sessionMeta: ${_this.sessionMeta})';
}


}

/// @nodoc
abstract mixin class $ProjectSessionsPageCopyWith<$Res>  {
  factory $ProjectSessionsPageCopyWith(ProjectSessionsPage value, $Res Function(ProjectSessionsPage) _then) = _$ProjectSessionsPageCopyWithImpl;
@useResult
$Res call({
 String projectId, List<Map<String, dynamic>> sessions, SessionMeta? sessionMeta
});


$SessionMetaCopyWith<$Res>? get sessionMeta;

}
/// @nodoc
class _$ProjectSessionsPageCopyWithImpl<$Res>
    implements $ProjectSessionsPageCopyWith<$Res> {
  _$ProjectSessionsPageCopyWithImpl(this._self, this._then);

  final ProjectSessionsPage _self;
  final $Res Function(ProjectSessionsPage) _then;

/// Create a copy of ProjectSessionsPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? sessions = null,Object? sessionMeta = freezed,}) {
  return _then(ProjectSessionsPage(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,sessionMeta: freezed == sessionMeta ? _self.sessionMeta : sessionMeta // ignore: cast_nullable_to_non_nullable
as SessionMeta?,
  ));
}
/// Create a copy of ProjectSessionsPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionMetaCopyWith<$Res>? get sessionMeta {
    if (_self.sessionMeta == null) {
    return null;
  }

  return $SessionMetaCopyWith<$Res>(_self.sessionMeta!, (value) {
    return _then(_self.copyWith(sessionMeta: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProjectSessionsPage].
extension ProjectSessionsPagePatterns on ProjectSessionsPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectSessionsPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectSessionsPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectSessionsPage value)  $default,){
final _that = this;
switch (_that) {
case _ProjectSessionsPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectSessionsPage value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectSessionsPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  List<Map<String, dynamic>> sessions,  SessionMeta? sessionMeta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectSessionsPage() when $default != null:
return $default(_that.projectId,_that.sessions,_that.sessionMeta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  List<Map<String, dynamic>> sessions,  SessionMeta? sessionMeta)  $default,) {final _that = this;
switch (_that) {
case _ProjectSessionsPage():
return $default(_that.projectId,_that.sessions,_that.sessionMeta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  List<Map<String, dynamic>> sessions,  SessionMeta? sessionMeta)?  $default,) {final _that = this;
switch (_that) {
case _ProjectSessionsPage() when $default != null:
return $default(_that.projectId,_that.sessions,_that.sessionMeta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectSessionsPage implements ProjectSessionsPage {
  const _ProjectSessionsPage({required this.projectId,  List<Map<String, dynamic>> sessions = const [], this.sessionMeta}): _sessions = sessions;
  factory _ProjectSessionsPage.fromJson(Map<String, dynamic> json) => _$ProjectSessionsPageFromJson(json);

@override final  String projectId;
 final  List<Map<String, dynamic>> _sessions;
@override@JsonKey() List<Map<String, dynamic>> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

@override final  SessionMeta? sessionMeta;

/// Create a copy of ProjectSessionsPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectSessionsPageCopyWith<_ProjectSessionsPage> get copyWith => __$ProjectSessionsPageCopyWithImpl<_ProjectSessionsPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectSessionsPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectSessionsPage&&(identical(other.projectId, projectId) || other.projectId == projectId)&&const DeepCollectionEquality().equals(other.sessions, _sessions)&&(identical(other.sessionMeta, sessionMeta) || other.sessionMeta == sessionMeta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,projectId,const DeepCollectionEquality().hash(_sessions),sessionMeta);
}

@override
String toString() {
    return 'ProjectSessionsPage(projectId: $projectId, sessions: $sessions, sessionMeta: $sessionMeta)';
}


}

/// @nodoc
abstract mixin class _$ProjectSessionsPageCopyWith<$Res> implements $ProjectSessionsPageCopyWith<$Res> {
  factory _$ProjectSessionsPageCopyWith(_ProjectSessionsPage value, $Res Function(_ProjectSessionsPage) _then) = __$ProjectSessionsPageCopyWithImpl;
@override @useResult
$Res call({
 String projectId, List<Map<String, dynamic>> sessions, SessionMeta? sessionMeta
});


@override $SessionMetaCopyWith<$Res>? get sessionMeta;

}
/// @nodoc
class __$ProjectSessionsPageCopyWithImpl<$Res>
    implements _$ProjectSessionsPageCopyWith<$Res> {
  __$ProjectSessionsPageCopyWithImpl(this._self, this._then);

  final _ProjectSessionsPage _self;
  final $Res Function(_ProjectSessionsPage) _then;

/// Create a copy of ProjectSessionsPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? sessions = null,Object? sessionMeta = freezed,}) {
  return _then(_ProjectSessionsPage(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,sessionMeta: freezed == sessionMeta ? _self.sessionMeta : sessionMeta // ignore: cast_nullable_to_non_nullable
as SessionMeta?,
  ));
}

/// Create a copy of ProjectSessionsPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionMetaCopyWith<$Res>? get sessionMeta {
    if (_self.sessionMeta == null) {
    return null;
  }

  return $SessionMetaCopyWith<$Res>(_self.sessionMeta!, (value) {
    return _then(_self.copyWith(sessionMeta: value));
  });
}
}

// dart format on
