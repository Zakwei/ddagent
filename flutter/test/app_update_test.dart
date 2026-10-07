import 'package:ddagent_app/features/system/data/app_update_channel.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _apk = ReleaseAsset(
  name: 'ddagent-flutter-android-v0.8.8.apk',
  downloadUrl: 'https://example.test/ddagent.apk',
);

const _deb = ReleaseAsset(
  name: 'ddagent-flutter-linux-x64-v0.8.8.deb',
  downloadUrl: 'https://example.test/ddagent.deb',
);

const _tar = ReleaseAsset(
  name: 'ddagent-flutter-linux-x64-v0.8.8.tar.gz',
  downloadUrl: 'https://example.test/ddagent.tar.gz',
);

const _setup = ReleaseAsset(
  name: 'ddagent-flutter-windows-x64-v0.8.8-setup.exe',
  downloadUrl: 'https://example.test/ddagent-setup.exe',
);

const _zip = ReleaseAsset(
  name: 'ddagent-flutter-windows-x64-v0.8.8.zip',
  downloadUrl: 'https://example.test/ddagent.zip',
);

ProviderContainer _container({
  required String latestTag,
  required String installedVersion,
  AppUpdateChannel channel = AppUpdateChannel.android,
  List<ReleaseAsset> assets = const [_apk],
}) {
  final container = ProviderContainer(
    overrides: [
      latestReleaseProvider.overrideWith(
        (ref) async => Release(tagName: latestTag, assets: assets),
      ),
      appVersionProvider.overrideWith((ref) async => installedVersion),
      appUpdateChannelProvider.overrideWithValue(channel),
    ],
  );
  addTearDown(container.dispose);
  // Pin the async providers so their values survive until the assertions.
  container.listen(latestReleaseProvider, (_, _) {}, fireImmediately: true);
  container.listen(appVersionProvider, (_, _) {}, fireImmediately: true);
  return container;
}

Future<void> _settle(ProviderContainer container) async {
  await container.read(latestReleaseProvider.future);
  await container.read(appVersionProvider.future);
}

void main() {
  test('offers an app update when the installed app is behind', () async {
    final container = _container(latestTag: 'v0.8.8', installedVersion: '0.8.7');
    await _settle(container);

    expect(container.read(appUpdateAvailableProvider), isTrue);
    expect(container.read(appUpdateAssetProvider)?.name, 'ddagent-flutter-android-v0.8.8.apk');
  });

  test('does not offer an app update when the installed app is current', () async {
    final container = _container(latestTag: 'v0.8.8', installedVersion: '0.8.8');
    await _settle(container);

    expect(container.read(appUpdateAvailableProvider), isFalse);
  });

  test('does not offer an app update on an unsupported channel', () async {
    final container = _container(
      latestTag: 'v0.8.8',
      installedVersion: '0.8.7',
      channel: AppUpdateChannel.unsupported,
    );
    await _settle(container);

    expect(container.read(appUpdateSupportedProvider), isFalse);
    expect(container.read(appUpdateAvailableProvider), isFalse);
  });

  test('the update is still offered when the release publishes no asset', () async {
    final container = _container(latestTag: 'v0.8.8', installedVersion: '0.8.7', assets: const []);
    await _settle(container);

    expect(container.read(appUpdateAvailableProvider), isTrue);
    expect(container.read(appUpdateAssetProvider), isNull);
  });

  test('picks the deb asset on a Linux deb install', () async {
    final container = _container(
      latestTag: 'v0.8.8',
      installedVersion: '0.8.7',
      channel: AppUpdateChannel.linuxDeb,
      assets: const [_tar, _deb],
    );
    await _settle(container);

    expect(container.read(appUpdateAvailableProvider), isTrue);
    expect(container.read(appUpdateAssetProvider)?.name, _deb.name);
  });

  test('picks the tarball asset on a portable Linux install', () async {
    final container = _container(
      latestTag: 'v0.8.8',
      installedVersion: '0.8.7',
      channel: AppUpdateChannel.linuxBundle,
      assets: const [_deb, _tar],
    );
    await _settle(container);

    expect(container.read(appUpdateAssetProvider)?.name, _tar.name);
  });

  test('picks the setup.exe on a Windows installer install', () async {
    final container = _container(
      latestTag: 'v0.8.8',
      installedVersion: '0.8.7',
      channel: AppUpdateChannel.windowsSetup,
      assets: const [_zip, _setup],
    );
    await _settle(container);

    expect(container.read(appUpdateAssetProvider)?.name, _setup.name);
  });

  test('picks the zip on a portable Windows install', () async {
    final container = _container(
      latestTag: 'v0.8.8',
      installedVersion: '0.8.7',
      channel: AppUpdateChannel.windowsBundle,
      assets: const [_setup, _zip],
    );
    await _settle(container);

    expect(container.read(appUpdateAssetProvider)?.name, _zip.name);
  });
}
