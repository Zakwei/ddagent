// Shared fakes for the terminal_matrix_*_test.dart files: per-tab fake shell
// sockets, a workspace without Hive / sync, fixed projects, sessions and
// accounts — no server anywhere.
import 'dart:async';

import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/preview/state/app_preview_controller.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/provider_accounts/state/provider_accounts_controller.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/system/state/system_providers.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// One tab's `/shell` socket: records what the client sends, lets the test
/// push server frames. Created inside the test zone, so `pump()` delivers.
class FakeShellWs extends WsClient {
  FakeShellWs() : super(urlBuilder: () async => Uri.parse('ws://test/shell'));

  final sent = <Map<String, dynamic>>[];
  final _frames = StreamController<Map<String, dynamic>>.broadcast(sync: true);
  final _states = StreamController<WsState>.broadcast(sync: true);
  WsState _state = WsState.closed;
  int reconnectNowCalls = 0;

  /// Like the real client, a connect on an open socket dials a second one.
  int connectCalls = 0;

  @override
  Stream<Map<String, dynamic>> get frames => _frames.stream;
  @override
  Stream<WsState> get states => _states.stream;
  @override
  WsState get state => _state;

  @override
  void send(Map<String, dynamic> frame) => sent.add(frame);

  @override
  void reconnectNow() => reconnectNowCalls++;

  @override
  Future<void> connect() async {
    connectCalls++;
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

  /// The socket dropped on its own: the client sits in a reconnect backoff.
  void drop() {
    _state = WsState.reconnecting;
    _states.add(WsState.reconnecting);
  }

  void emit(Map<String, dynamic> frame) => _frames.add(frame);
  void output(String data, {bool replay = false, int? exitCode}) => emit({
    'type': 'output',
    'data': data,
    'replay': ?(replay ? true : null),
    'exitCode': ?exitCode,
  });

  List<String> get inputs => [
    for (final f in sent)
      if (f['type'] == 'input') f['data'] as String,
  ];
  List<Map<String, dynamic>> get inits => [
    for (final f in sent)
      if (f['type'] == 'init') f,
  ];
  bool get terminated => sent.any((f) => f['type'] == 'terminate');
}

/// Every tab's fake socket, keyed by the local tab id (`term-N`).
class FakeShells {
  final sockets = <String, FakeShellWs>{};

  Override get override => shellChannelProvider.overrideWith((ref, key) {
    final ws = sockets[key] = FakeShellWs();
    return ShellChannel(ws)..start();
  });

  FakeShellWs of(TerminalTab tab) => sockets[tab.id]!;
}

/// Workspace without Hive and without the /ws sync — the server's copy
/// counts as read, so terminal rows attach right away.
class FakeWorkspace extends WorkspaceController {
  FakeWorkspace([this.initial = const WorkspaceState(serverLoaded: true)]);

  final WorkspaceState initial;

  @override
  WorkspaceState build() => initial;

  /// The server's workspace snapshot lands (what `_applyRemote` does).
  void serverSnapshot(WorkspaceState next) => state = next.copyWith(serverLoaded: true);
}

const projA = Project(projectId: 'pa', path: '/work/a', displayName: 'Alpha', fullPath: '/work/a');
const projB = Project(projectId: 'pb', path: '/work/b', displayName: 'Beta', fullPath: '/work/b');

class FakeProjects extends ProjectsController {
  @override
  ProjectsState build() => const ProjectsState(projects: [projA, projB], loading: false);
}

class FakePreview extends AppPreviewController {
  @override
  AppPreviewState build() => const AppPreviewState(loaded: true);
}

class FakeAccounts extends ProviderAccountsController {
  FakeAccounts(this.accounts) : super('');

  final List<ProviderAccountEntry> accounts;

  @override
  ProviderAccountsState build() => ProviderAccountsState(accounts: accounts);
}

class FakeSessions extends SessionsRepository {
  FakeSessions(this.sessions) : super(Dio());

  final Map<String, Session> sessions;

  @override
  Future<Session> details(String sessionId) async =>
      sessions[sessionId] ?? (throw StateError('no session $sessionId'));
}

Session fakeSession(String id, {String provider = 'codex', String path = '/work/a'}) => Session(
  sessionId: id,
  provider: provider,
  raw: {
    'summary': 'Session $id',
    'project': {'projectId': 'pa', 'fullPath': path},
  },
);

/// Container with every fake wired in; [workspace] seeds the panes/rows.
ProviderContainer matrixContainer(
  FakeShells shells, {
  WorkspaceState workspace = const WorkspaceState(serverLoaded: true),
  List<ProviderAccountEntry> accounts = const [],
  Map<String, Session> sessions = const {},
}) {
  final container = ProviderContainer(
    overrides: [
      shells.override,
      workspaceProvider.overrideWith(() => FakeWorkspace(workspace)),
      projectsProvider.overrideWith(FakeProjects.new),
      appPreviewControllerProvider.overrideWith(FakePreview.new),
      providerAccountsProvider('').overrideWith(() => FakeAccounts(accounts)),
      sessionsRepositoryProvider.overrideWithValue(FakeSessions(sessions)),
      serverHealthProvider.overrideWith((ref) async => {'platform': 'linux'}),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Widget matrixApp(ProviderContainer container, Widget home) => TranslationProvider(
  child: UncontrolledProviderScope(
    container: container,
    child: MaterialApp(theme: AppTheme.dark(), home: home),
  ),
);

/// `/terminal` and `/workspace` behind a real router — "Move to new pane"
/// from the standalone terminal navigates.
Widget matrixRouterApp(ProviderContainer container, {required GoRouter router}) =>
    TranslationProvider(
      child: UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(theme: AppTheme.dark(), routerConfig: router),
      ),
    );

Future<void> setMatrixSurface(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Marks every tab connected through a real output frame (clears the
/// connecting overlay, whose spinner never settles).
Future<void> connectAll(WidgetTester tester, ProviderContainer container, FakeShells shells) async {
  for (final tab in container.read(terminalControllerProvider).tabs) {
    if (tab.status != TerminalTabStatus.connected) shells.of(tab).output('ready \$ \r\n');
  }
  await tester.pump();
}

/// Lets the prompt-scan debounce and the init grace timers run out so no
/// fake timer outlives the test.
Future<void> drainTimers(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 1));
}

TerminalState terminalOf(ProviderContainer c) => c.read(terminalControllerProvider);
TerminalController terminalCtrl(ProviderContainer c) => c.read(terminalControllerProvider.notifier);
WorkspaceState workspaceOf(ProviderContainer c) => c.read(workspaceProvider);
