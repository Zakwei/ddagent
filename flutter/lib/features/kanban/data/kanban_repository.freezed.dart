// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kanban_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KanbanCard {

 String get cardId; String? get projectId; String? get title; String? get status; int get position;@JsonKey(includeFromJson: false, includeToJson: false) Map<String, dynamic> get raw;
/// Create a copy of KanbanCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanCardCopyWith<KanbanCard> get copyWith => _$KanbanCardCopyWithImpl<KanbanCard>(this as KanbanCard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KanbanCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanCard&&(identical(other.cardId, _this.cardId) || other.cardId == _this.cardId)&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.position, _this.position) || other.position == _this.position)&&const DeepCollectionEquality().equals(other.raw, _this.raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KanbanCard;
  return Object.hash(runtimeType,_this.cardId,_this.projectId,_this.title,_this.status,_this.position,const DeepCollectionEquality().hash(_this.raw));
}

@override
String toString() {
  final _this = this as KanbanCard;
  return 'KanbanCard(cardId: ${_this.cardId}, projectId: ${_this.projectId}, title: ${_this.title}, status: ${_this.status}, position: ${_this.position}, raw: ${_this.raw})';
}


}

/// @nodoc
abstract mixin class $KanbanCardCopyWith<$Res>  {
  factory $KanbanCardCopyWith(KanbanCard value, $Res Function(KanbanCard) _then) = _$KanbanCardCopyWithImpl;
@useResult
$Res call({
 String cardId, String? projectId, String? title, String? status, int position,@JsonKey(includeFromJson: false, includeToJson: false) Map<String, dynamic> raw
});




}
/// @nodoc
class _$KanbanCardCopyWithImpl<$Res>
    implements $KanbanCardCopyWith<$Res> {
  _$KanbanCardCopyWithImpl(this._self, this._then);

  final KanbanCard _self;
  final $Res Function(KanbanCard) _then;

/// Create a copy of KanbanCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardId = null,Object? projectId = freezed,Object? title = freezed,Object? status = freezed,Object? position = null,Object? raw = null,}) {
  return _then(KanbanCard(
cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [KanbanCard].
extension KanbanCardPatterns on KanbanCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanCard value)  $default,){
final _that = this;
switch (_that) {
case _KanbanCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanCard value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cardId,  String? projectId,  String? title,  String? status,  int position, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, dynamic> raw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanCard() when $default != null:
return $default(_that.cardId,_that.projectId,_that.title,_that.status,_that.position,_that.raw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cardId,  String? projectId,  String? title,  String? status,  int position, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, dynamic> raw)  $default,) {final _that = this;
switch (_that) {
case _KanbanCard():
return $default(_that.cardId,_that.projectId,_that.title,_that.status,_that.position,_that.raw);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cardId,  String? projectId,  String? title,  String? status,  int position, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, dynamic> raw)?  $default,) {final _that = this;
switch (_that) {
case _KanbanCard() when $default != null:
return $default(_that.cardId,_that.projectId,_that.title,_that.status,_that.position,_that.raw);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _KanbanCard implements KanbanCard {
  const _KanbanCard({required this.cardId, this.projectId, this.title, this.status, this.position = 0, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, dynamic> raw = const {}}): _raw = raw;
  factory _KanbanCard.fromJson(Map<String, dynamic> json) => _$KanbanCardFromJson(json);

@override final  String cardId;
@override final  String? projectId;
@override final  String? title;
@override final  String? status;
@override@JsonKey() final  int position;
 final  Map<String, dynamic> _raw;
@override@JsonKey(includeFromJson: false, includeToJson: false) Map<String, dynamic> get raw {
  if (_raw is EqualUnmodifiableMapView) return _raw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_raw);
}


/// Create a copy of KanbanCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanCardCopyWith<_KanbanCard> get copyWith => __$KanbanCardCopyWithImpl<_KanbanCard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanCard&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.raw, _raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cardId,projectId,title,status,position,const DeepCollectionEquality().hash(_raw));
}

@override
String toString() {
    return 'KanbanCard(cardId: $cardId, projectId: $projectId, title: $title, status: $status, position: $position, raw: $raw)';
}


}

/// @nodoc
abstract mixin class _$KanbanCardCopyWith<$Res> implements $KanbanCardCopyWith<$Res> {
  factory _$KanbanCardCopyWith(_KanbanCard value, $Res Function(_KanbanCard) _then) = __$KanbanCardCopyWithImpl;
@override @useResult
$Res call({
 String cardId, String? projectId, String? title, String? status, int position,@JsonKey(includeFromJson: false, includeToJson: false) Map<String, dynamic> raw
});




}
/// @nodoc
class __$KanbanCardCopyWithImpl<$Res>
    implements _$KanbanCardCopyWith<$Res> {
  __$KanbanCardCopyWithImpl(this._self, this._then);

  final _KanbanCard _self;
  final $Res Function(_KanbanCard) _then;

/// Create a copy of KanbanCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardId = null,Object? projectId = freezed,Object? title = freezed,Object? status = freezed,Object? position = null,Object? raw = null,}) {
  return _then(_KanbanCard(
cardId: null == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,raw: null == raw ? _self._raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$KanbanComment {

 String? get id; String? get cardId; int? get userId; String? get body; String? get createdAt;
/// Create a copy of KanbanComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KanbanCommentCopyWith<KanbanComment> get copyWith => _$KanbanCommentCopyWithImpl<KanbanComment>(this as KanbanComment, _$identity);

  /// Serializes this KanbanComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as KanbanComment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KanbanComment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.cardId, _this.cardId) || other.cardId == _this.cardId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as KanbanComment;
  return Object.hash(runtimeType,_this.id,_this.cardId,_this.userId,_this.body,_this.createdAt);
}

@override
String toString() {
  final _this = this as KanbanComment;
  return 'KanbanComment(id: ${_this.id}, cardId: ${_this.cardId}, userId: ${_this.userId}, body: ${_this.body}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $KanbanCommentCopyWith<$Res>  {
  factory $KanbanCommentCopyWith(KanbanComment value, $Res Function(KanbanComment) _then) = _$KanbanCommentCopyWithImpl;
@useResult
$Res call({
 String? id, String? cardId, int? userId, String? body, String? createdAt
});




}
/// @nodoc
class _$KanbanCommentCopyWithImpl<$Res>
    implements $KanbanCommentCopyWith<$Res> {
  _$KanbanCommentCopyWithImpl(this._self, this._then);

  final KanbanComment _self;
  final $Res Function(KanbanComment) _then;

/// Create a copy of KanbanComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? cardId = freezed,Object? userId = freezed,Object? body = freezed,Object? createdAt = freezed,}) {
  return _then(KanbanComment(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,cardId: freezed == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KanbanComment].
extension KanbanCommentPatterns on KanbanComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KanbanComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KanbanComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KanbanComment value)  $default,){
final _that = this;
switch (_that) {
case _KanbanComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KanbanComment value)?  $default,){
final _that = this;
switch (_that) {
case _KanbanComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? cardId,  int? userId,  String? body,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KanbanComment() when $default != null:
return $default(_that.id,_that.cardId,_that.userId,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? cardId,  int? userId,  String? body,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _KanbanComment():
return $default(_that.id,_that.cardId,_that.userId,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? cardId,  int? userId,  String? body,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _KanbanComment() when $default != null:
return $default(_that.id,_that.cardId,_that.userId,_that.body,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KanbanComment implements KanbanComment {
  const _KanbanComment({this.id, this.cardId, this.userId, this.body, this.createdAt});
  factory _KanbanComment.fromJson(Map<String, dynamic> json) => _$KanbanCommentFromJson(json);

@override final  String? id;
@override final  String? cardId;
@override final  int? userId;
@override final  String? body;
@override final  String? createdAt;

/// Create a copy of KanbanComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KanbanCommentCopyWith<_KanbanComment> get copyWith => __$KanbanCommentCopyWithImpl<_KanbanComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KanbanCommentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KanbanComment&&(identical(other.id, id) || other.id == id)&&(identical(other.cardId, cardId) || other.cardId == cardId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,cardId,userId,body,createdAt);
}

@override
String toString() {
    return 'KanbanComment(id: $id, cardId: $cardId, userId: $userId, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$KanbanCommentCopyWith<$Res> implements $KanbanCommentCopyWith<$Res> {
  factory _$KanbanCommentCopyWith(_KanbanComment value, $Res Function(_KanbanComment) _then) = __$KanbanCommentCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? cardId, int? userId, String? body, String? createdAt
});




}
/// @nodoc
class __$KanbanCommentCopyWithImpl<$Res>
    implements _$KanbanCommentCopyWith<$Res> {
  __$KanbanCommentCopyWithImpl(this._self, this._then);

  final _KanbanComment _self;
  final $Res Function(_KanbanComment) _then;

/// Create a copy of KanbanComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? cardId = freezed,Object? userId = freezed,Object? body = freezed,Object? createdAt = freezed,}) {
  return _then(_KanbanComment(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,cardId: freezed == cardId ? _self.cardId : cardId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
