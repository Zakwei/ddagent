// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) => _ApiKey(
  id: json['id'] as String?,
  name: json['name'] as String?,
  prefix: json['prefix'] as String?,
  createdAt: json['createdAt'] as String?,
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$ApiKeyToJson(_ApiKey instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'prefix': instance.prefix,
  'createdAt': instance.createdAt,
  'enabled': instance.enabled,
};

_Credential _$CredentialFromJson(Map<String, dynamic> json) => _Credential(
  id: json['id'] as String,
  credentialName: json['credentialName'] as String?,
  credentialType: json['credentialType'] as String?,
);

Map<String, dynamic> _$CredentialToJson(_Credential instance) => <String, dynamic>{
  'id': instance.id,
  'credentialName': instance.credentialName,
  'credentialType': instance.credentialType,
};
