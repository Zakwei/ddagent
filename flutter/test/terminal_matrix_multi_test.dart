// Terminal matrix — multi-pane layout: a desktop workspace grid with two or
// three terminal panes. Each pane owns its tab row; chords act on the
// focused pane only; a moved tab stays live; a closed pane ends its tabs;
// synced rows are per pane; flags and maximize. Fake sockets only.
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/features/workspace/view/workspace_screen.dart';
import 'package:flutter/gestures.dart' show kDoubleTapTimeout;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:xterm/xterm.dart' as xt;

import 'terminal_matrix_harness.dart';

const _a = SplitPane(id: 'pA', kind: PaneKind.terminal, projectId: 'pa');
const _b = SplitPane(id: 'pB', kind: PaneKind.terminal, projectId: 'pb');
const _c = SplitPane(id: 'pC', kind: PaneKind.terminal, projectId: 'pa');

Finder inPane(String paneId, Finder matching) =>
    find.descendant(of: find.byKey(ValueKey('terminal-$paneId')), matching: matching);

/// Host of the terminal holding the keyboard (null: none).
String? focusedHost() => FocusManager.instance.primaryFocus?.context
    ?.findAncestorWidgetOfExactType<TerminalScreen>()
    ?.hostId;

Future<void> chord(WidgetTester tester, LogicalKeyboardKey key, {bool shift = false}) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyDownEvent(key);
  await tester.sendKeyUpEvent(key);
  if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pump();
}

void main() {
  late FakeShells shells;
  setUp(() => shells = FakeShells());

  Future<ProviderContainer> pumpGrid(
    WidgetTester tester, {
    List<SplitPane> panes = const [_a, _b],
  }) async {
    await setMatrixSurface(tester, const Size(1500, 900));
    final c = matrixContainer(
      shells,
      workspace: WorkspaceState(panes: panes, activePaneId: panes.first.id, serverLoaded: true),
    );
    await tester.pumpWidget(matrixApp(c, const WorkspaceScreen()));
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();
    return c;
  }

  /// Click into a pane's terminal: focuses its view and activates the pane.
  Future<void> focusPane(WidgetTester tester, String paneId) async {
    await tester.tap(inPane(paneId, find.byType(xt.TerminalView)));
    await tester.pumpAndSettle();
  }

  testWidgets('three panes: one tab row each, in its own project, synced per pane', (tester) async {
    final c = await pumpGrid(tester, panes: const [_a, _b, _c]);
    expect(find.byType(TerminalScreen), findsNWidgets(3));
    for (final (pane, path) in [(_a, '/work/a'), (_b, '/work/b'), (_c, '/work/a')]) {
      final tab = terminalOf(c).tabsFor(pane.id).single;
      expect(tab.projectPath, path);
      expect(workspaceOf(c).terminals[pane.id]!.tabs.single.id, tab.syncId);
    }

    // `+` of pane B adds to pane B only.
    await tester.tap(inPane('pB', find.byIcon(LucideIcons.plus)));
    await tester.pump();
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();
    expect(terminalOf(c).tabsFor('pB').length, 2);
    expect(terminalOf(c).tabsFor('pA').length, 1);
    expect(terminalOf(c).tabsFor('pC').length, 1);
    expect(workspaceOf(c).terminals['pB']!.tabs.length, 2);
    expect(workspaceOf(c).terminals['pA']!.tabs.length, 1);
    await drainTimers(tester);
  });

  testWidgets('chords act on the focused pane only', (tester) async {
    final c = await pumpGrid(tester);
    await focusPane(tester, 'pB');
    expect(workspaceOf(c).activePaneId, 'pB');

    await chord(tester, LogicalKeyboardKey.keyT, shift: true);
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();
    expect(terminalOf(c).tabsFor('pB').length, 2);
    expect(terminalOf(c).tabsFor('pA').length, 1);

    final bActive = terminalOf(c).activeTabFor('pB')!;
    await chord(tester, LogicalKeyboardKey.tab); // Ctrl+Tab cycles B's row
    expect(terminalOf(c).activeTabFor('pB'), isNot(bActive));

    final aTab = terminalOf(c).activeTabFor('pA')!;
    final bTab = terminalOf(c).activeTabFor('pB')!;
    await chord(tester, LogicalKeyboardKey.equal);
    expect(bTab.fontSize, terminalFontSizeDefault + 1);
    expect(aTab.fontSize, terminalFontSizeDefault);

    // The keyboard stayed in pane B's (new) terminal all along.
    expect(focusedHost(), 'pB');
    expect(shells.of(aTab).inputs, isEmpty);

    await chord(tester, LogicalKeyboardKey.keyW, shift: true);
    await tester.pumpAndSettle();
    expect(terminalOf(c).tabsFor('pB').length, 1);
    expect(terminalOf(c).tabsFor('pA').single, aTab);

    // Focus moves to pane A: the same chord now works there.
    await focusPane(tester, 'pA');
    await chord(tester, LogicalKeyboardKey.keyT, shift: true);
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();
    expect(terminalOf(c).tabsFor('pA').length, 2);
    expect(terminalOf(c).tabsFor('pB').length, 1);
    expect(focusedHost(), 'pA');
    await drainTimers(tester);
  }, variant: const TargetPlatformVariant({TargetPlatform.linux}));

  testWidgets('a pane added or picked in the workspace takes the keyboard', (tester) async {
    final c = await pumpGrid(tester);
    await focusPane(tester, 'pA');
    expect(focusedHost(), 'pA');

    // "Add terminal pane": the new pane's first tab gets the keyboard.
    final added = c.read(workspaceProvider.notifier).openPane(PaneKind.terminal, projectId: 'pa')!;
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();
    expect(focusedHost(), added);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(shells.of(terminalOf(c).activeTabFor(added)!).inputs, ['\x1b']);

    // Picking another pane (overview, compact strip, a session opened there).
    c.read(workspaceProvider.notifier).setActivePaneId('pB');
    await tester.pumpAndSettle();
    expect(focusedHost(), 'pB');
    await drainTimers(tester);
  }, variant: const TargetPlatformVariant({TargetPlatform.linux}));

  /// A tab's tap lands once the double-tap (rename) window has passed.
  Future<void> tapTab(WidgetTester tester, TerminalTab tab) async {
    await tester.tap(find.byKey(ValueKey('terminal-tab-${tab.id}')));
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 10));
    await tester.pumpAndSettle();
  }

  testWidgets('a tab clicked in another pane\'s strip takes the keyboard there', (tester) async {
    final c = await pumpGrid(tester);
    terminalCtrl(c).createTab(projectPath: '/work/b', hostId: 'pB', title: 'second');
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();
    final [b1, b2] = terminalOf(c).tabsFor('pB');
    terminalCtrl(c).selectTab(b2.id);
    await tester.pumpAndSettle();

    await focusPane(tester, 'pA');
    expect(focusedHost(), 'pA');

    // Switching tabs in pane B's strip.
    await tapTab(tester, b1);
    expect(workspaceOf(c).activePaneId, 'pB');
    expect(terminalOf(c).activeTabFor('pB'), b1);
    expect(focusedHost(), 'pB');
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(shells.of(b1).inputs, ['\x1b']);
    expect(shells.of(terminalOf(c).activeTabFor('pA')!).inputs, isEmpty);

    // Clicking the tab that is already active moves the keyboard too.
    await focusPane(tester, 'pA');
    await tapTab(tester, b1);
    expect(focusedHost(), 'pB');
    await drainTimers(tester);
  }, variant: const TargetPlatformVariant({TargetPlatform.linux}));

  testWidgets('a tab clicked on a touch platform does not grab the keyboard', (tester) async {
    final c = await pumpGrid(tester);
    final b = terminalOf(c).activeTabFor('pB')!;
    expect(
      FocusManager.instance.primaryFocus?.context?.findAncestorWidgetOfExactType<xt.TerminalView>(),
      isNull,
    );
    await tapTab(tester, b);
    expect(workspaceOf(c).activePaneId, 'pB');
    expect(focusedHost(), isNull, reason: 'no soft keyboard popping on a tab tap');
    await drainTimers(tester);
  }, variant: const TargetPlatformVariant({TargetPlatform.android}));

  testWidgets('Move to new pane hands a live tab from pane B to a new pane', (tester) async {
    final c = await pumpGrid(tester);
    terminalCtrl(c).createTab(projectPath: '/work/b', hostId: 'pB', title: 'build');
    await tester.pump();
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();
    final moving = terminalOf(c).activeTabFor('pB')!;
    moving.terminal.write('long build log\r\n');

    await tester.longPress(inPane('pB', find.text('build')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Move to new pane'));
    await tester.pumpAndSettle();

    final ws = workspaceOf(c);
    expect(ws.panes.length, 3);
    final fresh = ws.panes.last;
    expect(ws.activePaneId, fresh.id);
    expect(fresh.projectId, 'pb', reason: "the source pane's project");
    expect(identical(terminalOf(c).tabsFor(fresh.id).single, moving), isTrue);
    expect(moving.terminal.buffer.getText(), contains('long build log'));
    expect(shells.of(moving).terminated, isFalse);
    expect(terminalOf(c).tabsFor('pB').length, 1);
    expect(ws.terminals['pB']!.tabs.length, 1);
    expect(ws.terminals[fresh.id]!.tabs.single.id, moving.syncId);
    expect(inPane(fresh.id, find.text('build')), findsOneWidget);
    await drainTimers(tester);
  });

  testWidgets('closing one pane ends its tabs only and drops only its row', (tester) async {
    final c = await pumpGrid(tester);
    final aTab = terminalOf(c).tabsFor('pA').single;
    final bTab = terminalOf(c).tabsFor('pB').single;
    await tester.tap(find.byTooltip('Close pane').at(1));
    await tester.pumpAndSettle();
    expect(workspaceOf(c).panes.map((p) => p.id), ['pA']);
    expect(terminalOf(c).tabs, [aTab]);
    expect(shells.of(bTab).terminated, isTrue);
    expect(shells.of(aTab).terminated, isFalse);
    expect(workspaceOf(c).terminals.keys, ['pA']);
    await drainTimers(tester);
  });

  testWidgets("another device's row edit applies to that pane only", (tester) async {
    final c = await pumpGrid(tester);
    final aTab = terminalOf(c).tabsFor('pA').single;
    final row = workspaceOf(c).terminals['pB']!;
    const remote = TerminalTabSpec(id: 'tab-remote', title: 'remote', projectPath: '/work/b');
    c
        .read(workspaceProvider.notifier)
        .setTerminalHost(
          'pB',
          TerminalHostSpec(tabs: [...row.tabs, remote], activeTabId: remote.id),
        );
    await tester.pump();
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();
    expect(terminalOf(c).tabsFor('pB').map((t) => t.syncId), [row.tabs.single.id, 'tab-remote']);
    expect(terminalOf(c).tabsFor('pA'), [aTab]);
    expect(inPane('pB', find.text('remote')), findsOneWidget);

    // It closes the first tab there: closed here too, its PTY left alone.
    final closed = terminalOf(c).tabsFor('pB').first;
    c
        .read(workspaceProvider.notifier)
        .setTerminalHost('pB', const TerminalHostSpec(tabs: [remote], activeTabId: 'tab-remote'));
    await tester.pumpAndSettle();
    expect(terminalOf(c).tabsFor('pB').single.syncId, 'tab-remote');
    expect(shells.of(closed).terminated, isFalse);
    await drainTimers(tester);
  });

  testWidgets('a tab opened before the server snapshot survives it, PTY and all', (tester) async {
    await setMatrixSurface(tester, const Size(1500, 900));
    final c = matrixContainer(
      shells,
      workspace: const WorkspaceState(panes: [_a], activePaneId: 'pA'),
    );
    await tester.pumpWidget(matrixApp(c, const WorkspaceScreen()));
    await tester.pumpAndSettle();
    expect(terminalOf(c).tabsFor('pA'), isEmpty, reason: 'no seeded tab before the server row');

    // The user opens a shell from the empty state meanwhile.
    await tester.tap(inPane('pA', find.text('New Shell')));
    await tester.pump();
    await connectAll(tester, c, shells);
    final local = terminalOf(c).tabsFor('pA').single;

    // The server's row (another device's tab) arrives.
    const remote = TerminalTabSpec(id: 'tab-remote', title: 'remote', projectPath: '/work/a');
    (c.read(workspaceProvider.notifier) as FakeWorkspace).serverSnapshot(
      const WorkspaceState(
        panes: [_a],
        activePaneId: 'pA',
        terminals: {
          'pA': TerminalHostSpec(tabs: [remote], activeTabId: 'tab-remote'),
        },
      ),
    );
    await tester.pump();
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();

    expect(terminalOf(c).tabsFor('pA').map((t) => t.syncId), ['tab-remote', local.syncId]);
    expect(terminalOf(c).tabsFor('pA').last, same(local), reason: 'the same live tab, not a copy');
    expect(
      terminalOf(c).activeTabFor('pA'),
      same(local),
      reason: 'the shell just opened stays shown',
    );
    expect(shells.of(local).terminated, isFalse);
    expect(workspaceOf(c).terminals['pA']!.tabs.map((t) => t.id), ['tab-remote', local.syncId]);
    await drainTimers(tester);
  });

  testWidgets('grid headers and the overview show the question / finished flags', (tester) async {
    final c = await pumpGrid(tester);
    final aTab = terminalOf(c).activeTabFor('pA')!;
    final bTab = terminalOf(c).activeTabFor('pB')!;
    const question = 'QUESTION — input required';
    const finished = 'Unread — finished with new output';
    expect(find.byTooltip(question), findsNothing);
    expect(find.byTooltip(finished), findsNothing);

    // Pane B (background) finishes; pane A's CLI asks.
    shells.of(bTab).output('\x07');
    shells.of(aTab).output('Allow?\r\n❯ 1. Yes\r\n  2. No\r\nesc to cancel\r\n');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();
    expect(bTab.bell, isTrue);
    expect(aTab.promptOptions, isNotNull);
    expect(find.byTooltip(question), findsOneWidget);
    expect(find.byTooltip(finished), findsOneWidget);

    // The overview dialog carries both badges.
    await tester.tap(find.byIcon(LucideIcons.layoutGrid));
    await tester.pumpAndSettle();
    expect(find.text(question), findsOneWidget);
    expect(find.text(finished), findsOneWidget);
    await tester.tap(find.byTooltip('Close overview'));
    await tester.pumpAndSettle();

    // Seen once pane B is focused.
    await focusPane(tester, 'pB');
    expect(find.byTooltip(finished), findsNothing);
    await drainTimers(tester);
  });

  testWidgets('bell: an unfocused pane keeps its flag until focused; the focused one is seen', (
    tester,
  ) async {
    final c = await pumpGrid(tester);
    final aTab = terminalOf(c).activeTabFor('pA')!;
    final bTab = terminalOf(c).activeTabFor('pB')!;
    expect(workspaceOf(c).activePaneId, 'pA');

    shells.of(aTab).output('\x07');
    shells.of(bTab).output('\x07');
    await tester.pump();
    await tester.pump();
    expect(aTab.bell, isFalse, reason: 'visible tab of the focused pane');
    expect(bTab.bell, isTrue, reason: 'pane B is in the background');

    await focusPane(tester, 'pB');
    expect(bTab.bell, isFalse);
    await drainTimers(tester);
  });

  testWidgets('maximize keeps the other panes live offstage; Esc in a terminal keeps it', (
    tester,
  ) async {
    final c = await pumpGrid(tester);
    await focusPane(tester, 'pA');
    await tester.tap(find.byTooltip('Maximize pane').first);
    await tester.pumpAndSettle();
    expect(workspaceOf(c).maximizedPaneId, 'pA');
    expect(find.byType(TerminalScreen), findsOneWidget);
    expect(find.byType(TerminalScreen, skipOffstage: false), findsNWidgets(2));

    // Output of the hidden pane still lands in its buffer.
    final bTab = terminalOf(c).activeTabFor('pB')!;
    shells.of(bTab).output('while hidden\r\n');
    await tester.pump();
    expect(bTab.terminal.buffer.getText(), contains('while hidden'));

    // Esc belongs to the agent while the terminal has the keyboard.
    await focusPane(tester, 'pA');
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(workspaceOf(c).maximizedPaneId, 'pA');
    expect(shells.of(terminalOf(c).activeTabFor('pA')!).inputs.last, '\x1b');

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(workspaceOf(c).maximizedPaneId, isNull);
    expect(find.byType(TerminalScreen), findsNWidgets(2));
    await drainTimers(tester);
  });
}
