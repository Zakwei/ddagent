// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  sessionId: json['sessionId'] as String,
  provider: json['provider'] as String?,
  providerSessionId: json['providerSessionId'] as String?,
  summary: json['summary'] as String?,
  projectPath: json['projectPath'] as String?,
  lastActivity: json['lastActivity'] as String?,
  createdAt: json['createdAt'] as String?,
  isArchived: json['isArchived'] as bool? ?? false,
  isRunning: json['isRunning'] as bool? ?? false,
);

_SessionsPage _$SessionsPageFromJson(Map<String, dynamic> json) =>
    _SessionsPage(
      sessions:
          (json['sessions'] as List<dynamic>?)
              ?.map((e) => Session.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hasMore: json['hasMore'] as bool? ?? false,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
