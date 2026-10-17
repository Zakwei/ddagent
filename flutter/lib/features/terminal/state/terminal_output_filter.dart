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
/// Sequences may be split across websocket frames, so an incomplete escape at
/// the end of a chunk is held back and prepended to the next one.
class TerminalOutputFilter {
  String _pending = '';

  /// Private-prefixed CSI: `ESC [ <prefix> <params> <final>`.
  static final _privateCsi = RegExp(r'\x1b\[([<=>?])([0-9;:]*)([\x40-\x7e])');

  /// DCS / SOS / PM / APC string terminated by ST (`ESC \\`).
  static final _controlString = RegExp(r'\x1b[PX^_].*?\x1b\\', dotAll: true);

  /// An unterminated control string — held back until its ST arrives.
  static final _openControlString = RegExp(r'\x1b[PX^_](?:(?!\x1b\\).)*$', dotAll: true);

  /// An escape sequence cut off by the chunk boundary.
  static final _tail = RegExp(r'\x1b(\[[<=>?]?[0-9;:]*)?$');

  /// A runaway control string (missing ST) is flushed past this size so a
  /// broken producer cannot stall the terminal forever.
  static const _maxPending = 64 * 1024;

  /// Filters one output chunk; returns the text to write to the emulator.
  String feed(String chunk) {
    var text = _pending + chunk;
    _pending = '';
    if (!text.contains('\x1b')) return text;

    text = text.replaceAll(_controlString, '');

    final open = _openControlString.firstMatch(text);
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
}
