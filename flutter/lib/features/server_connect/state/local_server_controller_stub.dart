import 'package:ddagent_app/features/server_connect/data/local_server_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Web/mobile stub — no dart:io, no process spawning. Every lifecycle call
/// no-ops and the stage stays `unsupported`, which the UI maps to "not
/// available on this platform" (the card is hidden anyway).
class LocalServerController extends Notifier<LocalServerStatus> {
  @override
  LocalServerStatus build() =>
      const LocalServerStatus(stage: LocalServerStage.unsupported);

  Future<void> refresh() async {}

  Future<String> installAndStart() =>
      throw UnsupportedError('Local server is not supported on this platform.');

  Future<String?> ensureRunning() async => null;

  Future<void> stop() async {}
}

final localServerProvider =
    NotifierProvider<LocalServerController, LocalServerStatus>(
      LocalServerController.new,
    );
