import 'dart:async';

import 'package:ddagent_app/features/server_connect/data/local_server.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mirrors [LocalServerService.status] into Riverpod — the service owns the
/// process/disk logic, this notifier only forwards status changes and guards
/// the install → start pipeline.
class LocalServerController extends Notifier<LocalServerStatus> {
  late final LocalServerService _service = LocalServerService(
    onStatus: (status) {
      if (ref.mounted) state = status;
    },
  );

  /// Shared in-flight [ensureRunning] so the router guard and widgets can call
  /// it concurrently without double-spawning.
  Future<String?>? _inFlightEnsure;

  /// The update check ran this app session — the router guard calls
  /// [ensureRunning] on every navigation, which must not re-run install()
  /// (disk scans + a network lookup when offline) each time.
  bool _updateChecked = false;

  @override
  LocalServerStatus build() {
    // Deferred — `state` is unavailable while build() is still running.
    unawaited(Future.microtask(refresh));
    return const LocalServerStatus(stage: LocalServerStage.checking);
  }

  /// Re-probe disk + port and update the status.
  Future<void> refresh() => _service.refresh();

  /// Full pipeline: install/update (download skipped when current, installed
  /// bundle kept when offline) → ensure Node → start. Always runs install() —
  /// a running-but-stale process must be replaced with the bundle on disk.
  /// Returns [LocalServerService.localUrl]. Rethrows after pushing the `error`
  /// stage so callers can decide whether to surface it.
  Future<String> installAndStart() async {
    try {
      await _service.install(onProgress: null);
      await _service.ensureNode();
      return await _service.start();
    } on Object catch (e) {
      state = LocalServerStatus(
        stage: LocalServerStage.error,
        message: '$e',
        version: _service.status.version,
      );
      rethrow;
    }
  }

  /// Router-guard safe startup: returns the URL when already running or after
  /// starting an installed bundle; null when nothing is installed — app start
  /// never installs the first bundle silently, but an installed bundle does
  /// self-update on launch (install() skips the download when current).
  Future<String?> ensureRunning() =>
      _inFlightEnsure ??= _ensureRunning().whenComplete(() => _inFlightEnsure = null);

  Future<String?> _ensureRunning() async {
    // No early "running" return: a stale adopted/orphaned process must go
    // through install() + start() so it gets replaced with the bundle on disk.
    if (await _service.installedVersion == null && !await _service.hasBundleRemains) {
      await refresh();
      return null; // nothing installed — app start never auto-downloads.
    }
    if (!_updateChecked) {
      _updateChecked = true;
      try {
        // Installed bundle → refresh to the newest release when reachable;
        // install() already keeps the current one when it matches or the
        // version check fails.
        await _service.install(onProgress: null);
      } on Object {
        // A failed update must not block startup — boot what we have.
      }
    }
    try {
      return await _service.start();
    } on Object {
      return null; // error stage was already set by the service.
    }
  }

  Future<void> stop() => _service.stop();
}

final localServerProvider = NotifierProvider<LocalServerController, LocalServerStatus>(
  LocalServerController.new,
);
