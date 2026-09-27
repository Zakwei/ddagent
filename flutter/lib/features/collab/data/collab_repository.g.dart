// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collab_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollabUser _$CollabUserFromJson(Map<String, dynamic> json) => _CollabUser(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  role: json['role'] as String?,
  displayName: json['displayName'] as String?,
);

Map<String, dynamic> _$CollabUserToJson(_CollabUser instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'role': instance.role,
  'displayName': instance.displayName,
};
