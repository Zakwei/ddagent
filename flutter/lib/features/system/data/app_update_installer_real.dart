import 'dart:io';

import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Installs a newer ddagent APK on Android through the `ddagent/app_update`
/// channel exposed by MainActivity. Android never installs silently: the
/// system installer takes over and needs the user's "install unknown apps"
/// grant for this app.
class AppUpdateInstaller {
  AppUpdateInstaller({Dio? dio}) : _dio = dio ?? Dio();

  /// A plain Dio on purpose — the GitHub asset URL is public and must never
  /// carry the ddagent server's auth headers.
  final Dio _dio;

  static const _channel = MethodChannel('ddagent/app_update');

  /// Only Android replaces the running app with a downloaded APK.
  static bool get supported => Platform.isAndroid;

  Future<bool> canInstallPackages() async =>
      await _channel.invokeMethod<bool>('canInstallPackages') ?? false;

  Future<void> openInstallPermissionSettings() =>
      _channel.invokeMethod<void>('openInstallPermissionSettings');

  /// Downloads [asset] into the app cache and launches the package installer.
  Future<void> downloadAndInstall(
    ReleaseAsset asset, {
    void Function(double progress)? onProgress,
  }) async {
    final directory = await getTemporaryDirectory();
    // Under <cache>/updates — the only path FileProvider exposes (file_paths.xml).
    final apk = File('${directory.path}/updates/${asset.name}');
    await apk.parent.create(recursive: true);
    await _dio.download(
      asset.downloadUrl,
      apk.path,
      deleteOnError: true,
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress?.call(received / total);
      },
    );
    await _channel.invokeMethod<void>('installApk', {'path': apk.path});
  }
}
