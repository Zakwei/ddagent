import 'dart:async';

import 'package:ddagent_app/core/realtime/ws_client.dart';

/// One decoded `/shell` frame from the server.
class ShellFrame {
  const ShellFrame({required this.raw});

  final Map<String, dynamic> raw;

  String get type => raw['type'] as String? ?? '';

  /// `output` payload (ANSI text — feed straight to the terminal widget).
  String get output => raw['data'] as String? ?? '';
  String? get error => raw['message'] as String?;
  String? get authUrl => raw['url'] as String?;
  bool get authUrlAutoOpen => raw['autoOpen'] == true;
  bool get isOutput => type == 'output';

  /// Output the server re-sends from its buffer on reattach — already seen
  /// (and its terminal queries already answered) when it was live.
  bool get isReplay => raw['replay'] == true;

  /// Stream offset this output frame ends at (absent on banners and older
  /// servers) — what a reattach reports back as `seen`.
  int? get end => raw['end'] as int?;

  /// Set on the server's exit line: the PTY's process ended with this code.
  int? get exitCode => raw['exitCode'] as int?;

  /// `stream` frame: the PTY run whose output follows.
  bool get isStream => type == 'stream';
  String? get streamId => raw['id'] as String?;
  bool get isError => type == 'error';
  bool get isAuthUrl => type == 'auth_url';
}

/// `/shell` PTY channel (Task 6.5).
///
/// Inbound:  init | input {data} | resize {cols, rows} | terminate
/// Outbound: stream {id} | output {data: ANSI, end?} | auth_url {url, autoOpen}
///           | error {message}
///
/// PTY sessions are keyed server-side by `<projectPath>_<sessionId>[_cmd_*]`;
/// on reconnect the same key re-attaches — so [init] is re-sent automatically
/// on every reconnect, with [reattachFields] (the stream and offset the tab
/// already shows), and the server sends only the output it missed.
/// A PTY with no socket attached keeps running; only [terminate] ends it.
class ShellChannel {
  ShellChannel(this._ws);

  final WsClient _ws;
  final _framesOut = StreamController<ShellFrame>.broadcast();
  StreamSubscription<Map<String, dynamic>>? _sub;
  StreamSubscription<WsState>? _statesSub;
  Map<String, dynamic>? _initFrame;

  /// Whether [_initFrame] went out already — only a re-send reattaches.
  bool _initSent = false;

  /// Fields merged into every re-sent `init` that does not restart the PTY:
  /// the tab's `stream` / `seen` offset and its current `cols` / `rows`.
  Map<String, Object?> Function()? reattachFields;

  Stream<ShellFrame> get frames => _framesOut.stream;
  Stream<WsState> get states => _ws.states;

  /// Spawns/reattaches the PTY. Re-sent on reconnect for buffer replay.
  void init({
    required String projectPath,
    String? sessionId,
    String provider = 'claude',
    bool hasSession = false,
    String? initialCommand,
    bool isPlainShell = false,
    bool forceRestart = false,
    Map<String, String>? env,
    int? cols,
    int? rows,
  }) {
    _initFrame = {
      'type': 'init',
      'projectPath': projectPath,
      'sessionId': ?sessionId,
      'provider': provider,
      'hasSession': hasSession,
      'initialCommand': ?initialCommand,
      'isPlainShell': isPlainShell,
      'forceRestart': forceRestart,
      'env': ?env,
      'cols': ?cols,
      'rows': ?rows,
    };
    _initSent = false;
    if (_ws.state == WsState.open) _sendInit();
  }

  /// `forceRestart` applies to the first send only — a reconnect re-sends the
  /// frame to reattach, and must not kill the PTY it just restarted.
  void _sendInit() {
    final frame = _initFrame!;
    final reattach = _initSent && frame['forceRestart'] != true ? reattachFields?.call() : null;
    _ws.send({...frame, ...?reattach});
    _initSent = true;
    _initFrame = {..._initFrame!, 'forceRestart': false};
  }

  /// Binds frames + auto re-init on reconnect. Call once.
  void start() {
    _sub ??= _ws.frames.listen((raw) => _framesOut.add(ShellFrame(raw: raw)));
    _statesSub = _ws.states.listen((s) {
      if (s == WsState.open && _initFrame != null) {
        _sendInit();
      }
    });
  }

  /// Silently drops input while the socket isn't open (web
  /// `sendSocketMessage` guards on readyState the same way) — a
  /// disconnected terminal must not throw on keystrokes.
  void input(String data) {
    if (_ws.state != WsState.open) return;
    _ws.send({'type': 'input', 'data': data});
  }

  void resize(int cols, int rows) {
    if (_ws.state != WsState.open) return;
    _ws.send({'type': 'resize', 'cols': cols, 'rows': rows});
  }

  /// The tab was closed: the server kills the PTY for every device. A socket
  /// that is not open cannot carry it — that PTY outlives the tab.
  void terminate() {
    if (_ws.state != WsState.open) return;
    _ws.send({'type': 'terminate'});
  }

  /// App back in the foreground: a socket dropped while backgrounded may sit
  /// in a reconnect backoff of up to 30 s — retry right away. An open socket
  /// is left alone (a reconnect would replay the buffer for nothing), and so
  /// is one the user disconnected.
  void wake() {
    if (_ws.state != WsState.open) _ws.reconnectNow();
  }

  /// Connect CTA: re-opens a socket the user disconnected, or retries a
  /// dropped one right away. Either way `start()` re-sends init to reattach.
  void reconnect() {
    if (_ws.state == WsState.closed) {
      unawaited(_ws.connect());
    } else {
      wake();
    }
  }

  Future<void> connect() => _ws.connect();
  Future<void> close() => _ws.close();

  Future<void> dispose() async {
    await _sub?.cancel();
    await _statesSub?.cancel();
    await _framesOut.close();
    await _ws.dispose();
  }
}
