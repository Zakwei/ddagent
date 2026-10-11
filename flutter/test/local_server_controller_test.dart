import 'package:ddagent_app/features/server_connect/data/local_server.dart';
import 'package:ddagent_app/features/server_connect/state/local_server_controller_real.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Installed, already-current bundle whose start() succeeds — counts probes.
class _FakeService extends LocalServerService {
  _FakeService({super.onStatus}) : _onStatus = onStatus;

  final void Function(LocalServerStatus status)? _onStatus;
  int starts = 0;

  @override
  Future<String?> get installedVersion async => '1.0.0';

  @override
  Future<void> refresh() async {}

  @override
  Future<void> install({required void Function(double progress)? onProgress}) async {}

  @override
  Future<String> start() async {
    starts++;
    _onStatus?.call(
      const LocalServerStatus(stage: LocalServerStage.running, url: LocalServerService.localUrl),
    );
    return LocalServerService.localUrl;
  }

  @override
  Future<void> stop() async =>
      _onStatus?.call(const LocalServerStatus(stage: LocalServerStage.stopped));
}

void main() {
  test('navigations right after a verified start skip the server probes', () async {
    late _FakeService service;
    final c = ProviderContainer(
      overrides: [
        localServerProvider.overrideWith(
          () => LocalServerController(
            createService: ({onStatus}) => service = _FakeService(onStatus: onStatus),
          ),
        ),
      ],
    );
    addTearDown(c.dispose);
    final ctrl = c.read(localServerProvider.notifier);

    expect(await ctrl.ensureRunning(), LocalServerService.localUrl);
    expect(await ctrl.ensureRunning(), LocalServerService.localUrl);
    expect(service.starts, 1);

    // A stop drops the proof — the next navigation checks (and starts) again.
    await ctrl.stop();
    await ctrl.ensureRunning();
    expect(service.starts, 2);
  });
}
