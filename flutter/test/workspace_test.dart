import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

Future<void> _initHive() async {
  Hive.init('/tmp/ddagent_workspace_hive');
  if (!Hive.isBoxOpen(WorkspaceStorage.boxName)) {
    await Hive.openBox<dynamic>(WorkspaceStorage.boxName);
  }
}

ProviderContainer _container() => ProviderContainer();

void main() {
  setUpAll(_initHive);

  // The controller persists every write — isolate tests from each other.
  setUp(() => Hive.box<dynamic>(WorkspaceStorage.boxName).clear());

  group('getSplitLayout', () {
    test('matches the web grid math', () {
      expect(getSplitLayout(0), (columns: 1, rows: 1));
      expect(getSplitLayout(1), (columns: 1, rows: 1));
      expect(getSplitLayout(2), (columns: 2, rows: 1));
      expect(getSplitLayout(3), (columns: 3, rows: 1));
      expect(getSplitLayout(4), (columns: 2, rows: 2));
      expect(getSplitLayout(5), (columns: 3, rows: 2));
      expect(getSplitLayout(6), (columns: 3, rows: 2));
    });
  });

  group('createPaneId', () {
    // `1 << 32` is 0 under dart2js — Random.nextInt then throws and every
    // "add pane" tap dies silently on web (regression guard for that bug).
    test('random suffix stays inside Random.nextInt range', () {
      expect(kPaneIdSpace, greaterThan(0));
      expect(kPaneIdSpace, lessThanOrEqualTo(4294967296));
    });

    test('ids are unique and well-formed', () {
      final ids = {for (var i = 0; i < 200; i++) createPaneId()};
      expect(ids, hasLength(200));
      expect(ids.every((id) => id.startsWith('split-pane-')), isTrue);
    });
  });

  group('per-server layout', () {
    ProviderContainer onServer(String url) =>
        ProviderContainer(overrides: [serverBaseUrlProvider.overrideWithValue(url)]);

    test("a server never restores another server's panes", () async {
      final vps = onServer('https://vps.example:8444');
      vps.read(workspaceProvider.notifier).openPane(PaneKind.terminal, sessionId: 'vps-session');
      await pumpEventQueue();
      vps.dispose();

      final local = onServer('http://127.0.0.1:10087');
      addTearDown(local.dispose);
      expect(local.read(workspaceProvider).panes, isEmpty);

      final vpsAgain = onServer('https://vps.example:8444');
      addTearDown(vpsAgain.dispose);
      expect(vpsAgain.read(workspaceProvider).panes.single.sessionId, 'vps-session');
    });
  });

  group('WorkspaceController ops', () {
    test('openPane adds + focuses, respects cap', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      for (var i = 0; i < 8; i++) {
        n.openPane(PaneKind.terminal);
      }
      final s = c.read(workspaceProvider);
      expect(s.panes.length, maxSplitPanes);
      expect(s.activePaneId, s.panes.last.id);
      expect(n.canAdd, isFalse);
    });

    test('updatePane clears a field set to null', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      final id = n.openPane(PaneKind.preview, projectId: 'p1', url: 'http://a/')!;
      n.updatePane(id, url: () => null);
      final pane = c.read(workspaceProvider).panes.single;
      expect(pane.url, isNull);
      expect(pane.projectId, 'p1');
    });

    test('openFileInEditor splits a new editor pane carrying filePath', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      n.openFileInEditor('p1', 'lib/a.dart');
      final s = c.read(workspaceProvider);
      expect(s.panes.length, 1);
      expect(s.panes.single.kind, PaneKind.editor);
      expect(s.panes.single.projectId, 'p1');
      expect(s.panes.single.filePath, 'lib/a.dart');
      expect(s.activePaneId, s.panes.single.id);
    });

    test('openFileInEditor retargets an existing editor pane for the project', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      n.openFileInEditor('p1', 'lib/a.dart');
      n.openFileInEditor('p1', 'lib/b.dart');
      final s = c.read(workspaceProvider);
      // Same project — reuse the pane, only the file changes.
      expect(s.panes.length, 1);
      expect(s.panes.single.filePath, 'lib/b.dart');
      // A different project splits a second editor pane.
      n.openFileInEditor('p2', 'src/c.ts');
      expect(c.read(workspaceProvider).panes.length, 2);
    });

    test('removePane focuses the neighbor sliding into the slot', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      n.openPane(PaneKind.terminal);
      n.openPane(PaneKind.browser);
      n.openPane(PaneKind.terminal);
      final ids = [for (final p in c.read(workspaceProvider).panes) p.id];
      n.setActivePaneId(ids[1]);
      n.removePane(ids[1]);
      final s = c.read(workspaceProvider);
      expect(s.panes.map((p) => p.id), [ids[0], ids[2]]);
      // Next pane slid into slot 1 → it owns focus.
      expect(s.activePaneId, ids[2]);
    });

    test('updatePane patches fields', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      n.openPane(PaneKind.terminal);
      final id = c.read(workspaceProvider).panes.single.id;
      n.updatePane(id, sessionId: () => 'sess-1', projectId: () => 'proj-1');
      final p = c.read(workspaceProvider).panes.single;
      expect(p.sessionId, 'sess-1');
      expect(p.projectId, 'proj-1');
    });

    test('reorderPanes moves a pane to the target index', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      n.openPane(PaneKind.terminal);
      n.openPane(PaneKind.browser);
      n.openPane(PaneKind.terminal);
      final ids = [for (final p in c.read(workspaceProvider).panes) p.id];
      n.reorderPanes(ids[2], 0);
      expect(c.read(workspaceProvider).panes.map((p) => p.id), [ids[2], ids[0], ids[1]]);
    });

    test('toggleMaximize flips; removing the pane clears it', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      n.openPane(PaneKind.terminal);
      n.openPane(PaneKind.browser);
      final ids = [for (final p in c.read(workspaceProvider).panes) p.id];
      n.toggleMaximize(ids[0]);
      expect(c.read(workspaceProvider).maximizedPaneId, ids[0]);
      n.toggleMaximize(ids[0]);
      expect(c.read(workspaceProvider).maximizedPaneId, isNull);
      n.toggleMaximize(ids[0]);
      n.removePane(ids[0]);
      expect(c.read(workspaceProvider).maximizedPaneId, isNull);
    });
  });

  group('WorkspaceState.sanitize', () {
    test('drops corrupt panes and fixes the active id', () {
      final s = WorkspaceState.sanitize({
        'panes': [
          {'id': 'a', 'kind': 'chat', 'sessionId': 's1'},
          {'id': '', 'kind': 'chat'},
          {'id': 'b', 'kind': 'nope'},
          {'kind': 'terminal'},
          {'id': 'c', 'kind': 'terminal'},
        ],
        'activePaneId': 'zzz',
        'lastUsedProjectId': 'p1',
      });
      expect(s.panes.map((p) => p.id), ['a', 'c']);
      // The legacy chat pane bound to a session became a terminal pane.
      expect(s.panes.first.kind, PaneKind.terminal);
      expect(s.panes.first.sessionId, 's1');
      expect(s.activePaneId, 'a'); // falls back to first pane
      expect(s.lastUsedProjectId, 'p1');
    });

    test('caps at maxSplitPanes and handles non-map input', () {
      expect(WorkspaceState.sanitize('junk').panes, isEmpty);
      final s = WorkspaceState.sanitize({
        'panes': [
          for (var i = 0; i < 10; i++) {'id': 'p$i', 'kind': 'terminal'},
        ],
      });
      expect(s.panes.length, maxSplitPanes);
    });
  });

  group('legacy chat pane migration', () {
    test('a chat pane bound to a session becomes a terminal pane keeping it', () {
      final p = SplitPane.fromJson({
        'id': 'a',
        'kind': 'chat',
        'sessionId': 's1',
        'projectId': 'proj-1',
      })!;
      expect(p.id, 'a');
      expect(p.kind, PaneKind.terminal);
      expect(p.sessionId, 's1');
      expect(p.projectId, 'proj-1');
      // Written back in the new shape — the next load is a plain terminal.
      expect(p.toJson()['kind'], 'terminal');
      expect(SplitPane.fromJson(p.toJson())!.kind, PaneKind.terminal);
    });

    test('an unbound chat pane (old session picker) is dropped', () {
      expect(SplitPane.fromJson({'id': 'a', 'kind': 'chat'}), isNull);
      expect(SplitPane.fromJson({'id': 'a', 'kind': 'chat', 'sessionId': '  '}), isNull);
      expect(SplitPane.fromJson({'id': 'a', 'kind': 'chat', 'sessionId': 7}), isNull);
    });

    test('sanitize migrates a saved workspace with chat panes', () {
      final s = WorkspaceState.sanitize({
        'panes': [
          {'id': 'picker', 'kind': 'chat'},
          {'id': 'bound', 'kind': 'chat', 'sessionId': 's1'},
          {'id': 'notes', 'kind': 'notes'},
        ],
        // The dropped picker was focused → focus falls back to the first pane.
        'activePaneId': 'picker',
        'terminals': {
          'bound': {
            'tabs': [
              {'id': 't1', 'title': 'x', 'projectPath': '/p', 'sessionId': 's1'},
            ],
          },
          'picker': {
            'tabs': [
              {'id': 't2', 'title': 'y', 'projectPath': '/p'},
            ],
          },
        },
      });
      expect(s.panes.map((p) => p.id), ['bound', 'notes']);
      expect(s.panes.first.kind, PaneKind.terminal);
      expect(s.panes.first.sessionId, 's1');
      expect(s.activePaneId, 'bound');
      // The migrated pane is a terminal host now; the dropped one's row goes.
      expect(s.terminals.keys, ['bound']);
      expect(s.terminals['bound']!.tabs.single.sessionId, 's1');
    });
  });

  group('WorkspaceController.openSessionTab', () {
    String? open(
      WorkspaceController n,
      String sessionId, {
      bool newPane = false,
      String? projectId,
    }) => n.openSessionTab(
      sessionId: sessionId,
      provider: 'codex',
      projectPath: '/p',
      projectId: projectId,
      title: 'Session $sessionId',
      newPane: newPane,
    );

    List<String?> sessionsIn(WorkspaceState s, String host) => [
      for (final tab in s.terminals[host]?.tabs ?? const <TerminalTabSpec>[]) tab.sessionId,
    ];

    test('no terminal pane → opens one with the resume tab active', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      n.openPane(PaneKind.notes);
      final host = open(n, 's1', projectId: 'proj-1');
      final s = c.read(workspaceProvider);
      expect(s.panes, hasLength(2));
      final pane = s.panes.last;
      expect(host, pane.id);
      expect(pane.kind, PaneKind.terminal);
      expect(pane.projectId, 'proj-1');
      expect(s.activePaneId, pane.id);
      final row = s.terminals[pane.id]!;
      final tab = row.tabs.single;
      expect(row.activeTabId, tab.id);
      expect(tab.sessionId, 's1');
      expect(tab.provider, 'codex');
      expect(tab.projectPath, '/p');
      expect(tab.title, 'Session s1');
      expect(tab.isPlainShell, isFalse);
    });

    test('a tab already showing the session is focused, not duplicated', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      final host = open(n, 's1')!;
      open(n, 's2');
      final browser = n.openPane(PaneKind.browser)!;
      expect(c.read(workspaceProvider).activePaneId, browser);
      final s1Tab = c.read(workspaceProvider).terminals[host]!.tabs.first;
      expect(c.read(workspaceProvider).terminals[host]!.activeTabId, isNot(s1Tab.id));

      expect(open(n, 's1', newPane: true), host);
      final s = c.read(workspaceProvider);
      expect(sessionsIn(s, host), ['s1', 's2']);
      expect(s.terminals[host]!.activeTabId, s1Tab.id);
      expect(s.activePaneId, host);
      expect(s.panes, hasLength(2));
    });

    test('goes to the active terminal pane', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      final first = n.openPane(PaneKind.terminal)!;
      final second = n.openPane(PaneKind.terminal)!;
      expect(c.read(workspaceProvider).activePaneId, second);
      expect(open(n, 's1'), second);
      final s = c.read(workspaceProvider);
      expect(sessionsIn(s, second), ['s1']);
      expect(sessionsIn(s, first), isEmpty);
      expect(s.panes, hasLength(2));
    });

    test('active pane not a terminal → the first terminal pane', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      final first = n.openPane(PaneKind.terminal)!;
      n.openPane(PaneKind.terminal);
      n.openPane(PaneKind.git);
      expect(open(n, 's1'), first);
      final s = c.read(workspaceProvider);
      expect(sessionsIn(s, first), ['s1']);
      expect(s.activePaneId, first);
      expect(s.panes, hasLength(3));
    });

    test('newPane: true splits a new terminal pane next to existing ones', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      final existing = n.openPane(PaneKind.terminal)!;
      final host = open(n, 's1', newPane: true);
      final s = c.read(workspaceProvider);
      expect(host, isNot(existing));
      expect(s.panes, hasLength(2));
      expect(s.panes.last.id, host);
      expect(s.panes.last.kind, PaneKind.terminal);
      expect(sessionsIn(s, host!), ['s1']);
      expect(sessionsIn(s, existing), isEmpty);
      expect(s.activePaneId, host);
    });

    test('full workspace without terminal panes → the standalone terminal', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      for (var i = 0; i < maxSplitPanes; i++) {
        n.openPane(PaneKind.notes);
      }
      final before = c.read(workspaceProvider);
      expect(open(n, 's1'), terminalRouteHost);
      final s = c.read(workspaceProvider);
      expect(s.panes, hasLength(maxSplitPanes));
      expect(s.activePaneId, before.activePaneId);
      expect(sessionsIn(s, terminalRouteHost), ['s1']);
    });

    test('a full tab row → null, row untouched', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      final host = n.openPane(PaneKind.terminal)!;
      final tabs = [
        for (var i = 0; i < maxSyncedTerminalTabs; i++)
          TerminalTabSpec(id: 'tab-$i', title: 't$i', projectPath: '/p', ptySessionId: 'pty-$i'),
      ];
      n.setTerminalHost(host, TerminalHostSpec(tabs: tabs, activeTabId: 'tab-3'));
      expect(maxSyncedTerminalTabs, 24);
      expect(open(n, 's1'), isNull);
      final row = c.read(workspaceProvider).terminals[host]!;
      expect(row.tabs, hasLength(maxSyncedTerminalTabs));
      expect(row.activeTabId, 'tab-3');
      expect(sessionsIn(c.read(workspaceProvider), host), isNot(contains('s1')));
    });

    test('un-maximizes another pane so the host is visible', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      final host = n.openPane(PaneKind.terminal)!;
      final browser = n.openPane(PaneKind.browser)!;
      n.toggleMaximize(browser);
      expect(open(n, 's1'), host);
      expect(c.read(workspaceProvider).maximizedPaneId, isNull);
      expect(c.read(workspaceProvider).activePaneId, host);

      // The host itself maximized stays maximized.
      n.toggleMaximize(host);
      open(n, 's2');
      expect(c.read(workspaceProvider).maximizedPaneId, host);
    });
  });
}
