// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  projectId: json['projectId'] as String,
  path: json['path'] as String,
  displayName: json['displayName'] as String,
  fullPath: json['fullPath'] as String?,
  customName: json['customName'] as String?,
  isArchived: json['isArchived'] as bool? ?? false,
  isStarred: json['isStarred'] as bool? ?? false,
  sessions:
      (json['sessions'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ??
      const [],
  sessionMeta: json['sessionMeta'] == null
      ? null
      : SessionMeta.fromJson(json['sessionMeta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'projectId': instance.projectId,
  'path': instance.path,
  'displayName': instance.displayName,
  'fullPath': instance.fullPath,
  'customName': instance.customName,
  'isArchived': instance.isArchived,
  'isStarred': instance.isStarred,
  'sessions': instance.sessions,
  'sessionMeta': instance.sessionMeta,
};

_SessionMeta _$SessionMetaFromJson(Map<String, dynamic> json) => _SessionMeta(
  hasMore: json['hasMore'] as bool? ?? false,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SessionMetaToJson(_SessionMeta instance) => <String, dynamic>{
  'hasMore': instance.hasMore,
  'total': instance.total,
};

_ProjectSessionsPage _$ProjectSessionsPageFromJson(Map<String, dynamic> json) =>
    _ProjectSessionsPage(
      projectId: json['projectId'] as String,
      sessions:
          (json['sessions'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ??
          const [],
      sessionMeta: json['sessionMeta'] == null
          ? null
          : SessionMeta.fromJson(json['sessionMeta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectSessionsPageToJson(_ProjectSessionsPage instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'sessions': instance.sessions,
      'sessionMeta': instance.sessionMeta,
    };
