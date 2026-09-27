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
    _sub ??= _ws.frames.listen(
      (raw) => _framesOut.add(BrowserViewFrame(raw: raw)),
    );
  }

  void startView({String? url, int? width, int? height}) => _ws.send({
    'type': 'start',
    'url': ?url,
    'width': ?width,
    'height': ?height,
  });
  void navigate(String url) => _ws.send({'type': 'navigate', 'url': url});
  void back() => _ws.send({'type': 'back'});
  void forward() => _ws.send({'type': 'forward'});
  void reload() => _ws.send({'type': 'reload'});
  void stop() => _ws.send({'type': 'stop'});
  void resizeView(int width, int height) =>
      _ws.send({'type': 'resize', 'width': width, 'height': height});
  void closeView() => _ws.send({'type': 'close'});

  /// event: mousemove|mousedown|mouseup|click|wheel (server-side dispatch).
  void mouse(
    String event, {
    double? x,
    double? y,
    String? button,
    double? deltaY,
  }) => _ws.send({
    'type': 'mouse',
    'event': event,
    'x': ?x,
    'y': ?y,
    'button': ?button,
    'deltaY': ?deltaY,
  });

  /// event: keydown|keyup — `modifiers` is the CDP bitmask.
  void key(
    String event, {
    String? key,
    String? code,
    int? keyCode,
    String? text,
    int? modifiers,
  }) => _ws.send({
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

  Future<void> dispose() async {
    await _sub?.cancel();
    await _framesOut.close();
  }
}
