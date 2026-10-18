import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/realtime/browser_view_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/browser/view/browser_key_mapping.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connection + page state the surface reports to its host pane.
class PreviewSurfaceStatus {
  const PreviewSurfaceStatus({
    this.ready = false,
    this.fatal = false,
    this.error,
    this.url = '',
    this.title = '',
    this.loading = false,
    this.canGoBack = false,
  });

  final bool ready;

  /// The server refused to start a page (cap, no Playwright) — needs a retry.
  final bool fatal;
  final String? error;
  final String url;
  final String title;
  final bool loading;
  final bool canGoBack;

  PreviewSurfaceStatus copyWith({
    bool? ready,
    bool? fatal,
    String? Function()? error,
    String? url,
    String? title,
    bool? loading,
    bool? canGoBack,
  }) => PreviewSurfaceStatus(
    ready: ready ?? this.ready,
    fatal: fatal ?? this.fatal,
    error: error != null ? error() : this.error,
    url: url ?? this.url,
    title: title ?? this.title,
    loading: loading ?? this.loading,
    canGoBack: canGoBack ?? this.canGoBack,
  );
}

/// Chromeless remote-Chromium surface for the Preview pane.
///
/// Unlike the browser pane it renders at a *fixed* logical [viewport] (the
/// device's CSS pixels) and lets the device frame scale it; the server page
/// is resized to the same viewport so the app lays out exactly as it would
/// on that device. [device] selects the server's mobile emulation preset.
/// Pointer and keyboard input are forwarded like the browser pane does.
class PreviewBrowserSurface extends ConsumerStatefulWidget {
  const PreviewBrowserSurface({
    super.key,
    required this.paneId,
    required this.viewport,
    this.url,
    this.device,
    this.reloadToken = 0,
    this.onStatus,
  });

  final String paneId;
  final Size viewport;
  final String? url;
  final String? device;

  /// A change asks the page to reload (agent `preview_reload`).
  final int reloadToken;
  final ValueChanged<PreviewSurfaceStatus>? onStatus;

  @override
  ConsumerState<PreviewBrowserSurface> createState() => PreviewBrowserSurfaceState();
}

class PreviewBrowserSurfaceState extends ConsumerState<PreviewBrowserSurface> {
  late final BrowserViewChannel _ch = ref.read(previewViewChannelProvider(widget.paneId));
  final _focus = FocusNode();
  StreamSubscription<BrowserViewFrame>? _frameSub;
  StreamSubscription<WsState>? _stateSub;

  PreviewSurfaceStatus _status = const PreviewSurfaceStatus();
  Uint8List? _frameBytes;
  int _frameW = 0;
  int _frameH = 0;
  int _lastMoveMs = 0;
  String _downButton = 'left';
  String? _currentUrl;

  static bool _isHttp(String? u) =>
      u != null && (u.startsWith('http://') || u.startsWith('https://'));

  @override
  void initState() {
    super.initState();
    _currentUrl = _isHttp(widget.url) ? widget.url : null;
    _frameSub = _ch.frames.listen(_onFrame);
    _stateSub = _ch.states.listen((s) {
      if (!mounted) return;
      if (s == WsState.open && !_status.ready && !_status.fatal) _start();
      if (s == WsState.connecting || s == WsState.reconnecting) {
        _set(_status.copyWith(ready: false));
      }
    });
    unawaited(_ch.attach());
  }

  void _start() {
    _safeSend(
      () => _ch.startView(
        url: _currentUrl,
        width: widget.viewport.width.round(),
        height: widget.viewport.height.round(),
        device: widget.device,
      ),
    );
  }

  void _set(PreviewSurfaceStatus next) {
    if (!mounted) return;
    setState(() => _status = next);
    widget.onStatus?.call(next);
  }

  void _onFrame(BrowserViewFrame f) {
    if (!mounted) return;
    switch (f.type) {
      case 'ready':
        _set(_status.copyWith(ready: true, error: () => null));
      case 'error':
        // Pre-ready errors mean no page at all; the socket closes server-side.
        final fatal = !_status.ready;
        if (fatal) unawaited(_ch.close());
        _set(_status.copyWith(fatal: fatal, error: () => f.error ?? 'error'));
      case 'navigation':
        final url = f.raw['url'] as String? ?? '';
        if (_isHttp(url)) _currentUrl = url;
        final loading = f.raw['loading'] == true;
        _set(
          _status.copyWith(
            url: url,
            title: f.raw['title'] as String? ?? '',
            loading: loading,
            canGoBack: f.raw['canGoBack'] == true,
            error: loading && !_status.fatal ? () => null : null,
          ),
        );
      case 'frame':
        final data = f.raw['data'] as String?;
        if (data == null) return;
        setState(() {
          _frameBytes = base64Decode(data);
          _frameW = (f.raw['width'] as num?)?.toInt() ?? _frameW;
          _frameH = (f.raw['height'] as num?)?.toInt() ?? _frameH;
        });
    }
  }

  void _safeSend(void Function() send) {
    try {
      send();
    } on StateError {
      // Socket not open — drop the event.
    }
  }

  // ─── Public controls (host pane toolbar) ──────────────────────────────────

  void reload() => _safeSend(_ch.reload);
  void back() => _safeSend(_ch.back);
  void navigate(String url) {
    _currentUrl = url;
    _safeSend(() => _ch.navigate(url));
  }

  /// After a fatal start error: drop the dead socket and start over.
  void retry() {
    _set(const PreviewSurfaceStatus());
    unawaited(_ch.connect());
  }

  // ─── Input ────────────────────────────────────────────────────────────────

  Offset? _norm(Offset local, Size size) {
    if (size.width == 0 || size.height == 0) return null;
    return Offset(
      (local.dx / size.width).clamp(0.0, 1.0),
      (local.dy / size.height).clamp(0.0, 1.0),
    );
  }

  void _pointer(String event, PointerEvent e, Size size) {
    final p = _norm(e.localPosition, size);
    if (p == null) return;
    if (event == 'move') {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastMoveMs < 40) return;
      _lastMoveMs = now;
    }
    if (event == 'down') {
      _downButton = switch (e.buttons) {
        kSecondaryMouseButton => 'right',
        kMiddleMouseButton => 'middle',
        _ => 'left',
      };
    }
    _safeSend(() => _ch.mouse(event, x: p.dx, y: p.dy, button: _downButton));
  }

  void _key(KeyEvent e, String phase) {
    final p = browserKeyPayload(e, phase);
    _safeSend(
      () => _ch.key(
        phase,
        key: p.key,
        code: p.code,
        keyCode: p.keyCode,
        text: p.text,
        modifiers: p.modifiers,
      ),
    );
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void didUpdateWidget(PreviewBrowserSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_status.ready) {
      _currentUrl = _isHttp(widget.url) ? widget.url : _currentUrl;
      return;
    }
    if (oldWidget.viewport != widget.viewport) {
      _safeSend(
        () => _ch.resizeView(widget.viewport.width.round(), widget.viewport.height.round()),
      );
    }
    if (oldWidget.device != widget.device) {
      // The server reloads the page itself after switching emulation.
      _safeSend(() => _ch.emulate(device: widget.device));
    }
    if (widget.url != oldWidget.url && _isHttp(widget.url) && widget.url != _currentUrl) {
      navigate(widget.url!);
    } else if (widget.reloadToken != oldWidget.reloadToken) {
      reload();
    }
  }

  @override
  void dispose() {
    _ch.detach();
    _frameSub?.cancel();
    _stateSub?.cancel();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _frameBytes;
    final size = widget.viewport;
    return SizedBox.fromSize(
      size: size,
      child: Focus(
        focusNode: _focus,
        onKeyEvent: (_, e) {
          if (e is KeyDownEvent || e is KeyRepeatEvent) _key(e, 'down');
          if (e is KeyUpEvent) _key(e, 'up');
          return KeyEventResult.handled;
        },
        child: Listener(
          onPointerHover: (e) => _pointer('move', e, size),
          onPointerMove: (e) => _pointer('move', e, size),
          onPointerDown: (e) {
            _focus.requestFocus();
            _pointer('down', e, size);
          },
          onPointerUp: (e) => _pointer('up', e, size),
          onPointerSignal: (e) {
            if (e is PointerScrollEvent) {
              final p = _norm(e.localPosition, size);
              if (p != null) {
                _safeSend(() => _ch.mouse('wheel', x: p.dx, y: p.dy, deltaY: e.scrollDelta.dy));
              }
            }
          },
          child: bytes == null || _frameW == 0 || _frameH == 0
              ? const ColoredBox(color: Color(0xFF101114))
              : Image.memory(
                  bytes,
                  gaplessPlayback: true,
                  fit: BoxFit.fill,
                  width: size.width,
                  height: size.height,
                ),
        ),
      ),
    );
  }
}
