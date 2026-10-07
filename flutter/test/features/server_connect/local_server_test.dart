import 'dart:ffi';

import 'package:ddagent_app/features/server_connect/data/local_server.dart';
import 'package:flutter_test/flutter_test.dart';

/// Looks up an ABI token by its `'os_arch'` name — `Abi` constants are private,
/// so tests pick entries out of `Abi.values` instead of referencing them.
Abi abiNamed(String name) => Abi.values.firstWhere((abi) => abi.toString() == name);

void main() {
  group('parseNodeMajorVersion', () {
    test('parses node --version output', () {
      expect(parseNodeMajorVersion('v24.16.0'), 24);
      expect(parseNodeMajorVersion('v22.20.0\n'), 22);
      expect(parseNodeMajorVersion('24.0.0'), 24);
      expect(parseNodeMajorVersion('  v22.1.0  '), 22);
    });

    test('rejects garbage', () {
      expect(parseNodeMajorVersion('not-node'), isNull);
      expect(parseNodeMajorVersion(''), isNull);
      expect(parseNodeMajorVersion('node v20'), isNull); // version must lead
    });
  });

  group('tarballSuffixForAbi', () {
    test('maps published targets', () {
      expect(tarballSuffixForAbi(abiNamed('linux_x64')), 'linux-x64');
      expect(tarballSuffixForAbi(abiNamed('windows_x64')), 'win-x64');
      // Mapped even though a release may not ship it — the 404 becomes the
      // error stage instead of a pre-emptive block.
      expect(tarballSuffixForAbi(abiNamed('linux_arm64')), 'linux-arm64');
    });

    test('returns null for unpublished ABIs', () {
      for (final name in ['macos_x64', 'macos_arm64', 'windows_arm64', 'android_arm64']) {
        expect(tarballSuffixForAbi(abiNamed(name)), isNull, reason: name);
      }
    });
  });

  group('sameServerVersion', () {
    test('tolerates a leading v', () {
      expect(sameServerVersion('0.8.0', 'v0.8.0'), isTrue);
      expect(sameServerVersion('0.8.0', '0.8.0'), isTrue);
      expect(sameServerVersion(' 0.8.0 ', '0.8.0'), isTrue);
      expect(sameServerVersion('0.8.0', '0.8.1'), isFalse);
    });
  });

  group('isPreservedBundleFile', () {
    test('keeps user env config across a bundle swap', () {
      expect(isPreservedBundleFile('.env'), isTrue);
      expect(isPreservedBundleFile('.env.local'), isTrue);
      expect(isPreservedBundleFile('.env.production'), isTrue);
    });

    test('ignores release-owned files and lookalikes', () {
      expect(isPreservedBundleFile('start.sh'), isFalse);
      expect(isPreservedBundleFile('.installed.json'), isFalse);
      expect(isPreservedBundleFile('.envrc'), isFalse);
      expect(isPreservedBundleFile('env'), isFalse);
      expect(isPreservedBundleFile('dist-server'), isFalse);
    });
  });

  test('serverAssetUrl matches the release workflow naming', () {
    expect(
      serverAssetUrl('0.8.0', 'linux-x64'),
      'https://github.com/Zakwei/ddagent/releases/download/'
      'v0.8.0/ddagent-server-0.8.0-linux-x64.tar.gz',
    );
    expect(
      serverAssetUrl('1.0.0', 'win-x64'),
      'https://github.com/Zakwei/ddagent/releases/download/'
      'v1.0.0/ddagent-server-1.0.0-win-x64.tar.gz',
    );
  });

  group('latestLtsInMajor', () {
    final index = <Map<String, dynamic>>[
      {'version': 'v24.10.0', 'lts': 'Krypton'},
      {'version': 'v24.9.0', 'lts': 'Krypton'},
      {'version': 'v23.6.0', 'lts': false},
      {'version': 'v22.20.0', 'lts': 'Jod'},
      {'version': 'v22.19.0', 'lts': 'Jod'},
      {'version': 'v22.18.0', 'lts': 'Jod'},
      {'version': 'v20.19.0', 'lts': 'Iron'},
    ];

    test('returns the newest LTS within the requested major', () {
      // Newest LTS overall is v24 — the bundle's natives need 22.x.
      expect(latestLtsInMajor(index, 22), 'v22.20.0');
      expect(latestLtsInMajor(index, 24), 'v24.10.0');
      expect(latestLtsInMajor(index, 20), 'v20.19.0');
    });

    test('skips non-LTS majors and misses cleanly', () {
      expect(latestLtsInMajor(index, 23), isNull);
      expect(latestLtsInMajor(index, 18), isNull);
      expect(latestLtsInMajor(const <dynamic>[], 22), isNull);
    });
  });

  group('nodeDistFileName', () {
    test('windows gets the x64 zip', () {
      expect(
        nodeDistFileName('v22.20.0', windows: true, arm64: false),
        'node-v22.20.0-win-x64.zip',
      );
    });

    test('linux gets tarballs per arch', () {
      expect(
        nodeDistFileName('v22.20.0', windows: false, arm64: false),
        'node-v22.20.0-linux-x64.tar.xz',
      );
      expect(
        nodeDistFileName('v22.20.0', windows: false, arm64: true),
        'node-v22.20.0-linux-arm64.tar.xz',
      );
    });
  });
}
