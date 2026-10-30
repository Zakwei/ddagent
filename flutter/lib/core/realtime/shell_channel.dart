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
/// Inbound:  init | input {data} | resize {cols, rows} | claim | terminate | ping
/// Outbound: stream {id} | output {data: ANSI, end?, exitCode?}
///           | auth_url {url, autoOpen} | error {message} | pong
///
/// PTY sessions are keyed server-side by `<projectPath>_<sessionId>[_cmd_*]`;
/// on reconnect the same key re-attaches — so [init] is re-sent automatically
/// on every reconnect, with [reattachFields] (the stream and offset the tab
/// already shows), and the server sends only the output it missed.
/// A PTY with no socket attached keeps running; only [terminate] ends it.
class ShellChannel {
  ShellChannel(this._ws, {this.pongTimeout = const Duration(seconds: 3)});

  final WsClient _ws;
  final _framesOut = StreamController<ShellFrame>.broadcast();
  StreamSubscription<Map<String, dynamic>>? _sub;
  StreamSubscription<WsState>? _statesSub;
  Map<String, dynamic>? _initFrame;

  /// Whether [_initFrame] went out already — only a re-send reattaches.
  bool _initSent = false;

  /// Keystrokes typed while the socket reconnects, sent right after the
  /// re-init — dropping them lost the start of a command typed on return.
  final _pendingInput = StringBuffer();

  /// Bounds [_pendingInput]: a long outage must not replay a wall of keys.
  static const maxPendingInputChars = 4096;

  /// How long [wake] waits for a `pong` before treating an open-looking
  /// socket as dead (a phone's socket can survive sleep only on paper).
  final Duration pongTimeout;
  Timer? _pongTimer;

  /// Fields merged into every re-sent `init` that does not restart the PTY:
  /// the tab's `stream` / `seen` offset and its current `cols` / `rows`.
  Map<String, Object?> Function()? reattachFields;

  /// Panes on this device showing the terminal. While any does, every
  /// (re)attach also [claim]s: the server applies an attaching viewer's size
  /// only when no other device views the PTY.
  int views = 0;

  Stream<ShellFrame> get frames => _framesOut.stream;
  Stream<WsState> get states => _ws.states;

  /// The socket is up — anything sent now reaches the server. Connecting,
  /// reconnecting (possibly in a backoff) and user-closed all count as not.
  bool get isOpen => _ws.state == WsState.open;

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
    // The server attaches a reattaching socket before it reads the next frame.
    if (views > 0) _ws.send({'type': 'claim'});
    if (_pendingInput.isNotEmpty) {
      _ws.send({'type': 'input', 'data': _pendingInput.toString()});
      _pendingInput.clear();
    }
  }

  /// Binds frames + auto re-init on reconnect. Call once.
  void start() {
    _sub ??= _ws.frames.listen((raw) {
      if (raw['type'] == 'pong') {
        _pongTimer?.cancel();
        _pongTimer = null;
        return;
      }
      _framesOut.add(ShellFrame(raw: raw));
    });
    _statesSub = _ws.states.listen((s) {
      if (s == WsState.open && _initFrame != null) {
        _sendInit();
      }
    });
  }

  /// Input while the socket reconnects is queued (up to
  /// [maxPendingInputChars]) and sent after the re-init; on a socket the user
  /// disconnected it is dropped — a disconnected terminal must not throw on
  /// keystrokes.
  void input(String data) {
    if (_ws.state == WsState.open) {
      _ws.send({'type': 'input', 'data': data});
      return;
    }
    if (_ws.state == WsState.closed || _initFrame == null) return;
    if (_pendingInput.length + data.length <= maxPendingInputChars) _pendingInput.write(data);
  }

  void resize(int cols, int rows) {
    if (_ws.state != WsState.open) return;
    _ws.send({'type': 'resize', 'cols': cols, 'rows': rows});
  }

  /// The user looks at this terminal on this device: the PTY takes its size
  /// and it answers the terminal queries, as after a keystroke. Otherwise a
  /// tab another device typed in last stays drawn for that device's screen —
  /// cut lines, the live area below the view, clicks on the wrong rows.
  /// Before the first init the attach itself claims ([views]).
  void claim() {
    if (_ws.state != WsState.open || !_initSent) return;
    _ws.send({'type': 'claim'});
  }

  /// The tab was closed: the server kills the PTY for every device. A socket
  /// that is not open cannot carry it — that PTY outlives the tab.
  void terminate() {
    if (_ws.state != WsState.open) return;
    _ws.send({'type': 'terminate'});
  }

  /// App back in the foreground: a socket dropped while backgrounded may sit
  /// in a reconnect backoff of up to 30 s — retry right away. An open socket
  /// is pinged: one that sat through device sleep can look open while the
  /// server dropped it long ago, so no `pong` within [pongTimeout] reconnects
  /// it (cheap — the server replays only what the tab missed). One the user
  /// disconnected is left alone.
  void wake() {
    if (_ws.state != WsState.open) {
      _ws.reconnectNow();
      return;
    }
    if (_pongTimer != null) return;
    _ws.send({'type': 'ping'});
    _pongTimer = Timer(pongTimeout, () {
      _pongTimer = null;
      _ws.reconnectNow();
    });
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
  Future<void> close() {
    _pongTimer?.cancel();
    _pongTimer = null;
    _pendingInput.clear();
    return _ws.close();
  }

  Future<void> dispose() async {
    _pongTimer?.cancel();
    _pongTimer = null;
    await _sub?.cancel();
    await _statesSub?.cancel();
    await _framesOut.close();
    await _ws.dispose();
  }
}
