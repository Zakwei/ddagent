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

  @override
  Future<void> connect() async {}
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
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
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
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);

      final tab1 = controller.createTab(
        title: 'Shell 1',
        projectPath: '/test/proj',
      );
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
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(
        projectPath: '/test/proj',
      );

      fakeWs.sent.clear();
      controller.sendInput(tab.id, 'ls -la\n');
      expect(fakeWs.sent.length, 1);
      expect(fakeWs.sent.first['type'], 'input');
      expect(fakeWs.sent.first['data'], 'ls -la\n');
    });

    test('resize forwards cols and rows to ShellChannel', () {
      final container = ProviderContainer(
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(
        projectPath: '/test/proj',
      );

      fakeWs.sent.clear();
      controller.resize(tab.id, 120, 40);
      expect(fakeWs.sent.length, 1);
      expect(fakeWs.sent.first['type'], 'resize');
      expect(fakeWs.sent.first['cols'], 120);
      expect(fakeWs.sent.first['rows'], 40);
    });

    test('output frames update terminal buffer and detect exit code', () async {
      final container = ProviderContainer(
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
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
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);
      final tab = controller.createTab(
        projectPath: '/test/proj',
        title: 'Auth test',
      );

      fakeWs.emitFrame({
        'type': 'auth_url',
        'url': 'https://claude.ai/oauth/login?code=123',
      });
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final currentTab = controller.state.tabs.firstWhere((t) => t.id == tab.id);
      expect(currentTab.authUrls, contains('https://claude.ai/oauth/login?code=123'));
    });

    test('tab navigation, closing, and toggling shortcuts', () {
      final container = ProviderContainer(
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);

      final tab1 = controller.createTab(
        projectPath: '/test/proj',
        title: 'Tab 1',
      );
      final tab2 = controller.createTab(
        projectPath: '/test/proj',
        title: 'Tab 2',
      );

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

    test('runOneShotCommand and runProviderLogin spawn expected tabs', () {
      final container = ProviderContainer(
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(terminalControllerProvider.notifier);

      controller.runOneShotCommand(
        projectPath: '/test/proj',
        command: 'npm test',
      );
      var active = controller.state.activeTab;
      expect(active?.title, 'Run: npm test');
      expect(active?.initialCommand, 'npm test');
      expect(active?.isCommandMode, isTrue);

      controller.runProviderLogin(
        projectPath: '/test/proj',
        provider: 'opencode',
      );
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
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: const Scaffold(
              body: TerminalScreen(
                projectPath: '/test/proj',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Shell 1'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byTooltip('Clear Output'), findsOneWidget);
      expect(find.byIcon(Icons.vpn_key_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Plain Shell').last);
      await tester.pumpAndSettle();

      expect(find.text('Shell 2'), findsOneWidget);
    });

    testWidgets('TerminalShortcutsBar sends key codes on tap', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: const Scaffold(
              body: TerminalScreen(
                projectPath: '/test/proj',
              ),
            ),
          ),
        ),
      );

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
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: const Scaffold(
              body: TerminalScreen(
                projectPath: '/test/proj',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        fakeWs.emitFrame({
          'type': 'auth_url',
          'url': 'https://claude.ai/login?oauth=test1234',
        });
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();

      expect(find.textContaining('Auth link: https://claude.ai/login'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('ProviderLoginDialog lists providers and launches terminal', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = ProviderContainer(
        overrides: [
          shellChannelProvider.overrideWith((ref, key) => fakeChannel),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: Scaffold(
              body: ProviderLoginDialog(
                projectPath: '/test/proj',
                provider: 'claude',
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
