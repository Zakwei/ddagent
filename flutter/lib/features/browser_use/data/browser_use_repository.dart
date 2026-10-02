import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `GET /api/browser-use/status` — runtime readiness + feature flag.
class BrowserUseStatus {
  const BrowserUseStatus({
    this.enabled = false,
    this.available = false,
    this.runtime,
    this.playwrightInstalled = false,
    this.chromiumInstalled = false,
    this.installInProgress = false,
    this.sessionCount = 0,
    this.message,
  });

  final bool enabled;
  final bool available;
  final String? runtime;
  final bool playwrightInstalled;
  final bool chromiumInstalled;
  final bool installInProgress;
  final int sessionCount;
  final String? message;

  static BrowserUseStatus fromJson(Map<String, dynamic> json) => BrowserUseStatus(
    enabled: json['enabled'] == true,
    available: json['available'] == true,
    runtime: json['runtime']?.toString(),
    playwrightInstalled: json['playwrightInstalled'] == true,
    chromiumInstalled: json['chromiumInstalled'] == true,
    installInProgress: json['installInProgress'] == true,
    sessionCount: (json['sessionCount'] as num?)?.toInt() ?? 0,
    message: json['message']?.toString(),
  );
}

/// Headless agent session row from `GET /api/browser-use/sessions`
/// (`PublicBrowserUseSession` — `ownerId` is server-side only).
class BrowserUseSession {
  const BrowserUseSession({
    required this.id,
    this.status = 'unavailable',
    this.url,
    this.title,
    this.screenshotDataUrl,
    this.createdAt,
    this.updatedAt,
    this.lastAction,
    this.message,
    this.profileName,
    this.viewport,
    this.cursor,
    this.raw = const {},
  });

  final String id;
  final String status;
  final String? url;
  final String? title;
  final String? screenshotDataUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? lastAction;
  final String? message;
  final String? profileName;

  /// Remote viewport the screenshot was captured at — pairs with [cursor]
  /// so the overlay can be positioned as a fraction of the frame.
  final ({double width, double height})? viewport;

  /// Agent cursor position in viewport coordinates.
  final ({double x, double y})? cursor;

  final Map<String, dynamic> raw;

  bool get isRunning => status == 'ready';

  static BrowserUseSession fromJson(Map<String, dynamic> json) {
    final viewport = json['viewport'];
    final cursor = json['cursor'];
    return BrowserUseSession(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'unavailable',
      url: json['url']?.toString(),
      title: json['title']?.toString(),
      screenshotDataUrl: json['screenshotDataUrl']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      lastAction: json['lastAction']?.toString(),
      message: json['message']?.toString(),
      profileName: json['profileName']?.toString(),
      viewport: viewport is Map && viewport['width'] != null
          ? (
              width: (viewport['width'] as num).toDouble(),
              height: (viewport['height'] as num?)?.toDouble() ?? 0,
            )
          : null,
      cursor: cursor is Map && cursor['x'] != null
          ? (x: (cursor['x'] as num).toDouble(), y: (cursor['y'] as num?)?.toDouble() ?? 0)
          : null,
      raw: json,
    );
  }
}

/// /api/browser-use — runtime status/install + headless session management.
class BrowserUseRepository {
  const BrowserUseRepository(this._dio);

  final Dio _dio;

  Future<BrowserUseStatus> status() => apiCall(
    () => _dio.get<dynamic>('/api/browser-use/status'),
    (d) => BrowserUseStatus.fromJson(d as Map<String, dynamic>? ?? const {}),
  );

  Future<List<BrowserUseSession>> sessions() =>
      apiCall(() => _dio.get<dynamic>('/api/browser-use/sessions'), (d) {
        final list = d is List ? d : (d as Map<String, dynamic>)['sessions'] as List? ?? const [];
        return [
          for (final s in list)
            if (s is Map) BrowserUseSession.fromJson(Map<String, dynamic>.from(s)),
        ];
      });

  /// `POST /runtime/install` — installs Playwright + Chromium; can take a
  /// while, the server returns the post-install status.
  Future<BrowserUseStatus> installRuntime() =>
      apiCall(() => _dio.post<dynamic>('/api/browser-use/runtime/install'), (d) {
        final m = d as Map<String, dynamic>? ?? const {};
        return BrowserUseStatus.fromJson(m['status'] as Map<String, dynamic>? ?? m);
      });

  Future<void> stopSession(String sessionId) =>
      apiCall(() => _dio.post<dynamic>('/api/browser-use/sessions/$sessionId/stop'), (_) {});

  Future<void> deleteSession(String sessionId) =>
      apiCall(() => _dio.delete<dynamic>('/api/browser-use/sessions/$sessionId'), (_) {});

  Future<Map<String, dynamic>> settings() => apiCall(
    () => _dio.get<dynamic>('/api/browser-use/settings'),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> saveSettings(Map<String, dynamic> body) => apiCall(
    () => _dio.put<dynamic>('/api/browser-use/settings', data: body),
    (d) => d as Map<String, dynamic>,
  );
}

final browserUseRepositoryProvider = Provider<BrowserUseRepository>(
  (ref) => BrowserUseRepository(ref.watch(dioProvider)),
);
