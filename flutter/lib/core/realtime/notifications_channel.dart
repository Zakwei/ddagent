import 'dart:async';

import 'package:ddagent_app/core/realtime/ws_client.dart';

/// One decoded `/desktop-notifications` frame (Task 6.7).
class DesktopNotification {
  const DesktopNotification({required this.raw});

  final Map<String, dynamic> raw;

  String get type => raw['type'] as String? ?? '';
  bool get isNotification => type == 'notification';
  bool get isRegistered => type == 'registered';
  bool get isError => type == 'error';
  String? get id => raw['id'] as String?;
  String? get title =>
      (raw['data'] as Map?)?['title'] as String? ?? raw['title'] as String?;
  String? get body =>
      (raw['data'] as Map?)?['body'] as String? ?? raw['body'] as String?;
}

/// `/desktop-notifications` channel (desktop builds).
///
/// Inbound:  register {deviceId, label?, platform?, appVersion?} |
///           notification_ack
/// Outbound: registered {deviceId, enabled} | notification {id, data…} |
///           error {code, message}
class DesktopNotificationsChannel {
  DesktopNotificationsChannel(this._ws);

  final WsClient _ws;
  final _out = StreamController<DesktopNotification>.broadcast();
  StreamSubscription<Map<String, dynamic>>? _sub;
  StreamSubscription<WsState>? _statesSub;
  Map<String, dynamic>? _registerFrame;

  Stream<DesktopNotification> get notifications => _out.stream;
  Stream<WsState> get states => _ws.states;

  /// Binds frames + auto re-register on reconnect. Call once.
  void start() {
    _sub ??= _ws.frames.listen(
      (raw) => _out.add(DesktopNotification(raw: raw)),
    );
    _statesSub = _ws.states.listen((s) {
      if (s == WsState.open && _registerFrame != null) {
        _ws.send(_registerFrame!);
      }
    });
  }

  /// Registers this device for `notification` frames. Re-sent on reconnect.
  void register({
    required String deviceId,
    String? label,
    String? platform,
    String? appVersion,
  }) {
    _registerFrame = {
      'type': 'register',
      'deviceId': deviceId,
      'label': ?label,
      'platform': ?platform,
      'appVersion': ?appVersion,
    };
    if (_ws.state == WsState.open) _ws.send(_registerFrame!);
  }

  Future<void> connect() => _ws.connect();
  Future<void> close() => _ws.close();

  Future<void> dispose() async {
    await _sub?.cancel();
    await _statesSub?.cancel();
    await _out.close();
    await _ws.dispose();
  }
}
