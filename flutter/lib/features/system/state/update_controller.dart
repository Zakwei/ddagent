import 'dart:async';

import 'package:ddagent_app/features/system/data/app_update_channel.dart';
import 'package:ddagent_app/features/system/data/app_update_installer.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/system_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

// The update checks share the Settings → About providers, so the rail badge and
// the About page always agree on the latest release and the server version.
export 'package:ddagent_app/features/system/state/system_providers.dart'
    show latestReleaseProvider, serverHealthProvider;

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

/// Whether the server is behind the latest GitHub release — the web client's
/// `useVersionCheck` (latest tag vs the version /health reports).
final updateAvailableProvider = Provider.autoDispose<bool>((ref) {
  final release = ref.watch(latestReleaseProvider).value;
  final health = ref.watch(serverHealthProvider).value;
  final running = health?['version']?.toString();
  if (release == null || running == null || running.isEmpty) return false;
  return compareVersions(normalizeVersion(release.tagName), running) > 0;
});

/// Installs a newer build of this app (Android via the system installer, a
/// packaged desktop build by staging and applying on quit; inert on web).
final appUpdateInstallerProvider = Provider<AppUpdateInstaller>((ref) => AppUpdateInstaller());

/// Update channel of this build — Android APK, Linux deb/bundle, Windows
/// setup/zip, or unsupported. A provider so tests can exercise the update logic
/// on a host whose real platform (and install layout) differs.
final appUpdateChannelProvider = Provider<AppUpdateChannel>((ref) => AppUpdateInstaller.channel);

/// Installed app version (`package_info_plus`) — the baseline for app updates,
/// deliberately separate from the server version `/health` reports.
final appVersionProvider = FutureProvider.autoDispose<String?>(
  (ref) async => (await PackageInfo.fromPlatform()).version,
);

/// The release asset that updates this app for [appUpdateChannelProvider]
/// (`.apk` on Android, `.deb`/`.tar.gz` on Linux, `-setup.exe`/`.zip` on
/// Windows), if published.
final appUpdateAssetProvider = Provider.autoDispose<ReleaseAsset?>((ref) {
  final release = ref.watch(latestReleaseProvider).value;
  if (release == null) return null;
  return selectAppUpdateAsset(release.assets, ref.watch(appUpdateChannelProvider));
});

/// Whether this build can install a downloaded update itself.
final appUpdateSupportedProvider = Provider<bool>(
  (ref) => ref.watch(appUpdateChannelProvider) != AppUpdateChannel.unsupported,
);

/// Whether THIS app is behind the latest release on a platform that can install
/// the update itself. Distinct from [updateAvailableProvider], which tracks the
/// connected server falling behind — on a phone the two are unrelated.
final appUpdateAvailableProvider = Provider.autoDispose<bool>((ref) {
  if (!ref.watch(appUpdateSupportedProvider)) return false;
  final release = ref.watch(latestReleaseProvider).value;
  final installed = ref.watch(appVersionProvider).value;
  if (release == null || installed == null || installed.isEmpty) return false;
  return compareVersions(normalizeVersion(release.tagName), installed) > 0;
});

enum DesktopUpdateStage { idle, downloading, ready, failed }

/// Background state of the desktop self-update: nothing yet, downloading the
/// platform artifact, staged and waiting for the next quit, or failed.
@immutable
class DesktopUpdateState {
  const DesktopUpdateState({
    this.stage = DesktopUpdateStage.idle,
    this.version = '',
    this.progress = 0,
    this.error,
  });

  final DesktopUpdateStage stage;

  /// Normalized version being staged ('' when idle).
  final String version;

  /// Download progress in the 0..1 range.
  final double progress;
  final String? error;

  @override
  bool operator ==(Object other) =>
      other is DesktopUpdateState &&
      other.stage == stage &&
      other.version == version &&
      other.progress == progress &&
      other.error == error;

  @override
  int get hashCode => Object.hash(stage, version, progress, error);
}

/// Desktop self-updater. Keeps [latestReleaseProvider]/[appVersionProvider]
/// alive so the check runs once per app start, downloads the platform artifact
/// into the staging dir in the background, and — on quit — hands it to the
/// detached installer (see [applyOnExit]).
class DesktopUpdateController extends Notifier<DesktopUpdateState> {
  DesktopUpdateState _state = const DesktopUpdateState();
  bool _staging = false;

  @override
  DesktopUpdateState build() {
    final channel = ref.watch(appUpdateChannelProvider);
    final release = ref.watch(latestReleaseProvider).value;
    final installed = ref.watch(appVersionProvider).value;
    if (isDesktopChannel(channel) &&
        release != null &&
        installed != null &&
        installed.isNotEmpty &&
        compareVersions(normalizeVersion(release.tagName), installed) > 0) {
      unawaited(Future<void>.microtask(_stage));
    }
    return _state;
  }

  Future<void> _stage() async {
    if (_staging) return;
    _staging = true;
    try {
      final channel = ref.read(appUpdateChannelProvider);
      final release = ref.read(latestReleaseProvider).value;
      final installed = ref.read(appVersionProvider).value;
      if (!isDesktopChannel(channel) || release == null || installed == null) return;
      final version = normalizeVersion(release.tagName);
      final installer = ref.read(appUpdateInstallerProvider);
      if (installed.isEmpty || compareVersions(version, installed) <= 0) {
        // Already current (e.g. the update landed between checks) — drop any
        // stale staged artifact so it is not applied again on quit.
        await installer.clearStaged();
        return;
      }
      final asset = selectAppUpdateAsset(release.assets, channel);
      if (asset == null) {
        _set(DesktopUpdateState(stage: DesktopUpdateStage.failed, version: version));
        return;
      }
      final existing = await installer.readStaged();
      if (existing != null && existing.version == version) {
        _set(DesktopUpdateState(stage: DesktopUpdateStage.ready, version: version, progress: 1));
        return;
      }
      _set(DesktopUpdateState(stage: DesktopUpdateStage.downloading, version: version));
      await installer.stageDownload(
        asset,
        version: version,
        channel: channel,
        onProgress: (progress) {
          if (!ref.mounted) return;
          _set(
            DesktopUpdateState(
              stage: DesktopUpdateStage.downloading,
              version: version,
              progress: progress,
            ),
          );
        },
      );
      _set(DesktopUpdateState(stage: DesktopUpdateStage.ready, version: version, progress: 1));
    } on Object catch (e) {
      _set(
        DesktopUpdateState(stage: DesktopUpdateStage.failed, version: _state.version, error: '$e'),
      );
    } finally {
      _staging = false;
    }
  }

  /// Re-runs the release check and staging — the About "Check for updates"
  /// button. Invalidating the release re-triggers [build].
  void recheck() {
    _set(const DesktopUpdateState());
    ref.invalidate(latestReleaseProvider);
  }

  /// Applies the staged update while the app exits. Safe to call with nothing
  /// staged (no-op).
  Future<void> applyOnExit() async {
    if (!ref.read(appUpdateSupportedProvider)) return;
    await ref.read(appUpdateInstallerProvider).applyStagedOnExit();
  }

  void _set(DesktopUpdateState state) {
    _state = state;
    if (ref.mounted) this.state = state;
  }
}

final desktopUpdateProvider = NotifierProvider<DesktopUpdateController, DesktopUpdateState>(
  DesktopUpdateController.new,
);
