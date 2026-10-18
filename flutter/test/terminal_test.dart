import 'dart:async';

import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/terminal/state/terminal_output_filter.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/provider_login_dialog.dart';
import 'package:ddagent_app/features/terminal/view/terminal_keymap.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:ddagent_app/features/terminal/view/terminal_search.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
  void send(Map<String, dynamic> frame) {
    sent.add(frame);
  }

  void emitFrame(Map<String, dynamic> frame) => _frames.add(frame);
  void emitState(WsState s) {
    _state = s;
    _states.add(s);
  }

  int connectCalls = 0;

  @override
  Future<void> connect() async {
    connectCalls++;
    // Real WsClient emits `open` on success — ShellChannel re-sends the
    // stored init frame off that transition.
    emitState(WsState.open);
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
  late ShellChannel fakeChannel;

  /// Emit one output frame on the real event loop so the tab flips to
  /// `connected` — otherwise the connection overlay's spinner makes
  /// `pumpAndSettle` hang forever.
  Future<void> connectTab(WidgetTester tester) async {
    await tester.runAsync(() async {
      fakeWs.emitFrame({'type': 'output', 'data': 'ready \$ \r\n'});
      await Future<void>.delayed(const Duration(milliseconds: 30));
    });
    await tester.pump();
    // Fire the 500ms prompt-scan debounce so no fake timer leaks past
    // teardown ("A Timer is still pending" failures).
    await tester.pump(const Duration(milliseconds: 600));
  }

  setUp(() {
    fakeWs = FakeWsClient();
    fakeChannel = ShellChannel(fakeWs)..start();
  });

  tearDown(() async {
    await fakeWs.dispose();
  });

  group('TerminalController unit tests', () {
    test('createTab adds new tab and sends init frame', () {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);

      final tab = controller.createTab(
        title: 'Shell 1',
        projectPath: '/test/proj',
        isPlainShell: true,
      );

      final state = controller.state;
      expect(state.tabs.length, 1);
      expect(state.activeTabId, tab.id);
      expect(state.activeTab?.projectPath, '/test/proj');
      expect(state.activeTab?.isPlainShell, isTrue);
      // Nothing is spawned before the view is laid out: a PTY started at the
      // 80×24 placeholder would draw its prompt for the wrong width.
      expect(fakeWs.sent, isEmpty);
      tab.terminal.resize(132, 43, 1056, 731);
      expect(fakeWs.sent.length, 1);
      expect(fakeWs.sent.first['type'], 'init');
      expect(fakeWs.sent.first['projectPath'], '/test/proj');
      expect(fakeWs.sent.first['isPlainShell'], isTrue);
      expect(fakeWs.sent.first['cols'], 132);
      expect(fakeWs.sent.first['rows'], 43);
      // Later layouts are plain resizes.
      tab.terminal.resize(100, 30, 800, 510);
      expect(fakeWs.sent.last['type'], 'resize');
      expect(fakeWs.sent.last['cols'], 100);
    });

    test('a tab that is never laid out still starts after the grace period', () async {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      controller.createTab(projectPath: '/test/proj', autoSelect: false);
      expect(fakeWs.sent, isEmpty);
      await Future<void>.delayed(const Duration(milliseconds: 600));
      expect(fakeWs.sent.single['type'], 'init');
      expect(fakeWs.sent.single['cols'], 80);
      expect(fakeWs.sent.single['rows'], 24);
    });

    test('createTab for provider CLI initializes with provider name', () {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);

      final tab1 = controller.createTab(title: 'Shell 1', projectPath: '/test/proj');
      final tab2 = controller.createTab(
        title: 'Claude CLI',
        projectPath: '/test/proj',
        provider: 'claude',
        isPlainShell: false,
      );

      expect(controller.state.tabs.length, 2);
      expect(controller.state.activeTabId, tab2.id);
      expect(controller.state.activeTab?.provider, 'claude');
      expect(controller.state.activeTab?.isPlainShell, isFalse);

      controller.selectTab(tab1.id);
      expect(controller.state.activeTabId, tab1.id);
    });

    test('sendInput forwards user input to ShellChannel', () {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(projectPath: '/test/proj');

      fakeWs.sent.clear();
      controller.sendInput(tab.id, 'ls -la\n');
      expect(fakeWs.sent.length, 1);
      expect(fakeWs.sent.first['type'], 'input');
      expect(fakeWs.sent.first['data'], 'ls -la\n');
    });

    test('resize forwards cols and rows to ShellChannel', () {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(projectPath: '/test/proj');

      fakeWs.sent.clear();
      controller.resize(tab.id, 120, 40);
      expect(fakeWs.sent.length, 1);
      expect(fakeWs.sent.first['type'], 'resize');
      expect(fakeWs.sent.first['cols'], 120);
      expect(fakeWs.sent.first['rows'], 40);
    });

    test('output frames update terminal buffer and detect exit code', () async {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      int? completedExitCode;
      final controller = container.read(terminalControllerProvider.notifier);

      final tab = controller.runOneShotCommand(
        projectPath: '/test/proj',
        command: 'exit 0',
        title: 'One-shot test',
        onComplete: (code) => completedExitCode = code,
      );

      fakeWs.emitFrame({'type': 'output', 'data': 'Starting test...\r\n'});
      await Future<void>.delayed(const Duration(milliseconds: 10));

      var currentTab = controller.state.tabs.firstWhere((t) => t.id == tab.id);
      expect(currentTab.terminal.buffer.lines.length, greaterThan(0));
      expect(currentTab.isCompleted, isFalse);

      fakeWs.emitFrame({
        'type': 'output',
        'data': '\r\n\x1b[33mProcess exited with code 0\x1b[0m\r\n',
      });
      await Future<void>.delayed(const Duration(milliseconds: 20));

      currentTab = controller.state.tabs.firstWhere((t) => t.id == tab.id);
      expect(currentTab.status, TerminalTabStatus.exited);
      expect(currentTab.exitCode, 0);
      expect(currentTab.isCompleted, isTrue);
      expect(completedExitCode, 0);
    });

    test('detects auth_url frames', () async {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(projectPath: '/test/proj', title: 'Auth test');

      fakeWs.emitFrame({'type': 'auth_url', 'url': 'https://claude.ai/oauth/login?code=123'});
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final currentTab = controller.state.tabs.firstWhere((t) => t.id == tab.id);
      expect(currentTab.authUrls, contains('https://claude.ai/oauth/login?code=123'));
    });

    test('bestAuthUrl picks the longest URL over mid-render fragments', () {
      final urls = [
        'https://accounts.google.com/o/oauth2/auth?client_id=abc',
        'https://accounts.google.com/o/oauth2/auth?client_id=abcdef&scope=s&state=x',
        'https://accounts.google.com/o/oauth2/auth?client_id=ab',
      ];
      expect(
        bestAuthUrl(urls),
        'https://accounts.google.com/o/oauth2/auth?client_id=abcdef&scope=s&state=x',
      );
      expect(bestAuthUrl(const []), isNull);
    });

    test('tab navigation, closing, and toggling shortcuts', () {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);

      final tab1 = controller.createTab(projectPath: '/test/proj', title: 'Tab 1');
      final tab2 = controller.createTab(projectPath: '/test/proj', title: 'Tab 2');

      expect(controller.state.activeTabId, tab2.id);

      controller.selectTab(tab1.id);
      expect(controller.state.activeTabId, tab1.id);

      final initialShortcuts = controller.state.showShortcutsBar;
      controller.toggleShortcutsBar();
      expect(controller.state.showShortcutsBar, !initialShortcuts);

      controller.closeTab(tab1.id);
      expect(controller.state.tabs.length, 1);
      expect(controller.state.activeTabId, tab2.id);
    });

    // T58 — ShellHeader/connection-overlay parity.
    test('createTab opens the socket (init alone only stores the frame)', () {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      controller.createTab(projectPath: '/test/proj');
      expect(fakeWs.connectCalls, 1);
    });

    test('disconnectTab closes the socket; connectTab reopens it', () {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(projectPath: '/test/proj');
      fakeWs.emitFrame({'type': 'output', 'data': 'ready\r\n'});
      // Let the output land so the tab is "connected".
      expect(controller.state.tabs.single.status, TerminalTabStatus.connecting);

      controller.disconnectTab(tab.id);
      expect(controller.state.tabs.single.status, TerminalTabStatus.disconnected);
      expect(fakeWs.state, WsState.closed);

      // Input on a closed socket is dropped, not thrown.
      fakeWs.sent.clear();
      controller.sendInput(tab.id, 'x');
      expect(fakeWs.sent, isEmpty);

      controller.connectTab(tab.id);
      expect(controller.state.tabs.single.status, TerminalTabStatus.connecting);
      expect(fakeWs.connectCalls, 2);
    });

    test('zoom clamps to 9–24px', () {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(projectPath: '/test/proj');
      expect(tab.fontSize, 13);

      controller.zoomIn(tab.id);
      expect(tab.fontSize, 14);
      for (var i = 0; i < 30; i++) {
        controller.zoomIn(tab.id);
      }
      expect(tab.fontSize, terminalFontSizeMax);
      for (var i = 0; i < 30; i++) {
        controller.zoomOut(tab.id);
      }
      expect(tab.fontSize, terminalFontSizeMin);
    });

    test('copyOutputText joins buffer lines, trims trailing blanks', () async {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(projectPath: '/test/proj');

      expect(controller.copyOutputText(tab.id), isNull);
      fakeWs.emitFrame({'type': 'output', 'data': 'hello\r\nworld\r\n'});
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(controller.copyOutputText(tab.id), 'hello\nworld');
    });

    test('CLI prompt options surface after the debounce window', () async {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(projectPath: '/test/proj');

      fakeWs.emitFrame({
        'type': 'output',
        'data': 'Pick one:\r\n❯ 1. Approve\r\n  2. Reject\r\nesc to cancel\r\n',
      });
      await Future<void>.delayed(const Duration(milliseconds: 30));
      // Options appear only after the 500ms debounce.
      expect(tab.promptOptions, isNull);
      await Future<void>.delayed(const Duration(milliseconds: 600));
      expect(tab.promptOptions, isNotNull);
      expect(tab.promptOptions!.map((o) => o.number), ['1', '2']);
      expect(tab.promptOptions!.map((o) => o.label), ['Approve', 'Reject']);

      fakeWs.sent.clear();
      controller.answerPrompt(tab.id, '1');
      expect(tab.promptOptions, isNull);
      expect(fakeWs.sent.last['data'], '1');
    });

    test('non-prompt output clears any stale prompt options', () async {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(projectPath: '/test/proj');
      tab.promptOptions = [(number: '1', label: 'Approve')];

      fakeWs.emitFrame({'type': 'output', 'data': 'plain output\r\n'});
      await Future<void>.delayed(const Duration(milliseconds: 700));
      expect(tab.promptOptions, isNull);
    });

    test('runOneShotCommand and runProviderLogin spawn expected tabs', () {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);

      controller.runOneShotCommand(projectPath: '/test/proj', command: 'npm test');
      var active = controller.state.activeTab;
      expect(active?.title, 'Run: npm test');
      expect(active?.initialCommand, 'npm test');
      expect(active?.isCommandMode, isTrue);

      controller.runProviderLogin(projectPath: '/test/proj', provider: 'opencode');
      active = controller.state.activeTab;
      expect(active?.title, 'Login: opencode');
      expect(active?.initialCommand, 'opencode auth login');
    });

    test('one-shot init sends env and forceRestart only on the first send', () async {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      final tab = container
          .read(terminalControllerProvider.notifier)
          .runOneShotCommand(
            projectPath: '/test/proj',
            command: 'claude setup-token',
            env: {'CLAUDE_CONFIG_DIR': '/tmp/acct'},
          );
      tab.terminal.resize(80, 24, 640, 384); // first layout spawns the PTY
      await Future<void>.delayed(Duration.zero);

      final inits = fakeWs.sent.where((f) => f['type'] == 'init').toList();
      expect(inits.first['env'], {'CLAUDE_CONFIG_DIR': '/tmp/acct'});
      expect(inits.first['forceRestart'], isTrue);
      // The reconnect re-send must reattach, not kill the login it started.
      expect(inits.last['forceRestart'], isFalse);
      expect(inits.last['env'], {'CLAUDE_CONFIG_DIR': '/tmp/acct'});
    });
  });

  group('Windows Terminal tab management', () {
    late ProviderContainer container;
    late TerminalController ctrl;

    setUp(() {
      container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);
      ctrl = container.read(terminalControllerProvider.notifier);
    });

    List<String> titles() => ctrl.state.tabs.map((t) => t.title).toList();

    test('selectRelativeTab wraps; selectTabAt clamps to the last tab', () {
      final a = ctrl.createTab(projectPath: '/p', title: 'A');
      final b = ctrl.createTab(projectPath: '/p', title: 'B');
      final c = ctrl.createTab(projectPath: '/p', title: 'C');
      expect(ctrl.state.activeTabId, c.id);

      ctrl.selectRelativeTab(1);
      expect(ctrl.state.activeTabId, a.id);
      ctrl.selectRelativeTab(-1);
      expect(ctrl.state.activeTabId, c.id);

      ctrl.selectTabAt(1);
      expect(ctrl.state.activeTabId, b.id);
      ctrl.selectTabAt(8); // Ctrl+Alt+9 → last tab
      expect(ctrl.state.activeTabId, c.id);
    });

    test('reorderTab moves to the final position', () {
      ctrl.createTab(projectPath: '/p', title: 'A');
      ctrl.createTab(projectPath: '/p', title: 'B');
      ctrl.createTab(projectPath: '/p', title: 'C');

      ctrl.reorderTab(0, 2);
      expect(titles(), ['B', 'C', 'A']);
      ctrl.reorderTab(2, 0);
      expect(titles(), ['A', 'B', 'C']);
      ctrl.reorderTab(1, 1);
      expect(titles(), ['A', 'B', 'C']);
    });

    test('renameTab edits in place; blank names are ignored', () {
      final tab = ctrl.createTab(projectPath: '/p', title: 'A');
      ctrl.renameTab(tab.id, '  build  ');
      expect(ctrl.state.activeTab?.title, 'build');
      ctrl.renameTab(tab.id, '   ');
      expect(ctrl.state.activeTab?.title, 'build');
    });

    test('duplicateTab copies the profile and lands right after the source', () {
      final a = ctrl.createTab(
        projectPath: '/p',
        title: 'A',
        provider: 'claude',
        isPlainShell: false,
      );
      ctrl.createTab(projectPath: '/p', title: 'B');

      final copy = ctrl.duplicateTab(a.id)!;
      expect(titles(), ['A', 'A', 'B']);
      expect(copy.provider, 'claude');
      expect(copy.isPlainShell, isFalse);
      expect(copy.projectPath, '/p');
      expect(ctrl.state.activeTabId, copy.id);
    });

    test('closeOtherTabs / closeTabsToRight', () {
      ctrl.createTab(projectPath: '/p', title: 'A');
      final b = ctrl.createTab(projectPath: '/p', title: 'B');
      ctrl.createTab(projectPath: '/p', title: 'C');
      ctrl.createTab(projectPath: '/p', title: 'D');

      ctrl.closeTabsToRight(b.id);
      expect(titles(), ['A', 'B']);
      ctrl.closeOtherTabs(b.id);
      expect(titles(), ['B']);
      expect(ctrl.state.activeTabId, b.id);
    });

    test('second plain shell gets its own PTY key; the first keeps the default', () async {
      ctrl.createTab(projectPath: '/p').terminal.resize(80, 24, 640, 384);
      await Future<void>.delayed(Duration.zero);
      final first = fakeWs.sent.where((f) => f['type'] == 'init').toList();
      expect(first.first.containsKey('sessionId'), isFalse);

      fakeWs.sent.clear();
      final second = ctrl.createTab(projectPath: '/p');
      second.terminal.resize(80, 24, 640, 384);
      await Future<void>.delayed(Duration.zero);
      final init = fakeWs.sent.firstWhere((f) => f['type'] == 'init');
      expect(init['sessionId'], 'shell-2');
      expect(init['hasSession'], isFalse);
      expect(init['isPlainShell'], isTrue);
      // The tab itself is still a plain shell (no agent session to resume).
      expect(second.sessionId, isNull);
      expect(second.ptySessionId, 'shell-2');

      // Restart keeps the same PTY key.
      fakeWs.sent.clear();
      ctrl.restartTab(second.id);
      await Future<void>.delayed(Duration.zero);
      expect(fakeWs.sent.firstWhere((f) => f['type'] == 'init')['sessionId'], 'shell-2');
    });

    test('zoomReset returns to the default size', () {
      final tab = ctrl.createTab(projectPath: '/p');
      ctrl.zoomIn(tab.id);
      ctrl.zoomIn(tab.id);
      expect(tab.fontSize, terminalFontSizeDefault + 2);
      ctrl.zoomReset(tab.id);
      expect(tab.fontSize, terminalFontSizeDefault);
    });

    test('latched Ctrl/Alt apply to typed characters and key-bar keys once', () {
      final tab = ctrl.createTab(projectPath: '/p');
      fakeWs.sent.clear();

      ctrl.toggleLatchedModifier(LatchedModifier.ctrl);
      tab.terminal.textInput('c');
      expect(fakeWs.sent.last['data'], '\x03');
      expect(ctrl.state.latchedModifiers, isEmpty);

      tab.terminal.textInput('c');
      expect(fakeWs.sent.last['data'], 'c');

      ctrl.toggleLatchedModifier(LatchedModifier.alt);
      ctrl.sendInput(tab.id, '\x1b[D');
      expect(fakeWs.sent.last['data'], '\x1b[1;3D');

      // Toggling twice disarms.
      ctrl.toggleLatchedModifier(LatchedModifier.ctrl);
      ctrl.toggleLatchedModifier(LatchedModifier.ctrl);
      ctrl.sendInput(tab.id, 'x');
      expect(fakeWs.sent.last['data'], 'x');
    });
  });

  group('TerminalOutputFilter', () {
    test('drops private-prefixed CSI that xterm misreads as SGR / cursor ops', () {
      final f = TerminalOutputFilter();
      expect(f.feed('a\x1b[>4;2mb\x1b[>4mc'), 'abc');
      expect(f.feed('\x1b[>1u\x1b[<u\x1b[?u\x1b[>0qx'), 'x');
    });

    test('keeps real SGR, DEC private modes and device attribute queries', () {
      final f = TerminalOutputFilter();
      const keep = '\x1b[4mu\x1b[0m \x1b[?25l\x1b[?2004h \x1b[>c\x1b[=c \x1b[38;2;1;2;3mz';
      expect(f.feed(keep), keep);
    });

    test('drops DCS/APC strings, also when split across chunks', () {
      final f = TerminalOutputFilter();
      // OpenCode's XTGETTCAP terminfo query.
      expect(f.feed('a\x1bP+q4d73\x1b\\b'), 'ab');
      // Kitty graphics APC.
      expect(f.feed('\x1b_Gf=100,a=T;AAAA\x1b\\c'), 'c');
      // Split: payload continues in the next frame, text after ST survives.
      expect(f.feed('d\x1bP+q'), 'd');
      expect(f.feed('4d73'), '');
      expect(f.feed('\x1b\\e'), 'e');
    });

    test('carries an escape split across chunks', () {
      final f = TerminalOutputFilter();
      expect(f.feed('one\x1b[>4'), 'one');
      expect(f.feed(';2mtwo'), 'two');
      expect(f.feed('x\x1b'), 'x');
      expect(f.feed('[31mred'), '\x1b[31mred');
      expect(f.feed('y\x1b'), 'y');
      expect(f.feed('(Bz'), '\x1b(Bz');
      expect(f.feed('plain'), 'plain');
    });

    test('modifyOtherKeys from Claude Code no longer underlines the buffer', () async {
      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);
      final tab = container.read(terminalControllerProvider.notifier).createTab(projectPath: '/p');

      fakeWs.emitFrame({'type': 'output', 'data': '\x1b[>4;2mClaude \x1b[4mlink\x1b[0m'});
      await Future<void>.delayed(const Duration(milliseconds: 30));

      final line = tab.terminal.buffer.lines[0];
      expect(line.getText().trimRight(), 'Claude link');
      expect(line.getAttributes(0) & xt.CellFlags.underline, 0);
      expect(line.getAttributes(0) & xt.CellFlags.faint, 0);
      // Genuine SGR 4 still underlines.
      expect(line.getAttributes(7) & xt.CellFlags.underline, isNot(0));
    });
  });

  group('applyLatchedModifiers', () {
    const ctrl = {LatchedModifier.ctrl};
    const alt = {LatchedModifier.alt};
    const both = {LatchedModifier.ctrl, LatchedModifier.alt};

    test('control codes for letters and punctuation', () {
      expect(applyLatchedModifiers('a', ctrl), '\x01');
      expect(applyLatchedModifiers('z', ctrl), '\x1a');
      expect(applyLatchedModifiers('[', ctrl), '\x1b');
      expect(applyLatchedModifiers(' ', ctrl), '\x00');
      expect(applyLatchedModifiers('?', ctrl), '\x7f');
      // Not a control chord — passed through.
      expect(applyLatchedModifiers('1', ctrl), '1');
    });

    test('alt prefixes ESC; both combine', () {
      expect(applyLatchedModifiers('x', alt), '\x1bx');
      expect(applyLatchedModifiers('b', both), '\x1b\x02');
    });

    test('CSI keys receive the xterm modifier parameter', () {
      expect(applyLatchedModifiers('\x1b[A', ctrl), '\x1b[1;5A');
      expect(applyLatchedModifiers('\x1b[H', alt), '\x1b[1;3H');
      expect(applyLatchedModifiers('\x1b[F', both), '\x1b[1;7F');
      expect(applyLatchedModifiers('\x1b[5~', ctrl), '\x1b[5;5~');
      expect(applyLatchedModifiers('\x1b[6~', alt), '\x1b[6;3~');
      // Already-modified sequences merge instead of nesting.
      expect(applyLatchedModifiers('\x1b[1;2A', ctrl), '\x1b[1;6A');
    });

    test('multi-character input and empty modifiers pass through', () {
      expect(applyLatchedModifiers('ls -la', ctrl), 'ls -la');
      expect(applyLatchedModifiers('\x1b', ctrl), '\x1b');
      expect(applyLatchedModifiers('a', const {}), 'a');
    });
  });

  group('resolveTerminalCommand (Windows Terminal defaults)', () {
    TerminalKeyBinding? win(
      LogicalKeyboardKey key, {
      bool control = false,
      bool shift = false,
      bool alt = false,
      bool hasSelection = false,
      bool isWeb = false,
    }) => resolveTerminalCommand(
      key: key,
      control: control,
      shift: shift,
      alt: alt,
      meta: false,
      platform: TargetPlatform.windows,
      hasSelection: hasSelection,
      isWeb: isWeb,
    );

    TerminalKeyBinding? mac(
      LogicalKeyboardKey key, {
      bool shift = false,
      bool alt = false,
      bool hasSelection = false,
    }) => resolveTerminalCommand(
      key: key,
      control: false,
      shift: shift,
      alt: alt,
      meta: true,
      platform: TargetPlatform.macOS,
      hasSelection: hasSelection,
      isWeb: false,
    );

    test('Ctrl+C is SIGINT without a selection and copy with one', () {
      expect(win(LogicalKeyboardKey.keyC, control: true), isNull);
      expect(
        win(LogicalKeyboardKey.keyC, control: true, hasSelection: true)?.command,
        TerminalCommand.copy,
      );
      expect(win(LogicalKeyboardKey.keyC, control: true, shift: true), isNull);
      expect(
        win(LogicalKeyboardKey.keyC, control: true, shift: true, hasSelection: true)?.command,
        TerminalCommand.copy,
      );
      expect(
        win(LogicalKeyboardKey.insert, control: true, hasSelection: true)?.command,
        TerminalCommand.copy,
      );
    });

    test('paste chords', () {
      expect(win(LogicalKeyboardKey.keyV, control: true)?.command, TerminalCommand.paste);
      expect(
        win(LogicalKeyboardKey.keyV, control: true, shift: true)?.command,
        TerminalCommand.paste,
      );
      expect(win(LogicalKeyboardKey.insert, shift: true)?.command, TerminalCommand.paste);
    });

    test('Esc clears a selection, otherwise reaches the shell', () {
      expect(win(LogicalKeyboardKey.escape), isNull);
      expect(
        win(LogicalKeyboardKey.escape, hasSelection: true)?.command,
        TerminalCommand.clearSelection,
      );
    });

    test('tab, zoom, find, scroll and menu chords', () {
      expect(
        win(LogicalKeyboardKey.keyT, control: true, shift: true)?.command,
        TerminalCommand.newTab,
      );
      expect(
        win(LogicalKeyboardKey.keyW, control: true, shift: true)?.command,
        TerminalCommand.closeTab,
      );
      expect(
        win(LogicalKeyboardKey.keyD, control: true, shift: true)?.command,
        TerminalCommand.duplicateTab,
      );
      expect(win(LogicalKeyboardKey.tab, control: true)?.command, TerminalCommand.nextTab);
      expect(
        win(LogicalKeyboardKey.tab, control: true, shift: true)?.command,
        TerminalCommand.previousTab,
      );
      expect(win(LogicalKeyboardKey.pageDown, control: true)?.command, TerminalCommand.nextTab);
      final goTo = win(LogicalKeyboardKey.digit3, control: true, alt: true);
      expect(goTo?.command, TerminalCommand.selectTab);
      expect(goTo?.index, 2);
      expect(win(LogicalKeyboardKey.equal, control: true)?.command, TerminalCommand.zoomIn);
      expect(win(LogicalKeyboardKey.minus, control: true)?.command, TerminalCommand.zoomOut);
      expect(win(LogicalKeyboardKey.digit0, control: true)?.command, TerminalCommand.zoomReset);
      expect(
        win(LogicalKeyboardKey.keyF, control: true, shift: true)?.command,
        TerminalCommand.find,
      );
      expect(
        win(LogicalKeyboardKey.keyA, control: true, shift: true)?.command,
        TerminalCommand.selectAll,
      );
      // Plain Ctrl+A stays the shell's beginning-of-line.
      expect(win(LogicalKeyboardKey.keyA, control: true), isNull);
      expect(
        win(LogicalKeyboardKey.arrowUp, control: true, shift: true)?.command,
        TerminalCommand.scrollUpLine,
      );
      expect(
        win(LogicalKeyboardKey.pageDown, control: true, shift: true)?.command,
        TerminalCommand.scrollDownPage,
      );
      expect(
        win(LogicalKeyboardKey.home, control: true, shift: true)?.command,
        TerminalCommand.scrollToTop,
      );
      expect(
        win(LogicalKeyboardKey.keyP, control: true, shift: true)?.command,
        TerminalCommand.commandMenu,
      );
    });

    test('web gets Ctrl+Alt+T / Ctrl+Alt+W because browsers reserve the Shift chords', () {
      expect(win(LogicalKeyboardKey.keyT, control: true, alt: true), isNull);
      expect(
        win(LogicalKeyboardKey.keyT, control: true, alt: true, isWeb: true)?.command,
        TerminalCommand.newTab,
      );
      expect(
        win(LogicalKeyboardKey.keyW, control: true, alt: true, isWeb: true)?.command,
        TerminalCommand.closeTab,
      );
    });

    test('macOS uses ⌘ chords and leaves Ctrl to the shell', () {
      expect(mac(LogicalKeyboardKey.keyT)?.command, TerminalCommand.newTab);
      expect(mac(LogicalKeyboardKey.keyW)?.command, TerminalCommand.closeTab);
      expect(mac(LogicalKeyboardKey.keyF)?.command, TerminalCommand.find);
      expect(mac(LogicalKeyboardKey.keyV)?.command, TerminalCommand.paste);
      expect(mac(LogicalKeyboardKey.keyC), isNull);
      expect(mac(LogicalKeyboardKey.keyC, hasSelection: true)?.command, TerminalCommand.copy);
      expect(mac(LogicalKeyboardKey.bracketRight, shift: true)?.command, TerminalCommand.nextTab);
      expect(mac(LogicalKeyboardKey.digit2)?.index, 1);
      expect(
        resolveTerminalCommand(
          key: LogicalKeyboardKey.keyC,
          control: true,
          shift: false,
          alt: false,
          meta: false,
          platform: TargetPlatform.macOS,
          hasSelection: true,
          isWeb: false,
        ),
        isNull,
      );
    });

    test('shortcut labels render per platform', () {
      expect(terminalShortcutLabel(TerminalCommand.newTab, TargetPlatform.windows), 'Ctrl+Shift+T');
      expect(terminalShortcutLabel(TerminalCommand.newTab, TargetPlatform.macOS), '⌘T');
    });
  });

  group('TerminalSearch', () {
    late xt.Terminal terminal;
    late xt.TerminalController controller;
    late TerminalSearch search;

    setUp(() {
      terminal = xt.Terminal(maxLines: 500);
      controller = xt.TerminalController();
      search = TerminalSearch(
        terminal: terminal,
        controller: controller,
        hitColor: const Color(0x40FFFF00),
        currentHitColor: const Color(0xC0FFFF00),
      );
      terminal.write('alpha foo\r\nbeta\r\nFOO foo gamma\r\n');
    });

    tearDown(() {
      search.dispose();
      controller.dispose();
    });

    test('finds hits case-insensitively, newest first, and paints highlights', () {
      search.open();
      search.setQuery('foo');
      expect(search.hitCount, 3);
      expect(search.currentIndex, 2);
      expect(search.currentHit, (line: 2, x: 4, length: 3));
      expect(controller.highlights.length, 3);

      search.setCaseSensitive(true);
      expect(search.hitCount, 2);
      expect(search.hits.map((h) => h.line), [0, 2]);
    });

    test('next/previous wrap around', () {
      search.open();
      search.setQuery('foo');
      search.next();
      expect(search.currentIndex, 0);
      search.previous();
      expect(search.currentIndex, 2);
      search.previous();
      expect(search.currentIndex, 1);
    });

    test('close removes highlights and hits', () {
      search.open();
      search.setQuery('a');
      expect(controller.highlights, isNotEmpty);
      search.close();
      expect(search.isOpen, isFalse);
      expect(search.hitCount, 0);
      expect(controller.highlights, isEmpty);
    });

    test('live output re-scans after a short debounce', () async {
      search.open();
      search.setQuery('delta');
      expect(search.hitCount, 0);
      terminal.write('delta\r\n');
      await Future<void>.delayed(const Duration(milliseconds: 250));
      expect(search.hitCount, 1);
    });
  });

  group('Terminal widget tests', () {
    testWidgets('renders tabs, action bar, and terminal view', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.dark(),
              home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
            ),
          ),
        ),
      );

      await connectTab(tester);
      await tester.pumpAndSettle();

      // WT tab row: tabs, `+` and the `⌄` dropdown; no icon clutter.
      expect(find.text('Shell 1'), findsOneWidget);
      expect(find.byIcon(LucideIcons.plus), findsOneWidget);
      expect(find.byIcon(LucideIcons.chevronDown), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsNothing);

      // `+` opens the default profile (plain shell) straight away.
      await tester.tap(find.byIcon(LucideIcons.plus));
      await tester.pump();
      // The new tab starts connecting — an output frame clears the overlay.
      await connectTab(tester);
      await tester.pumpAndSettle();
      expect(find.text('Shell 2'), findsOneWidget);

      // The dropdown carries the profiles and the former header actions.
      await tester.tap(find.byIcon(LucideIcons.chevronDown));
      await tester.pumpAndSettle();
      expect(find.text('Plain Shell'), findsOneWidget);
      expect(find.text('Claude CLI'), findsOneWidget);
      expect(find.text('Provider Login'), findsOneWidget);
      expect(find.text('Ctrl+Shift+T'), findsOneWidget);
      // Pane actions sit in submenus.
      await tester.tap(find.text('Session'));
      await tester.pumpAndSettle();
      expect(find.text('Restart Session'), findsOneWidget);
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      expect(find.text('Clear Output'), findsOneWidget);
      expect(find.text('Find'), findsOneWidget);

      await tester.tap(find.text('Claude CLI'));
      await tester.pump();
      // The provider tab starts connecting — settle it before asserting.
      await connectTab(tester);
      await tester.pumpAndSettle();
      expect(find.text('claude CLI'), findsOneWidget);
      expect(container.read(terminalControllerProvider).tabs.length, 3);
    });

    testWidgets('tab context menu: rename, close others', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.dark(),
              home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
            ),
          ),
        ),
      );
      await connectTab(tester);
      await tester.pumpAndSettle();

      final ctrl = container.read(terminalControllerProvider.notifier);
      ctrl.createTab(projectPath: '/test/proj', title: 'Other');
      await tester.pump();
      await connectTab(tester);
      await tester.pumpAndSettle();
      expect(container.read(terminalControllerProvider).tabs.length, 2);

      // Long-press (touch) opens the tab menu.
      await tester.longPress(find.text('Shell 1'));
      await tester.pumpAndSettle();
      expect(find.text('Close other tabs'), findsOneWidget);
      await tester.tap(find.text('Rename tab'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'build');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('build'), findsOneWidget);
      expect(find.text('Shell 1'), findsNothing);

      await tester.longPress(find.text('build'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Close other tabs'));
      await tester.pumpAndSettle();
      final tabs = container.read(terminalControllerProvider).tabs;
      expect(tabs.map((t) => t.title), ['build']);
    });

    testWidgets('keyboard chords: new tab, cycle, find, close', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.dark(),
              home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
            ),
          ),
        ),
      );
      await connectTab(tester);
      await tester.pumpAndSettle();

      Future<void> chord(LogicalKeyboardKey key, {bool shift = false}) async {
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyDownEvent(key);
        await tester.sendKeyUpEvent(key);
        if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await tester.pump();
      }

      TerminalState state() => container.read(terminalControllerProvider);
      final first = state().activeTabId;

      // Ctrl+Shift+T — a new default tab, now active; nothing reaches the PTY.
      fakeWs.sent.clear();
      await chord(LogicalKeyboardKey.keyT, shift: true);
      expect(state().tabs.length, 2);
      expect(state().activeTabId, isNot(first));
      expect(fakeWs.sent.where((f) => f['type'] == 'input'), isEmpty);
      await connectTab(tester);
      await tester.pumpAndSettle();

      // Ctrl+Tab cycles (wraps) back to the first tab.
      await chord(LogicalKeyboardKey.tab);
      expect(state().activeTabId, first);
      await chord(LogicalKeyboardKey.tab, shift: true);
      expect(state().activeTabId, isNot(first));

      // Ctrl+Shift+F — the search box appears over the pane.
      await chord(LogicalKeyboardKey.keyF, shift: true);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Match case'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Match case'), findsNothing);

      // Ctrl+Shift+W closes the active tab.
      await chord(LogicalKeyboardKey.keyW, shift: true);
      await tester.pumpAndSettle();
      expect(state().tabs.length, 1);
      expect(state().activeTabId, first);
    });

    testWidgets('TerminalShortcutsBar sends key codes on tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.dark(),
              home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
            ),
          ),
        ),
      );

      await connectTab(tester);
      await tester.pumpAndSettle();
      fakeWs.sent.clear();

      await tester.tap(find.text('Esc'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\x1b');

      await tester.tap(find.text('Tab'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\t');

      await tester.tap(find.text('Ctrl+C'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\x03');

      await tester.tap(find.text('▲'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\x1b[A');

      // Sticky Ctrl: arms for exactly one key, then releases.
      await tester.tap(find.text('Ctrl'));
      await tester.pump();
      expect(container.read(terminalControllerProvider).latchedModifiers, {LatchedModifier.ctrl});
      await tester.tap(find.text('▲'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\x1b[1;5A');
      expect(container.read(terminalControllerProvider).latchedModifiers, isEmpty);
      await tester.tap(find.text('▲'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\x1b[A');
    });

    testWidgets('typed characters reach the PTY on Windows', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.dark(),
              home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
            ),
          ),
        ),
      );

      await connectTab(tester);
      await tester.pumpAndSettle();
      fakeWs.sent.clear();

      await tester.sendKeyEvent(LogicalKeyboardKey.keyA, platform: 'windows');
      await tester.pump();
      final inputs = fakeWs.sent.where((f) => f['type'] == 'input').map((f) => f['data']);
      expect(inputs, contains('a'));
    }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

    testWidgets('shortcuts bar toggle stays reachable in a narrow pane', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.dark(),
              home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
            ),
          ),
        ),
      );

      await connectTab(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Hide Shortcuts'));
      await tester.pumpAndSettle();
      expect(find.text('Esc'), findsNothing);

      await tester.tap(find.byTooltip('Show Shortcuts'));
      await tester.pumpAndSettle();
      expect(find.text('Esc'), findsOneWidget);
    });

    testWidgets('displays auth URL banner and triggers tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.dark(),
              home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
            ),
          ),
        ),
      );

      await connectTab(tester);
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        fakeWs.emitFrame({'type': 'auth_url', 'url': 'https://claude.ai/login?oauth=test1234'});
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();

      expect(find.textContaining('Auth link: https://claude.ai/login'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('connection overlay: Connect CTA, disconnect button, prompt chips', (tester) async {
      // <768px wide → the prompt chips strip is allowed (web md:hidden).
      tester.view.physicalSize = const Size(700, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.dark(),
              home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
            ),
          ),
        ),
      );
      await tester.pump();

      // Fresh tab starts connecting → overlay shows the spinner label.
      expect(find.text('Connecting…'), findsOneWidget);
      expect(find.text('Connect'), findsNothing);

      final tab = container.read(terminalControllerProvider).activeTab!;

      // Output lands → connected; overlay clears, header actions appear.
      await tester.runAsync(() async {
        fakeWs.emitFrame({'type': 'output', 'data': 'ready \$ \r\n'});
        await Future<void>.delayed(const Duration(milliseconds: 30));
      });
      await tester.pump();
      expect(find.text('Connecting…'), findsNothing);
      // Connected-only actions live in the `⌄` dropdown.
      await tester.tap(find.byIcon(LucideIcons.chevronDown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Session'));
      await tester.pumpAndSettle();
      expect(find.text('Disconnect'), findsOneWidget);
      expect(find.text('Kill running process (Ctrl+C)'), findsOneWidget);
      // A tap outside dismisses the menu (submenu first, then the root) —
      // the empty part of the tab strip is clear of both panels.
      await tester.tapAt(const Offset(400, 18));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(400, 18));
      await tester.pumpAndSettle();
      expect(find.text('Disconnect'), findsNothing);

      // CLI prompt output → option chips + Esc. Emit on the real event
      // loop (same as connectTab) — a bare emitFrame() schedules delivery
      // on a zone pump() never drains. The 500ms debounce timer then
      // lives on the fake clock and pump(duration) fires it.
      await tester.runAsync(() async {
        fakeWs.emitFrame({
          'type': 'output',
          'data': 'Choose:\r\n❯ 1. Approve\r\n  2. Reject\r\nesc to cancel\r\n',
        });
        await Future<void>.delayed(const Duration(milliseconds: 30));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(find.text('1. Approve'), findsOneWidget);
      expect(find.text('2. Reject'), findsOneWidget);
      // The chips' Esc plus the key bar's Esc keycap.
      expect(find.text('Esc'), findsAtLeastNWidgets(1));

      // Tapping a chip sends its digit and clears the strip.
      fakeWs.sent.clear();
      await tester.tap(find.text('1. Approve'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '1');
      expect(find.text('2. Reject'), findsNothing);

      // Disconnect (dropdown) → overlay returns with the explicit Connect CTA.
      await tester.tap(find.byIcon(LucideIcons.chevronDown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Session'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Disconnect'));
      await tester.pumpAndSettle();
      expect(find.text('Connect'), findsOneWidget);
      expect(fakeWs.state, WsState.closed);

      // Connect → restart (forceRestart init resent on the reopened socket).
      fakeWs.sent.clear();
      await tester.tap(find.text('Connect'));
      await tester.pump();
      await tester.pump();
      expect(tab.status, TerminalTabStatus.connecting);
      expect(fakeWs.sent.any((f) => f['type'] == 'init' && f['forceRestart'] == true), isTrue);
    });

    testWidgets('ProviderLoginDialog lists providers and launches terminal', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        TranslationProvider(
          child: UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.dark(),
              home: Scaffold(
                body: ProviderLoginDialog(projectPath: '/test/proj', provider: 'claude'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Claude CLI Login'), findsOneWidget);
      expect(fakeWs.sent, isNotEmpty);
      expect(fakeWs.sent.first['initialCommand'], contains('claude'));
    });
  });
}
