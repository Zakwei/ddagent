import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ffi';
import 'dart:io';

import 'package:ddagent_app/features/server_connect/data/local_server_status.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

export 'local_server_status.dart';

/// Parses `node --version` output (`v22.20.0`, `24.0.0`) into a major version.
/// Returns null for anything that doesn't start with `v?<digits>`.
int? parseNodeMajorVersion(String output) {
  final match = RegExp('^v?(\\d+)').firstMatch(output.trim());
  return match == null ? null : int.parse(match.group(1)!);
}

/// GitHub release tarball suffix for a CPU ABI (`Abi.toString()` form, e.g.
/// `linux_x64`). Returns null for ABIs we never publish a bundle for.
String? tarballSuffixForAbi(Abi abi) => switch (abi.toString()) {
  'linux_x64' => 'linux-x64',
  'windows_x64' => 'win-x64',
  // linux_arm64 tarballs may not exist for every release — we still map it
  // and let the download 404 surface as the `error` stage.
  'linux_arm64' => 'linux-arm64',
  _ => null,
};

/// File name of the portable Node distribution on nodejs.org/dist.
String nodeDistFileName(String nodeVersion, {required bool windows, required bool arm64}) => windows
    ? 'node-$nodeVersion-win-x64.zip'
    : 'node-$nodeVersion-linux-${arm64 ? 'arm64' : 'x64'}.tar.xz';

/// Version equality tolerant of a leading `v` (`0.8.0` == `v0.8.0`) — pubspec
/// versions never carry the prefix but release tags/markers might.
bool sameServerVersion(String a, String b) {
  String norm(String v) => v.trim().replaceFirst(RegExp('^v', caseSensitive: false), '');
  return norm(a) == norm(b);
}

/// Release asset URL produced by `scripts/release/build-server-bundle.js`.
String serverAssetUrl(String serverVersion, String suffix) =>
    'https://github.com/Zakwei/ddagent/releases/download/'
    'v$serverVersion/ddagent-server-$serverVersion-$suffix.tar.gz';

/// Manages an on-device ddagent server: downloads the published release
/// tarball, finds (or downloads) a Node >=22 runtime, and spawns/stops the
/// process. Runtime-only state — the only persistence is the extracted bundle
/// on disk. Supported targets: Windows x64, Linux x64/arm64.
class LocalServerService {
  LocalServerService({
    Dio? dio,
    Directory? rootDir,
    Abi? abi,
    bool? isWindows,
    bool? isLinux,
    String? serverVersion,
    this.onStatus,
  }) : _dio = dio ?? Dio(),
       // ignore: prefer_initializing_formals — named params can't be private.
       _rootDir = rootDir,
       _abi = abi ?? Abi.current(),
       _isWindows = isWindows ?? Platform.isWindows,
       _isLinux = isLinux ?? Platform.isLinux,
       _serverVersionOverride = serverVersion;

  /// Alias kept for call sites that referenced the service-level constant.
  static const String localUrl = kLocalServerUrl;
  static const int localPort = 10087;

  /// Minimum Node.js major the server bundle needs.
  static const int minNodeMajor = 22;

  /// Used when nodejs.org's dist index can't be fetched.
  static const String pinnedNodeVersion = 'v22.20.0';

  static const Duration _probeTimeout = Duration(seconds: 2);
  static const Duration _startupTimeout = Duration(seconds: 60);
  static const Duration _pollInterval = Duration(milliseconds: 500);
  static const int _stderrTailBytes = 4096;

  /// Invoked after every internal status change — mirrors [status] for the
  /// Riverpod controller (keeps download progress streaming into `state`).
  final void Function(LocalServerStatus status)? onStatus;

  final Dio _dio;
  final Directory? _rootDir;
  final Abi _abi;
  final bool _isWindows;
  final bool _isLinux;
  final String? _serverVersionOverride;
  String? _resolvedServerVersion;

  /// The spawned server process. Stays null when we adopt a server that was
  /// already answering on [localUrl] — adopted servers are never killed.
  Process? _process;

  String? _nodeExe;
  Dio? _probeClient;

  LocalServerStatus _status = const LocalServerStatus(stage: LocalServerStage.checking);

  LocalServerStatus get status => _status;

  /// True only where a server tarball is published: Windows x64, Linux x64,
  /// Linux arm64. Everything else reports `unsupported` from [refresh] on and
  /// lifecycle calls throw [UnsupportedError].
  bool get isSupported => (_isWindows || _isLinux) && tarballSuffixForAbi(_abi) != null;

  /// `<app-support>/ddagent-local-server/` — holds the extracted bundle and
  /// the portable Node runtime.
  Future<Directory> get _root async =>
      _rootDir ??
      Directory('${(await getApplicationSupportDirectory()).path}/ddagent-local-server');

  /// `<root>/server/` — the extracted release tarball.
  Future<Directory> get _bundle async => Directory('${(await _root).path}/server');

  /// `<root>/node/` — portable Node.js runtime when the system one is missing.
  Future<Directory> get _nodeDir async => Directory('${(await _root).path}/node');

  /// Server version = the newest GitHub release tag, minus the `v` prefix.
  /// The app's own pubspec version is unrelated — server tarballs are
  /// versioned by the repo `package.json`, so the release API is the only
  /// reliable source. Cached; [serverVersion] overrides it (tests).
  Future<String> get _serverVersion async =>
      _resolvedServerVersion ??= _serverVersionOverride ?? await _latestReleaseVersion();

  Future<String> _latestReleaseVersion() async {
    final res = await _dio.get<Map<String, dynamic>>(
      'https://api.github.com/repos/Zakwei/ddagent/releases/latest',
    );
    final tag = res.data?['tag_name'] as String?;
    if (tag == null || tag.isEmpty) {
      throw StateError('Could not resolve the latest ddagent release tag.');
    }
    return tag.replaceFirst(RegExp('^v', caseSensitive: false), '');
  }

  Dio get _probe => _probeClient ??= Dio(
    BaseOptions(connectTimeout: _probeTimeout, receiveTimeout: _probeTimeout),
  );

  void _emit(LocalServerStatus status) {
    _status = status;
    onStatus?.call(status);
  }

  void _requireSupported() {
    if (!isSupported) {
      throw UnsupportedError('Local server is not supported on this platform ($_abi).');
    }
  }

  /// GET /api/auth/status on a short-timeout bare client — 200 means a ddagent
  /// server (ours or foreign) is answering on [localUrl].
  Future<bool> _probeAlive() async {
    try {
      final res = await _probe.get<dynamic>('$localUrl/api/auth/status');
      return res.statusCode == 200;
    } on DioException {
      return false;
    }
  }

  /// Bundle version recorded in `server/.installed.json` (the marker ships
  /// inside the release tarball), or null when nothing is installed.
  Future<String?> get installedVersion async {
    try {
      final marker = File('${(await _bundle).path}/.installed.json');
      if (!await marker.exists()) return null;
      final decoded = jsonDecode(await marker.readAsString());
      return decoded is Map<String, dynamic> ? decoded['version'] as String? : null;
    } on Object {
      return null;
    }
  }

  /// Syncs [status] from disk + the probe: unsupported / notInstalled /
  /// stopped (installed but not answering) / running.
  Future<void> refresh() async {
    if (!isSupported) {
      _emit(const LocalServerStatus(stage: LocalServerStage.unsupported));
      return;
    }
    try {
      final version = await installedVersion;
      if (await _probeAlive()) {
        _emit(LocalServerStatus(stage: LocalServerStage.running, url: localUrl, version: version));
      } else {
        _emit(
          LocalServerStatus(
            stage: version == null ? LocalServerStage.notInstalled : LocalServerStage.stopped,
            version: version,
          ),
        );
      }
    } on Object catch (e) {
      _emit(LocalServerStatus(stage: LocalServerStage.error, message: '$e'));
    }
  }

  /// Resolves a Node >=[minNodeMajor] executable and returns its path/name.
  ///
  /// Order: system `node` on PATH → cached portable runtime in `nodeDir` →
  /// download the latest LTS from nodejs.org (pinned fallback when the dist
  /// index can't be fetched).
  Future<String> ensureNode() async {
    _requireSupported();
    // 1) System node.
    for (final name in _isWindows ? const ['node', 'node.exe'] : const ['node']) {
      final major = await _nodeMajorOf(name);
      if (major != null && major >= minNodeMajor) return _nodeExe = name;
    }
    // 2) Portable node cached from a previous run.
    final exe = await _portableNodeExe();
    if (await File(exe).exists()) {
      final major = await _nodeMajorOf(exe);
      if (major != null && major >= minNodeMajor) return _nodeExe = exe;
    }
    // 3) Download + extract a portable LTS into nodeDir.
    await _downloadPortableNode();
    if (!await File(exe).exists()) {
      throw StateError('Node.js extraction did not produce $exe');
    }
    return _nodeExe = exe;
  }

  Future<String> _portableNodeExe() async =>
      _isWindows ? '${(await _nodeDir).path}/node.exe' : '${(await _nodeDir).path}/bin/node';

  Future<int?> _nodeMajorOf(String exe) async {
    try {
      final res = await Process.run(exe, const ['--version']);
      if (res.exitCode != 0) return null;
      return parseNodeMajorVersion('${res.stdout}');
    } on ProcessException {
      return null;
    }
  }

  /// Latest LTS line from the nodejs.org dist index; [pinnedNodeVersion] when
  /// the index can't be fetched or parsed.
  Future<String> _latestNodeLtsVersion() async {
    try {
      final res = await _dio.get<List<dynamic>>('https://nodejs.org/dist/index.json');
      for (final entry in res.data ?? const <dynamic>[]) {
        if (entry is Map<String, dynamic> && entry['lts'] != false && entry['version'] is String) {
          return entry['version'] as String;
        }
      }
    } on Object {
      // Fall through to the pinned version.
    }
    return pinnedNodeVersion;
  }

  Future<void> _downloadPortableNode() async {
    final nodeVersion = await _latestNodeLtsVersion();
    final file = nodeDistFileName(
      nodeVersion,
      windows: _isWindows,
      arm64: _abi.toString() == 'linux_arm64',
    );
    final root = await _root;
    await root.create(recursive: true);
    final archive = File('${root.path}/$file');
    final nodeDir = await _nodeDir;
    try {
      await _dio.download(
        'https://nodejs.org/dist/$nodeVersion/$file',
        archive.path,
        onReceiveProgress: (received, total) {
          _emit(
            LocalServerStatus(
              stage: LocalServerStage.installing,
              progress: total > 0 ? (received / total).clamp(0.0, 1.0).toDouble() : 0,
              version: _status.version,
            ),
          );
        },
      );
      if (await nodeDir.exists()) await nodeDir.delete(recursive: true);
      await nodeDir.create(recursive: true);
      // Archives contain a top node-<ver>-<plat>-<arch>/ dir — strip it so
      // nodeDir/bin/node (linux) or nodeDir/node.exe (windows) lands directly.
      await _tar(['-xf', archive.path, '-C', nodeDir.path, '--strip-components=1']);
    } finally {
      await _deleteQuietly(archive);
    }
  }

  /// Downloads the newest release tarball and extracts it into `server/`.
  /// Skips the download when `.installed.json` already records that version.
  Future<void> install({required void Function(double progress)? onProgress}) async {
    _requireSupported();
    final suffix = tarballSuffixForAbi(_abi)!;
    final serverVersion = await _serverVersion;
    final installed = await installedVersion;
    if (installed != null && sameServerVersion(installed, serverVersion)) {
      onProgress?.call(1);
      _emit(LocalServerStatus(stage: LocalServerStage.installing, progress: 1, version: installed));
      return;
    }
    final root = await _root;
    await root.create(recursive: true);
    final archive = File('${root.path}/ddagent-server-$serverVersion-$suffix.tar.gz');
    _emit(LocalServerStatus(stage: LocalServerStage.downloading, version: installed));
    try {
      await _dio.download(
        serverAssetUrl(serverVersion, suffix),
        archive.path,
        onReceiveProgress: (received, total) {
          final progress = total > 0 ? (received / total).clamp(0.0, 1.0).toDouble() : 0.0;
          onProgress?.call(progress);
          _emit(
            LocalServerStatus(
              stage: LocalServerStage.downloading,
              progress: progress,
              version: installed,
            ),
          );
        },
      );
    } on Object catch (e) {
      await _deleteQuietly(archive);
      _emit(
        LocalServerStatus(
          stage: LocalServerStage.error,
          message: 'Server download failed: $e',
          version: installed,
        ),
      );
      rethrow;
    }
    _emit(LocalServerStatus(stage: LocalServerStage.installing, progress: 1, version: installed));
    try {
      final bundle = await _bundle;
      // Version bump: wipe first so files removed between releases can't linger.
      if (installed != null && await bundle.exists()) await bundle.delete(recursive: true);
      await bundle.create(recursive: true);
      await _tar(['-xf', archive.path, '-C', bundle.path]);
      _emit(
        LocalServerStatus(stage: LocalServerStage.installing, progress: 1, version: serverVersion),
      );
    } on Object catch (e) {
      _emit(
        LocalServerStatus(
          stage: LocalServerStage.error,
          message: 'Server install failed: $e',
          version: installed,
        ),
      );
      rethrow;
    } finally {
      await _deleteQuietly(archive);
    }
  }

  /// Adopt-or-spawn: when a ddagent already answers on [localUrl] (e.g. an
  /// orphan from a previous app run, or the systemd service on this box) it is
  /// reused as-is and [stop] will leave it alone. Otherwise we spawn
  /// `node dist-server/server/index.js` from the installed bundle and poll the
  /// probe every 500 ms for up to 60 s.
  ///
  /// Port conflicts are reported, never rerouted: a spawn that exits fast with
  /// EADDRINUSE (or stalls while stderr complains about it) surfaces an `error`
  /// status saying port 10087 is taken by another app.
  Future<String> start() async {
    _requireSupported();
    final version = await installedVersion;
    _emit(LocalServerStatus(stage: LocalServerStage.starting, version: version));
    if (await _probeAlive()) {
      _emit(LocalServerStatus(stage: LocalServerStage.running, url: localUrl, version: version));
      return localUrl;
    }
    if (version == null) {
      const message = 'Server bundle is not installed.';
      _emit(const LocalServerStatus(stage: LocalServerStage.error, message: message));
      throw StateError(message);
    }
    final exe = _nodeExe ?? await ensureNode();
    final bundle = await _bundle;
    late final Process proc;
    try {
      proc = await Process.start(
        exe,
        const ['dist-server/server/index.js'],
        workingDirectory: bundle.path,
        environment: {...Platform.environment, 'SERVER_PORT': '$localPort', 'HOST': '127.0.0.1'},
      );
    } on Object catch (e) {
      final message = 'Failed to spawn the local server: $e';
      _emit(LocalServerStatus(stage: LocalServerStage.error, message: message, version: version));
      throw StateError(message);
    }
    _process = proc;
    var exited = false;
    unawaited(proc.exitCode.then<void>((_) => exited = true));
    final stderrTail = StringBuffer();
    proc.stdout
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter())
        .listen((line) => developer.log(line, name: 'ddagent-local'));
    proc.stderr
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter())
        .listen((line) {
          _appendTail(stderrTail, line);
          developer.log(line, name: 'ddagent-local');
        });

    final deadline = DateTime.now().add(_startupTimeout);
    while (DateTime.now().isBefore(deadline)) {
      if (await _probeAlive()) {
        _emit(LocalServerStatus(stage: LocalServerStage.running, url: localUrl, version: version));
        return localUrl;
      }
      if (exited) break;
      await Future<void>.delayed(_pollInterval);
    }

    final stderrText = stderrTail.toString().trim();
    String message;
    if (stderrText.contains('EADDRINUSE')) {
      message = 'Port $localPort is already in use by another application.';
    } else if (exited) {
      final tail = stderrText.length > 300
          ? '…${stderrText.substring(stderrText.length - 300)}'
          : stderrText;
      message = 'Local server exited during startup${tail.isEmpty ? '.' : ': $tail'}';
    } else {
      message = 'Timed out waiting for the local server to start.';
    }
    if (!exited) proc.kill();
    _process = null;
    _emit(LocalServerStatus(stage: LocalServerStage.error, message: message, version: version));
    throw StateError(message);
  }

  /// Kills the spawned server when we own one; an adopted server is left
  /// running. Status becomes `stopped` either way — call [refresh] to re-probe.
  Future<void> stop() async {
    if (!isSupported) return;
    final proc = _process;
    _process = null;
    if (proc != null) proc.kill();
    _emit(LocalServerStatus(stage: LocalServerStage.stopped, version: await installedVersion));
  }

  /// System `tar` — bsdtar on Windows 10+ (reads .zip too), GNU tar on Linux.
  Future<void> _tar(List<String> args) async {
    final proc = await Process.start('tar', args);
    unawaited(proc.stdout.drain<void>());
    final stderr = StringBuffer();
    proc.stderr.transform(const Utf8Decoder(allowMalformed: true)).listen(stderr.write);
    final code = await proc.exitCode;
    if (code != 0) {
      throw StateError('tar ${args.join(' ')} failed (exit $code): ${stderr.toString().trim()}');
    }
  }

  void _appendTail(StringBuffer buffer, String line) {
    buffer.writeln(line);
    if (buffer.length > _stderrTailBytes) {
      final text = buffer.toString();
      buffer
        ..clear()
        ..write(text.substring(text.length - _stderrTailBytes));
    }
  }

  Future<void> _deleteQuietly(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } on Object {
      // Best-effort cleanup of temp archives.
    }
  }
}
