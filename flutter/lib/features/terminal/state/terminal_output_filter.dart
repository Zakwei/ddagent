/// Strips the terminal-protocol negotiation sequences xterm.dart 4.0
/// misparses, before PTY output reaches the emulator.
///
/// xterm's CSI dispatcher ignores the private prefix byte for most finals,
/// so modern TUIs that negotiate keyboard protocols corrupt the display:
///
/// - `CSI > 4 ; 2 m` (xterm *modifyOtherKeys*, sent by Claude Code for
///   Shift+Enter) lands in the SGR handler as `4;2` → every following cell is
///   underlined and faint;
/// - `CSI > 1 u` / `CSI < u` / `CSI ? u` (kitty keyboard protocol push, pop,
///   query) land in the restore-cursor handler → the cursor jumps.
///
/// xterm.dart also has no handler for the string sequences DCS / APC / PM /
/// SOS (`ESC P` … `ESC \\` etc.) — OpenCode's terminfo query `ESC P + q …`
/// would otherwise print its payload as text — so those are dropped whole.
///
/// Queries the emulator cannot answer are intercepted here and surfaced via
/// [takeQueries] so the owner can reply on the PTY: `OSC 10/11/12 ; ?`
/// (foreground / background / cursor colour — how OpenCode and Codex pick a
/// light or dark theme) and DECRQM `CSI ? Pd $ p` (mode support probes).
///
/// Sequences may be split across websocket frames, so an incomplete escape at
/// the end of a chunk is held back and prepended to the next one.
class TerminalOutputFilter {
  String _pending = '';
  final List<TerminalQuery> _queries = [];

  /// Private-prefixed CSI: `ESC [ <prefix> <params> <final>`.
  static final _privateCsi = RegExp(r'\x1b\[([<=>?])([0-9;:]*)([\x40-\x7e])');

  /// DCS / SOS / PM / APC string terminated by ST (`ESC \\`).
  static final _controlString = RegExp(r'\x1b[PX^_].*?\x1b\\', dotAll: true);

  /// An unterminated control string — held back until its ST arrives.
  static final _openControlString = RegExp(r'\x1b[PX^_](?:(?!\x1b\\).)*$', dotAll: true);

  /// `OSC 10/11/12 ; ? BEL|ST` — dynamic colour queries.
  static final _colorQuery = RegExp(r'\x1b\](1[012]);\?(\x07|\x1b\\)');

  /// `CSI ? Pd $ p` — DECRQM private mode status request.
  static final _modeQuery = RegExp(r'\x1b\[\?(\d+)\$p');

  /// An unterminated OSC — held back so a colour query split across frames
  /// is still recognised (any other OSC passes through once complete).
  static final _openOsc = RegExp(r'\x1b\](?:(?!\x1b\\|\x07).)*$', dotAll: true);

  /// An escape sequence cut off by the chunk boundary.
  static final _tail = RegExp(r'\x1b(\[[<=>?]?[0-9;:]*[ -/]*)?$');

  /// A runaway control string (missing ST) is flushed past this size so a
  /// broken producer cannot stall the terminal forever.
  static const _maxPending = 64 * 1024;

  /// Filters one output chunk; returns the text to write to the emulator.
  String feed(String chunk) {
    var text = _pending + chunk;
    _pending = '';
    if (!text.contains('\x1b')) return text;

    text = text.replaceAll(_controlString, '');

    final open = _openControlString.firstMatch(text) ?? _openOsc.firstMatch(text);
    if (open != null) {
      if (open.group(0)!.length <= _maxPending) {
        _pending = open.group(0)!;
        text = text.substring(0, open.start);
      }
    } else {
      final tail = _tail.firstMatch(text);
      if (tail != null) {
        _pending = tail.group(0)!;
        text = text.substring(0, tail.start);
      }
    }

    text = text.replaceAllMapped(_colorQuery, (m) {
      _queries.add(
        TerminalQuery(
          kind: switch (m.group(1)) {
            '10' => TerminalQueryKind.foregroundColor,
            '11' => TerminalQueryKind.backgroundColor,
            _ => TerminalQueryKind.cursorColor,
          },
          terminator: m.group(2)!,
        ),
      );
      return '';
    });
    text = text.replaceAllMapped(_modeQuery, (m) {
      _queries.add(
        TerminalQuery(
          kind: TerminalQueryKind.modeStatus,
          mode: int.parse(m.group(1)!),
          terminator: '',
        ),
      );
      return '';
    });

    return text.replaceAllMapped(_privateCsi, (m) {
      final prefix = m.group(1)!;
      final finalByte = m.group(3)!;
      // `CSI ? Pm h/l` DEC private modes are the one `?` family xterm handles
      // correctly — keep everything with `?` except the kitty query.
      if (prefix == '?') return finalByte == 'u' ? '' : m.group(0)!;
      // `CSI > c` / `CSI = c` device attributes are dispatched by prefix.
      if (finalByte == 'c') return m.group(0)!;
      return '';
    });
  }

  /// Queries intercepted by the last [feed] calls; cleared on read.
  List<TerminalQuery> takeQueries() {
    final out = List<TerminalQuery>.unmodifiable(_queries);
    _queries.clear();
    return out;
  }
}

enum TerminalQueryKind { foregroundColor, backgroundColor, cursorColor, modeStatus }

/// A terminal capability/state query lifted out of the PTY stream.
class TerminalQuery {
  const TerminalQuery({required this.kind, required this.terminator, this.mode});

  final TerminalQueryKind kind;

  /// DEC private mode number for [TerminalQueryKind.modeStatus].
  final int? mode;

  /// The terminator the query used (`BEL` or `ESC \\`) — echoed in the reply.
  final String terminator;
}

/// DEC private modes xterm.dart actually implements (its `CSI ? Pm h/l`
/// switch). Anything else is reported as "not recognised" so a TUI falls
/// back instead of enabling a feature the emulator silently ignores.
const _supportedDecModes = {
  1,
  3,
  5,
  6,
  7,
  9,
  12,
  13,
  25,
  47,
  66,
  1000,
  1001,
  1002,
  1003,
  1004,
  1005,
  1006,
  1007,
  1015,
  1047, //
  1048, 1049, 2004,
};

/// `rgb:rrrr/gggg/bbbb` — the X11 colour spec xterm uses in OSC replies
/// (each channel scaled to 16 bits).
String xtermColorSpec(int r, int g, int b) {
  String wide(int c) => (c * 257).toRadixString(16).padLeft(4, '0');
  return 'rgb:${wide(r)}/${wide(g)}/${wide(b)}';
}

/// Builds the PTY reply for [query]; colours are 8-bit RGB triples.
String terminalQueryReply(
  TerminalQuery query, {
  required (int, int, int) foreground,
  required (int, int, int) background,
}) {
  switch (query.kind) {
    case TerminalQueryKind.foregroundColor:
      return '\x1b]10;${xtermColorSpec(foreground.$1, foreground.$2, foreground.$3)}${query.terminator}';
    case TerminalQueryKind.backgroundColor:
      return '\x1b]11;${xtermColorSpec(background.$1, background.$2, background.$3)}${query.terminator}';
    case TerminalQueryKind.cursorColor:
      return '\x1b]12;${xtermColorSpec(foreground.$1, foreground.$2, foreground.$3)}${query.terminator}';
    case TerminalQueryKind.modeStatus:
      // 2 = recognised, currently reset; 0 = not recognised.
      final status = _supportedDecModes.contains(query.mode) ? 2 : 0;
      return '\x1b[?${query.mode};$status\$y';
  }
}
