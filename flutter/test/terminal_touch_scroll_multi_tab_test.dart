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

/// Regression: a second shell tab inflated a fresh pane that autofocused, so
/// the soft keyboard slid up without any tap; a finger drag started while the
/// insets were still changing was cancelled by xterm's jump-to-bottom and the
/// terminal "could not be scrolled". A fresh pane no longer autofocuses on
/// touch platforms, and a drag with the keyboard open and insets moving keeps
/// scrolling the scrollback.
void main() {
  testWidgets('a touch drag scrolls a freshly opened second shell tab', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(tester.view.resetViewInsets);
    final container = ProviderContainer(
      overrides: [
        shellChannelProvider.overrideWith((ref, key) => ShellChannel(_FakeWs())..start()),
      ],
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
    void connect(TerminalTab tab) {
      tab.status = TerminalTabStatus.connected;
      ctrl.state = ctrl.state.copyWith(tabs: [...ctrl.state.tabs]);
    }

    connect(ctrl.state.tabs.single);
    await tester.pumpAndSettle();

    // `+`: second plain shell becomes active and its pane is inflated fresh.
    final second = ctrl.createTab(projectPath: '/p', isPlainShell: true);
    connect(second);
    await tester.pumpAndSettle();
    expect(ctrl.state.tabs.length, 2);
    for (var i = 0; i < 300; i++) {
      second.terminal.write('line $i\r\n');
    }
    await tester.pumpAndSettle();

    final terminalView = find.byType(xt.TerminalView);
    final scrollable = find.descendant(of: terminalView, matching: find.byType(Scrollable)).first;
    ScrollPosition position() => tester.widget<Scrollable>(scrollable).controller!.position;
    expect(position().pixels, position().maxScrollExtent);
    expect(
      FocusManager.instance.primaryFocus?.context?.findAncestorWidgetOfExactType<xt.TerminalView>(),
      isNull,
      reason: 'a fresh pane must not autofocus on a touch platform',
    );

    // Keyboard already sliding up; the finger drags while the insets keep changing.
    tester.view.viewInsets = const FakeViewPadding(bottom: 20);
    tester.binding.handleMetricsChanged();
    await tester.pump();
    final drag = await tester.startGesture(
      tester.getCenter(terminalView),
      kind: PointerDeviceKind.touch,
    );
    await tester.pump(const Duration(milliseconds: 150));
    for (var i = 0; i < 6; i++) {
      tester.view.viewInsets = FakeViewPadding(bottom: 20 + 50.0 * (i + 1));
      tester.binding.handleMetricsChanged();
      await drag.moveBy(const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await drag.up();
    await tester.pumpAndSettle();
    expect(
      position().pixels,
      lessThan(position().maxScrollExtent),
      reason: 'drag on a fresh second tab must scroll while the keyboard slides up',
    );
  });
}
