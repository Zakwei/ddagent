import 'package:ddagent_app/features/terminal/state/terminal_mouse_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

void main() {
  String? report(
    String modes,
    TerminalMouseButton button, {
    bool middleDown = false,
    TerminalMouseButtonState state = TerminalMouseButtonState.down,
  }) {
    String? out;
    final terminal = Terminal(mouseHandler: XtermMouseHandler()..middleDown = middleDown)
      ..onOutput = ((data) => out = data)
      ..write(modes);
    terminal.mouseInput(button, state, const CellOffset(76, 25));
    return out;
  }

  const sgr = '\x1b[?1000h\x1b[?1006h';

  test('wheel reports xterm buttons 64/65', () {
    expect(report(sgr, TerminalMouseButton.wheelUp), '\x1b[<64;77;26M');
    expect(report(sgr, TerminalMouseButton.wheelDown), '\x1b[<65;77;26M');
    expect(report('\x1b[?1000h\x1b[?1015h', TerminalMouseButton.wheelUp), '\x1b[96;77;26M');
  });

  test('a drag reports the button plus 32 in the drag and any-motion modes only', () {
    expect(
      report(
        '\x1b[?1002h\x1b[?1006h',
        TerminalMouseButton.left,
        state: TerminalMouseButtonState.move,
      ),
      '\x1b[<32;77;26M',
    );
    expect(
      report(
        '\x1b[?1003h\x1b[?1006h',
        TerminalMouseButton.left,
        state: TerminalMouseButtonState.move,
      ),
      '\x1b[<32;77;26M',
    );
    expect(report(sgr, TerminalMouseButton.left, state: TerminalMouseButtonState.move), isNull);
    expect(
      report('\x1b[?1002h', TerminalMouseButton.left, state: TerminalMouseButtonState.move),
      '\x1b[M${String.fromCharCodes([32 + 32, 32 + 77, 32 + 26])}',
    );
  });

  test('clicks report button, release and 1-based cell in SGR mode', () {
    expect(report(sgr, TerminalMouseButton.left), '\x1b[<0;77;26M');
    expect(
      report(sgr, TerminalMouseButton.left, state: TerminalMouseButtonState.up),
      '\x1b[<0;77;26m',
    );
    expect(report(sgr, TerminalMouseButton.right), '\x1b[<2;77;26M');
  });

  test('a middle press xterm routes as right reports button 1', () {
    expect(report(sgr, TerminalMouseButton.right, middleDown: true), '\x1b[<1;77;26M');
  });

  test('X10 mode reports the row unshifted and release as button 3', () {
    String chars(int b) => '\x1b[M${String.fromCharCodes([32 + b, 32 + 77, 32 + 26])}';
    expect(report('\x1b[?1000h', TerminalMouseButton.left), chars(0));
    expect(
      report('\x1b[?1000h', TerminalMouseButton.left, state: TerminalMouseButtonState.up),
      chars(3),
    );
    expect(report('\x1b[?1000h', TerminalMouseButton.wheelUp), chars(64));
  });

  test('nothing is reported without mouse tracking', () {
    expect(report('', TerminalMouseButton.left), isNull);
  });
}
