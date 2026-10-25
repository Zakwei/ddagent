import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/workspace_dialogs.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:xterm/xterm.dart' as xt;

class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://test/shell'));

  @override
  Stream<Map<String, dynamic>> get frames => const Stream.empty();
  @override
  Stream<WsState> get states => const Stream.empty();
  @override
  WsState get state => WsState.open;
  @override
  void send(Map<String, dynamic> frame) {}
  @override
  Future<void> connect() async {}
}

/// Terminal controller whose state the test drives directly — no PTYs.
class _FakeTerminal extends TerminalController {
  @override
  TerminalState build() => const TerminalState();

  void emit(TerminalState next) => state = next;
}

/// Same derivation as `WorkspaceScreen._questionHosts`: a connected tab
/// showing a CLI prompt marks its host pane as waiting on the user.
Set<String> _questionHosts(TerminalState s) => {
  for (final tab in s.tabs)
    if (tab.promptOptions != null && tab.status == TerminalTabStatus.connected) tab.hostId,
};

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_overview_hive');
    if (!Hive.isBoxOpen(WorkspaceStorage.boxName)) {
      await Hive.openBox<dynamic>(WorkspaceStorage.boxName);
    }
  });

  // Regression: the dialog used to get a snapshot from open time, so an
  // agent asking (or finishing) while it was open never changed the tile.
  testWidgets('question badge follows terminal prompts while the dialog is open', (tester) async {
    // Ahem glyphs are wide — give the 720px dialog room to lay out.
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    const pane = SplitPane(id: 'p1', kind: PaneKind.terminal, sessionId: 's1');
    final container = ProviderContainer(
      overrides: [terminalControllerProvider.overrideWith(_FakeTerminal.new)],
    );
    addTearDown(container.dispose);
    final channel = ShellChannel(_FakeWs())..start();
    addTearDown(channel.dispose);
    final tab = TerminalTab(
      id: 't1',
      syncId: 'sync-t1',
      title: 'claude',
      projectPath: '/p',
      hostId: 'p1',
      sessionId: 's1',
      terminal: xt.Terminal(),
      channel: channel,
      status: TerminalTabStatus.connected,
    );
    final terminal = container.read(terminalControllerProvider.notifier) as _FakeTerminal;
    terminal.emit(TerminalState(tabs: [tab]));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TranslationProvider(
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: Scaffold(
              body: SplitOverviewDialog(
                onSelectPane: (_) {},
                panes: (ref) {
                  final questions = ref.watch(terminalControllerProvider.select(_questionHosts));
                  final d = splitPaneDisplay(pane, questionPaneIds: questions);
                  return [
                    OverviewPaneInfo(
                      pane: pane,
                      title: d.title,
                      subtitle: d.subtitle,
                      action: d.action,
                    ),
                  ];
                },
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);

    // The CLI shows a numbered prompt → the tile turns into a question.
    tab.promptOptions = const [(number: '1', label: 'Yes'), (number: '2', label: 'No')];
    terminal.emit(TerminalState(tabs: [tab]));
    await tester.pump();
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    // Answered → back to idle.
    tab.promptOptions = null;
    terminal.emit(TerminalState(tabs: [tab]));
    await tester.pump();
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);

    // A prompt left on a disconnected tab is stale, not a live question.
    tab
      ..promptOptions = const [(number: '1', label: 'Yes')]
      ..status = TerminalTabStatus.disconnected;
    terminal.emit(TerminalState(tabs: [tab]));
    await tester.pump();
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
  });
}
