import 'package:ddagent_app/features/system/data/app_update_channel.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';

/// Web stub: a browser can neither install an APK nor replace a desktop build,
/// so the app never updates itself and every call site stays branch-free.
class AppUpdateInstaller {
  AppUpdateInstaller();

  /// No downloadable self-update on web.
  static AppUpdateChannel get channel => AppUpdateChannel.unsupported;

  static bool get supported => false;

  Future<bool> canInstallPackages() async => false;

  Future<void> openInstallPermissionSettings() async {}

  Future<void> downloadAndInstall(
    ReleaseAsset asset, {
    void Function(double progress)? onProgress,
  }) async {}

  Future<StagedUpdate?> readStaged() async => null;

  Future<StagedUpdate> stageDownload(
    ReleaseAsset asset, {
    required String version,
    required AppUpdateChannel channel,
    void Function(double progress)? onProgress,
  }) async => throw UnsupportedError('App self-update is not supported here.');

  Future<void> applyStagedOnExit() async {}

  Future<void> clearStaged() async {}
}
