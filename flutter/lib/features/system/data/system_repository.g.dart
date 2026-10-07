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
  assets:
      (json['assets'] as List<dynamic>?)
          ?.map((e) => ReleaseAsset.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ReleaseAsset>[],
);

Map<String, dynamic> _$ReleaseToJson(_Release instance) => <String, dynamic>{
  'tagName': instance.tagName,
  'name': instance.name,
  'body': instance.body,
  'publishedAt': instance.publishedAt,
  'htmlUrl': instance.htmlUrl,
  'assets': instance.assets,
};

_ReleaseAsset _$ReleaseAssetFromJson(Map<String, dynamic> json) => _ReleaseAsset(
  name: json['name'] as String,
  downloadUrl: json['downloadUrl'] as String,
  size: (json['size'] as num?)?.toInt(),
);

Map<String, dynamic> _$ReleaseAssetToJson(_ReleaseAsset instance) => <String, dynamic>{
  'name': instance.name,
  'downloadUrl': instance.downloadUrl,
  'size': instance.size,
};
