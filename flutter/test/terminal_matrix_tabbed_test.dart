// Terminal matrix — tabbed layouts: the compact breakpoint, where the
// workspace grid becomes a pane tab strip that mounts only the active pane,
// and several terminal tabs inside one pane. Switching keeps buffers and
// state; background tabs / panes carry the bell (green) and ask (amber)
// flags. Fake sockets only.
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:ddagent_app/features/terminal/view/terminal_tab_strip.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/workspace_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'terminal_matrix_harness.dart';

const _a = SplitPane(id: 'pA', kind: PaneKind.terminal, projectId: 'pa');
const _b = SplitPane(id: 'pB', kind: PaneKind.terminal, projectId: 'pb');

/// The compact pane strip's entries (the only ListView on screen).
Finder paneTabs() => find.descendant(of: find.byType(ListView), matching: find.byType(InkWell));
Finder paneTab(int index) => paneTabs().at(index);

Finder tabDot(Color color) => find.byWidgetPredicate(
  (w) =>
      w is Container &&
      w.decoration is BoxDecoration &&
      (w.decoration! as BoxDecoration).shape == BoxShape.circle &&
      (w.decoration! as BoxDecoration).color == color,
);

const _prompt = 'Allow?\r\n❯ 1. Yes\r\n  2. No\r\nesc to cancel\r\n';

void main() {
  late FakeShells shells;
  setUp(() => shells = FakeShells());

  /// Pump through layout and connect every tab (its spinner never settles).
  Future<void> settle(WidgetTester tester, ProviderContainer c) async {
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await connectAll(tester, c, shells);
    await tester.pumpAndSettle();
  }

  Future<ProviderContainer> pumpCompact(
    WidgetTester tester, {
    List<SplitPane> panes = const [_a, _b],
  }) async {
    await setMatrixSurface(tester, const Size(400, 800));
    final c = matrixContainer(
      shells,
      workspace: WorkspaceState(panes: panes, activePaneId: panes.first.id, serverLoaded: true),
    );
    await tester.pumpWidget(matrixApp(c, const WorkspaceScreen()));
    await settle(tester, c);
    return c;
  }

  Future<void> showPane(WidgetTester tester, ProviderContainer c, int index) async {
    await tester.tap(paneTab(index));
    await settle(tester, c);
  }

  group('compact pane strip', () {
    testWidgets('mounts only the active pane; switching keeps every tab and buffer', (
      tester,
    ) async {
      final c = await pumpCompact(tester);
      expect(find.byType(TerminalScreen), findsOneWidget);
      expect(paneTabs(), findsNWidgets(2));
      final aTab = terminalOf(c).tabsFor('pA').single;
      aTab.terminal.write('alpha output\r\n');

      await showPane(tester, c, 1);
      expect(workspaceOf(c).activePaneId, 'pB');
      expect(find.byType(TerminalScreen), findsOneWidget);
      final bTab = terminalOf(c).tabsFor('pB').single;
      expect(bTab.projectPath, '/work/b');
      expect(terminalOf(c).tabsFor('pA').single, aTab, reason: 'hidden pane keeps its tab');
      expect(shells.of(aTab).terminated, isFalse);

      // Output keeps arriving for the unmounted pane.
      shells.of(aTab).output('while hidden\r\n');
      await tester.pump();

      await showPane(tester, c, 0);
      expect(identical(terminalOf(c).tabsFor('pA').single, aTab), isTrue);
      expect(aTab.terminal.buffer.getText(), contains('alpha output'));
      expect(aTab.terminal.buffer.getText(), contains('while hidden'));
      expect(shells.of(aTab).inits.length, 1, reason: 'remount does not re-spawn');
      await drainTimers(tester);
    });

    testWidgets('each pane in the strip is named after the tab it shows', (tester) async {
      final c = await pumpCompact(tester);
      await showPane(tester, c, 1);
      await showPane(tester, c, 0);
      final ctrl = c.read(terminalControllerProvider.notifier);
      ctrl.renameTab(terminalOf(c).tabsFor('pA').single.id, 'api server');
      // The hidden pane's agent sets its window title (OSC 2).
      shells.of(terminalOf(c).tabsFor('pB').single).output('\x1b]2;claude: fix login\x07');
      await tester.pump();

      expect(find.descendant(of: paneTab(0), matching: find.text('api server')), findsOneWidget);
      expect(
        find.descendant(of: paneTab(1), matching: find.text('claude: fix login')),
        findsOneWidget,
      );
      await drainTimers(tester);
    });

    testWidgets('a hidden pane turns green on a bell, amber on a prompt; focus clears the bell', (
      tester,
    ) async {
      final c = await pumpCompact(tester);
      await showPane(tester, c, 1); // mount B once so it has a tab
      final bTab = terminalOf(c).tabsFor('pB').single;
      await showPane(tester, c, 0);

      shells.of(bTab).output('\x07');
      await tester.pump();
      await tester.pump();
      expect(bTab.bell, isTrue);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      shells.of(bTab).output(_prompt);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(find.byIcon(LucideIcons.triangleAlert), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing, reason: 'a question outranks done');

      await showPane(tester, c, 1);
      expect(bTab.bell, isFalse);
      expect(find.byIcon(LucideIcons.triangleAlert), findsNothing, reason: 'selected pane');
      // Phone width: the visible tab's prompt shows as answer chips.
      expect(find.text('1. Yes'), findsOneWidget);
      await tester.tap(find.text('2. No'));
      await tester.pump();
      expect(shells.of(bTab).inputs.last, '2');
      await drainTimers(tester);
    });

    testWidgets('the visible pane of the strip does not keep a bell', (tester) async {
      final c = await pumpCompact(tester);
      final aTab = terminalOf(c).tabsFor('pA').single;
      shells.of(aTab).output('\x07');
      await tester.pump();
      await tester.pump();
      expect(aTab.bell, isFalse);
      await drainTimers(tester);
    });

    testWidgets('Move to new pane switches the strip to the new pane with the live tab', (
      tester,
    ) async {
      final c = await pumpCompact(tester, panes: const [_a]);
      terminalCtrl(c).createTab(projectPath: '/work/a', hostId: 'pA', title: 'logs');
      await settle(tester, c);
      final logs = terminalOf(c).activeTabFor('pA')!;

      await tester.longPress(find.text('logs'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Move to new pane'));
      await settle(tester, c);

      final fresh = workspaceOf(c).panes.last;
      expect(workspaceOf(c).panes.length, 2);
      expect(workspaceOf(c).activePaneId, fresh.id);
      expect(paneTabs(), findsNWidgets(2), reason: 'two panes → strip');
      expect(find.byType(TerminalScreen), findsOneWidget);
      expect(identical(terminalOf(c).tabsFor(fresh.id).single, logs), isTrue);
      expect(
        find.descendant(of: find.byType(TerminalTabStrip), matching: find.text('logs')),
        findsOneWidget,
      );
      await drainTimers(tester);
    });

    testWidgets('closing the shown pane mounts its neighbour and ends only its tabs', (
      tester,
    ) async {
      final c = await pumpCompact(tester);
      await showPane(tester, c, 1);
      await showPane(tester, c, 0);
      final aTab = terminalOf(c).tabsFor('pA').single;
      final bTab = terminalOf(c).tabsFor('pB').single;

      await tester.tap(find.byTooltip('Close pane'));
      await settle(tester, c);
      expect(workspaceOf(c).panes.single.id, 'pB');
      expect(paneTabs(), findsNothing, reason: 'one pane left: no strip');
      expect(find.byType(TerminalScreen), findsOneWidget);
      expect(shells.of(aTab).terminated, isTrue);
      expect(terminalOf(c).tabs, [bTab]);
      await drainTimers(tester);
    });
  });

  group('several tabs in one pane', () {
    testWidgets('switching tabs keeps buffer, zoom and title; background tabs carry flags', (
      tester,
    ) async {
      final c = await pumpCompact(tester, panes: const [_a]);
      final first = terminalOf(c).tabsFor('pA').single;
      first.terminal.write('first buffer\r\n');
      terminalCtrl(c).zoomIn(first.id);
      shells.of(first).output('\x1b]0;claude: refactor\x07');
      await tester.pump();

      await tester.tap(find.byIcon(LucideIcons.plus));
      await settle(tester, c);
      final second = terminalOf(c).activeTabFor('pA')!;
      expect(second, isNot(first));

      // Background tab: a prompt is amber, a bell (after answering) green.
      shells.of(first).output(_prompt);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(tabDot(terminalAskColor), findsOneWidget);
      expect(find.text('1. Yes'), findsNothing, reason: 'chips are for the visible tab only');
      // The CLI redraws over its prompt, then rings.
      shells.of(first).output('\x1b[2J\x1b[Hdone\r\n\x07');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(tabDot(terminalAskColor), findsNothing);
      expect(tabDot(terminalBellColor), findsOneWidget);

      await tester.tap(find.text('claude: refactor'));
      await tester.pump(const Duration(milliseconds: 400));
      await settle(tester, c);
      expect(terminalOf(c).activeTabFor('pA'), first);
      expect(first.bell, isFalse);
      expect(first.fontSize, terminalFontSizeDefault + 1);
      expect(
        first.terminal.buffer.getText(),
        contains('done'),
        reason: 'output from the background',
      );
      expect(tabDot(terminalBellColor), findsNothing);
      expect(shells.of(first).inits.length, 1);
      await drainTimers(tester);
    });

    testWidgets('a disconnected background tab reattaches through Connect when shown', (
      tester,
    ) async {
      final c = await pumpCompact(tester, panes: const [_a]);
      final first = terminalOf(c).tabsFor('pA').single;
      await tester.tap(find.byIcon(LucideIcons.plus));
      await settle(tester, c);
      terminalCtrl(c).disconnectTab(first.id);
      await tester.pump();
      expect(first.status, TerminalTabStatus.disconnected);

      terminalCtrl(c).selectTab(first.id);
      await tester.pump();
      expect(find.text('Connect'), findsOneWidget);
      await tester.tap(find.text('Connect'));
      await tester.pump();
      expect(shells.of(first).inits.last['forceRestart'], isFalse);
      await settle(tester, c);
      await drainTimers(tester);
    });
  });
}
