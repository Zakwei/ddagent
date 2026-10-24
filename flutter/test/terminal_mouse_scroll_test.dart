import 'package:ddagent_app/features/terminal/state/terminal_mouse_handler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

/// Claude Code 2.1.310 at startup: alt screen, button/drag/any-motion
/// tracking, SGR reports.
const claudeModes = '\x1b[?1049h\x1b[?1000h\x1b[?1002h\x1b[?1003h\x1b[?1006h';

/// Height of the bar the terminal sits under — reports must name the cell
/// under the pointer, not the cell a global position would land on.
const headerHeight = 120.0;

Future<(Terminal, List<String>, ScrollController)> pumpTerminal(
  WidgetTester tester, {
  String modes = '',
  int lines = 0,
}) async {
  final terminal = Terminal(mouseHandler: XtermMouseHandler());
  final sent = <String>[];
  terminal.onOutput = sent.add;
  final controller = ScrollController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: headerHeight),
            Expanded(child: TerminalView(terminal, scrollController: controller)),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
  for (var i = 0; i < lines; i++) {
    terminal.write('line $i\r\n');
  }
  terminal.write(modes);
  await tester.pumpAndSettle();
  sent.clear();
  return (terminal, sent, controller);
}

Future<void> fingerDrag(WidgetTester tester) async {
  final gesture = await tester.startGesture(
    tester.getCenter(find.byType(TerminalView)),
    kind: PointerDeviceKind.touch,
  );
  await tester.pump(const Duration(milliseconds: 150));
  for (var i = 0; i < 10; i++) {
    await gesture.moveBy(const Offset(0, 30));
    await tester.pump(const Duration(milliseconds: 16));
  }
  await gesture.up();
  await tester.pumpAndSettle();
}

Future<void> wheel(WidgetTester tester, {int ticks = 3, double dy = -60}) async {
  final center = tester.getCenter(find.byType(TerminalView));
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: center);
  await tester.pump();
  for (var i = 0; i < ticks; i++) {
    await tester.sendEventToBinding(
      PointerScrollEvent(position: center, scrollDelta: Offset(0, dy)),
    );
    await tester.pump(const Duration(milliseconds: 16));
  }
  await tester.pumpAndSettle();
  await mouse.removePointer();
}

Iterable<String> wheelUps(List<String> sent) => sent.where((s) => s.startsWith('\x1b[<64;'));

void main() {
  testWidgets('a drag scrolls the program when it reports the wheel on the main screen', (
    tester,
  ) async {
    final (terminal, sent, _) = await pumpTerminal(tester, modes: '\x1b[?1000h\x1b[?1006h');
    expect(terminal.isUsingAltBuffer, isFalse);
    await fingerDrag(tester);
    expect(wheelUps(sent), isNotEmpty, reason: '$sent');
  });

  testWidgets('without wheel reports the main screen scrolls its own scrollback', (tester) async {
    final (_, sent, controller) = await pumpTerminal(tester, lines: 200);
    final before = controller.position.pixels;
    await fingerDrag(tester);
    expect(sent, isEmpty);
    expect(controller.position.pixels, lessThan(before));
  });

  testWidgets('the wheel goes to a program that reports it even over local scrollback', (
    tester,
  ) async {
    // Claude Code whose alt-screen switch was lost in a replay: mouse modes
    // on, main screen, scrollback behind it. The inner scrollable used to
    // take the wheel first and the program never scrolled.
    final (terminal, sent, controller) = await pumpTerminal(
      tester,
      lines: 200,
      modes: '\x1b[?1000h\x1b[?1002h\x1b[?1003h\x1b[?1006h',
    );
    expect(terminal.isUsingAltBuffer, isFalse);
    final bottom = controller.position.pixels;
    await wheel(tester);
    expect(wheelUps(sent), isNotEmpty, reason: '$sent');
    expect(controller.position.pixels, bottom, reason: 'the scrollback must not move');
  });

  testWidgets('Shift+wheel moves the local scrollback instead of the program', (tester) async {
    final (_, sent, controller) = await pumpTerminal(
      tester,
      lines: 200,
      modes: '\x1b[?1000h\x1b[?1006h',
    );
    final bottom = controller.position.pixels;
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await wheel(tester);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(sent, isEmpty);
    expect(controller.position.pixels, lessThan(bottom));
  });

  testWidgets('a wheel report names the cell under the pointer, not the global row', (
    tester,
  ) async {
    final (terminal, sent, _) = await pumpTerminal(tester, modes: claudeModes);
    await wheel(tester, ticks: 1);
    final view = tester.getRect(find.byType(TerminalView));
    final center = view.center;
    final rows = terminal.viewHeight;
    final expectedRow = ((center.dy - view.top) / view.height * rows).floor() + 1;
    final report = wheelUps(sent).first;
    final row = int.parse(RegExp(r';(\d+)M$').firstMatch(report)!.group(1)!);
    expect((row - expectedRow).abs(), lessThanOrEqualTo(1), reason: report);
    expect(row, lessThan(rows), reason: 'a global position would clamp to the last row');
  });

  testWidgets('a mouse drag reports press, motion and release to a tracking program', (
    tester,
  ) async {
    final (_, sent, _) = await pumpTerminal(tester, modes: claudeModes);
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(TerminalView)),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump(const Duration(milliseconds: 150));
    for (var i = 0; i < 4; i++) {
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pumpAndSettle();
    expect(sent.first, startsWith('\x1b[<0;'), reason: '$sent');
    expect(sent.first, endsWith('M'));
    expect(sent.where((s) => s.startsWith('\x1b[<32;')), isNotEmpty, reason: '$sent');
    expect(sent.last, startsWith('\x1b[<0;'));
    expect(sent.last, endsWith('m'), reason: 'the press must be released: $sent');
  });

  testWidgets('a finger tap reports press and release together; a finger drag reports neither', (
    tester,
  ) async {
    final (_, sent, _) = await pumpTerminal(tester, modes: claudeModes);
    await tester.tap(find.byType(TerminalView), kind: PointerDeviceKind.touch);
    await tester.pumpAndSettle();
    expect(sent.where((s) => s.startsWith('\x1b[<0;')).map((s) => s[s.length - 1]), ['M', 'm']);
    sent.clear();
    await fingerDrag(tester);
    expect(sent.where((s) => s.startsWith('\x1b[<0;')), isEmpty, reason: '$sent');
    expect(wheelUps(sent), isNotEmpty);
  });
}
