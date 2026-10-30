// The vendored xterm.dart against the escape sequences agent CLIs send:
// each case drew Claude Code / Codex screens shifted, on the wrong row or
// stopped painting until the next output.
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

void main() {
  Terminal term(int cols, int rows) => Terminal()..resize(cols, rows);

  /// Row [y] with blank cells as spaces (getText skips them).
  String row(Terminal t, int y) {
    final line = t.buffer.lines[y];
    return String.fromCharCodes([
      for (var x = 0; x < t.viewWidth; x++)
        if (line.getWidth(x) != 0 || line.getCodePoint(x) == 0)
          line.getCodePoint(x) == 0 ? 32 : line.getCodePoint(x),
    ]).trimRight();
  }

  test('a cursor move after a full-width row ends the pending wrap', () {
    final up = term(10, 5)..write('\x1b[3;1H0123456789\x1b[1AX');
    expect(row(up, 1), '         X');
    expect(row(up, 2), '0123456789');

    final down = term(10, 5)..write('\x1b[1;1H0123456789\nX');
    expect(row(down, 1), '         X');

    final back = term(10, 5)..write('0123456789\x1b[2DX');
    expect(row(back, 0), '0123456X89');
  });

  test('zero-width marks take no column', () {
    final t = term(20, 3)..write('e\u0301|a\u200b|');
    expect(t.buffer.cursorX, 4);
  });

  test('a wide char at the last column wraps whole', () {
    final t = term(5, 3)..write('abcd中x');
    expect(row(t, 0), 'abcd');
    expect(row(t, 1), startsWith('中'));
  });

  test('restoring a cursor saved below a shrunk screen paints instead of throwing', () {
    var painted = 0;
    final t = term(10, 10)..write('\x1b[9;3H\x1b7');
    t.addListener(() => painted++);
    t.resize(10, 5);
    t.write('\x1b8X');
    expect(painted, greaterThan(0));
    expect(t.buffer.cursorY, 4);
  });

  test('a truncated colour code is ignored and the rest of the chunk still draws', () {
    final t = term(20, 3)..write('\x1b[38mA\x1b[48;5mB\x1b[38;2;1mC');
    expect(row(t, 0), 'ABC');
  });

  test('colon sub-parameters and underline colour do not turn into other codes', () {
    final t = term(20, 3)..write('\x1b[4:3mA\x1b[58;2;255;0;0mB');
    expect(t.cursor.background, Terminal().cursor.background);
    expect(t.cursor.isFaint, isFalse);
    expect(t.cursor.isUnderline, isTrue);
  });

  test('CUP with one or a leading empty parameter', () {
    final t = term(20, 10)..write('\x1b[3H');
    expect((t.buffer.cursorX, t.buffer.cursorY), (0, 2));
    t.write('\x1b[;5H');
    expect((t.buffer.cursorX, t.buffer.cursorY), (4, 0));
  });

  test('autowrap off overwrites the last column', () {
    final t = term(10, 3)..write('\x1b[?7l0123456789ABC');
    expect(row(t, 0), '012345678C');
    expect(row(t, 1), '');
  });

  test('erase to the start of the line includes the cursor cell', () {
    final t = term(10, 3)..write('0123456789\x1b[5G\x1b[1K');
    expect(row(t, 0), '     56789');
  });

  test('cursor position reports are 1-based', () {
    final sent = <String>[];
    term(20, 5)
      ..onOutput = sent.add
      ..write('\x1b[3;7H\x1b[6n');
    expect(sent, ['\x1b[3;7R']);
  });
}
