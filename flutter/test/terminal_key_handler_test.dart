import 'package:ddagent_app/features/terminal/state/terminal_key_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

void main() {
  String? key(
    TerminalKey key, {
    bool ctrl = false,
    bool alt = false,
    bool shift = false,
    String modes = '',
  }) {
    String? out;
    final terminal = Terminal(inputHandler: const XtermInputHandler())
      ..onOutput = ((data) => out = data)
      ..write(modes);
    terminal.keyInput(key, ctrl: ctrl, alt: alt, shift: shift);
    return out;
  }

  test('cursor keys carry the xterm modifier code', () {
    expect(key(TerminalKey.arrowUp), '\x1b[A');
    expect(key(TerminalKey.arrowUp, shift: true), '\x1b[1;2A');
    expect(key(TerminalKey.arrowUp, alt: true), '\x1b[1;3A');
    expect(key(TerminalKey.arrowUp, ctrl: true), '\x1b[1;5A');
    expect(key(TerminalKey.arrowLeft, shift: true), '\x1b[1;2D');
    expect(key(TerminalKey.home, ctrl: true, shift: true), '\x1b[1;6H');
    expect(key(TerminalKey.f1, ctrl: true), '\x1b[1;5P');
  });

  test('DECCKM switches cursor keys to SS3', () {
    expect(key(TerminalKey.arrowUp, modes: '\x1b[?1h'), '\x1bOA');
    expect(key(TerminalKey.end, modes: '\x1b[?1h'), '\x1bOF');
  });

  test('Alt prefixes ESC to the typed character', () {
    expect(key(TerminalKey.keyB, alt: true), '\x1bb');
    expect(key(TerminalKey.keyB, alt: true, shift: true), '\x1bB');
    expect(key(TerminalKey.period, alt: true), '\x1b.');
    expect(key(TerminalKey.enter, alt: true), '\x1b\r');
    expect(key(TerminalKey.backspace, alt: true), '\x1b\x7f');
  });

  test('Shift+Enter sends ESC CR — a newline in agent CLIs, not a submit', () {
    expect(key(TerminalKey.enter, shift: true), '\x1b\r');
  });

  test('Ctrl+symbols send their control codes', () {
    expect(key(TerminalKey.bracketLeft, ctrl: true), '\x1b');
    expect(key(TerminalKey.backslash, ctrl: true), '\x1c');
    expect(key(TerminalKey.bracketRight, ctrl: true), '\x1d');
    expect(key(TerminalKey.slash, ctrl: true), '\x1f');
  });

  test('keys xterm.dart already gets right fall through unchanged', () {
    expect(key(TerminalKey.enter), '\r');
    expect(key(TerminalKey.keyL, ctrl: true), '\x0c');
    expect(key(TerminalKey.space, ctrl: true), '\x00');
    expect(key(TerminalKey.tab, shift: true), '\x1b[Z');
    expect(key(TerminalKey.delete), '\x1b[3~');
    expect(key(TerminalKey.pageUp, shift: true), '\x1b[5;2~');
    // Ctrl+Alt is AltGr on Windows — left unhandled.
    expect(key(TerminalKey.keyB, ctrl: true, alt: true), isNull);
  });
}
