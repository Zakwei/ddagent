import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collab_repository.freezed.dart';
part 'collab_repository.g.dart';

/// Assignee-picker entry; role is owner/member/viewer.
@freezed
abstract class CollabUser with _$CollabUser {
  const factory CollabUser({
    required int id,
    required String username,
    String? role,
    String? displayName,
  }) = _CollabUser;

  factory CollabUser.fromJson(Map<String, dynamic> json) => _$CollabUserFromJson(json);
}

/// Collab API — `GET /api/users` and `GET /api/activity?projectId=`.
/// Invite management routes are namespaced under /api/collab when mounted.
class CollabRepository {
  const CollabRepository(this._dio);

  final Dio _dio;

  Future<List<CollabUser>> users() => apiCall(() => _dio.get<dynamic>('/api/users'), (d) {
    final list = d is List ? d : (d as Map<String, dynamic>)['users'] as List? ?? const [];
    return [for (final u in list) CollabUser.fromJson(u as Map<String, dynamic>)];
  });

  Future<List<Map<String, dynamic>>> activity(String projectId, {int? limit}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/activity',
      queryParameters: {'projectId': projectId, 'limit': ?limit},
    ),
    (d) {
      final list = d is List ? d : (d as Map<String, dynamic>)['events'] as List? ?? const [];
      return [for (final e in list) e as Map<String, dynamic>];
    },
  );
}

final collabRepositoryProvider = Provider<CollabRepository>(
  (ref) => CollabRepository(ref.watch(dioProvider)),
);
