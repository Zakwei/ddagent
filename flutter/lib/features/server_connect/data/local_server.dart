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

/// Picks the newest LTS entry for [major] from nodejs.org's dist index
/// (`[{version: 'v22.20.0', lts: 'Jod'}, ...]` — newest first). Returns null
/// when no entry qualifies.
String? latestLtsInMajor(List<dynamic> index, int major) {
  for (final entry in index) {
    if (entry is Map<String, dynamic> &&
        entry['lts'] != false &&
        entry['version'] is String &&
        parseNodeMajorVersion(entry['version'] as String) == major) {
      return entry['version'] as String;
    }
  }
  return null;
}

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
/// tarball, finds (or downloads) a Node 22.x runtime, and spawns/stops the
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

  /// Exact Node.js major the bundle's native modules are built against.
  /// CI compiles better-sqlite3/node-pty with Node 22 (ABI 127) — a newer
  /// system Node (24+) fails to dlopen them, so only 22.x is acceptable.
  static const int requiredNodeMajor = 22;

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

  /// Version the currently-answering server reports via `GET /health` — null
  /// when nothing (or something that isn't ddagent) is listening.
  Future<String?> _runningVersion() async {
    try {
      final res = await _probe.get<dynamic>('$localUrl/health');
      final data = res.data;
      if (res.statusCode == 200 && data is Map<String, dynamic>) {
        return data['version']?.toString();
      }
      return null;
    } on DioException {
      return null;
    }
  }

  /// `~/.ddagent/local-server.json` — the marker every server writes at
  /// startup (`writeLocalServerMarker` in server/index.ts). Identifies an
  /// orphan spawned from *this* bundle install by `appRoot` equal to our
  /// bundle dir (plus a live node pid). A foreign server (systemd, manual
  /// start, another bundle) reports a different appRoot.
  Future<Map<String, dynamic>?> _readLocalMarker() async {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home == null) return null;
    try {
      final marker = File(
        '$home${Platform.pathSeparator}.ddagent${Platform.pathSeparator}local-server.json',
      );
      final decoded = jsonDecode(await marker.readAsString());
      return decoded is Map<String, dynamic> ? decoded : null;
    } on Object {
      return null;
    }
  }

  /// PID of an orphan spawned from *this* bundle — identified by the startup
  /// marker's `appRoot` equal to our bundle dir plus a live `node` image on
  /// the recorded pid — or null. Pre-bundle-detection servers recorded
  /// `installMode: 'npm'` for this same bundle, so the mode isn't checked;
  /// appRoot equality is the real signal. The image check also rejects a
  /// stale marker whose pid was reused by an unrelated process. A foreign
  /// server (systemd, manual start, another bundle) reports a different
  /// appRoot and is never touched.
  Future<int?> _ourBundleOrphanPid() async {
    final marker = await _readLocalMarker();
    final pid = marker?['pid'];
    if (marker == null || pid is! int) return null;
    final bundle = await _bundle;
    final markerRoot = marker['appRoot']?.toString().replaceAll('/', Platform.pathSeparator);
    if (markerRoot == null || markerRoot.toLowerCase() != bundle.path.toLowerCase()) {
      return null;
    }
    return await _isNodeProcess(pid) ? pid : null;
  }

  /// Whether [pid] belongs to a `node` process right now.
  Future<bool> _isNodeProcess(int pid) async {
    try {
      if (_isWindows) {
        final res = await Process.run('tasklist', ['/FI', 'PID eq $pid', '/NH', '/FO', 'CSV']);
        return '${res.stdout}'.toLowerCase().contains('node');
      }
      final comm = await File('/proc/$pid/comm').readAsString();
      return comm.trim().startsWith('node');
    } on Object {
      return false;
    }
  }

  /// SIGTERMs the marked orphan (ours only — verified by
  /// [_ourBundleOrphanPid]) and waits until the port stops answering, so the
  /// fresh spawn can bind.
  Future<void> _killMarkedOrphan(int pid) async {
    Process.killPid(pid);
    await _waitForPortFree();
  }

  /// Stops the process locking the bundle dir — our spawned child or a
  /// marker-verified orphan spawned from this install. A server keeps its
  /// spawn directory as CWD, which blocks renaming `server/` on Windows, so
  /// this runs before every bundle swap. Foreign servers have their own CWD,
  /// never lock our dir, and are left untouched.
  Future<void> _stopBundleProcess() async {
    if (!await _probeAlive()) return;
    if (_process != null) {
      final proc = _process!;
      _process = null;
      proc.kill();
      await _waitForPortFree();
    } else {
      final orphanPid = await _ourBundleOrphanPid();
      if (orphanPid != null) await _killMarkedOrphan(orphanPid);
    }
  }

  /// Polls until nothing answers on [localUrl] (max 5 s) — used after killing
  /// a stale process before respawning.
  Future<void> _waitForPortFree() async {
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (DateTime.now().isBefore(deadline) && await _probeAlive()) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
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

  /// Resolves a Node [requiredNodeMajor].x executable and returns its path.
  ///
  /// Order: system `node` on PATH → cached portable runtime in `nodeDir` →
  /// download the latest LTS from nodejs.org (pinned fallback when the dist
  /// index can't be fetched).
  Future<String> ensureNode() async {
    _requireSupported();
    // 1) System node.
    for (final name in _isWindows ? const ['node', 'node.exe'] : const ['node']) {
      final major = await _nodeMajorOf(name);
      if (major == requiredNodeMajor) return _nodeExe = name;
    }
    // 2) Portable node cached from a previous run.
    final exe = await _portableNodeExe();
    if (await File(exe).exists()) {
      final major = await _nodeMajorOf(exe);
      if (major == requiredNodeMajor) return _nodeExe = exe;
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

  /// Latest LTS **within [requiredNodeMajor]** from the nodejs.org dist
  /// index; [pinnedNodeVersion] when the index can't be fetched or parsed.
  /// The newest LTS overall is a newer major — its ABI won't match the
  /// bundled native modules.
  Future<String> _latestNodeLtsVersion() async {
    try {
      final res = await _dio.get<List<dynamic>>('https://nodejs.org/dist/index.json');
      final found = latestLtsInMajor(res.data ?? const <dynamic>[], requiredNodeMajor);
      if (found != null) return found;
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

  /// Whether any server dir exists on disk — distinguishes "never installed"
  /// (app start must not download) from a broken or partial install that
  /// [install] should recover.
  Future<bool> get hasBundleRemains async {
    final root = await _root;
    for (final name in const ['server', 'server.tmp', 'server.old']) {
      if (await Directory('${root.path}/$name').exists()) return true;
    }
    return false;
  }

  /// Downloads the newest release tarball and extracts it into `server/`.
  /// Skips the download when `.installed.json` already records that version.
  /// When the latest release can't be resolved (offline, GitHub down) an
  /// already-installed bundle is kept as-is instead of erroring — a usable
  /// local server must survive network loss.
  Future<void> install({required void Function(double progress)? onProgress}) async {
    _requireSupported();
    final suffix = tarballSuffixForAbi(_abi)!;
    final root = await _root;
    final bundle = await _bundle;
    final staging = Directory('${root.path}/server.tmp');
    final backup = Directory('${root.path}/server.old');
    // Finish an install interrupted mid-swap: staging holds the complete new
    // bundle while the live dir is missing or half-deleted.
    await _deleteDirQuietly(backup);
    if (await File('${staging.path}/.installed.json').exists() &&
        !await File('${bundle.path}/.installed.json').exists()) {
      await _stopBundleProcess();
      if (await bundle.exists()) await bundle.rename(backup.path);
      await staging.rename(bundle.path);
      await _deleteDirQuietly(backup);
    }
    await _deleteDirQuietly(staging);
    final installed = await installedVersion;
    String serverVersion;
    try {
      serverVersion = await _serverVersion;
    } on Object {
      if (installed != null) {
        _emit(
          LocalServerStatus(stage: LocalServerStage.installing, progress: 1, version: installed),
        );
        return;
      }
      rethrow;
    }
    if (installed != null && sameServerVersion(installed, serverVersion)) {
      onProgress?.call(1);
      _emit(LocalServerStatus(stage: LocalServerStage.installing, progress: 1, version: installed));
      return;
    }
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
      // Extract to a staging dir, then swap with renames: a recursive delete
      // of the live bundle dies halfway on files locked by a still-running
      // server (Windows) and leaves a broken install — renamed dirs stay
      // coherent and locked leftovers go to server.old for next time.
      await staging.create(recursive: true);
      await _tar(['-xf', archive.path, '-C', staging.path]);
      await _stopBundleProcess();
      if (await bundle.exists()) await bundle.rename(backup.path);
      await staging.rename(bundle.path);
      await _deleteDirQuietly(backup);
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
      final running = await _runningVersion();
      // A foreign or already-current server owns the port → adopt as-is.
      // A stale process (older bundle on disk — e.g. an orphan left by an
      // older app build, or our own child after a bundle swap) is replaced,
      // but only when it's provably ours: our spawned `_process`, or a
      // marker-verified bundle orphan. Anything else stays untouched.
      final adopted = version == null || (running != null && sameServerVersion(running, version));
      if (!adopted) await _stopBundleProcess();
      if (await _probeAlive()) {
        _emit(LocalServerStatus(stage: LocalServerStage.running, url: localUrl, version: version));
        return localUrl;
      }
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

  /// Best-effort recursive delete — files locked by a running process
  /// (Windows) are left behind and retried on the next [install] pass.
  Future<void> _deleteDirQuietly(Directory dir) async {
    try {
      if (await dir.exists()) await dir.delete(recursive: true);
    } on Object {
      // A server still running inside this dir holds the locks.
    }
  }
}
