import 'package:flutter/foundation.dart';
import 'package:xterm/xterm.dart';

/// Key sequences encoded the way real xterm does where xterm.dart 4.0.0 gets
/// them wrong; everything else falls through to [defaultInputHandler]. Its
/// keytab sends Shift/Alt+arrows as Ctrl ones (or nothing), keys DECCKM off
/// the keypad mode, upper-cases Alt+letter (Alt+b → ESC B), and drops
/// Alt+Enter, Alt+. and Ctrl+[ \ ] /. Shift+Enter sends ESC CR like Alt+Enter
/// — what Claude Code's `/terminal-setup` binds it to in VS Code — so it
/// inserts a newline in an agent CLI instead of submitting.
class XtermInputHandler implements TerminalInputHandler {
  const XtermInputHandler();

  static const _cursor = {
    TerminalKey.arrowUp: 'A',
    TerminalKey.arrowDown: 'B',
    TerminalKey.arrowRight: 'C',
    TerminalKey.arrowLeft: 'D',
    TerminalKey.home: 'H',
    TerminalKey.end: 'F',
  };

  static const _pf = {
    TerminalKey.f1: 'P',
    TerminalKey.f2: 'Q',
    TerminalKey.f3: 'R',
    TerminalKey.f4: 'S',
  };

  static const _ctrlSymbols = {
    TerminalKey.bracketLeft: '\x1b',
    TerminalKey.backslash: '\x1c',
    TerminalKey.bracketRight: '\x1d',
    TerminalKey.slash: '\x1f',
  };

  @override
  String? call(TerminalKeyboardEvent event) {
    final key = event.key;
    final mod = 1 + (event.shift ? 1 : 0) + (event.alt ? 2 : 0) + (event.ctrl ? 4 : 0);

    final cursor = _cursor[key];
    if (cursor != null) {
      if (mod > 1) return '\x1b[1;$mod$cursor';
      return event.state.cursorKeysMode ? '\x1bO$cursor' : '\x1b[$cursor';
    }
    final pf = _pf[key];
    if (pf != null && mod > 1) return '\x1b[1;$mod$pf';

    if (event.ctrl && !event.alt && !event.shift) {
      final symbol = _ctrlSymbols[key];
      if (symbol != null) return symbol;
    }

    if (key == TerminalKey.enter && event.shift && !event.ctrl && !event.alt) return '\x1b\r';

    // Ctrl+Alt is left alone: on Windows that is AltGr.
    if (event.alt && !event.ctrl) {
      if (key == TerminalKey.enter) return '\x1b\r';
      if (key == TerminalKey.backspace) return '\x1b\x7f';
      // macOS Option types characters instead.
      if (defaultTargetPlatform != TargetPlatform.macOS) {
        final char = _altChar(key, shift: event.shift);
        if (char != null) return '\x1b$char';
      }
    }

    return defaultInputHandler(event);
  }

  static String? _altChar(TerminalKey key, {required bool shift}) {
    if (key.index >= TerminalKey.keyA.index && key.index <= TerminalKey.keyZ.index) {
      final letter = String.fromCharCode(0x61 + key.index - TerminalKey.keyA.index);
      return shift ? letter.toUpperCase() : letter;
    }
    // Shifted punctuation depends on the keyboard layout; Alt+digits are the
    // app's own navigation chords (AdaptiveScaffold).
    return key == TerminalKey.period && !shift ? '.' : null;
  }
}
