// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_accounts_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderAccount _$ProviderAccountFromJson(Map<String, dynamic> json) => _ProviderAccount(
  id: json['id'] as String,
  provider: json['provider'] as String?,
  label: json['label'] as String?,
  usage: json['usage'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$ProviderAccountToJson(_ProviderAccount instance) => <String, dynamic>{
  'id': instance.id,
  'provider': instance.provider,
  'label': instance.label,
  'usage': instance.usage,
};
