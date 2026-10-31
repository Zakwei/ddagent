// The wheel over a program that takes it (Claude Code full screen: alternate
// buffer + mouse reports) must keep reaching it after the scroll physics
// change — Ctrl swaps them for Ctrl+wheel zoom, so a Ctrl+V paste used to
// leave the wheel dead until the tab was switched.
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

void main() {
  testWidgets('wheel reports survive a physics swap', (tester) async {
    final output = <String>[];
    final terminal = Terminal(onOutput: output.add)..write('\x1b[?1049h\x1b[?1000h\x1b[?1006h');
    final physics = ValueNotifier<ScrollPhysics?>(null);
    addTearDown(physics.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder(
          valueListenable: physics,
          builder: (context, value, _) => ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(physics: value),
            child: TerminalView(terminal),
          ),
        ),
      ),
    );

    Future<void> wheel() async {
      final pointer = TestPointer(1, PointerDeviceKind.mouse)
        ..hover(tester.getCenter(find.byType(TerminalView)));
      await tester.sendEventToBinding(pointer.scroll(const Offset(0, -200)));
      await tester.pump();
    }

    // An SGR mouse report: `ESC [ < button ; x ; y M`.
    bool reported() => output.any((o) => o.startsWith('\x1b[<'));

    await wheel();
    expect(reported(), isTrue);

    // Ctrl down → wheel zooms, Ctrl up → wheel scrolls again.
    physics.value = const NeverScrollableScrollPhysics();
    await tester.pump();
    physics.value = null;
    await tester.pump();

    output.clear();
    await wheel();
    expect(reported(), isTrue);
  });
}
