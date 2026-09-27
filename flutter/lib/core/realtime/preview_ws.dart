/// Preview WS tunneling (Task 6.9).
///
/// The preview proxy forwards both HTTP and raw WS upgrades mounted under
/// `/api/preview/<port>/<upstream-path>`. Auth on upgrade requests comes from
/// the `ddagent_preview_token` HttpOnly cookie or a `?token=<jwt>` query param
/// (the proxy strips it before forwarding to the dev server).
///
/// Dev servers that emit absolute root paths need a matching `base` config —
/// the proxy is byte-transparent (no HTML rewriting).
library;

/// Maps a localhost dev-server URL to a tunneled URL under the preview mount.
///
/// ```dart
/// previewTunnelUrl(baseUrl: 'https://server', port: 5173, upstreamPath: '/ws')
/// // → 'wss://server/api/preview/5173/ws?token=<jwt>'
/// ```
Uri previewTunnelUrl({
  required String baseUrl,
  required int port,
  String upstreamPath = '/',
  String? token,
}) {
  final base = Uri.parse(baseUrl);
  final scheme = switch (base.scheme) {
    'https' || 'wss' => 'wss',
    _ => 'ws',
  };
  final path = upstreamPath.startsWith('/') ? upstreamPath : '/$upstreamPath';
  return Uri(
    scheme: scheme,
    host: base.host,
    port: base.hasPort ? base.port : null,
    path: '/api/preview/$port$path',
    queryParameters: {'token': ?token},
  );
}
