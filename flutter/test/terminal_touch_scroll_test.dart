import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/text_selection_scroll_behavior.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart' as xt;

class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://x'));
  @override
  void send(Map<String, dynamic> frame) {}
  @override
  Future<void> connect() async {}
}

/// Regression: on phones a finger rests past the 100 ms tap deadline before
/// it moves; xterm then asked for the soft keyboard, and the keyboard sliding
/// up (inset changes) made xterm snap back to the bottom on every frame — the
/// drag never scrolled anything. The pane now opens the keyboard only on a
/// completed tap, so a drag with the keyboard closed scrolls the scrollback.
void main() {
  testWidgets('a touch drag scrolls the terminal even while the keyboard slides up', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(tester.view.resetViewInsets);
    final channel = ShellChannel(_FakeWs())..start();
    final container = ProviderContainer(
      overrides: [shellChannelProvider.overrideWith((ref, key) => channel)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      TranslationProvider(
        child: UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            scrollBehavior: const NoMouseDragScrollBehavior(),
            home: const Scaffold(body: TerminalScreen(projectPath: '/p')),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    final ctrl = container.read(terminalControllerProvider.notifier);
    final tab = ctrl.state.tabs.single;
    tab.status = TerminalTabStatus.connected;
    ctrl.state = ctrl.state.copyWith(tabs: [...ctrl.state.tabs]);
    await tester.pump();
    for (var i = 0; i < 300; i++) {
      tab.terminal.write('line $i\r\n');
    }
    await tester.pumpAndSettle();

    final terminalView = find.byType(xt.TerminalView);
    final scrollable = find.descendant(of: terminalView, matching: find.byType(Scrollable)).first;
    ScrollPosition position() => tester.widget<Scrollable>(scrollable).controller!.position;

    // The terminal already has focus (the user typed before), as on a device.
    await tester.tap(terminalView);
    await tester.pumpAndSettle();
    expect(position().pixels, position().maxScrollExtent);

    // Finger rests past the tap deadline, then drags while the keyboard
    // slides up over several frames (each inset change shrinks the body).
    final drag = await tester.startGesture(
      tester.getCenter(terminalView),
      kind: PointerDeviceKind.touch,
    );
    await tester.pump(const Duration(milliseconds: 150));
    for (var i = 0; i < 6; i++) {
      tester.view.viewInsets = FakeViewPadding(bottom: 50.0 * (i + 1));
      tester.binding.handleMetricsChanged();
      await drag.moveBy(const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await drag.up();
    await tester.pumpAndSettle();
    expect(
      position().pixels,
      lessThan(position().maxScrollExtent),
      reason: 'the first drag must not be swallowed by the keyboard pop',
    );

    // A second drag with the keyboard already open keeps scrolling.
    final after = position().pixels;
    final drag2 = await tester.startGesture(
      tester.getCenter(terminalView),
      kind: PointerDeviceKind.touch,
    );
    await tester.pump(const Duration(milliseconds: 150));
    for (var i = 0; i < 6; i++) {
      await drag2.moveBy(const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await drag2.up();
    await tester.pumpAndSettle();
    expect(position().pixels, lessThan(after));
  });
}
