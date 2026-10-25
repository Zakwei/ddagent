// Terminal matrix — single-pane layout: the standalone `/terminal` screen
// (route host, synced through the workspace) and a workspace holding one
// terminal pane. Fake sockets only.
import 'package:ddagent_app/features/provider_accounts/state/provider_accounts_controller.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:ddagent_app/features/terminal/view/terminal_tab_strip.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/features/workspace/view/workspace_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'terminal_matrix_harness.dart';

/// The 7px status dot of a tab in the strip, by colour.
Finder tabDot(Color color) => find.byWidgetPredicate(
  (w) =>
      w is Container &&
      w.decoration is BoxDecoration &&
      (w.decoration! as BoxDecoration).shape == BoxShape.circle &&
      (w.decoration! as BoxDecoration).color == color,
);

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

  Future<ProviderContainer> pumpStandalone(
    WidgetTester tester, {
    String? sessionId,
    List<ProviderAccountEntry> accounts = const [],
    Size size = const Size(1100, 800),
  }) async {
    await setMatrixSurface(tester, size);
    final container = matrixContainer(
      shells,
      accounts: accounts,
      sessions: {'s1': fakeSession('s1', provider: 'codex', path: '/work/b')},
    );
    await tester.pumpWidget(
      matrixApp(container, Scaffold(body: TerminalScreen(sessionId: sessionId, syncTabs: true))),
    );
    await tester.pump();
    await tester.pump();
    await connectAll(tester, container, shells);
    await tester.pumpAndSettle();
    return container;
  }

  group('standalone /terminal', () {
    testWidgets('seeds one shell and publishes its row to the workspace', (tester) async {
      final c = await pumpStandalone(tester);
      final tabs = terminalOf(c).tabsFor(terminalRouteHost);
      expect(tabs.single.title, 'Shell 1');
      expect(tabs.single.projectPath, '/work/a', reason: 'first project when nothing picked');
      final row = workspaceOf(c).terminals[terminalRouteHost]!;
      expect(row.tabs.single.id, tabs.single.syncId);
      expect(row.activeTabId, tabs.single.syncId);
      await drainTimers(tester);
    });

    testWidgets('a sessionId link resumes the session in its own CLI and directory', (
      tester,
    ) async {
      final c = await pumpStandalone(tester, sessionId: 's1');
      final tab = terminalOf(c).activeTab!;
      expect(tab.sessionId, 's1');
      expect(tab.provider, 'codex');
      expect(tab.isPlainShell, isFalse);
      expect(tab.projectPath, '/work/b');
      expect(find.text('Session s1'), findsOneWidget);
      final init = shells.of(tab).inits.first;
      expect(init['hasSession'], isTrue);
      expect(init['sessionId'], 's1');

      // Duplicate opens a fresh codex CLI, not a second resume of s1.
      terminalCtrl(c).duplicateTab(tab.id);
      await tester.pump();
      final copy = terminalOf(c).activeTab!;
      expect(copy.sessionId, isNull);
      expect(copy.provider, 'codex');
      await connectAll(tester, c, shells);
      await drainTimers(tester);
    });

    testWidgets('project menu opens a tab in the picked project and remembers it', (tester) async {
      final c = await pumpStandalone(tester);
      expect(find.text('Alpha'), findsOneWidget);
      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta').last);
      await tester.pump();
      await connectAll(tester, c, shells);
      await tester.pumpAndSettle();

      final tabs = terminalOf(c).tabsFor(terminalRouteHost);
      expect(tabs.length, 2);
      expect(tabs.last.projectPath, '/work/b');
      expect(workspaceOf(c).lastUsedProjectId, 'pb');
      expect(find.text('Beta'), findsOneWidget, reason: 'strip shows the active tab project');
      // `+` keeps opening in the picked project.
      await tester.tap(find.byIcon(LucideIcons.plus));
      await tester.pump();
      expect(terminalOf(c).activeTab!.projectPath, '/work/b');
      await connectAll(tester, c, shells);
      await drainTimers(tester);
    });

    testWidgets('account profiles run the CLI as that account in the visible shell', (
      tester,
    ) async {
      final c = await pumpStandalone(
        tester,
        accounts: const [
          ProviderAccountEntry(
            id: '1',
            provider: 'claude',
            label: 'Work',
            envOverrides: {'CLAUDE_CONFIG_DIR': '/c/work'},
            isDefault: false,
          ),
        ],
      );
      final shell = terminalOf(c).activeTab!;
      await tester.tap(find.byTooltip('Terminal menu'));
      await tester.pumpAndSettle();
      expect(find.text('Claude CLI · Work'), findsOneWidget);
      await tester.tap(find.text('Claude CLI · Work'));
      await tester.pumpAndSettle();
      expect(terminalOf(c).tabs.length, 1, reason: 'typed into the connected plain shell');
      expect(
        shells.of(shell).inputs.last,
        "env CLAUDE_CONFIG_DIR='/c/work' claude --allow-dangerously-skip-permissions\r",
      );

      // A running CLI cannot take typed input: the profile opens its own tab
      // with the account env on the PTY instead.
      terminalCtrl(c).createTab(projectPath: '/work/a', provider: 'codex', isPlainShell: false);
      await tester.pump();
      await connectAll(tester, c, shells);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Terminal menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Claude CLI · Work'));
      await tester.pump();
      final tab = terminalOf(c).activeTab!;
      expect(tab.env, {'CLAUDE_CONFIG_DIR': '/c/work'});
      expect(tab.title, 'Claude CLI · Work');
      await connectAll(tester, c, shells);
      await drainTimers(tester);
    });

    testWidgets('background bell shows green, prompt amber; the visible tab is acknowledged', (
      tester,
    ) async {
      final c = await pumpStandalone(tester);
      final first = terminalOf(c).activeTab!;
      await tester.tap(find.byIcon(LucideIcons.plus));
      await tester.pump();
      await connectAll(tester, c, shells);
      await tester.pumpAndSettle();
      final second = terminalOf(c).activeTab!;

      // Visible tab rings: seen right away, no dot when switching away.
      shells.of(second).output('\x07');
      await tester.pump();
      await tester.pump();
      expect(second.bell, isFalse);

      // Background tab rings: green dot until selected.
      shells.of(first).output('\x07');
      await tester.pump();
      await tester.pump();
      expect(first.bell, isTrue);
      expect(tabDot(terminalBellColor), findsOneWidget);

      // A CLI prompt in the background outranks the bell: amber.
      shells.of(first).output('❯ 1. Yes\r\n  2. No\r\nesc to cancel\r\n');
      await tester.pump(const Duration(milliseconds: 600));
      expect(tabDot(terminalAskColor), findsOneWidget);
      expect(tabDot(terminalBellColor), findsNothing);

      await tester.tap(find.text('Shell 1'));
      // The tab also takes double-taps (rename): a tap lands after that window.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(first.bell, isFalse);
      expect(tabDot(terminalAskColor), findsNothing, reason: 'the visible tab shows no dot');
      await drainTimers(tester);
    });

    testWidgets('menu: zoom, key bar, clear, kill and the find button act on the active tab', (
      tester,
    ) async {
      final c = await pumpStandalone(tester);
      final tab = terminalOf(c).activeTab!;

      Future<void> menu(String group, String entry) async {
        await tester.tap(find.byTooltip('Terminal menu'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(group));
        await tester.pumpAndSettle();
        await tester.tap(find.text(entry));
        await tester.pumpAndSettle();
      }

      await menu('View', 'Zoom in');
      expect(tab.fontSize, terminalFontSizeDefault + 1);
      await menu('View', 'Reset zoom');
      expect(tab.fontSize, terminalFontSizeDefault);

      final barShown = terminalOf(c).showShortcutsBar;
      await menu('View', 'On-screen key bar');
      expect(terminalOf(c).showShortcutsBar, !barShown);

      await menu('Session', 'Kill running process (Ctrl+C)');
      expect(shells.of(tab).inputs.last, '\x03');

      tab.terminal.write('some output\r\n');
      await menu('Edit', 'Clear Output');
      expect(terminalCtrl(c).copyOutputText(tab.id), isNull);

      await tester.tap(find.byTooltip('Find  Ctrl+Shift+F'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Match case'), findsOneWidget);
      await drainTimers(tester);
    }, variant: const TargetPlatformVariant({TargetPlatform.linux}));

    testWidgets('Ctrl+Shift+P opens the menu; zoom chords and Ctrl+Alt+digit select', (
      tester,
    ) async {
      final c = await pumpStandalone(tester);
      final tab = terminalOf(c).activeTab!;
      await chord(tester, LogicalKeyboardKey.equal);
      expect(tab.fontSize, terminalFontSizeDefault + 1);
      await chord(tester, LogicalKeyboardKey.digit0);
      expect(tab.fontSize, terminalFontSizeDefault);

      await chord(tester, LogicalKeyboardKey.keyT, shift: true);
      await connectAll(tester, c, shells);
      await tester.pumpAndSettle();
      expect(terminalOf(c).activeTab, isNot(tab));
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(terminalOf(c).activeTab, tab);

      await chord(tester, LogicalKeyboardKey.keyP, shift: true);
      await tester.pumpAndSettle();
      expect(find.text('Plain Shell'), findsOneWidget);
      await drainTimers(tester);
    }, variant: const TargetPlatformVariant({TargetPlatform.linux}));

    testWidgets('Move to new pane hands the live tab to a new workspace pane', (tester) async {
      await setMatrixSurface(tester, const Size(1100, 800));
      final c = matrixContainer(shells);
      final router = GoRouter(
        initialLocation: '/terminal',
        routes: [
          GoRoute(
            path: '/terminal',
            builder: (_, _) => const Scaffold(body: TerminalScreen(syncTabs: true)),
          ),
          GoRoute(path: '/workspace', builder: (_, _) => const WorkspaceScreen()),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(matrixRouterApp(c, router: router));
      await tester.pump();
      await tester.pump();
      await connectAll(tester, c, shells);
      await tester.pumpAndSettle();
      final tab = terminalOf(c).activeTab!;
      tab.terminal.write('kept history\r\n');
      List<String?> spawns() => [
        for (final f in shells.of(tab).sent)
          if (f['type'] == 'init' || f['type'] == 'terminate') f['type'] as String?,
      ];
      final before = spawns();

      await tester.longPress(find.text('Shell 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Move to new pane'));
      await tester.pumpAndSettle();

      final ws = workspaceOf(c);
      final pane = ws.panes.single;
      expect(pane.kind, PaneKind.terminal);
      expect(pane.projectId, 'pa');
      expect(ws.activePaneId, pane.id);
      expect(router.state.uri.path, '/workspace');
      expect(identical(terminalOf(c).tabsFor(pane.id).single, tab), isTrue);
      expect(terminalOf(c).tabsFor(terminalRouteHost), isEmpty);
      expect(tab.terminal.buffer.getText(), contains('kept history'));
      expect(spawns(), before, reason: 'no re-spawn, no terminate — only a resize');
      expect(ws.terminals[pane.id]!.tabs.single.id, tab.syncId, reason: 'pane row published');
      expect(ws.terminals[terminalRouteHost]!.tabs, isEmpty);
      await drainTimers(tester);
    });
  });

  group('workspace with one terminal pane', () {
    const pane = SplitPane(id: 'p1', kind: PaneKind.terminal, projectId: 'pb');

    Future<ProviderContainer> pumpOne(WidgetTester tester, {SplitPane p = pane}) async {
      await setMatrixSurface(tester, const Size(1100, 800));
      final c = matrixContainer(
        shells,
        workspace: WorkspaceState(panes: [p], activePaneId: p.id, serverLoaded: true),
        sessions: {'s1': fakeSession('s1', provider: 'claude', path: '/work/b')},
      );
      await tester.pumpWidget(matrixApp(c, const WorkspaceScreen()));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await connectAll(tester, c, shells);
      await tester.pumpAndSettle();
      return c;
    }

    testWidgets("seeds a shell in the pane's project; no maximize for a lone pane", (tester) async {
      final c = await pumpOne(tester);
      final tab = terminalOf(c).tabsFor('p1').single;
      expect(tab.projectPath, '/work/b');
      expect(find.byTooltip('Maximize pane'), findsNothing);
      expect(workspaceOf(c).terminals['p1']!.tabs.single.id, tab.syncId);
      await drainTimers(tester);
    });

    testWidgets('closing the pane ends its tabs and drops its row', (tester) async {
      final c = await pumpOne(tester);
      final tab = terminalOf(c).tabsFor('p1').single;
      await tester.tap(find.byTooltip('Close pane'));
      await tester.pumpAndSettle();
      expect(terminalOf(c).tabs, isEmpty);
      expect(shells.of(tab).terminated, isTrue);
      expect(workspaceOf(c).terminals.containsKey('p1'), isFalse);
      await drainTimers(tester);
    });

    testWidgets('a migrated session pane resumes its session instead of the launcher', (
      tester,
    ) async {
      final c = await pumpOne(
        tester,
        p: const SplitPane(id: 'p1', kind: PaneKind.terminal, sessionId: 's1'),
      );
      final tab = terminalOf(c).tabsFor('p1').single;
      expect(tab.sessionId, 's1');
      expect(tab.projectPath, '/work/b');
      expect(find.byType(TerminalScreen), findsOneWidget);
      await drainTimers(tester);
    });

    testWidgets('tabs of a pane closed while the workspace was not shown are closed on mount', (
      tester,
    ) async {
      await setMatrixSurface(tester, const Size(1100, 800));
      final c = matrixContainer(
        shells,
        workspace: const WorkspaceState(panes: [pane], activePaneId: 'p1', serverLoaded: true),
      );
      final orphan = terminalCtrl(c).createTab(projectPath: '/work/a', hostId: 'pane-gone');
      final route = terminalCtrl(c).createTab(projectPath: '/work/a');
      await tester.pumpWidget(matrixApp(c, const WorkspaceScreen()));
      await tester.pump();
      await tester.pump();
      expect(terminalOf(c).tabs.contains(orphan), isFalse);
      expect(terminalOf(c).tabs.contains(route), isTrue, reason: '/terminal row is not a pane');
      await connectAll(tester, c, shells);
      await drainTimers(tester);
    });

    testWidgets('openSessionTab focuses an open tab instead of resuming twice', (tester) async {
      final c = await pumpOne(tester);
      final ws = c.read(workspaceProvider.notifier);
      expect(ws.openSessionTab(sessionId: 's9', provider: 'claude', projectPath: '/work/a'), 'p1');
      await tester.pump();
      await connectAll(tester, c, shells);
      await tester.pumpAndSettle();
      final resumed = terminalOf(c).activeTabFor('p1')!;
      expect(resumed.sessionId, 's9');
      terminalCtrl(c).selectTab(terminalOf(c).tabsFor('p1').first.id);
      await tester.pumpAndSettle();
      ws.openSessionTab(sessionId: 's9', provider: 'claude', projectPath: '/work/a');
      await tester.pumpAndSettle();
      expect(terminalOf(c).tabsFor('p1').length, 2);
      expect(terminalOf(c).activeTabFor('p1'), resumed);
      await drainTimers(tester);
    });
  });
}
