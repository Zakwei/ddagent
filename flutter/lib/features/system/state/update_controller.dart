import 'package:ddagent_app/features/system/data/app_update_installer.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Numeric dot-version compare — port of `compareVersions` in
/// `useVersionCheck.ts`. Positive if [a] > [b].
int compareVersions(String a, String b) {
  final pa = a.split('.').map(int.tryParse).map((p) => p ?? 0).toList();
  final pb = b.split('.').map(int.tryParse).map((p) => p ?? 0).toList();
  for (var i = 0; i < pa.length || i < pb.length; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x - y;
  }
  return 0;
}

/// Strip the `v` prefix a GitHub tag carries (`v1.2.3` → `1.2.3`).
String normalizeVersion(String v) => v.startsWith('v') || v.startsWith('V') ? v.substring(1) : v;

/// `GET /health` — running server version probe (also used after update).
final serverHealthProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) =>
      ref.watch(systemRepositoryProvider).health().catchError((_) => const <String, dynamic>{}),
);

/// `GET /api/system/latest-release` — newest GitHub release (null on failure).
final latestReleaseProvider = FutureProvider.autoDispose<Release?>(
  (ref) => ref.watch(systemRepositoryProvider).latestRelease().catchError((_) => null),
);

/// Whether the server is behind the latest GitHub release — the web client's
/// `useVersionCheck` (latest tag vs the version /health reports).
final updateAvailableProvider = Provider.autoDispose<bool>((ref) {
  final release = ref.watch(latestReleaseProvider).value;
  final health = ref.watch(serverHealthProvider).value;
  final running = health?['version']?.toString();
  if (release == null || running == null || running.isEmpty) return false;
  return compareVersions(normalizeVersion(release.tagName), running) > 0;
});

/// Installs a newer APK of this app (Android only; an inert stub elsewhere).
final appUpdateInstallerProvider = Provider<AppUpdateInstaller>((ref) => AppUpdateInstaller());

/// Installed app version (`package_info_plus`) — the baseline for app updates,
/// deliberately separate from the server version `/health` reports.
final appVersionProvider = FutureProvider.autoDispose<String?>(
  (ref) async => (await PackageInfo.fromPlatform()).version,
);

/// The release asset that updates this app — the Android APK, if published.
final appUpdateAssetProvider = Provider.autoDispose<ReleaseAsset?>((ref) {
  final release = ref.watch(latestReleaseProvider).value;
  if (release == null) return null;
  for (final asset in release.assets) {
    if (asset.name.endsWith('.apk')) return asset;
  }
  return null;
});

/// Whether this build can install a downloaded APK (Android). A provider rather
/// than a direct [AppUpdateInstaller] read so tests can exercise the update
/// logic on a host where the platform check is false.
final appUpdateSupportedProvider = Provider<bool>((ref) => AppUpdateInstaller.supported);

/// Whether THIS app is behind the latest release on a platform that can install
/// the APK itself. Distinct from [updateAvailableProvider], which tracks the
/// connected server falling behind — on a phone the two are unrelated.
final appUpdateAvailableProvider = Provider.autoDispose<bool>((ref) {
  if (!ref.watch(appUpdateSupportedProvider)) return false;
  final release = ref.watch(latestReleaseProvider).value;
  final installed = ref.watch(appVersionProvider).value;
  if (release == null || installed == null || installed.isEmpty) return false;
  return compareVersions(normalizeVersion(release.tagName), installed) > 0;
});
