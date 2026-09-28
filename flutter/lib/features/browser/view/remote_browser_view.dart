import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/realtime/browser_view_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class _Nav {
  const _Nav({
    this.url = '',
    this.title = '',
    this.canGoBack = false,
    this.canGoForward = false,
    this.loading = false,
  });
  final String url;
  final String title;
  final bool canGoBack;
  final bool canGoForward;
  final bool loading;

  _Nav copy({bool? loading}) => _Nav(
    url: url,
    title: title,
    canGoBack: canGoBack,
    canGoForward: canGoForward,
    loading: loading ?? this.loading,
  );
}

/// Remote browser (port of web-browser/view/RemoteBrowserPane.tsx): streams
/// JPEG frames from `/browser-view` into the pane and forwards normalized
/// pointer + keyboard events back to drive the server-side Chromium page.
class RemoteBrowserView extends ConsumerStatefulWidget {
  const RemoteBrowserView({super.key, this.url, this.onUrlChange});

  /// Initial page — later prop changes navigate the running session.
  final String? url;
  final ValueChanged<String>? onUrlChange;

  @override
  ConsumerState<RemoteBrowserView> createState() => _RemoteBrowserViewState();
}

class _RemoteBrowserViewState extends ConsumerState<RemoteBrowserView> {
  BrowserViewChannel get _ch => ref.read(browserViewChannelProvider);

  final _address = TextEditingController();
  final _viewFocus = FocusNode();
  bool _addressEditing = false;
  StreamSubscription<BrowserViewFrame>? _frameSub;
  StreamSubscription<WsState>? _stateSub;

  _Nav _nav = const _Nav();
  String _status = 'connecting'; // connecting | ready | closed
  String? _error;
  bool _fatal = false;
  bool _ready = false;
  String? _resumeUrl;
  Uint8List? _frameBytes;
  int _frameW = 0;
  int _frameH = 0;
  Size _viewport = Size.zero;
  int _lastMoveMs = 0;
  String? _lastRequestedUrl;

  static bool _isHttp(String? u) =>
      u != null && (u.startsWith('http://') || u.startsWith('https://'));

  @override
  void initState() {
    super.initState();
    _resumeUrl = _isHttp(widget.url) ? widget.url : null;
    _lastRequestedUrl = widget.url;
    if (widget.url != null) _address.text = widget.url!;
    _hook();
  }

  void _hook() {
    _frameSub ??= _ch.frames.listen(_onFrame);
    _stateSub = _ch.states.listen((s) {
      if (!mounted) return;
      if (s == WsState.open && !_ready && !_fatal) {
        _ch.startView(
          url: _resumeUrl,
          width: _viewport.width.round(),
          height: _viewport.height.round(),
        );
      }
      if (s == WsState.connecting || s == WsState.reconnecting) {
        setState(() {
          _status = 'connecting';
          _ready = false;
        });
      }
    });
    unawaited(_ch.connect());
  }

  void _onFrame(BrowserViewFrame f) {
    if (!mounted) return;
    switch (f.type) {
      case 'ready':
        _ready = true;
        setState(() {
          _status = 'ready';
          _error = null;
        });
      case 'error':
        // Terminal (auth / concurrency cap) — no reconnect loop.
        _fatal = true;
        unawaited(_ch.close());
        setState(() {
          _status = 'closed';
          _error = f.error ?? 'Browser view error';
        });
      case 'navigation':
        final url = f.raw['url'] as String? ?? '';
        if (_isHttp(url)) {
          _resumeUrl = url;
          widget.onUrlChange?.call(url);
        }
        setState(() {
          _nav = _Nav(
            url: url,
            title: f.raw['title'] as String? ?? '',
            canGoBack: f.raw['canGoBack'] == true,
            canGoForward: f.raw['canGoForward'] == true,
            loading: f.raw['loading'] == true,
          );
          if (!_addressEditing) _address.text = url;
        });
      case 'frame':
        final data = f.raw['data'] as String?;
        if (data == null) return;
        setState(() {
          _frameBytes = base64Decode(data);
          _frameW = (f.raw['width'] as num?)?.toInt() ?? _frameW;
          _frameH = (f.raw['height'] as num?)?.toInt() ?? _frameH;
          if (_nav.loading) _nav = _nav.copy(loading: false);
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
    _safeSend(
      () => _ch.mouse(
        event,
        x: p.dx,
        y: p.dy,
        button: switch (e.buttons) {
          kSecondaryMouseButton => 'right',
          kMiddleMouseButton => 'middle',
          _ => 'left',
        },
      ),
    );
  }

  int get _modifiers =>
      (HardwareKeyboard.instance.isAltPressed ? 1 : 0) |
      (HardwareKeyboard.instance.isControlPressed ? 2 : 0) |
      (HardwareKeyboard.instance.isMetaPressed ? 4 : 0) |
      (HardwareKeyboard.instance.isShiftPressed ? 8 : 0);

  void _key(KeyEvent e, String phase) {
    final label = e.logicalKey.keyLabel;
    final printable = label.length == 1 && (_modifiers & (1 | 2 | 4)) == 0;
    _safeSend(
      () => _ch.key(
        phase,
        key: label,
        code: e.physicalKey.debugName,
        keyCode: e.logicalKey.keyId,
        text: printable && phase == 'down' ? label : null,
        modifiers: _modifiers,
      ),
    );
  }

  void _navigate() {
    var v = _address.text.trim();
    if (v.isEmpty) return;
    if (!_isHttp(v)) v = 'https://$v';
    _viewFocus.unfocus();
    _safeSend(() => _ch.navigate(v));
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  /// A new `url` prop navigates the live session instead of reconnecting —
  /// unless it round-tripped from the server's own navigation report.
  @override
  void didUpdateWidget(RemoteBrowserView old) {
    super.didUpdateWidget(old);
    final url = widget.url;
    if (url == _lastRequestedUrl) return;
    _lastRequestedUrl = url;
    if (_isHttp(url) && _ready && url != _resumeUrl) {
      _safeSend(() => _ch.navigate(url!));
    }
  }

  @override
  void dispose() {
    // Stop the server screencast — the shared channel socket lives on, but
    // without this the remote page keeps streaming frames to nobody.
    try {
      _ch.stop();
    } on Object {
      // Socket already closed — nothing to stop.
    }
    _frameSub?.cancel();
    _stateSub?.cancel();
    _address.dispose();
    _viewFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            color: c.muted.withValues(alpha: 0.3),
            border: Border(bottom: BorderSide(color: c.border)),
          ),
          child: Row(
            children: [
              _navButton(
                Icons.arrow_back,
                'Back',
                _nav.canGoBack ? () => _safeSend(_ch.back) : null,
              ),
              _navButton(
                Icons.arrow_forward,
                'Forward',
                _nav.canGoForward ? () => _safeSend(_ch.forward) : null,
              ),
              _navButton(
                _nav.loading ? Icons.close : Icons.refresh,
                _nav.loading ? 'Stop' : 'Reload',
                () => _safeSend(_nav.loading ? _ch.stop : _ch.reload),
              ),
              Expanded(
                child: Focus(
                  onFocusChange: (has) {
                    _addressEditing = has;
                    if (!has && _nav.url.isNotEmpty) _address.text = _nav.url;
                  },
                  child: AppInput(
                    controller: _address,
                    hint: 'Enter URL',
                    onSubmitted: (_) => _navigate(),
                  ),
                ),
              ),
              _navButton(Icons.open_in_new, 'Open in system browser', () {
                final u = _nav.url.isEmpty ? widget.url : _nav.url;
                if (_isHttp(u)) {
                  unawaited(
                    launchUrl(
                      Uri.parse(u!),
                      mode: LaunchMode.externalApplication,
                    ),
                  );
                }
              }),
            ],
          ),
        ),
        if (_error != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            color: c.destructive.withValues(alpha: 0.1),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _error!,
                    style: t.bodySmall?.copyWith(color: c.destructive),
                  ),
                ),
                if (_fatal)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _fatal = false;
                        _error = null;
                        _status = 'connecting';
                      });
                      unawaited(_ch.connect());
                    },
                    child: const Text('Retry'),
                  ),
              ],
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              if (size != _viewport && size != Size.zero) {
                _viewport = size;
                if (_ready) {
                  _safeSend(
                    () =>
                        _ch.resizeView(size.width.round(), size.height.round()),
                  );
                }
              }
              return Stack(
                children: [
                  Positioned.fill(child: _stage(size)),
                  if (_nav.title.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          color: c.background.withValues(alpha: 0.7),
                          child: Text(
                            _nav.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.labelSmall?.copyWith(
                              color: c.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_status != 'ready')
                    Positioned.fill(
                      child: Container(
                        color: c.background,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.public,
                              size: 24,
                              color: c.mutedForeground,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              _status == 'connecting'
                                  ? 'Connecting to browser…'
                                  : 'Browser view disconnected',
                              style: t.bodySmall?.copyWith(
                                color: c.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _navButton(IconData icon, String tip, VoidCallback? onPressed) {
    return IconButton(
      tooltip: tip,
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: context.appColors.mutedForeground),
      visualDensity: VisualDensity.compact,
    );
  }

  /// Frame image scaled to fit — gestures resolve in *frame* coordinates via
  /// the fixed child size, so normalized x/y always map to the remote
  /// viewport regardless of display scaling.
  Widget _stage(Size viewport) {
    final bytes = _frameBytes;
    if (bytes == null || _frameW == 0 || _frameH == 0) {
      return const SizedBox.shrink();
    }
    final frameSize = Size(_frameW.toDouble(), _frameH.toDouble());
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox.fromSize(
          size: frameSize,
          child: KeyboardListener(
            focusNode: _viewFocus,
            onKeyEvent: (e) {
              if (e is KeyDownEvent) _key(e, 'down');
              if (e is KeyUpEvent) _key(e, 'up');
            },
            child: Listener(
              onPointerHover: (e) => _pointer('move', e, frameSize),
              onPointerMove: (e) => _pointer('move', e, frameSize),
              onPointerDown: (e) => _pointer('down', e, frameSize),
              onPointerUp: (e) => _pointer('up', e, frameSize),
              onPointerSignal: (e) {
                if (e is PointerScrollEvent) {
                  final p = _norm(e.localPosition, frameSize);
                  if (p != null) {
                    _safeSend(
                      () => _ch.mouse(
                        'wheel',
                        x: p.dx,
                        y: p.dy,
                        deltaY: e.scrollDelta.dy,
                      ),
                    );
                  }
                }
              },
              child: GestureDetector(
                onTap: () {
                  _viewFocus.requestFocus();
                  // A tap is down+up already; 'click' is implicit server-side.
                },
                child: Image.memory(
                  bytes,
                  gaplessPlayback: true,
                  fit: BoxFit.fill,
                  width: frameSize.width,
                  height: frameSize.height,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
