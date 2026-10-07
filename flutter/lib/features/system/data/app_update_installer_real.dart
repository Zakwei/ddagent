import 'dart:convert';
import 'dart:io';

import 'package:ddagent_app/features/system/data/app_update_channel.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Installs a newer build of this app.
///
/// * Android hands a downloaded APK to the system installer through the
///   `ddagent/app_update` channel exposed by MainActivity — Android never
///   installs silently, so the user grants "install unknown apps" once.
/// * Linux/Windows (release builds) download the platform installer/archive
///   into a staging dir and apply it on quit, when the running binary's files
///   are no longer locked.
class AppUpdateInstaller {
  AppUpdateInstaller({Dio? dio}) : _dio = dio ?? Dio();

  /// A plain Dio on purpose — the GitHub asset URL is public and must never
  /// carry the ddagent server's auth headers.
  final Dio _dio;

  static const _channel = MethodChannel('ddagent/app_update');
  static const _stagingDirName = 'ddagent-updates';
  static const _markerName = 'pending.json';

  /// Which artifact updates this build (Android APK / Linux deb / bundle /
  /// Windows setup / zip), or [AppUpdateChannel.unsupported].
  static AppUpdateChannel get channel => channelForHost(
    Platform.isAndroid
        ? AppUpdateHost.android
        : Platform.isWindows
        ? AppUpdateHost.windows
        : Platform.isLinux
        ? AppUpdateHost.linux
        : AppUpdateHost.other,
    executablePath: _executablePath,
    packaged: kReleaseMode,
  );

  /// Whether this build can replace itself (Android, or a packaged desktop).
  static bool get supported => channel != AppUpdateChannel.unsupported;

  static String get _executablePath {
    try {
      return Platform.resolvedExecutable;
    } on Object {
      return '';
    }
  }

  // ---------------------------------------------------------------------------
  // Android (system installer)
  // ---------------------------------------------------------------------------

  Future<bool> canInstallPackages() async =>
      await _channel.invokeMethod<bool>('canInstallPackages') ?? false;

  Future<void> openInstallPermissionSettings() =>
      _channel.invokeMethod<void>('openInstallPermissionSettings');

  /// Downloads [asset] into the app cache and launches the package installer.
  Future<void> downloadAndInstall(
    ReleaseAsset asset, {
    void Function(double progress)? onProgress,
  }) async {
    assert(Platform.isAndroid, 'APK install is Android-only');
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

  // ---------------------------------------------------------------------------
  // Desktop (stage now, install on quit)
  // ---------------------------------------------------------------------------

  /// `<app-support>/ddagent-updates/` — persists across runs so a download
  /// survives until the next quit installs it.
  static Future<Directory> stagingDir() async {
    final support = await getApplicationSupportDirectory();
    return Directory('${support.path}/$_stagingDirName');
  }

  /// The staged update recorded in `pending.json`, or null when nothing (or a
  /// missing artifact) is staged.
  Future<StagedUpdate?> readStaged() async {
    if (!isDesktopChannel(channel)) return null;
    try {
      final marker = File('${(await stagingDir()).path}/$_markerName');
      if (!await marker.exists()) return null;
      final decoded = jsonDecode(await marker.readAsString());
      final staged = decoded is Map<String, dynamic> ? StagedUpdate.fromJson(decoded) : null;
      if (staged == null) return null;
      if (!await File(staged.path).exists()) return null;
      return staged;
    } on Object {
      return null;
    }
  }

  /// Downloads [asset] into the staging dir and records it as pending. Any
  /// previous artifact is removed so only one staged update lingers.
  Future<StagedUpdate> stageDownload(
    ReleaseAsset asset, {
    required String version,
    required AppUpdateChannel channel,
    void Function(double progress)? onProgress,
  }) async {
    final directory = await stagingDir();
    await directory.create(recursive: true);
    final target = File('${directory.path}/${asset.name}');
    final part = File('${target.path}.part');
    await _cleanStaging(keep: target);
    if (await part.exists()) await part.delete();
    await _dio.download(
      asset.downloadUrl,
      part.path,
      deleteOnError: true,
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress?.call((received / total).clamp(0.0, 1.0));
      },
    );
    if (await target.exists()) await target.delete();
    await part.rename(target.path);
    final staged = StagedUpdate(
      version: version,
      assetName: asset.name,
      path: target.path,
      channel: channel,
    );
    await File('${directory.path}/$_markerName')
        .writeAsString(jsonEncode(staged.toJson()), flush: true);
    return staged;
  }

  /// Spawns the detached installer for the staged update. Called on quit, once
  /// the app is about to exit, so the helper's file swap is not blocked by the
  /// running binary.
  Future<void> applyStagedOnExit() async {
    final staged = await readStaged();
    if (staged == null) return;
    final plan = buildDesktopInstallPlan(
      channel: staged.channel,
      assetPath: staged.path,
      executablePath: _executablePath,
      relaunchPath: await _relaunchPath(staged.channel),
      pid: pid,
    );
    final scriptPath = plan.scriptPath;
    if (scriptPath != null && plan.scriptContent != null) {
      final script = File(scriptPath);
      await script.writeAsString(plan.scriptContent!, flush: true);
      if (!Platform.isWindows) await Process.run('chmod', ['+x', script.path]);
    }
    await Process.start(
      plan.executable,
      plan.arguments,
      mode: ProcessStartMode.detached,
      workingDirectory: File(staged.path).parent.path,
    );
    // The installer owns the artifact now; drop the marker so the next quit
    // does not re-run it for the already-installed version. On a failed spawn
    // the marker survives and the update is retried on the next quit.
    await _deleteQuietly(File('${(await stagingDir()).path}/$_markerName'));
  }

  /// Drops the staged artifact + marker (after a successful install or when the
  /// staged version is no longer newer than the running build).
  Future<void> clearStaged() async {
    final directory = await stagingDir();
    if (!await directory.exists()) return;
    await _deleteQuietly(File('${directory.path}/$_markerName'));
    await _cleanStaging(keep: null);
  }

  /// `/usr/bin/ddagent` is the deb's launcher symlink; the portable bundle
  /// relaunches its own executable.
  Future<String> _relaunchPath(AppUpdateChannel channel) async {
    if (channel == AppUpdateChannel.linuxDeb && await File('/usr/bin/ddagent').exists()) {
      return '/usr/bin/ddagent';
    }
    return _executablePath;
  }

  /// Removes every file in the staging dir except [keep] (the marker is left
  /// for its own write to replace).
  Future<void> _cleanStaging({required File? keep}) async {
    final directory = await stagingDir();
    if (!await directory.exists()) return;
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File) continue;
      if (entity.path.endsWith('/$_markerName') || entity.path.endsWith('\\$_markerName')) {
        continue;
      }
      if (keep != null && entity.path == keep.path) continue;
      await _deleteQuietly(entity);
    }
  }

  Future<void> _deleteQuietly(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } on Object {
      // Best-effort cleanup; a locked file is retried on the next pass.
    }
  }
}
