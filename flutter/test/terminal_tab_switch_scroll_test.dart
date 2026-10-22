import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/text_selection_scroll_behavior.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
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

void main() {
  testWidgets('switching tabs keeps each tab where it was scrolled', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
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

    final first = ctrl.state.tabs.single;
    connect(first);
    for (var i = 0; i < 300; i++) {
      first.terminal.write('line $i\r\n');
    }
    await tester.pumpAndSettle();

    ScrollPosition position() => tester
        .widget<Scrollable>(
          find
              .descendant(of: find.byType(xt.TerminalView), matching: find.byType(Scrollable))
              .first,
        )
        .controller!
        .position;

    // Scrolled into the history, 1000 px above the bottom.
    position().jumpTo(position().maxScrollExtent - 1000);
    await tester.pumpAndSettle();
    final fromBottom = position().maxScrollExtent - position().pixels;

    final second = ctrl.createTab(projectPath: '/p', isPlainShell: true);
    connect(second);
    await tester.pumpAndSettle();
    ctrl.selectTab(first.id);
    await tester.pumpAndSettle();
    expect(position().maxScrollExtent - position().pixels, fromBottom);

    // A tab left at the bottom comes back at the bottom.
    position().jumpTo(position().maxScrollExtent);
    await tester.pumpAndSettle();
    ctrl.selectTab(second.id);
    await tester.pumpAndSettle();
    ctrl.selectTab(first.id);
    await tester.pumpAndSettle();
    expect(position().pixels, position().maxScrollExtent);
  });
}
