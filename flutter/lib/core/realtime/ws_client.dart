import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:web_socket_channel/web_socket_channel.dart';

enum WsState { connecting, open, reconnecting, closed }

/// Reconnecting JSON WebSocket client for the ddagent gateway paths
/// (`/ws`, `/shell`, `/browser-view`, `/desktop-notifications`).
///
/// The server pings each socket on an interval and drops sockets that miss a
/// pong — `web_socket_channel` answers protocol pings automatically, so no
/// app-level heartbeat is needed. Exponential backoff (1s → 30s, jitter)
/// drives reconnects; [urlBuilder] is re-invoked per attempt so `?token=`
/// always carries a fresh JWT. Heartbeats/reconnect state surface on [states].
class WsClient {
  WsClient({required this.urlBuilder, this.maxAttempts});

  /// Invoked before every connect attempt (fresh query token each time).
  final Future<Uri> Function() urlBuilder;

  /// Max consecutive reconnect attempts; null = retry forever.
  final int? maxAttempts;

  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  bool _closing = false;
  int _attempt = 0;

  Stream<Map<String, dynamic>> get frames => _frames.stream;
  Stream<WsState> get states => _states.stream;
  WsState _state = WsState.closed;
  WsState get state => _state;

  /// JSON frame to the server. Throws if the socket is not open — callers
  /// should await [states] == open or use a channel-scoped helper.
  void send(Map<String, dynamic> frame) {
    final channel = _channel;
    if (_state != WsState.open || channel == null) {
      throw StateError('WebSocket is not open');
    }
    channel.sink.add(jsonEncode(frame));
  }

  Future<void> connect() async {
    _closing = false;
    _attempt = 0;
    await _connectOnce();
  }

  Future<void> _connectOnce() async {
    _setState(_attempt == 0 ? WsState.connecting : WsState.reconnecting);
    final uri = await urlBuilder();
    try {
      final channel = WebSocketChannel.connect(uri);
      _channel = channel;
      await channel.ready;
    } on WebSocketChannelException {
      return _scheduleReconnect();
    }
    _attempt = 0;
    _setState(WsState.open);
    await _sub?.cancel();
    _sub = _channel!.stream.listen(
      _onData,
      onDone: _onDone,
      onError: (Object _) => _onDone(),
      cancelOnError: true,
    );
  }

  void _onData(dynamic raw) {
    try {
      final decoded = jsonDecode(raw as String);
      if (decoded is Map<String, dynamic>) _frames.add(decoded);
    } on FormatException {
      // Non-JSON frames are not part of the gateway protocol — ignore.
    }
  }

  void _onDone() {
    _channel = null;
    if (_closing) {
      _setState(WsState.closed);
      return;
    }
    _scheduleReconnect();
  }

  Future<void> _scheduleReconnect() async {
    if (_closing) {
      _setState(WsState.closed);
      return;
    }
    _attempt++;
    if (maxAttempts != null && _attempt > maxAttempts!) {
      _setState(WsState.closed);
      return;
    }
    final seconds = min(30, pow(2, _attempt - 1).toInt());
    final jitter = Random().nextDouble() * 0.4 * seconds;
    _setState(WsState.reconnecting);
    await Future<void>.delayed(Duration(milliseconds: (seconds * 1000 + jitter * 1000).round()));
    if (!_closing) await _connectOnce();
  }

  void _setState(WsState next) {
    _state = next;
    _states.add(next);
  }

  Future<void> close() async {
    _closing = true;
    await _sub?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _setState(WsState.closed);
  }

  Future<void> dispose() async {
    await close();
    await _frames.close();
    await _states.close();
  }
}
