// Terminal matrix — TerminalController semantics that every layout relies on:
// tab rows are per host (the /terminal route or a workspace pane), commands
// act on one row only, a moved tab stays live, closed panes take their tabs
// along, synced rows are per host, and the bell / ask flags.
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart'
    show maxSyncedTerminalTabs;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'terminal_matrix_harness.dart';

void main() {
  late FakeShells shells;
  late ProviderContainer container;
  TerminalController ctrl() => container.read(terminalControllerProvider.notifier);
  TerminalState state() => container.read(terminalControllerProvider);

  setUp(() {
    shells = FakeShells();
    container = ProviderContainer(overrides: [shells.override]);
  });
  tearDown(() => container.dispose());

  /// Frames reach the controller through an async broadcast stream.
  Future<void> flush() => Future<void>.delayed(Duration.zero);

  /// A tab laid out (init sent) and connected by a first output frame.
  Future<TerminalTab> open(
    String host, {
    String? title,
    String? sessionId,
    String provider = 'claude',
    bool isPlainShell = true,
    Map<String, String>? env,
  }) async {
    final tab = ctrl().createTab(
      projectPath: '/work/a',
      hostId: host,
      title: title,
      sessionId: sessionId,
      provider: provider,
      isPlainShell: isPlainShell,
      env: env,
      cols: 100,
      rows: 30,
    );
    shells.of(tab).output('ready \$ \r\n');
    await flush();
    return tab;
  }

  List<String> titles(String host) => [for (final t in state().tabsFor(host)) t.title];

  group('rows are per host (multi-pane)', () {
    test('select / cycle / select-at act on the named row only', () async {
      final a1 = await open('pane-a', title: 'a1');
      final a2 = await open('pane-a', title: 'a2');
      final b1 = await open('pane-b', title: 'b1');
      final b2 = await open('pane-b', title: 'b2');
      final r1 = await open(terminalRouteHost, title: 'r1');

      expect(state().activeTabFor('pane-a'), a2);
      expect(state().activeTabFor('pane-b'), b2);
      expect(state().activeTab, r1);

      ctrl().selectRelativeTab(1, hostId: 'pane-a');
      expect(state().activeTabFor('pane-a'), a1);
      expect(state().activeTabFor('pane-b'), b2, reason: 'Ctrl+Tab in pane A must not move B');

      ctrl().selectTabAt(8, hostId: 'pane-b'); // Ctrl+Alt+9 → last tab of B
      expect(state().activeTabFor('pane-b'), b2);
      ctrl().selectTabAt(0, hostId: 'pane-b');
      expect(state().activeTabFor('pane-b'), b1);
      expect(state().activeTabFor('pane-a'), a1);
      expect(state().activeTab, r1);
    });

    test('close others / to the right / duplicate / reorder stay inside the row', () async {
      final a1 = await open('pane-a', title: 'a1');
      await open('pane-a', title: 'a2');
      await open('pane-a', title: 'a3');
      await open('pane-b', title: 'b1');
      await open('pane-b', title: 'b2');

      ctrl().reorderTab(0, 2, hostId: 'pane-a');
      expect(titles('pane-a'), ['a2', 'a3', 'a1']);
      expect(titles('pane-b'), ['b1', 'b2']);

      final copy = ctrl().duplicateTab(a1.id)!;
      expect(copy.hostId, 'pane-a');
      expect(titles('pane-a'), ['a2', 'a3', 'a1', 'a1']);

      ctrl().closeTabsToRight(state().tabsFor('pane-a')[1].id);
      expect(titles('pane-a'), ['a2', 'a3']);
      ctrl().closeOtherTabs(state().tabsFor('pane-a').first.id);
      expect(titles('pane-a'), ['a2']);
      expect(titles('pane-b'), ['b1', 'b2'], reason: 'pane B keeps every tab');
    });

    test("closing one row's active tab picks its neighbour, other rows keep theirs", () async {
      final a1 = await open('pane-a', title: 'a1');
      final a2 = await open('pane-a', title: 'a2');
      final a3 = await open('pane-a', title: 'a3');
      final b1 = await open('pane-b', title: 'b1');
      ctrl().selectTab(a2.id);

      ctrl().closeTab(a2.id);
      expect(state().activeTabFor('pane-a'), a3);
      expect(state().activeTabFor('pane-b'), b1);
      expect(shells.of(a2).terminated, isTrue, reason: 'closing a tab ends its PTY');
      ctrl().closeTab(a3.id);
      expect(state().activeTabFor('pane-a'), a1);
      ctrl().closeTab(a1.id);
      expect(state().activeTabFor('pane-a'), isNull);
      expect(state().activeTabFor('pane-b'), b1);
    });

    test('moveTab hands over the live tab: same emulator and socket, no re-spawn', () async {
      final a1 = await open('pane-a', title: 'a1');
      final a2 = await open('pane-a', title: 'a2');
      a2.terminal.write('history line\r\n');
      final ws = shells.of(a2);
      final sentBefore = ws.sent.length;

      ctrl().moveTab(a2.id, toHost: 'pane-b');
      final moved = state().activeTabFor('pane-b')!;
      expect(identical(moved, a2), isTrue);
      expect(moved.terminal.buffer.getText(), contains('history line'));
      expect(ws.sent.length, sentBefore, reason: 'no init / terminate for a move');
      expect(state().activeTabFor('pane-a'), a1, reason: 'source row selects what is left');
      expect(moved.status, TerminalTabStatus.connected);
    });

    test('closeHostsExcept ends the tabs of panes that are gone, keeps the route row', () async {
      final a = await open('pane-a');
      final gone = await open('pane-gone');
      final route = await open(terminalRouteHost);

      ctrl().closeHostsExcept({'pane-a'});
      expect(state().tabs, [a, route]);
      expect(shells.of(gone).terminated, isTrue);
      expect(shells.of(a).terminated, isFalse);
    });

    test('synced rows are per host; applying one row leaves the others alone', () async {
      final a1 = await open('pane-a', title: 'a1');
      final b1 = await open('pane-b', title: 'b1');
      final rowA = ctrl().syncedRowFor('pane-a');
      expect([for (final t in rowA.tabs) t.id], [a1.syncId]);
      expect(rowA.activeTabId, a1.syncId);
      expect(rowA.tabs.single.ptySessionId, a1.syncId);

      // Another device opened a second tab in pane A and selected it.
      const spec = TerminalTabSpec(id: 'tab-remote', title: 'remote', projectPath: '/work/a');
      ctrl().applySyncedRow(
        'pane-a',
        TerminalHostSpec(tabs: [rowA.tabs.single, spec], activeTabId: spec.id),
      );
      expect(titles('pane-a'), ['a1', 'remote']);
      expect(state().activeTabFor('pane-a')!.syncId, 'tab-remote');
      expect(identical(state().tabsFor('pane-a').first, a1), isTrue, reason: 'live tab kept');
      expect(state().tabsFor('pane-b'), [b1]);
      expect(state().activeTabFor('pane-b'), b1);
    });

    test('a tab moved between panes on another device re-attaches the same PTY here', () async {
      final a1 = await open('pane-a', title: 'a1');
      final x = await open('pane-a', title: 'x');
      final rowA = ctrl().syncedRowFor('pane-a');
      final xSpec = rowA.tabs.last;

      // Pane B's row lands first (x appended), then pane A's (x gone).
      ctrl().applySyncedRow('pane-b', TerminalHostSpec(tabs: [xSpec], activeTabId: xSpec.id));
      ctrl().applySyncedRow('pane-a', TerminalHostSpec(tabs: [rowA.tabs.first]));

      final inB = state().tabsFor('pane-b').single;
      expect(inB.syncId, x.syncId);
      expect(inB.ptySessionId, x.ptySessionId, reason: 'same server PTY key');
      expect(state().tabsFor('pane-a'), [a1]);
      expect(shells.of(x).terminated, isFalse, reason: 'the other device moved it — keep the PTY');
    });

    test('latched key-bar modifiers are one shared arming for every row', () async {
      final a = await open('pane-a');
      final b = await open('pane-b');
      ctrl().toggleLatchedModifier(LatchedModifier.ctrl);
      ctrl().sendInput(b.id, 'c');
      expect(shells.of(b).inputs.last, '\x03');
      ctrl().sendInput(a.id, 'c');
      expect(shells.of(a).inputs.last, 'c', reason: 'released after one chord');
    });

    test("the emulator's own reports keep a latched modifier armed", () async {
      final a = await open('pane-a');
      ctrl().toggleLatchedModifier(LatchedModifier.ctrl);
      a.terminal.onOutput!('\x1b[<0;5;3M');
      a.terminal.onOutput!('\x1b[I');
      a.terminal.onOutput!('\x1b[2;1R');
      ctrl().sendInput(a.id, 'c');
      expect(shells.of(a).inputs, ['\x1b[<0;5;3M', '\x1b[I', '\x1b[2;1R', '\x03']);
    });
  });

  group('per-tab session actions touch only their own socket', () {
    test('restart / disconnect / reconnect / kill / clear', () async {
      final a = await open('pane-a');
      final b = await open('pane-b');
      final wsA = shells.of(a);
      final wsB = shells.of(b);
      wsB.sent.clear();

      ctrl().restartTab(a.id);
      expect(wsA.inits.last['forceRestart'], isTrue);
      expect(a.status, TerminalTabStatus.connecting);
      expect(wsA.connectCalls, 1, reason: 'restart on an open socket must not dial a second one');

      // Restart from a disconnected tab re-opens the socket first.
      ctrl().disconnectTab(a.id);
      ctrl().restartTab(a.id);
      expect(wsA.connectCalls, 2);
      expect(wsA.inits.last['forceRestart'], isTrue);

      ctrl().disconnectTab(a.id);
      expect(wsA.state.name, 'closed');
      expect(a.status, TerminalTabStatus.disconnected);
      ctrl().reconnectTab(a.id);
      expect(wsA.state.name, 'open');
      expect(wsA.inits.last['forceRestart'], isFalse, reason: 'reattach, not restart');

      ctrl().sendInput(a.id, '\x03'); // menu "Kill running process"
      expect(wsA.inputs.last, '\x03');
      ctrl().clearTab(a.id);
      expect(wsB.sent, isEmpty, reason: 'pane B untouched by pane A actions');
      expect(b.status, TerminalTabStatus.connected);
    });

    test('restart on a socket in a reconnect backoff re-dials it right away', () async {
      final a = await open('pane-a');
      final wsA = shells.of(a);
      wsA.drop();
      wsA.sent.clear();

      ctrl().restartTab(a.id);
      expect(wsA.reconnectNowCalls, 1, reason: 'no waiting out the backoff');
      expect(wsA.connectCalls, 1, reason: 'the reconnect loop owns the socket — no second dial');
      expect(wsA.inits, isEmpty, reason: 'init goes out once the socket is open');

      // The backoff retry lands: the restart init goes out, forced.
      await wsA.connect();
      expect(wsA.inits.single['forceRestart'], isTrue);
      expect(a.status, TerminalTabStatus.connecting);
    });

    test('an exited tab restarts on Connect; a live one reattaches', () async {
      final a = await open('pane-a');
      shells.of(a).output('bye\r\n', exitCode: 3);
      await flush();
      expect(a.status, TerminalTabStatus.exited);
      expect(a.exitCode, 3);
      shells.of(a).sent.clear();
      ctrl().reconnectTab(a.id);
      expect(shells.of(a).inits.single['forceRestart'], isTrue);
    });

    test('zoom is per tab and clamps', () async {
      final a = await open('pane-a');
      final b = await open('pane-b');
      for (var i = 0; i < 30; i++) {
        ctrl().zoomIn(a.id);
      }
      expect(a.fontSize, terminalFontSizeMax);
      expect(b.fontSize, terminalFontSizeDefault);
      ctrl().zoomReset(a.id);
      expect(a.fontSize, terminalFontSizeDefault);
    });

    test('OSC title names only its tab until renamed', () async {
      final a = await open('pane-a', title: 'a');
      final b = await open('pane-b', title: 'b');
      shells.of(a).output('\x1b]0;claude: fix tests\x07');
      await flush();
      expect(a.displayTitle, 'claude: fix tests');
      expect(b.displayTitle, 'b');
      ctrl().renameTab(a.id, 'mine');
      shells.of(a).output('\x1b]0;other\x07');
      await flush();
      expect(a.displayTitle, 'mine');
    });
  });

  group('bell flag', () {
    test('BEL flags the tab; selecting it clears the flag', () async {
      final a1 = await open('pane-a');
      await open('pane-a');
      shells.of(a1).output('\x07');
      await flush();
      expect(a1.bell, isTrue);
      ctrl().selectTab(a1.id);
      expect(a1.bell, isFalse);
    });

    test('OSC 9 and 777 ring; OSC 9;4 progress does not', () async {
      final a = await open('pane-a');
      shells.of(a).output('\x1b]9;4;1;50\x07');
      await flush();
      expect(a.bell, isFalse, reason: 'ConEmu progress is sent while working');
      shells.of(a).output('\x1b]9;turn finished\x07');
      await flush();
      expect(a.bell, isTrue);
      ctrl().acknowledgeBell('pane-a');
      expect(a.bell, isFalse);
      shells.of(a).output('\x1b]777;notify;Claude;done\x07');
      await flush();
      expect(a.bell, isTrue);
    });

    test('a replayed bell and a bell right after typing do not ring', () async {
      final a = await open('pane-a');
      shells.of(a).output('\x07', replay: true);
      await flush();
      expect(a.bell, isFalse);
      ctrl().sendInput(a.id, '\t');
      shells.of(a).output('\x07');
      await flush(); // failed completion beep
      expect(a.bell, isFalse);
    });

    test('typing into a flagged tab clears it; acknowledge clears only the visible tab', () async {
      final a1 = await open('pane-a');
      final a2 = await open('pane-a');
      final b1 = await open('pane-b');
      shells.of(a1).output('\x07');
      await flush();
      shells.of(a2).output('\x07');
      await flush();
      shells.of(b1).output('\x07');
      await flush();

      ctrl().acknowledgeBell('pane-a'); // a2 visible
      expect([a1.bell, a2.bell, b1.bell], [true, false, true]);
      a1.terminal.textInput('x'); // keystroke via the emulator
      expect(a1.bell, isFalse);
      expect(b1.bell, isTrue);
    });
  });

  group('duplicate', () {
    test('a resumed session duplicates to a fresh CLI of its provider, account env kept', () async {
      final env = {'CODEX_HOME': '/home/u/.codex-work'};
      final s = await open(
        'pane-a',
        title: 'Fix bug',
        sessionId: 'sess-1',
        provider: 'codex',
        isPlainShell: false,
        env: env,
      );
      final copy = ctrl().duplicateTab(s.id)!;
      expect(copy.sessionId, isNull, reason: 'resuming again would share the PTY');
      expect(copy.provider, 'codex');
      expect(copy.isPlainShell, isFalse);
      expect(copy.env, env);
      expect(copy.ptySessionId, copy.syncId);
      expect(copy.title, 'codex CLI');
      expect(state().tabsFor('pane-a'), [s, copy]);
      copy.terminal.resize(80, 24);
      final init = shells.of(copy).inits.single;
      expect(init['hasSession'], isFalse);
      expect(init['sessionId'], copy.syncId);
      expect(init['provider'], 'codex');
      expect(init['env'], env);
    });

    test('a one-shot command duplicates to a plain shell without its env', () async {
      final cmd = ctrl().runOneShotCommand(
        projectPath: '/work/a',
        command: 'npm i -g x',
        env: {'K': 'V'},
      );
      final copy = ctrl().duplicateTab(cmd.id)!;
      expect(copy.isCommandMode, isFalse);
      expect(copy.initialCommand, isNull);
      expect(copy.env, isNull);
      expect(copy.isPlainShell, isTrue);
    });
  });

  test('prompt options are per tab and clear on non-prompt output', () async {
    final a = await open('pane-a');
    final b = await open('pane-b');
    shells.of(a).output('Pick:\r\n❯ 1. Yes\r\n  2. No\r\nesc to cancel\r\n');
    await flush();
    await flush();
    await Future<void>.delayed(const Duration(milliseconds: 650));
    expect(a.promptOptions?.map((o) => o.label), ['Yes', 'No']);
    expect(b.promptOptions, isNull);
    ctrl().answerPrompt(a.id, '2');
    expect(shells.of(a).inputs.last, '2');
    expect(a.promptOptions, isNull);
  });

  group('connection and run lifecycle', () {
    test('Connect after a start error asks the server again', () async {
      final tab = ctrl().createTab(projectPath: '/gone', hostId: 'pane-a', cols: 100, rows: 30);
      shells.of(tab).emit({'type': 'error', 'message': 'Invalid project path'});
      await flush();
      expect(tab.status, TerminalTabStatus.disconnected);

      shells.of(tab).sent.clear();
      ctrl().reconnectTab(tab.id);
      expect(shells.of(tab).inits, hasLength(1));
    });

    test('a finished run is reported once and not spawned again on reconnect', () async {
      final codes = <int>[];
      final tab = ctrl().createTab(
        projectPath: '/work/a',
        hostId: 'pane-a',
        initialCommand: 'npm i -g foo',
        onComplete: codes.add,
        cols: 100,
        rows: 30,
      );
      shells.of(tab).output('done\r\n', exitCode: 0);
      await flush();
      shells.of(tab).output('again\r\n', exitCode: 0);
      await flush();
      expect(codes, [0]);

      shells.of(tab).sent.clear();
      shells.of(tab).drop();
      await shells.of(tab).connect();
      await flush();
      expect(shells.of(tab).inits, isEmpty);

      ctrl().restartTab(tab.id);
      expect(shells.of(tab).inits.single['forceRestart'], isTrue);
    });

    test("a bell in another device's live output still marks the tab", () async {
      final a = await open('pane-a');
      shells.of(a).emit({'type': 'output', 'data': '\x07', 'replay': true, 'live': true});
      await flush();
      expect(a.bell, isTrue);
    });

    test('a new run does not continue a sequence cut off in the old one', () async {
      final a = await open('pane-a');
      shells.of(a).emit({'type': 'stream', 'id': 'run-1'});
      shells.of(a).output('\x1b]0;my ti');
      await flush();
      shells.of(a).emit({'type': 'stream', 'id': 'run-2'});
      shells.of(a).output('fresh prompt');
      await flush();
      expect(ctrl().copyOutputText(a.id), contains('fresh prompt'));
    });

    test('a socket down for a while shows as connecting until the reattach', () async {
      final a = await open('pane-a');
      shells.of(a).drop();
      await Future<void>.delayed(const Duration(milliseconds: 3200));
      expect(a.status, TerminalTabStatus.connecting);

      await shells.of(a).connect();
      shells.of(a).emit({'type': 'stream', 'id': 'run-1'});
      await flush();
      expect(a.status, TerminalTabStatus.connected);
    });

    test('tabs past the synced cap survive a row from another device', () async {
      final tabs = [
        for (var i = 0; i <= maxSyncedTerminalTabs; i++) await open('pane-a', title: 't$i'),
      ];
      final row = ctrl().syncedRowFor('pane-a');
      expect(row.tabs, hasLength(maxSyncedTerminalTabs));

      ctrl().applySyncedRow(
        'pane-a',
        TerminalHostSpec(tabs: row.tabs, activeTabId: row.tabs.first.id),
      );
      expect(state().tabsFor('pane-a'), tabs);
      expect(shells.of(tabs.last).terminated, isFalse);
    });
  });
}
