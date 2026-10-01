import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_sync.dart';
import 'package:flutter_test/flutter_test.dart';

const _local = WorkspaceState(
  panes: [
    SplitPane(
      id: 'p1',
      kind: PaneKind.chat,
      sessionId: 's1',
      projectId: 'proj-1',
    ),
  ],
  activePaneId: 'p1',
  lastUsedProjectId: 'proj-1',
);

const _remote = WorkspaceState(
  panes: [
    SplitPane(id: 'p9', kind: PaneKind.chat, sessionId: 's9'),
    SplitPane(
      id: 'p8',
      kind: PaneKind.editor,
      projectId: 'proj-2',
      filePath: '/x.dart',
    ),
  ],
  activePaneId: 'p8',
  lastUsedProjectId: 'proj-2',
);

class _Harness {
  _Harness() {
    sync = WorkspaceSync(
      deviceId: () => 'dev-test',
      getState: () => current,
      applyRemote: (next) {
        applied = next;
        current = next;
      },
      send: (frame) {
        if (sendOk) sent.add(frame);
        return sendOk;
      },
      pushDebounce: Duration.zero,
    );
  }

  late final WorkspaceSync sync;
  final sent = <Map<String, dynamic>>[];
  WorkspaceState? applied;
  WorkspaceState current = _local;
  bool sendOk = true;
}

void main() {
  test('requestSnapshot sends workspace.get with the device id', () {
    final h = _Harness();
    h.sync.requestSnapshot();
    expect(h.sent, [
      {'type': 'workspace.get', 'deviceId': 'dev-test'},
    ]);
  });

  test(
    'remote workspace_state applies sanitized state and records it as synced',
    () {
      final h = _Harness();
      h.sync.handleFrame({
        'kind': 'workspace_state',
        'state': _remote.toJson(),
        'revision': 3,
      });

      expect(h.applied?.panes.length, 2);
      expect(h.applied?.panes.last.kind, PaneKind.editor);
      expect(h.applied?.panes.last.filePath, '/x.dart');

      // Applying must not echo back — the local watcher now sees state equal to
      // lastSynced and stays silent.
      h.sync.pushLocal();
      expect(h.sent, isEmpty);
    },
  );

  test(
    'local change pushes one workspace.update; unchanged state stays silent',
    () {
      final h = _Harness();

      h.current = _remote;
      h.sync.pushLocal();
      expect(h.sent.length, 1);
      expect(h.sent[0]['type'], 'workspace.update');
      expect(h.sent[0]['state'], _remote.toJson());

      h.sync.pushLocal(); // same serialized state → deduped, stays silent
      expect(h.sent.length, 1);
    },
  );

  test('empty server reply seeds it with the local workspace', () {
    final h = _Harness();
    h.sync.handleFrame({
      'kind': 'workspace_state',
      'state': null,
      'revision': 0,
    });

    expect(h.sent.length, 1);
    expect(h.sent[0]['type'], 'workspace.update');
    expect(h.sent[0]['state'], _local.toJson());
  });

  test(
    'unsent local edits win over an incoming remote state (dirty tie-break)',
    () {
      final h = _Harness();
      h.current = _remote;
      h.sendOk = false;
      h.sync.pushLocal(); // socket down → dirty, nothing sent
      h.sendOk = true;

      h.sync.handleFrame({
        'kind': 'workspace_state',
        'state': _local.toJson(),
        'revision': 5,
      });

      // Remote was NOT applied; our dirty local state was pushed instead.
      expect(h.applied, isNull);
      expect(h.sent.length, 1);
      expect(h.sent[0]['type'], 'workspace.update');
      expect(h.sent[0]['state'], _remote.toJson());
      expect(h.sync.dirty, isFalse);
    },
  );

  test('unrelated frames are ignored', () {
    final h = _Harness();
    h.sync.handleFrame({'kind': 'stream_delta', 'sessionId': 'x'});
    h.sync.handleFrame({'type': 'presence-roster', 'users': <String>[]});
    expect(h.applied, isNull);
    expect(h.sent, isEmpty);
  });
}
