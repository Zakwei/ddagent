import 'package:ddagent_app/features/system/data/system_repository.dart';

/// Which artifact updates *this* build, derived from the running platform and
/// the install layout (dpkg/Inno vs a portable bundle). Android installs an APK
/// through the system installer; the desktop channels download a platform
/// installer/archive and apply it on quit.
enum AppUpdateChannel { unsupported, android, linuxDeb, linuxBundle, windowsSetup, windowsBundle }

/// Host platform of the running client — the input [channelForHost] resolves.
enum AppUpdateHost { android, linux, windows, other }

/// True for the desktop channels that stage a download and apply it on quit.
bool isDesktopChannel(AppUpdateChannel channel) => switch (channel) {
  AppUpdateChannel.linuxDeb ||
  AppUpdateChannel.linuxBundle ||
  AppUpdateChannel.windowsSetup ||
  AppUpdateChannel.windowsBundle => true,
  AppUpdateChannel.unsupported || AppUpdateChannel.android => false,
};

/// Release-asset name suffix that fits [channel] (null when unsupported).
String? assetSuffixForChannel(AppUpdateChannel channel) => switch (channel) {
  AppUpdateChannel.android => '.apk',
  AppUpdateChannel.linuxDeb => '.deb',
  AppUpdateChannel.linuxBundle => '.tar.gz',
  AppUpdateChannel.windowsSetup => '-setup.exe',
  AppUpdateChannel.windowsBundle => '.zip',
  AppUpdateChannel.unsupported => null,
};

/// Picks the release asset matching [channel], or null when the release
/// publishes nothing for it.
ReleaseAsset? selectAppUpdateAsset(List<ReleaseAsset> assets, AppUpdateChannel channel) {
  final suffix = assetSuffixForChannel(channel);
  if (suffix == null) return null;
  for (final asset in assets) {
    if (asset.name.toLowerCase().endsWith(suffix)) return asset;
  }
  return null;
}

/// `/opt/ddagent/...` (or the `/usr/bin/ddagent` symlink) is a dpkg install;
/// anything else is a portable bundle the user extracted somewhere.
bool isDebInstallExecutable(String executablePath) =>
    executablePath.startsWith('/opt/ddagent/') || executablePath == '/usr/bin/ddagent';

/// `C:\Program Files\ddagent\ddagent_app.exe` comes from the Inno Setup
/// installer; anything else is a portable zip.
bool isWindowsInstallerExecutable(String executablePath) {
  final normalized = executablePath.toLowerCase().replaceAll('\\', '/');
  return normalized.contains('/program files') || normalized.contains('/programdata/ddagent');
}

/// Resolves the update channel from the host, the installer layout and whether
/// this is a packaged (release-mode) build. Debug builds never self-update.
AppUpdateChannel channelForHost(
  AppUpdateHost host, {
  required String executablePath,
  required bool packaged,
}) {
  switch (host) {
    case AppUpdateHost.android:
      return AppUpdateChannel.android;
    case AppUpdateHost.linux:
      if (!packaged) return AppUpdateChannel.unsupported;
      return isDebInstallExecutable(executablePath)
          ? AppUpdateChannel.linuxDeb
          : AppUpdateChannel.linuxBundle;
    case AppUpdateHost.windows:
      if (!packaged) return AppUpdateChannel.unsupported;
      return isWindowsInstallerExecutable(executablePath)
          ? AppUpdateChannel.windowsSetup
          : AppUpdateChannel.windowsBundle;
    case AppUpdateHost.other:
      return AppUpdateChannel.unsupported;
  }
}

/// A desktop update downloaded into the staging dir and waiting for the next
/// quit. Persisted as `pending.json` next to the artifact.
class StagedUpdate {
  const StagedUpdate({
    required this.version,
    required this.assetName,
    required this.path,
    required this.channel,
  });

  /// Normalized release version (no `v` prefix).
  final String version;
  final String assetName;

  /// Absolute path of the downloaded installer/archive.
  final String path;
  final AppUpdateChannel channel;

  Map<String, dynamic> toJson() => {
    'version': version,
    'assetName': assetName,
    'path': path,
    'channel': channel.name,
  };

  static StagedUpdate? fromJson(Map<String, dynamic> json) {
    final version = json['version'];
    final assetName = json['assetName'];
    final path = json['path'];
    final channelName = json['channel'];
    if (version is! String || assetName is! String || path is! String) return null;
    final channel = AppUpdateChannel.values.where((c) => c.name == channelName).firstOrNull;
    if (channel == null || !isDesktopChannel(channel)) return null;
    return StagedUpdate(version: version, assetName: assetName, path: path, channel: channel);
  }
}

/// A detached command that installs a staged desktop update once the current
/// process has exited. [scriptPath]/[scriptContent] are set when the platform
/// needs a helper script (portable bundles, Linux deb relaunch).
class DesktopInstallPlan {
  const DesktopInstallPlan({
    required this.executable,
    this.arguments = const <String>[],
    this.scriptPath,
    this.scriptContent,
  });

  final String executable;
  final List<String> arguments;
  final String? scriptPath;
  final String? scriptContent;
}

/// Inno Setup switches that upgrade in place: silent, no reboot, and let the
/// Restart Manager close the running app and relaunch it afterwards.
const List<String> kWindowsSetupArguments = <String>[
  '/VERYSILENT',
  '/SUPPRESSMSGBOXES',
  '/NORESTART',
  '/CLOSEAPPLICATIONS',
  '/RESTARTAPPLICATIONS',
];

/// Builds the detached install command for a staged desktop update.
///
/// The generated helper scripts wait for [pid] to disappear so the running
/// app's files are unlocked before the swap, then relaunch [relaunchPath].
DesktopInstallPlan buildDesktopInstallPlan({
  required AppUpdateChannel channel,
  required String assetPath,
  required String executablePath,
  required String relaunchPath,
  required int pid,
}) {
  final scriptDirectory = _dirName(assetPath);
  switch (channel) {
    case AppUpdateChannel.windowsSetup:
      // The installer owns the swap; no helper script needed.
      return DesktopInstallPlan(executable: assetPath, arguments: kWindowsSetupArguments);
    case AppUpdateChannel.windowsBundle:
      final script = '$scriptDirectory${_sep(executablePath)}apply-update.ps1';
      return DesktopInstallPlan(
        executable: 'powershell',
        arguments: [
          '-NoProfile',
          '-ExecutionPolicy',
          'Bypass',
          '-File',
          script,
          '$pid',
          assetPath,
          _dirName(executablePath),
          executablePath,
        ],
        scriptPath: script,
        scriptContent: _windowsBundleScript,
      );
    case AppUpdateChannel.linuxDeb:
      final script = '$scriptDirectory/apply-update.sh';
      return DesktopInstallPlan(
        executable: 'sh',
        arguments: [script, '$pid', assetPath, relaunchPath],
        scriptPath: script,
        scriptContent: _linuxScript,
      );
    case AppUpdateChannel.linuxBundle:
      final script = '$scriptDirectory/apply-update.sh';
      return DesktopInstallPlan(
        executable: 'sh',
        arguments: [script, '$pid', assetPath, _dirName(_dirName(executablePath)), executablePath],
        scriptPath: script,
        scriptContent: _linuxBundleScript,
      );
    case AppUpdateChannel.android || AppUpdateChannel.unsupported:
      throw ArgumentError('No desktop install plan for $channel');
  }
}

/// POSIX helper: wait for the app to exit, then either install a .deb (deb) or
/// unpack the release tarball over the bundle (bundle), and relaunch.
const String _linuxScript = r'''#!/bin/sh
pid="$1"; asset="$2"; target="$3"
while kill -0 "$pid" 2>/dev/null; do sleep 0.5; done
pkexec dpkg -i "$asset" || exit 1
setsid "$target" >/dev/null 2>&1 &
''';

const String _linuxBundleScript = r'''#!/bin/sh
pid="$1"; archive="$2"; dest="$3"; target="$4"
while kill -0 "$pid" 2>/dev/null; do sleep 0.5; done
tar -xzf "$archive" -C "$dest" || exit 1
setsid "$target" >/dev/null 2>&1 &
''';

/// Windows helper for the portable zip: wait for the app pid, unzip over the
/// install dir, relaunch. PowerShell (not cmd) so quoted paths with spaces are
/// parsed correctly.
const String _windowsBundleScript =
    r'''param([int]$ddagentPid, [string]$zip, [string]$dest, [string]$app)
while (Get-Process -Id $ddagentPid -ErrorAction SilentlyContinue) { Start-Sleep -Milliseconds 500 }
Expand-Archive -Force -LiteralPath $zip -DestinationPath $dest
Start-Process -FilePath $app
''';

/// Separator matching the style of [path] (Windows paths use `\`).
String _sep(String path) => path.contains('\\') ? '\\' : '/';

/// Trailing directory of a path in either separator style; returns '' for a
/// bare file name.
String _dirName(String path) {
  final index = path.lastIndexOf(RegExp(r'[/\\]'));
  return index <= 0 ? '' : path.substring(0, index);
}
