import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

/// A program that asked for mouse wheel reports gets the scroll gesture even
/// on the main screen — like xterm. Claude Code in a session whose alt-screen
/// switch was lost (adopted after a server restart) otherwise never scrolled:
/// the finger moved an empty scrollback instead.
Future<void> fingerDrag(WidgetTester tester) async {
  final gesture = await tester.startGesture(
    tester.getCenter(find.byType(TerminalView)),
    kind: PointerDeviceKind.touch,
  );
  for (var i = 0; i < 10; i++) {
    await gesture.moveBy(const Offset(0, 30));
    await tester.pump(const Duration(milliseconds: 16));
  }
  await gesture.up();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a drag scrolls the program when it reports the wheel on the main screen', (
    tester,
  ) async {
    final terminal = Terminal();
    final sent = <String>[];
    terminal.onOutput = sent.add;
    terminal.write('\x1b[?1000h\x1b[?1006h');
    expect(terminal.isUsingAltBuffer, isFalse);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TerminalView(terminal))));
    await fingerDrag(tester);
    expect(sent.where((s) => s.startsWith('\x1b[<6')), isNotEmpty, reason: '$sent');
  });

  testWidgets('without wheel reports the main screen scrolls its own scrollback', (tester) async {
    final terminal = Terminal();
    final sent = <String>[];
    terminal.onOutput = sent.add;
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TerminalView(terminal))));
    await fingerDrag(tester);
    expect(sent, isEmpty);
  });
}
