import 'package:xterm/xterm.dart';

/// Mouse reports encoded the way real xterm does. xterm 4.0.0 gets three
/// wrong: the wheel goes out as buttons 68/69 (64 + 4/5), which apps with
/// mouse tracking read as Shift+wheel — Claude Code's fullscreen UI then
/// never scrolls, by wheel or by a finger drag; X10/UTF-8 rows are one too
/// low; and the middle button arrives here as the right one (its gesture
/// handler routes tertiary taps to the secondary callbacks).
///
/// A drag ([TerminalMouseButtonState.move], a ddagent addition to xterm.dart)
/// is reported as the button code plus 32, as in xterm — Claude Code selects
/// transcript text from press / motion / release and copies it over OSC 52.
class XtermMouseHandler implements TerminalMouseHandler {
  /// Set by the pane on pointer-down: the press in flight is the middle button.
  bool middleDown = false;

  @override
  String? call(TerminalMouseEvent event) {
    // The default handler still decides whether the active mode reports it.
    if (defaultMouseHandler(event) == null) return null;
    final button = event.button;
    final motion = event.buttonState == TerminalMouseButtonState.move ? 32 : 0;
    final id =
        (button.isWheel
            ? button.id - 4
            : middleDown && button == TerminalMouseButton.right
            ? TerminalMouseButton.middle.id
            : button.id) +
        motion;
    final up = event.buttonState == TerminalMouseButtonState.up;
    final x = event.position.x + 1;
    final y = event.position.y + 1;
    return switch (event.state.mouseReportMode) {
      MouseReportMode.sgr => '\x1b[<$id;$x;$y${up ? 'm' : 'M'}',
      MouseReportMode.urxvt => '\x1b[${32 + (up ? 3 : id)};$x;${y}M',
      MouseReportMode.normal => _x10(up ? 3 : id, x, y, 223),
      MouseReportMode.utf => _x10(up ? 3 : id, x, y, 2015),
    };
  }

  static String _x10(int id, int x, int y, int max) {
    String pos(int v) => v > max ? '\x00' : String.fromCharCode(32 + v);
    return '\x1b[M${String.fromCharCode(32 + id)}${pos(x)}${pos(y)}';
  }
}
