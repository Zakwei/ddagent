// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Release _$ReleaseFromJson(Map<String, dynamic> json) => _Release(
  tagName: json['tagName'] as String,
  name: json['name'] as String?,
  body: json['body'] as String?,
  publishedAt: json['publishedAt'] as String?,
  htmlUrl: json['htmlUrl'] as String?,
);

Map<String, dynamic> _$ReleaseToJson(_Release instance) => <String, dynamic>{
  'tagName': instance.tagName,
  'name': instance.name,
  'body': instance.body,
  'publishedAt': instance.publishedAt,
  'htmlUrl': instance.htmlUrl,
};
