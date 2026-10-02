import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Grouped misc surface (T5.19): browser-use, assets, preview ports,
/// tts/stt, agent turns, mcp-server ping. Split into per-feature repos when
/// the matching feature task lands.
class MiscRepository {
  const MiscRepository(this._dio);

  final Dio _dio;

  // --- browser-use ---
  Future<Map<String, dynamic>> browserStatus() =>
      apiCall(() => _dio.get<dynamic>('/api/browser-use/status'), (d) => d as Map<String, dynamic>);
  Future<Map<String, dynamic>> browserSettings() => apiCall(
    () => _dio.get<dynamic>('/api/browser-use/settings'),
    (d) => d as Map<String, dynamic>,
  );
  Future<void> saveBrowserSettings(Map<String, dynamic> body) =>
      apiCall(() => _dio.put<dynamic>('/api/browser-use/settings', data: body), (_) {});
  Future<List<Map<String, dynamic>>> browserSessions() => apiCall(
    () => _dio.get<dynamic>('/api/browser-use/sessions'),
    (d) => d is List
        ? [for (final s in d) s as Map<String, dynamic>]
        : [
            for (final s in (d as Map<String, dynamic>)['sessions'] as List? ?? const [])
              s as Map<String, dynamic>,
          ],
  );
  Future<void> browserStopSession(String sessionId) =>
      apiCall(() => _dio.post<dynamic>('/api/browser-use/sessions/$sessionId/stop'), (_) {});
  Future<void> browserDeleteSession(String sessionId) =>
      apiCall(() => _dio.delete<dynamic>('/api/browser-use/sessions/$sessionId'), (_) {});
  Future<void> browserInstallRuntime() =>
      apiCall(() => _dio.post<dynamic>('/api/browser-use/runtime/install'), (_) {});

  // --- assets (chat attachments) ---
  /// Raw bytes for a stored chat-file attachment (`GET /api/assets/files/:name`).
  Future<Uint8List> downloadAssetFile(String name) => apiCall(
    () => _dio.get<dynamic>(
      '/api/assets/files/${Uri.encodeComponent(name)}',
      options: Options(responseType: ResponseType.bytes),
    ),
    (d) => d is Uint8List ? d : Uint8List.fromList((d as List).cast<int>()),
  );

  Future<Map<String, dynamic>> uploadImage(FormData form) => apiCall(
    () => _dio.post<dynamic>(
      '/api/assets/images',
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    ),
    (d) => d as Map<String, dynamic>,
  );
  Future<Map<String, dynamic>> uploadFile(FormData form) => apiCall(
    () => _dio.post<dynamic>(
      '/api/assets/files',
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    ),
    (d) => d as Map<String, dynamic>,
  );

  // --- preview ---
  Future<Map<String, dynamic>> previewPorts() =>
      apiCall(() => _dio.get<dynamic>('/api/preview/ports'), (d) => d as Map<String, dynamic>);

  // --- tts / stt ---
  Future<Map<String, dynamic>> ttsConfig() =>
      apiCall(() => _dio.get<dynamic>('/api/tts/'), (d) => d as Map<String, dynamic>);
  Future<List<Map<String, dynamic>>> ttsVoices() => apiCall(
    () => _dio.get<dynamic>('/api/tts/voices'),
    (d) => d is List
        ? [for (final v in d) v as Map<String, dynamic>]
        : [
            for (final v in (d as Map<String, dynamic>)['voices'] as List? ?? const [])
              v as Map<String, dynamic>,
          ],
  );

  /// Speech synthesis — returns audio bytes.
  Future<List<int>> ttsSynthesize(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>(
      '/api/tts/',
      data: body,
      options: Options(responseType: ResponseType.bytes),
    ),
    (d) => (d as List).cast<int>(),
  );
  Future<Map<String, dynamic>> sttConfig() =>
      apiCall(() => _dio.get<dynamic>('/api/stt/config'), (d) => d as Map<String, dynamic>);
  Future<void> saveSttConfig(Map<String, dynamic> body) =>
      apiCall(() => _dio.put<dynamic>('/api/stt/config', data: body), (_) {});

  /// Transcribe audio — multipart body with the audio file.
  Future<Map<String, dynamic>> sttTranscribe(FormData form) => apiCall(
    () => _dio.post<dynamic>(
      '/api/stt/',
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    ),
    (d) => d as Map<String, dynamic>,
  );

  // --- agent turn ---
  /// Non-streaming agent turn. The endpoint defaults to SSE
  /// (`stream` undefined → true) — force `stream: false` for a plain JSON
  /// response. For incremental frames use `SseClient.agentStream` instead.
  Future<Map<String, dynamic>> agent(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/agent', data: {'stream': false, ...body}),
    (d) => d as Map<String, dynamic>,
  );

  // --- mcp token management (/api/mcp — token CRUD; the /mcp transport uses
  // mcp_* bearer tokens, not app JWT) ---
  Future<Map<String, dynamic>> mcpTokens() =>
      apiCall(() => _dio.get<dynamic>('/api/mcp/tokens'), (d) => d as Map<String, dynamic>);
}

final miscRepositoryProvider = Provider<MiscRepository>(
  (ref) => MiscRepository(ref.watch(dioProvider)),
);
