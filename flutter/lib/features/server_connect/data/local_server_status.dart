/// Lifecycle of the self-hosted ddagent server running on this device.
///
/// dart:io-free — shared between the real (io) service implementation and
/// the web/mobile stub so widgets can import the status types on every
/// platform.
enum LocalServerStage {
  /// Platform can't host the server (web/mobile/macOS, or a CPU ABI with no
  /// published tarball — e.g. windows_arm64, linux_ia32).
  unsupported,
  checking,
  notInstalled,
  downloading,
  installing,
  starting,
  running,
  stopped,
  error,
}

/// Fixed loopback URL the local server always binds — the UI pre-fills a
/// server profile with this when local mode is active.
const String kLocalServerUrl = 'http://127.0.0.1:10087';

/// Runtime status of the local server — enums and raw values only, no
/// translated strings (the UI maps `stage`/`message` to i18n keys).
class LocalServerStatus {
  const LocalServerStatus({
    required this.stage,
    this.progress = 0,
    this.message,
    this.url,
    this.version,
  });

  final LocalServerStage stage;

  /// 0..1 while `downloading`/`installing`.
  final double progress;

  /// Error detail or note (not localized).
  final String? message;

  /// [kLocalServerUrl] once running or adopted.
  final String? url;

  /// Bundle version read from `.installed.json`.
  final String? version;

  LocalServerStatus copyWith({
    LocalServerStage? stage,
    double? progress,
    String? message,
    String? url,
    String? version,
  }) => LocalServerStatus(
    stage: stage ?? this.stage,
    progress: progress ?? this.progress,
    message: message ?? this.message,
    url: url ?? this.url,
    version: version ?? this.version,
  );
}
