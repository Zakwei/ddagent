import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _apk = ReleaseAsset(
  name: 'ddagent-flutter-android-v0.8.8.apk',
  downloadUrl: 'https://example.test/ddagent.apk',
);

ProviderContainer _container({
  required String latestTag,
  required String installedVersion,
  bool supported = true,
  List<ReleaseAsset> assets = const [_apk],
}) {
  final container = ProviderContainer(
    overrides: [
      latestReleaseProvider.overrideWith((ref) async => Release(tagName: latestTag, assets: assets)),
      appVersionProvider.overrideWith((ref) async => installedVersion),
      appUpdateSupportedProvider.overrideWithValue(supported),
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

  test('does not offer an app update where the platform cannot install an APK', () async {
    final container = _container(
      latestTag: 'v0.8.8',
      installedVersion: '0.8.7',
      supported: false,
    );
    await _settle(container);

    expect(container.read(appUpdateAvailableProvider), isFalse);
  });

  test('the update is still offered when the release publishes no APK asset', () async {
    final container = _container(latestTag: 'v0.8.8', installedVersion: '0.8.7', assets: const []);
    await _settle(container);

    expect(container.read(appUpdateAvailableProvider), isTrue);
    expect(container.read(appUpdateAssetProvider), isNull);
  });
}
