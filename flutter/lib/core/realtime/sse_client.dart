import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

/// One parsed Server-Sent Event: `event:` name (null = default `data:` frame)
/// + decoded JSON `data:` payload.
class SseEvent {
  const SseEvent({this.event, required this.data});

  final String? event;
  final Map<String, dynamic> data;

  String get type => event ?? (data['type'] as String? ?? 'message');
}

/// Minimal SSE reader over a Dio streamed response (Task 6.8).
///
/// Server sends either named frames (`event: x\ndata: {…}\n\n` — search) or
/// `data:`-only frames carrying a `type` field (clone-progress, agent stream).
/// Comment lines (`:`-prefixed) and multi-line data are handled per spec.
class SseClient {
  const SseClient(this._dio);

  final Dio _dio;

  /// Opens `path` as an SSE stream. Throws [DioException] on transport errors.
  Stream<SseEvent> stream(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    String method = 'GET',
    CancelToken? cancelToken,
  }) async* {
    final response = await _dio.request<ResponseBody>(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(
        method: method,
        responseType: ResponseType.stream,
        headers: {'Accept': 'text/event-stream', 'Cache-Control': 'no-cache'},
      ),
      cancelToken: cancelToken,
    );

    String? eventName;
    final dataLines = <String>[];
    await for (final chunk in response.data!.stream) {
      for (final line in utf8.decode(chunk, allowMalformed: true).split('\n')) {
        final trimmed = line.endsWith('\r') ? line.substring(0, line.length - 1) : line;
        if (trimmed.isEmpty) {
          if (dataLines.isNotEmpty) {
            yield SseEvent(event: eventName, data: _decode(dataLines.join('\n')));
          }
          eventName = null;
          dataLines.clear();
        } else if (trimmed.startsWith(':')) {
          continue; // keep-alive comment
        } else if (trimmed.startsWith('event:')) {
          eventName = trimmed.substring(6).trim();
        } else if (trimmed.startsWith('data:')) {
          dataLines.add(trimmed.substring(5).trimLeft());
        }
      }
    }
    if (dataLines.isNotEmpty) {
      yield SseEvent(event: eventName, data: _decode(dataLines.join('\n')));
    }
  }

  static Map<String, dynamic> _decode(String data) {
    try {
      final decoded = jsonDecode(data);
      return decoded is Map<String, dynamic> ? decoded : {'value': decoded};
    } on FormatException {
      return {'raw': data};
    }
  }
}

/// Typed helpers for the three server SSE endpoints.
extension SseEndpoints on SseClient {
  /// GET /api/projects/clone-progress — frames `progress` | `complete` | `error`.
  Stream<SseEvent> cloneProgress({
    required String repoUrl,
    String? githubTokenId,
    String? newGithubToken,
    CancelToken? cancelToken,
  }) => stream(
    '/api/projects/clone-progress',
    queryParameters: {
      'repoUrl': repoUrl,
      'githubTokenId': ?githubTokenId,
      'newGithubToken': ?newGithubToken,
    },
    cancelToken: cancelToken,
  );

  /// GET /api/providers/search/sessions — named events `title-results`,
  /// `result`, `progress`, `done`, `error`.
  Stream<SseEvent> searchSessions(String query, {int limit = 50, CancelToken? cancelToken}) =>
      stream(
        '/api/providers/search/sessions',
        queryParameters: {'q': query, 'limit': '$limit'},
        cancelToken: cancelToken,
      );

  /// POST /api/agent — `data:` frames until `{"type":"done"}`. Forces
  /// `stream: true` so a caller's body can't silently disable streaming.
  Stream<SseEvent> agentStream(Map<String, dynamic> body, {CancelToken? cancelToken}) => stream(
    '/api/agent',
    method: 'POST',
    body: {'stream': true, ...body},
    cancelToken: cancelToken,
  );
}
