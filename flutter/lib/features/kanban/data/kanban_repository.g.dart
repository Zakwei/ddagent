// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanban_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KanbanCard _$KanbanCardFromJson(Map<String, dynamic> json) => _KanbanCard(
  cardId: json['cardId'] as String,
  projectId: json['projectId'] as String?,
  title: json['title'] as String?,
  status: json['status'] as String?,
  position: (json['position'] as num?)?.toInt() ?? 0,
);

_KanbanComment _$KanbanCommentFromJson(Map<String, dynamic> json) =>
    _KanbanComment(
      id: json['id'] as String?,
      cardId: json['cardId'] as String?,
      body: json['body'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$KanbanCommentToJson(_KanbanComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardId': instance.cardId,
      'body': instance.body,
      'createdAt': instance.createdAt,
    };
