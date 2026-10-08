import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_sync.dart';
import 'package:flutter_test/flutter_test.dart';

const _local = WorkspaceState(
  panes: [SplitPane(id: 'p1', kind: PaneKind.chat, sessionId: 's1', projectId: 'proj-1')],
  activePaneId: 'p1',
  lastUsedProjectId: 'proj-1',
);

const _remote = WorkspaceState(
  panes: [
    SplitPane(id: 'p9', kind: PaneKind.chat, sessionId: 's9'),
    SplitPane(id: 'p8', kind: PaneKind.editor, projectId: 'proj-2', filePath: '/x.dart'),
  ],
  activePaneId: 'p8',
  lastUsedProjectId: 'proj-2',
);

const _picker = SplitPane(id: 'p2', kind: PaneKind.chat, picker: true);

Map<String, dynamic> _state(WorkspaceState s, int rev, {String? origin, bool conflict = false}) => {
  'kind': 'workspace_state',
  'state': s.toJson(),
  'revision': rev,
  'originDeviceId': origin,
  if (conflict) 'conflict': true,
};

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

  /// Boot handshake done: the server holds exactly the local state at [rev].
  void synced({int rev = 1}) {
    sync.handleFrame(_state(current, rev));
    sent.clear();
    applied = null;
  }

  List<String> get paneIds => [for (final p in current.panes) p.id];
}

void main() {
  test('requestSnapshot sends workspace.get and waits for the reply', () {
    final h = _Harness();
    h.sync.requestSnapshot();
    expect(h.sent, [
      {'type': 'workspace.get', 'deviceId': 'dev-test'},
    ]);
    expect(h.sync.awaitingSnapshot, isTrue);
    h.sync.handleFrame(_state(_remote, 3));
    expect(h.sync.awaitingSnapshot, isFalse);
  });

  test('a cold boot adopts the server snapshot over stale local panes', () {
    final h = _Harness();
    h.sync.handleFrame(_state(_remote, 3));

    expect(h.paneIds, ['p9', 'p8']);
    expect(h.sent, isEmpty);
  });

  test('pre-sync pushes stay silent so boot state never reaches the server', () {
    final h = _Harness();
    h.sync.pushLocal(); // e.g. the auto-seeded picker pane firing pre-snapshot
    expect(h.sent, isEmpty);
  });

  test('waking up with no local edits adopts the server state (server wins)', () {
    final h = _Harness();
    h.synced();
    // Phone slept; the desktop replaced the panes meanwhile.
    h.sync.requestSnapshot();
    h.sent.clear();
    h.sync.handleFrame(_state(_remote, 4));

    expect(h.paneIds, ['p9', 'p8']);
    expect(h.current.activePaneId, 'p8');
    expect(h.sent, isEmpty, reason: 'the stale layout must not be pushed back');
  });

  test('local edits survive a remote change and are rebased onto it', () {
    final h = _Harness();
    h.synced();
    // Opened a pane while the socket was down.
    h.sendOk = false;
    h.current = WorkspaceState(panes: [..._local.panes, _picker], activePaneId: 'p2');
    h.sync.pushLocal();
    h.sendOk = true;

    // Meanwhile another device opened p9.
    final remote = WorkspaceState(
      panes: [..._local.panes, _remote.panes.first],
      activePaneId: 'p9',
    );
    h.sync.handleFrame(_state(remote, 2));

    expect(h.paneIds, ['p1', 'p9', 'p2']);
    expect(h.current.activePaneId, 'p2');
    expect(h.sent.single['type'], 'workspace.update');
    expect(h.sent.single['baseRevision'], 2);
    expect(h.sent.single['state'], h.current.toJson());
  });

  test('a pane closed locally stays closed after the merge', () {
    final h = _Harness();
    h.current = _remote;
    h.synced();
    h.sendOk = false;
    h.current = const WorkspaceState(
      panes: [SplitPane(id: 'p9', kind: PaneKind.chat, sessionId: 's9')],
      activePaneId: 'p9',
    );
    h.sync.pushLocal();
    h.sendOk = true;

    h.sync.handleFrame(_state(WorkspaceState(panes: [..._remote.panes, _picker]), 2));
    expect(h.paneIds, ['p9', 'p2']);
  });

  test('local edits push one update with baseRevision; acks advance the base', () {
    final h = _Harness();
    h.synced(rev: 5);

    h.current = _remote;
    h.sync.pushLocal();
    expect(h.sent.single['type'], 'workspace.update');
    expect(h.sent.single['baseRevision'], 5);
    expect(h.sent.single['state'], _remote.toJson());

    // In flight: further pushes wait for the ack.
    h.current = const WorkspaceState(panes: [_picker], activePaneId: 'p2');
    h.sync.pushLocal();
    expect(h.sent.length, 1);

    h.sync.handleFrame({'kind': 'workspace_ack', 'revision': 6});
    expect(h.sent.length, 2);
    expect(h.sent[1]['baseRevision'], 6);
    expect(h.sync.hasPendingEdits, isTrue);

    h.sync.handleFrame({'kind': 'workspace_ack', 'revision': 7});
    expect(h.sync.hasPendingEdits, isFalse);
    h.sync.pushLocal(); // nothing new → silent
    expect(h.sent.length, 2);
  });

  test('a conflict reply rebases the in-flight edit and retries', () {
    final h = _Harness();
    h.synced();
    h.current = WorkspaceState(panes: [..._local.panes, _picker], activePaneId: 'p2');
    h.sync.pushLocal();
    h.sent.clear();

    final server = WorkspaceState(
      panes: [..._local.panes, _remote.panes.first],
      activePaneId: 'p1',
    );
    h.sync.handleFrame(_state(server, 2, conflict: true));

    expect(h.paneIds, ['p1', 'p9', 'p2']);
    expect(h.sent.single['baseRevision'], 2);
  });

  test('an edit broadcast from another device is applied as sanitized state', () {
    final h = _Harness();
    h.synced();
    h.sync.handleFrame(_state(_remote, 2, origin: 'other-device'));

    expect(h.current.panes.last.kind, PaneKind.editor);
    expect(h.current.panes.last.filePath, '/x.dart');
    h.sync.pushLocal(); // applying must not echo back
    expect(h.sent, isEmpty);
  });

  test('a broadcast older than the acked base is ignored', () {
    final h = _Harness();
    h.synced(rev: 5);
    h.sync.handleFrame(_state(_remote, 4, origin: 'other-device'));
    expect(h.applied, isNull);
  });

  test('empty server reply seeds it with the local workspace', () {
    final h = _Harness();
    h.sync.handleFrame({'kind': 'workspace_state', 'state': null, 'revision': 0});

    expect(h.sent.single['type'], 'workspace.update');
    expect(h.sent.single['baseRevision'], 0);
    expect(h.sent.single['state'], _local.toJson());
  });

  test('flush sends a pending edit immediately', () {
    final h = _Harness();
    h.synced();
    h.current = _remote;
    h.sync.schedulePush();
    h.sync.flush();
    expect(h.sent.single['state'], _remote.toJson());
  });

  test('unrelated frames are ignored', () {
    final h = _Harness();
    h.sync.handleFrame({'kind': 'stream_delta', 'sessionId': 'x'});
    h.sync.handleFrame({'type': 'presence-roster', 'users': <String>[]});
    expect(h.applied, isNull);
    expect(h.sent, isEmpty);
  });

  group('mergeWorkspace', () {
    test('no local edits → exactly the remote state', () {
      final merged = mergeWorkspace(base: _local, local: _local, remote: _remote);
      expect(merged.toJson(), _remote.toJson());
    });

    test('local reorder wins for shared panes', () {
      const a = SplitPane(id: 'a', kind: PaneKind.chat);
      const b = SplitPane(id: 'b', kind: PaneKind.git);
      const c = SplitPane(id: 'c', kind: PaneKind.notes);
      final merged = mergeWorkspace(
        base: const WorkspaceState(panes: [a, b]),
        local: const WorkspaceState(panes: [b, a]),
        remote: const WorkspaceState(panes: [a, b, c]),
      );
      expect([for (final p in merged.panes) p.id], ['b', 'a', 'c']);
    });

    test('local re-bind of a pane wins over the remote copy', () {
      const base = WorkspaceState(
        panes: [SplitPane(id: 'a', kind: PaneKind.chat, picker: true)],
      );
      const local = WorkspaceState(
        panes: [SplitPane(id: 'a', kind: PaneKind.chat, sessionId: 's')],
      );
      final merged = mergeWorkspace(base: base, local: local, remote: base);
      expect(merged.panes.single.sessionId, 's');
    });
  });
}
