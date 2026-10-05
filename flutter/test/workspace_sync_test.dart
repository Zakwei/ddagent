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

  /// Marks the boot handshake as done: feeds a snapshot echoing the current
  /// local state so `_lastSyncedJson` is set (this is a reconnect, not a cold
  /// boot), then clears the captured side-effects.
  void synced() {
    sync.handleFrame({
      'kind': 'workspace_state',
      'state': current.toJson(),
      'revision': 1,
      'originDeviceId': null,
    });
    sent.clear();
    applied = null;
  }
}

void main() {
  test('requestSnapshot sends workspace.get with the device id', () {
    final h = _Harness();
    h.sync.requestSnapshot();
    expect(h.sent, [
      {'type': 'workspace.get', 'deviceId': 'dev-test'},
    ]);
  });

  test('a cold boot adopts the server snapshot over stale local panes', () {
    final h = _Harness();
    // First frame of the app run — local panes are restored-from-disk or
    // auto-seeded guesses, the snapshot carries another device's live
    // workspace. Remote wins and nothing is pushed back over it.
    h.sync.handleFrame({
      'kind': 'workspace_state',
      'state': _remote.toJson(),
      'revision': 3,
      'originDeviceId': null,
    });

    expect(h.applied?.panes.length, 2);
    expect(h.applied?.panes.first.id, 'p9');
    expect(h.sent, isEmpty);
  });

  test('pre-sync pushes stay silent so boot state never reaches the server', () {
    final h = _Harness();
    h.sync.pushLocal(); // e.g. the auto-seeded picker pane firing pre-snapshot
    expect(h.sent, isEmpty);
    expect(h.sync.dirty, isFalse);
  });

  test('a snapshot reply never clobbers a non-empty local workspace on reconnect', () {
    final h = _Harness();
    h.synced(); // past the boot handshake — this socket already saw the server
    // Server reply to workspace.get → originDeviceId null, may be stale.
    h.sync.handleFrame({
      'kind': 'workspace_state',
      'state': _remote.toJson(),
      'revision': 3,
      'originDeviceId': null,
    });

    // Local panes were kept, not replaced, and pushed back so the server
    // catches up (the "panes close on reconnect" regression).
    expect(h.applied, isNull);
    expect(h.sent.length, 1);
    expect(h.sent[0]['type'], 'workspace.update');
    expect(h.sent[0]['state'], _local.toJson());
  });

  test('an edit broadcast from another device is applied as sanitized state', () {
    final h = _Harness();
    h.sync.handleFrame({
      'kind': 'workspace_state',
      'state': _remote.toJson(),
      'revision': 3,
      'originDeviceId': 'other-device',
    });

    expect(h.applied?.panes.length, 2);
    expect(h.applied?.panes.last.kind, PaneKind.editor);
    expect(h.applied?.panes.last.filePath, '/x.dart');

    // Applying must not echo back — the local watcher now sees state equal to
    // lastSynced and stays silent.
    h.sync.pushLocal();
    expect(h.sent, isEmpty);
  });

  test('a snapshot reply fills an empty local workspace', () {
    final h = _Harness();
    h.current = const WorkspaceState();
    h.sync.handleFrame({
      'kind': 'workspace_state',
      'state': _remote.toJson(),
      'revision': 3,
      'originDeviceId': null,
    });

    // Fresh device — adopt the server's panes.
    expect(h.applied?.panes.length, 2);
    expect(h.sent, isEmpty);
  });

  test('local change pushes one workspace.update; unchanged state stays silent', () {
    final h = _Harness();
    h.synced();

    h.current = _remote;
    h.sync.pushLocal();
    expect(h.sent.length, 1);
    expect(h.sent[0]['type'], 'workspace.update');
    expect(h.sent[0]['state'], _remote.toJson());

    h.sync.pushLocal(); // same serialized state → deduped, stays silent
    expect(h.sent.length, 1);
  });

  test('empty server reply seeds it with the local workspace', () {
    final h = _Harness();
    h.sync.handleFrame({'kind': 'workspace_state', 'state': null, 'revision': 0});

    expect(h.sent.length, 1);
    expect(h.sent[0]['type'], 'workspace.update');
    expect(h.sent[0]['state'], _local.toJson());
  });

  test('unsent local edits win over an incoming remote state (dirty tie-break)', () {
    final h = _Harness();
    h.synced();
    h.current = _remote;
    h.sendOk = false;
    h.sync.pushLocal(); // socket down → dirty, nothing sent
    h.sendOk = true;

    h.sync.handleFrame({'kind': 'workspace_state', 'state': _local.toJson(), 'revision': 5});

    // Remote was NOT applied; our dirty local state was pushed instead.
    expect(h.applied, isNull);
    expect(h.sent.length, 1);
    expect(h.sent[0]['type'], 'workspace.update');
    expect(h.sent[0]['state'], _remote.toJson());
    expect(h.sync.dirty, isFalse);
  });

  test('unrelated frames are ignored', () {
    final h = _Harness();
    h.sync.handleFrame({'kind': 'stream_delta', 'sessionId': 'x'});
    h.sync.handleFrame({'type': 'presence-roster', 'users': <String>[]});
    expect(h.applied, isNull);
    expect(h.sent, isEmpty);
  });
}
