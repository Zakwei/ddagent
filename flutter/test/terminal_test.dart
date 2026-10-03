import 'dart:async';

import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/provider_login_dialog.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
      expect(fakeWs.sent, isNotEmpty);
      expect(fakeWs.sent.first['type'], 'init');
      expect(fakeWs.sent.first['projectPath'], '/test/proj');
      expect(fakeWs.sent.first['isPlainShell'], isTrue);
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
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
          ),
        ),
      );

      await connectTab(tester);
      await tester.pumpAndSettle();

      expect(find.text('Shell 1'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byTooltip('Clear Output'), findsOneWidget);
      expect(find.byIcon(Icons.vpn_key_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Plain Shell').last);
      await tester.pump();
      // The new tab starts connecting — an output frame clears the overlay.
      await connectTab(tester);
      await tester.pumpAndSettle();

      expect(find.text('Shell 2'), findsOneWidget);
    });

    testWidgets('TerminalShortcutsBar sends key codes on tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
          ),
        ),
      );

      await connectTab(tester);
      await tester.pumpAndSettle();
      fakeWs.sent.clear();

      await tester.tap(find.text('ESC'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\x1b');

      await tester.tap(find.text('TAB'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\t');

      await tester.tap(find.text('Ctrl+C'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\x03');

      await tester.tap(find.text('▲'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '\x1b[A');
    });

    testWidgets('displays auth URL banner and triggers tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [shellChannelProvider.overrideWith((ref, key) => fakeChannel)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
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
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: const Scaffold(body: TerminalScreen(projectPath: '/test/proj')),
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
      expect(find.byTooltip('Disconnect'), findsOneWidget);
      expect(find.byTooltip('Kill running process (Ctrl+C)'), findsOneWidget);

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
      expect(find.text('Esc'), findsOneWidget);

      // Tapping a chip sends its digit and clears the strip.
      fakeWs.sent.clear();
      await tester.tap(find.text('1. Approve'));
      await tester.pump();
      expect(fakeWs.sent.last['data'], '1');
      expect(find.text('2. Reject'), findsNothing);

      // Disconnect → overlay returns with the explicit Connect CTA. The
      // button may be scrolled out of the (horizontally scrollable)
      // header at this width — bring it into view first.
      await tester.ensureVisible(find.byTooltip('Disconnect'));
      await tester.pump();
      await tester.tap(find.byTooltip('Disconnect'));
      await tester.pump();
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
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: Scaffold(
              body: ProviderLoginDialog(projectPath: '/test/proj', provider: 'claude'),
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
