import 'package:ddagent_app/features/system/data/system_repository.dart';

/// Web stub: a browser cannot install an APK, so the app never updates itself.
class AppUpdateInstaller {
  AppUpdateInstaller();

  /// Whether this platform can install a downloaded APK over the running app.
  static bool get supported => false;

  Future<bool> canInstallPackages() async => false;

  Future<void> openInstallPermissionSettings() async {}

  Future<void> downloadAndInstall(
    ReleaseAsset asset, {
    void Function(double progress)? onProgress,
  }) async {}
}
