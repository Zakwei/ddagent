import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kanban_repository.freezed.dart';
part 'kanban_repository.g.dart';

enum KanbanStatus { backlog, ready, working, needsDecision, done, archived }

@Freezed(toJson: false)
abstract class KanbanCard with _$KanbanCard {
  const factory KanbanCard({
    required String cardId,
    String? projectId,
    String? title,
    String? status,
    @Default(0) int position,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default({})
    Map<String, dynamic> raw,
  }) = _KanbanCard;

  factory KanbanCard.fromJson(Map<String, dynamic> json) =>
      _$KanbanCardFromJson(json);

  /// API-tolerant parse: `id` alias + raw row preserved.
  static KanbanCard fromApi(Map<String, dynamic> json) =>
      KanbanCard.fromJson({...json, 'cardId': json['cardId'] ?? json['id']})
          .copyWith(raw: json);
}

@freezed
abstract class KanbanComment with _$KanbanComment {
  const factory KanbanComment({
    String? id,
    String? cardId,
    int? userId,
    String? body,
    String? createdAt,
  }) = _KanbanComment;

  factory KanbanComment.fromJson(Map<String, dynamic> json) =>
      _$KanbanCommentFromJson(json);
}

/// /api/kanban — board config, cards CRUD/move/abort, comments.
/// (The agent /report route is card-token guarded and server-side only.)
class KanbanRepository {
  const KanbanRepository(this._dio);

  final Dio _dio;

  Future<List<KanbanCard>> cards(
    String projectId, {
    bool includeArchived = false,
  }) => apiCall(
    () => _dio.get<dynamic>(
      '/api/kanban/cards',
      queryParameters: {
        'project': projectId,
        if (includeArchived) 'includeArchived': '1',
      },
    ),
    (d) {
      final list = d is List
          ? d
          : (d as Map<String, dynamic>)['cards'] as List? ?? const [];
      return [
        for (final c in list) KanbanCard.fromApi(c as Map<String, dynamic>),
      ];
    },
  );

  Future<KanbanCard> create(String projectId, Map<String, dynamic> body) =>
      apiCall(
        () => _dio.post<dynamic>(
          '/api/kanban/cards',
          data: {'projectId': projectId, ...body},
        ),
        (d) => KanbanCard.fromApi(
          (d as Map<String, dynamic>)['card'] as Map<String, dynamic>? ?? d,
        ),
      );

  Future<KanbanCard> update(String cardId, Map<String, dynamic> body) =>
      apiCall(
        () => _dio.patch<dynamic>('/api/kanban/cards/$cardId', data: body),
        (d) => KanbanCard.fromApi(
          (d as Map<String, dynamic>)['card'] as Map<String, dynamic>? ?? d,
        ),
      );

  Future<void> move(String cardId, String status, int position) => apiCall(
    () => _dio.post<dynamic>(
      '/api/kanban/cards/$cardId/move',
      data: {'status': status, 'position': position},
    ),
    (_) {},
  );

  Future<void> abort(String cardId) => apiCall(
    () => _dio.post<dynamic>('/api/kanban/cards/$cardId/abort'),
    (_) {},
  );

  Future<void> delete(String cardId) =>
      apiCall(() => _dio.delete<dynamic>('/api/kanban/cards/$cardId'), (_) {});

  Future<Map<String, dynamic>> boardConfig(String projectId) => apiCall(
    () => _dio.get<dynamic>(
      '/api/kanban/board-config',
      queryParameters: {'project': projectId},
    ),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> saveBoardConfig(String projectId, Map<String, dynamic> body) =>
      apiCall(
        () => _dio.put<dynamic>(
          '/api/kanban/board-config',
          data: {'projectId': projectId, ...body},
        ),
        (_) {},
      );

  Future<List<KanbanComment>> comments(String cardId) => apiCall(
    () => _dio.get<dynamic>('/api/kanban/cards/$cardId/comments'),
    (d) {
      final list = d is List
          ? d
          : (d as Map<String, dynamic>)['comments'] as List? ?? const [];
      return [
        for (final c in list) KanbanComment.fromJson(c as Map<String, dynamic>),
      ];
    },
  );

  Future<void> addComment(String cardId, String body) => apiCall(
    () => _dio.post<dynamic>(
      '/api/kanban/cards/$cardId/comments',
      data: {'body': body},
    ),
    (_) {},
  );
}

final kanbanRepositoryProvider = Provider<KanbanRepository>(
  (ref) => KanbanRepository(ref.watch(dioProvider)),
);
