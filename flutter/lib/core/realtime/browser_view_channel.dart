import 'dart:async';

import 'package:ddagent_app/core/realtime/ws_client.dart';

/// One decoded `/browser-view` frame (Task 6.6).
class BrowserViewFrame {
  const BrowserViewFrame({required this.raw});

  final Map<String, dynamic> raw;

  String get type => raw['type'] as String? ?? '';
  bool get isFrame => type == 'frame'; // {data: jpeg/png b64, ...}
  bool get isNavigation => type == 'navigation';
  bool get isReady => type == 'ready';
  bool get isError => type == 'error';
  String? get sessionId => raw['sessionId'] as String?;
  String? get error => raw['error'] as String?;
}

/// `/browser-view` channel — embedded-browser remote control.
///
/// Inbound:  start {url?, width?, height?} | navigate | back | forward |
///           reload | stop | resize | mouse {event,x,y,button?,deltaY?} |
///           key {event,key,code,keyCode,text?,modifiers?} | close
/// Outbound: ready | frame | navigation | error
class BrowserViewChannel {
  BrowserViewChannel(this._ws);

  final WsClient _ws;
  final _framesOut = StreamController<BrowserViewFrame>.broadcast();
  StreamSubscription<Map<String, dynamic>>? _sub;

  Stream<BrowserViewFrame> get frames => _framesOut.stream;
  Stream<WsState> get states => _ws.states;

  void start() {
    _sub ??= _ws.frames.listen((raw) => _framesOut.add(BrowserViewFrame(raw: raw)));
  }

  void startView({String? url, int? width, int? height}) =>
      _ws.send({'type': 'start', 'url': ?url, 'width': ?width, 'height': ?height});
  void navigate(String url) => _ws.send({'type': 'navigate', 'url': url});
  void back() => _ws.send({'type': 'back'});
  void forward() => _ws.send({'type': 'forward'});
  void reload() => _ws.send({'type': 'reload'});
  void stop() => _ws.send({'type': 'stop'});
  void resizeView(int width, int height) =>
      _ws.send({'type': 'resize', 'width': width, 'height': height});
  void closeView() => _ws.send({'type': 'close'});

  /// event: mousemove|mousedown|mouseup|click|wheel (server-side dispatch).
  void mouse(String event, {double? x, double? y, String? button, double? deltaY}) => _ws.send({
    'type': 'mouse',
    'event': event,
    'x': ?x,
    'y': ?y,
    'button': ?button,
    'deltaY': ?deltaY,
  });

  /// event: keydown|keyup — `modifiers` is the CDP bitmask.
  void key(String event, {String? key, String? code, int? keyCode, String? text, int? modifiers}) =>
      _ws.send({
        'type': 'key',
        'event': event,
        'key': ?key,
        'code': ?code,
        'keyCode': ?keyCode,
        'text': ?text,
        'modifiers': ?modifiers,
      });

  Future<void> connect() => _ws.connect();
  Future<void> close() => _ws.close();

  int _views = 0;

  /// A view mounts: always start from a fresh socket. Reusing a live one would
  /// leave the server-side page bound to the old view (`start` is ignored once
  /// a session exists, so the new view never sees `ready`), and calling
  /// [connect] on an open client orphans the previous socket — and with it a
  /// whole Chromium process the server only frees on socket close.
  Future<void> attach() async {
    _views++;
    await _ws.close();
    await _ws.connect();
  }

  /// A view unmounts: once none is left, close the socket so the server tears
  /// the Chromium session down instead of streaming frames to nobody. A pane
  /// moving within the tree attaches its new state before the old one
  /// detaches, so the count never touches zero in that case.
  void detach() {
    if (_views > 0) _views--;
    if (_views == 0) unawaited(_ws.close());
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _framesOut.close();
    await _ws.dispose();
  }
}
