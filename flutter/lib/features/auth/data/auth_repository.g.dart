// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  role: json['role'] as String?,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'role': instance.role,
};

_AuthStatus _$AuthStatusFromJson(Map<String, dynamic> json) => _AuthStatus(
  needsSetup: json['needsSetup'] as bool,
  authenticated: json['authenticated'] as bool? ?? false,
);

Map<String, dynamic> _$AuthStatusToJson(_AuthStatus instance) => <String, dynamic>{
  'needsSetup': instance.needsSetup,
  'authenticated': instance.authenticated,
};
