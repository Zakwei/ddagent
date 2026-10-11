import 'dart:io';

import 'package:ddagent_app/core/platform/instance.dart';
import 'package:ddagent_app/features/server_connect/data/server_profiles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A window opened via "Open in new window" runs as `--server=<url>`: it must
/// land on that server with storage of its own (Hive locks box files per
/// process, so sharing the primary's would leave every box unopened).
void main() {
  tearDown(() {
    pinnedServerUrl = null;
    pinnedServerIsLocal = false;
  });

  test('parses the pinned server and gives it a stable storage dir', () {
    expect(instanceStorageSubdir(), isNull);
    parseInstanceArgs(['--server=https://host.ts.net:8444', '--local']);
    expect(pinnedServerUrl, 'https://host.ts.net:8444');
    expect(pinnedServerIsLocal, isTrue);
    expect(isSecondaryInstance, isTrue);
    expect(instanceStorageSubdir(), 'ddagent-windows/https_host.ts.net_8444');
  });

  test('a pinned window with fresh storage starts on its server', () async {
    final dir = Directory.systemTemp.createTempSync('ddagent_instance_test');
    addTearDown(() async {
      await Hive.close();
      dir.deleteSync(recursive: true);
    });
    Hive.init(dir.path);
    await Hive.openBox<dynamic>('settings');
    parseInstanceArgs(['--server=https://remote:8444']);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    final state = container.read(serverProfilesProvider);
    expect(state.activeUrl, 'https://remote:8444');
    expect(state.profiles.single.url, 'https://remote:8444');
  });
}
