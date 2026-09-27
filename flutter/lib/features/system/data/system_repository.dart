import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_repository.freezed.dart';
part 'system_repository.g.dart';

@freezed
abstract class Release with _$Release {
  const factory Release({
    required String tagName,
    String? name,
    String? body,
    String? publishedAt,
  }) = _Release;

  factory Release.fromJson(Map<String, dynamic> json) => _$ReleaseFromJson(json);
}

/// /api/system — releases feed, self-update, restart.
class SystemRepository {
  const SystemRepository(this._dio);

  final Dio _dio;

  Future<Release?> latestRelease() =>
      apiCall(() => _dio.get<dynamic>('/api/system/latest-release'), (d) {
        if (d is! Map<String, dynamic>) return null;
        return Release.fromJson(d);
      });

  Future<List<Release>> releases() => apiCall(() => _dio.get<dynamic>('/api/system/releases'), (d) {
    final list = d is List ? d : (d as Map<String, dynamic>)['releases'] as List? ?? const [];
    return [for (final r in list) Release.fromJson(r as Map<String, dynamic>)];
  });

  /// Triggers server self-update (spawn + exit on the server side).
  Future<void> update() => apiCall(() => _dio.post<dynamic>('/api/system/update'), (_) {});

  /// Restarts the server process; the connection drops — callers should treat
  /// a transport error here as "restart in progress", not failure.
  Future<void> restart() => apiCall(() => _dio.post<dynamic>('/api/system/restart'), (_) {});
}

final systemRepositoryProvider = Provider<SystemRepository>(
  (ref) => SystemRepository(ref.watch(dioProvider)),
);
