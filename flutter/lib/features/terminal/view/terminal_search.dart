import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart' as xt;

/// One search hit: a run of [length] cells starting at column [x] on
/// absolute buffer line [line].
typedef TerminalSearchHit = ({int line, int x, int length});

/// Hard cap on tracked hits — each hit owns two buffer anchors, and a
/// 10 000-line scrollback full of a one-letter query would otherwise pin
/// tens of thousands of them.
const terminalSearchMaxHits = 2000;

/// Windows Terminal style find-in-buffer. Scans the scrollback for [query],
/// paints every hit through the view controller's highlight layer (the
/// current hit in a stronger colour) and exposes next/previous navigation.
///
/// The buffer is re-scanned (debounced) whenever the terminal emits output
/// while the search is open, so hits track a live process.
class TerminalSearch extends ChangeNotifier {
  TerminalSearch({
    required this.terminal,
    required this.controller,
    required this.hitColor,
    required this.currentHitColor,
  });

  final xt.Terminal terminal;
  final xt.TerminalController controller;
  Color hitColor;
  Color currentHitColor;

  /// Theme change (light ↔ dark) — repaints open highlights. Deferred a
  /// microtask because the caller is the pane's dependency hook, and the
  /// highlight layer notifies listeners that `setState`.
  void setColors({required Color hit, required Color current}) {
    if (hit == hitColor && current == currentHitColor) return;
    hitColor = hit;
    currentHitColor = current;
    if (_open) scheduleMicrotask(() => _open ? _paint() : null);
  }

  String _query = '';
  bool _caseSensitive = false;
  bool _open = false;
  final List<TerminalSearchHit> _hits = [];
  final List<xt.TerminalHighlight> _highlights = [];
  int _current = -1;
  Timer? _rescan;

  String get query => _query;
  bool get caseSensitive => _caseSensitive;
  bool get isOpen => _open;
  List<TerminalSearchHit> get hits => List.unmodifiable(_hits);
  int get hitCount => _hits.length;

  /// 0-based index of the current hit, or -1 when there are none.
  int get currentIndex => _current;
  TerminalSearchHit? get currentHit =>
      _current >= 0 && _current < _hits.length ? _hits[_current] : null;

  void open() {
    if (_open) return;
    _open = true;
    terminal.addListener(_onTerminalChanged);
    _scan(keepCurrent: false);
    notifyListeners();
  }

  void close() {
    if (!_open) return;
    _open = false;
    _rescan?.cancel();
    _rescan = null;
    terminal.removeListener(_onTerminalChanged);
    _clearHighlights();
    _hits.clear();
    _current = -1;
    notifyListeners();
  }

  void setQuery(String query) {
    if (query == _query) return;
    _query = query;
    _scan(keepCurrent: false);
    notifyListeners();
  }

  void setCaseSensitive(bool value) {
    if (value == _caseSensitive) return;
    _caseSensitive = value;
    _scan(keepCurrent: false);
    notifyListeners();
  }

  void next() => _step(1);
  void previous() => _step(-1);

  void _step(int delta) {
    if (_hits.isEmpty) return;
    _current = (_current + delta) % _hits.length;
    if (_current < 0) _current += _hits.length;
    _paint();
    notifyListeners();
  }

  void _onTerminalChanged() {
    _rescan?.cancel();
    _rescan = Timer(const Duration(milliseconds: 150), () {
      _rescan = null;
      if (_open) {
        _scan(keepCurrent: true);
        notifyListeners();
      }
    });
  }

  /// Rebuilds the hit list from the current buffer. With [keepCurrent] the
  /// selection stays on the same hit when it still exists (live output
  /// appended below must not jump the cursor).
  void _scan({required bool keepCurrent}) {
    final previous = currentHit;
    _hits.clear();
    final needle = _caseSensitive ? _query : _query.toLowerCase();
    if (needle.isNotEmpty) {
      final lines = terminal.buffer.lines;
      outer:
      for (var y = 0; y < lines.length; y++) {
        final raw = lines[y].getText();
        if (raw.isEmpty) continue;
        final hay = _caseSensitive ? raw : raw.toLowerCase();
        var from = 0;
        while (true) {
          final idx = hay.indexOf(needle, from);
          if (idx == -1) break;
          _hits.add((line: y, x: idx, length: needle.length));
          if (_hits.length >= terminalSearchMaxHits) break outer;
          from = idx + needle.length;
        }
      }
    }
    if (_hits.isEmpty) {
      _current = -1;
    } else if (keepCurrent && previous != null) {
      final same = _hits.indexWhere(
        (h) => h.line == previous.line && h.x == previous.x && h.length == previous.length,
      );
      _current = same != -1 ? same : _hits.length - 1;
    } else {
      // Fresh query: start from the most recent hit, like WT's search box
      // which searches upward from the bottom by default.
      _current = _hits.length - 1;
    }
    _paint();
  }

  void _paint() {
    _clearHighlights();
    final buffer = terminal.buffer;
    for (var i = 0; i < _hits.length; i++) {
      final hit = _hits[i];
      if (hit.line >= buffer.lines.length) continue;
      _highlights.add(
        controller.highlight(
          p1: buffer.createAnchor(hit.x, hit.line),
          p2: buffer.createAnchor(hit.x + hit.length, hit.line),
          color: i == _current ? currentHitColor : hitColor,
        ),
      );
    }
  }

  void _clearHighlights() {
    for (final h in _highlights) {
      h.dispose();
    }
    _highlights.clear();
  }

  /// Scrolls the viewport so the current hit sits roughly mid-screen. The
  /// scroll extent maps linearly onto the scrollback, so the line height
  /// is derived from the extent instead of asking the renderer.
  void revealCurrent(ScrollController scroll) {
    final hit = currentHit;
    if (hit == null || !scroll.hasClients) return;
    final scrollBack = terminal.buffer.height - terminal.viewHeight;
    if (scrollBack <= 0) return;
    final position = scroll.position;
    final lineHeight = position.maxScrollExtent / scrollBack;
    final target = ((hit.line - terminal.viewHeight ~/ 2) * lineHeight).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    scroll.jumpTo(target);
  }

  @override
  void dispose() {
    _rescan?.cancel();
    if (_open) terminal.removeListener(_onTerminalChanged);
    _clearHighlights();
    super.dispose();
  }
}
