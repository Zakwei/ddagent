import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/preview/data/app_preview_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `/api/app-preview` — the preview-target registry shared with the agent's
/// MCP `preview_*` tools.
class AppPreviewRepository {
  const AppPreviewRepository(this._dio);

  final Dio _dio;

  static List<AppPreviewTarget> _targets(dynamic d) {
    final list = d is List ? d : (d as Map<String, dynamic>?)?['previews'] as List? ?? const [];
    return [for (final p in list) ?AppPreviewTarget.fromJson(p)];
  }

  static AppPreviewTarget _target(dynamic d) {
    final m = d as Map<String, dynamic>? ?? const {};
    final t = AppPreviewTarget.fromJson(m['preview'] ?? m);
    if (t == null) throw const FormatException('preview payload missing');
    return t;
  }

  Future<List<AppPreviewTarget>> list() =>
      apiCall(() => _dio.get<dynamic>('/api/app-preview'), _targets);

  Future<AppPreviewTarget> register({
    required String url,
    String? title,
    PreviewPlatform? platform,
    String? device,
    bool? landscape,
    String? projectPath,
  }) => apiCall(
    () => _dio.post<dynamic>(
      '/api/app-preview',
      data: {
        'url': url,
        'title': ?title,
        'platform': ?platform?.name,
        'device': ?device,
        if (landscape != null) 'orientation': landscape ? 'landscape' : 'portrait',
        'projectPath': ?projectPath,
      },
    ),
    _target,
  );

  Future<AppPreviewTarget> update(
    String id, {
    String? url,
    String? title,
    PreviewPlatform? platform,
    String? device,
    bool? landscape,
  }) => apiCall(
    () => _dio.patch<dynamic>(
      '/api/app-preview/${Uri.encodeComponent(id)}',
      data: {
        'url': ?url,
        'title': ?title,
        'platform': ?platform?.name,
        'device': ?device,
        if (landscape != null) 'orientation': landscape ? 'landscape' : 'portrait',
      },
    ),
    _target,
  );

  Future<AppPreviewTarget> reload(String id) => apiCall(
    () => _dio.post<dynamic>('/api/app-preview/${Uri.encodeComponent(id)}/reload'),
    _target,
  );

  Future<void> remove(String id) =>
      apiCall(() => _dio.delete<dynamic>('/api/app-preview/${Uri.encodeComponent(id)}'), (_) {});
}

final appPreviewRepositoryProvider = Provider<AppPreviewRepository>(
  (ref) => AppPreviewRepository(ref.watch(dioProvider)),
);
