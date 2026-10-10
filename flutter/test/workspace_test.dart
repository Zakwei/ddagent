import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/features/workspace/view/session_picker.dart';
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

SplitPane pane(String id, {PaneKind kind = PaneKind.chat, String? sessionId}) =>
    SplitPane(id: id, kind: kind, sessionId: sessionId);

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
      vps.read(workspaceProvider.notifier).openPane(PaneKind.chat, sessionId: 'vps-session');
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
        n.openPane(PaneKind.chat);
      }
      final s = c.read(workspaceProvider);
      expect(s.panes.length, maxSplitPanes);
      expect(s.activePaneId, s.panes.last.id);
      expect(n.canAdd, isFalse);
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
      n.openPane(PaneKind.chat);
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

    test('updatePane patches fields, picker flag included', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      n.openPane(PaneKind.chat, picker: true);
      final id = c.read(workspaceProvider).panes.single.id;
      n.updatePane(id, sessionId: () => 'sess-1', projectId: () => 'proj-1', picker: false);
      final p = c.read(workspaceProvider).panes.single;
      expect(p.sessionId, 'sess-1');
      expect(p.projectId, 'proj-1');
      expect(p.picker, isFalse);
    });

    test('reorderPanes moves a pane to the target index', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(workspaceProvider.notifier);
      n.openPane(PaneKind.chat);
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
      n.openPane(PaneKind.chat);
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
      expect(s.activePaneId, 'a'); // falls back to first pane
      expect(s.lastUsedProjectId, 'p1');
    });

    test('caps at maxSplitPanes and handles non-map input', () {
      expect(WorkspaceState.sanitize('junk').panes, isEmpty);
      final s = WorkspaceState.sanitize({
        'panes': [
          for (var i = 0; i < 10; i++) {'id': 'p$i', 'kind': 'chat'},
        ],
      });
      expect(s.panes.length, maxSplitPanes);
    });
  });

  group('boundChatSessionIds', () {
    test('excludes only chat panes with a bound session', () {
      final ids = boundChatSessionIds([
        pane('a', sessionId: 's1'),
        pane('b'), // no session
        pane('c', kind: PaneKind.terminal, sessionId: 's2'),
        pane('d', sessionId: 's3'),
      ]);
      expect(ids, {'s1', 's3'});
    });
  });
}
