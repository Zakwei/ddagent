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

  @override
  LocalServerStatus build() {
    // Deferred — `state` is unavailable while build() is still running.
    unawaited(Future.microtask(refresh));
    return const LocalServerStatus(stage: LocalServerStage.checking);
  }

  /// Re-probe disk + port and update the status.
  Future<void> refresh() => _service.refresh();

  /// Full pipeline: download (when not installed) → ensure Node → start.
  /// Returns [LocalServerService.localUrl]. Rethrows after pushing the `error`
  /// stage so callers can decide whether to surface it.
  Future<String> installAndStart() async {
    final current = state;
    if (current.stage == LocalServerStage.running && current.url != null) {
      return current.url!;
    }
    try {
      if (await _service.installedVersion == null) {
        await _service.install(onProgress: null);
      }
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
  /// never auto-downloads.
  Future<String?> ensureRunning() =>
      _inFlightEnsure ??= _ensureRunning().whenComplete(() => _inFlightEnsure = null);

  Future<String?> _ensureRunning() async {
    final current = state;
    if (current.stage == LocalServerStage.running && current.url != null) {
      return current.url!;
    }
    if (await _service.installedVersion == null) {
      await refresh();
      return null;
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
