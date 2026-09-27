// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sessions_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Session {

 String get sessionId; String? get provider; String? get providerSessionId; String? get summary; String? get projectPath; String? get lastActivity; String? get createdAt; bool get isArchived; bool get isRunning;@JsonKey(includeFromJson: false, includeToJson: false) Map<String, dynamic> get raw;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Session;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.providerSessionId, _this.providerSessionId) || other.providerSessionId == _this.providerSessionId)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.projectPath, _this.projectPath) || other.projectPath == _this.projectPath)&&(identical(other.lastActivity, _this.lastActivity) || other.lastActivity == _this.lastActivity)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived)&&(identical(other.isRunning, _this.isRunning) || other.isRunning == _this.isRunning)&&const DeepCollectionEquality().equals(other.raw, _this.raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Session;
  return Object.hash(runtimeType,_this.sessionId,_this.provider,_this.providerSessionId,_this.summary,_this.projectPath,_this.lastActivity,_this.createdAt,_this.isArchived,_this.isRunning,const DeepCollectionEquality().hash(_this.raw));
}

@override
String toString() {
  final _this = this as Session;
  return 'Session(sessionId: ${_this.sessionId}, provider: ${_this.provider}, providerSessionId: ${_this.providerSessionId}, summary: ${_this.summary}, projectPath: ${_this.projectPath}, lastActivity: ${_this.lastActivity}, createdAt: ${_this.createdAt}, isArchived: ${_this.isArchived}, isRunning: ${_this.isRunning}, raw: ${_this.raw})';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
 String sessionId, String? provider, String? providerSessionId, String? summary, String? projectPath, String? lastActivity, String? createdAt, bool isArchived, bool isRunning,@JsonKey(includeFromJson: false, includeToJson: false) Map<String, dynamic> raw
});




}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? provider = freezed,Object? providerSessionId = freezed,Object? summary = freezed,Object? projectPath = freezed,Object? lastActivity = freezed,Object? createdAt = freezed,Object? isArchived = null,Object? isRunning = null,Object? raw = null,}) {
  return _then(Session(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,providerSessionId: freezed == providerSessionId ? _self.providerSessionId : providerSessionId // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,projectPath: freezed == projectPath ? _self.projectPath : projectPath // ignore: cast_nullable_to_non_nullable
as String?,lastActivity: freezed == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String? provider,  String? providerSessionId,  String? summary,  String? projectPath,  String? lastActivity,  String? createdAt,  bool isArchived,  bool isRunning, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, dynamic> raw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.sessionId,_that.provider,_that.providerSessionId,_that.summary,_that.projectPath,_that.lastActivity,_that.createdAt,_that.isArchived,_that.isRunning,_that.raw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String? provider,  String? providerSessionId,  String? summary,  String? projectPath,  String? lastActivity,  String? createdAt,  bool isArchived,  bool isRunning, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, dynamic> raw)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.sessionId,_that.provider,_that.providerSessionId,_that.summary,_that.projectPath,_that.lastActivity,_that.createdAt,_that.isArchived,_that.isRunning,_that.raw);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String? provider,  String? providerSessionId,  String? summary,  String? projectPath,  String? lastActivity,  String? createdAt,  bool isArchived,  bool isRunning, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, dynamic> raw)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.sessionId,_that.provider,_that.providerSessionId,_that.summary,_that.projectPath,_that.lastActivity,_that.createdAt,_that.isArchived,_that.isRunning,_that.raw);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _Session implements Session {
  const _Session({required this.sessionId, this.provider, this.providerSessionId, this.summary, this.projectPath, this.lastActivity, this.createdAt, this.isArchived = false, this.isRunning = false, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, dynamic> raw = const {}}): _raw = raw;
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override final  String sessionId;
@override final  String? provider;
@override final  String? providerSessionId;
@override final  String? summary;
@override final  String? projectPath;
@override final  String? lastActivity;
@override final  String? createdAt;
@override@JsonKey() final  bool isArchived;
@override@JsonKey() final  bool isRunning;
 final  Map<String, dynamic> _raw;
@override@JsonKey(includeFromJson: false, includeToJson: false) Map<String, dynamic> get raw {
  if (_raw is EqualUnmodifiableMapView) return _raw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_raw);
}


/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.providerSessionId, providerSessionId) || other.providerSessionId == providerSessionId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.projectPath, projectPath) || other.projectPath == projectPath)&&(identical(other.lastActivity, lastActivity) || other.lastActivity == lastActivity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&const DeepCollectionEquality().equals(other.raw, _raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,provider,providerSessionId,summary,projectPath,lastActivity,createdAt,isArchived,isRunning,const DeepCollectionEquality().hash(_raw));
}

@override
String toString() {
    return 'Session(sessionId: $sessionId, provider: $provider, providerSessionId: $providerSessionId, summary: $summary, projectPath: $projectPath, lastActivity: $lastActivity, createdAt: $createdAt, isArchived: $isArchived, isRunning: $isRunning, raw: $raw)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String? provider, String? providerSessionId, String? summary, String? projectPath, String? lastActivity, String? createdAt, bool isArchived, bool isRunning,@JsonKey(includeFromJson: false, includeToJson: false) Map<String, dynamic> raw
});




}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? provider = freezed,Object? providerSessionId = freezed,Object? summary = freezed,Object? projectPath = freezed,Object? lastActivity = freezed,Object? createdAt = freezed,Object? isArchived = null,Object? isRunning = null,Object? raw = null,}) {
  return _then(_Session(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,providerSessionId: freezed == providerSessionId ? _self.providerSessionId : providerSessionId // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,projectPath: freezed == projectPath ? _self.projectPath : projectPath // ignore: cast_nullable_to_non_nullable
as String?,lastActivity: freezed == lastActivity ? _self.lastActivity : lastActivity // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,raw: null == raw ? _self._raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$SessionsPage {

 List<Session> get sessions; bool get hasMore; int get total;
/// Create a copy of SessionsPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionsPageCopyWith<SessionsPage> get copyWith => _$SessionsPageCopyWithImpl<SessionsPage>(this as SessionsPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionsPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionsPage&&const DeepCollectionEquality().equals(other.sessions, _this.sessions)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SessionsPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.sessions),_this.hasMore,_this.total);
}

@override
String toString() {
  final _this = this as SessionsPage;
  return 'SessionsPage(sessions: ${_this.sessions}, hasMore: ${_this.hasMore}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $SessionsPageCopyWith<$Res>  {
  factory $SessionsPageCopyWith(SessionsPage value, $Res Function(SessionsPage) _then) = _$SessionsPageCopyWithImpl;
@useResult
$Res call({
 List<Session> sessions, bool hasMore, int total
});




}
/// @nodoc
class _$SessionsPageCopyWithImpl<$Res>
    implements $SessionsPageCopyWith<$Res> {
  _$SessionsPageCopyWithImpl(this._self, this._then);

  final SessionsPage _self;
  final $Res Function(SessionsPage) _then;

/// Create a copy of SessionsPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessions = null,Object? hasMore = null,Object? total = null,}) {
  return _then(SessionsPage(
sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<Session>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionsPage].
extension SessionsPagePatterns on SessionsPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionsPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionsPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionsPage value)  $default,){
final _that = this;
switch (_that) {
case _SessionsPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionsPage value)?  $default,){
final _that = this;
switch (_that) {
case _SessionsPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Session> sessions,  bool hasMore,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionsPage() when $default != null:
return $default(_that.sessions,_that.hasMore,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Session> sessions,  bool hasMore,  int total)  $default,) {final _that = this;
switch (_that) {
case _SessionsPage():
return $default(_that.sessions,_that.hasMore,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Session> sessions,  bool hasMore,  int total)?  $default,) {final _that = this;
switch (_that) {
case _SessionsPage() when $default != null:
return $default(_that.sessions,_that.hasMore,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _SessionsPage implements SessionsPage {
  const _SessionsPage({ List<Session> sessions = const [], this.hasMore = false, this.total = 0}): _sessions = sessions;
  factory _SessionsPage.fromJson(Map<String, dynamic> json) => _$SessionsPageFromJson(json);

 final  List<Session> _sessions;
@override@JsonKey() List<Session> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  int total;

/// Create a copy of SessionsPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionsPageCopyWith<_SessionsPage> get copyWith => __$SessionsPageCopyWithImpl<_SessionsPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionsPage&&const DeepCollectionEquality().equals(other.sessions, _sessions)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_sessions),hasMore,total);
}

@override
String toString() {
    return 'SessionsPage(sessions: $sessions, hasMore: $hasMore, total: $total)';
}


}

/// @nodoc
abstract mixin class _$SessionsPageCopyWith<$Res> implements $SessionsPageCopyWith<$Res> {
  factory _$SessionsPageCopyWith(_SessionsPage value, $Res Function(_SessionsPage) _then) = __$SessionsPageCopyWithImpl;
@override @useResult
$Res call({
 List<Session> sessions, bool hasMore, int total
});




}
/// @nodoc
class __$SessionsPageCopyWithImpl<$Res>
    implements _$SessionsPageCopyWith<$Res> {
  __$SessionsPageCopyWithImpl(this._self, this._then);

  final _SessionsPage _self;
  final $Res Function(_SessionsPage) _then;

/// Create a copy of SessionsPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessions = null,Object? hasMore = null,Object? total = null,}) {
  return _then(_SessionsPage(
sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<Session>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
