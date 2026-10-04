import 'dart:async';

import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_view_wrapper.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xterm/xterm.dart' as xt;

class FakeWsClient extends WsClient {
  FakeWsClient() : super(urlBuilder: () async => Uri.parse('ws://test/shell'));

  final sent = <Map<String, dynamic>>[];
  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();
  WsState _state = WsState.open;

  @override
  Stream<Map<String, dynamic>> get frames => _frames.stream;
  @override
  Stream<WsState> get states => _states.stream;
  @override
  WsState get state => _state;

  @override
  void send(Map<String, dynamic> frame) => sent.add(frame);

  @override
  Future<void> connect() async {
    _state = WsState.open;
    _states.add(WsState.open);
  }

  @override
  Future<void> close() async => _state = WsState.closed;
  @override
  Future<void> dispose() async {
    await _frames.close();
    await _states.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeWsClient fakeWs;
  var tabSeq = 0;

  setUpAll(() {
    Hive.init('/tmp/ddagent_focus_repro_test');
  });

  setUp(() async {
    fakeWs = FakeWsClient();
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
    await Hive.box<dynamic>('settings').clear();
  });

  tearDown(() async {
    await fakeWs.dispose();
  });

  TerminalTab makeTab() => TerminalTab(
    id: 't${tabSeq++}',
    title: 't',
    projectPath: '/p',
    terminal: xt.Terminal(),
    channel: ShellChannel(fakeWs)..start(),
    status: TerminalTabStatus.connected,
  );

  /// Pumps the real split-grid layout: a chat pane with [field] next to a
  /// terminal pane — the exact tree the guard inspects.
  Widget app({Widget? field}) => ProviderScope(
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: Scaffold(
        body: SplitWorkspaceGrid(
          panes: const [
            SplitPane(id: 'chat', kind: PaneKind.chat),
            SplitPane(id: 'term', kind: PaneKind.terminal),
          ],
          activePaneId: 'term',
          onClosePane: (_) {},
          onReorderPanes: (_, _) {},
          renderPane: (pane, _) => pane.id == 'chat'
              ? field ?? const SizedBox()
              : TerminalViewWrapper(tab: makeTab(), autofocus: false),
        ),
      ),
    ),
  );

  Future<void> hoverTerminal(WidgetTester tester) async {
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(gesture.removePointer);
    // Start inside the chat pane — the pointer must cross into the
    // terminal region for MouseRegion.onEnter to fire.
    await gesture.addPointer(location: const Offset(100, 300));
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.byType(TerminalViewWrapper)));
    await tester.pump();
  }

  /// Seeds the pref into the `settings` box before the ProviderScope is
  /// pumped — `uiPreferencesProvider.build()` reads it synchronously.
  Future<void> enablePref(WidgetTester tester) => tester.runAsync(
    () =>
        Hive.box<dynamic>('settings')
            .put('uiPreferences', <String, dynamic>{'focusFollowsPointer': true}),
  );

  bool primaryInsideWrapper() {
    final ctx = FocusManager.instance.primaryFocus?.context;
    return ctx?.findAncestorWidgetOfExactType<TerminalViewWrapper>() != null;
  }

  bool primaryInsideEditable() {
    final ctx = FocusManager.instance.primaryFocus?.context;
    return ctx?.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  testWidgets('hover focuses the terminal when the pref is on', (tester) async {
    await enablePref(tester);
    await tester.pumpWidget(app());
    await tester.pump();

    expect(primaryInsideWrapper(), isFalse);
    await hoverTerminal(tester);
    expect(primaryInsideWrapper(), isTrue);
  });

  testWidgets('pref off — hover does not focus', (tester) async {
    await tester.pumpWidget(app());
    await tester.pump();
    await hoverTerminal(tester);
    expect(primaryInsideWrapper(), isFalse);
  });

  testWidgets('single-line pane field keeps focus (web INPUT)', (tester) async {
    await enablePref(tester);
    await tester.pumpWidget(app(field: const TextField(autofocus: true)));
    await tester.pump();

    expect(primaryInsideEditable(), isTrue);
    await hoverTerminal(tester);
    expect(primaryInsideWrapper(), isFalse);
  });

  testWidgets('multi-line pane field hands off focus (web pane TEXTAREA)', (tester) async {
    await enablePref(tester);
    await tester.pumpWidget(app(field: const TextField(autofocus: true, maxLines: 8)));
    await tester.pump();

    expect(primaryInsideEditable(), isTrue);
    await hoverTerminal(tester);
    expect(primaryInsideWrapper(), isTrue);
  });

  testWidgets('multi-line field outside a pane keeps focus', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 100, child: TextField(autofocus: true, maxLines: 8)),
                Expanded(child: TerminalViewWrapper(tab: makeTab(), autofocus: false)),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(primaryInsideEditable(), isTrue);
    await hoverTerminal(tester);
    expect(primaryInsideWrapper(), isFalse);
  });
}
