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
  bool get isError => type == 'error';
  bool get isAuthUrl => type == 'auth_url';
}

/// `/shell` PTY channel (Task 6.5).
///
/// Inbound:  init | input {data} | resize {cols, rows}
/// Outbound: output {data: ANSI} | auth_url {url, autoOpen} | error {message}
///
/// PTY sessions are keyed server-side by `<projectPath>_<sessionId>[_cmd_*]`;
/// on reconnect the same key re-attaches and the server replays its output
/// ring buffer — so [init] is re-sent automatically on every reconnect.
class ShellChannel {
  ShellChannel(this._ws);

  final WsClient _ws;
  final _framesOut = StreamController<ShellFrame>.broadcast();
  StreamSubscription<Map<String, dynamic>>? _sub;
  Map<String, dynamic>? _initFrame;

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
    };
    if (_ws.state == WsState.open) _ws.send(_initFrame!);
  }

  /// Binds frames + auto re-init on reconnect. Call once.
  void start() {
    _sub ??= _ws.frames.listen((raw) => _framesOut.add(ShellFrame(raw: raw)));
    _ws.states.listen((s) {
      if (s == WsState.open && _initFrame != null) _ws.send(_initFrame!);
    });
  }

  void input(String data) => _ws.send({'type': 'input', 'data': data});
  void resize(int cols, int rows) =>
      _ws.send({'type': 'resize', 'cols': cols, 'rows': rows});

  Future<void> connect() => _ws.connect();
  Future<void> close() => _ws.close();

  Future<void> dispose() async {
    await _sub?.cancel();
    await _framesOut.close();
  }
}
