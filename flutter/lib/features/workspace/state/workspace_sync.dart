import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/features/workspace/state/split_workspace.dart';

/// Port of src/components/main-content/utils/workspaceSync.ts — cross-device
/// sync of the split workspace over the /ws chat socket.
///
/// Server protocol: `workspace.get` → `workspace_state` reply to the requester;
/// `workspace.update {state, baseRevision}` is a compare-and-swap — accepted
/// writes are acked (`workspace_ack {revision}`) and broadcast as
/// `workspace_state` to the user's other sockets; a stale `baseRevision` is
/// rejected with the current state (`workspace_state {conflict: true}`).
///
/// The server is the source of truth. This device only ever contributes its
/// own *edits* — the diff between the last server-confirmed state ([_base])
/// and the local state — rebased onto whatever the server holds (see
/// [mergeWorkspace]). A device that slept through other devices' changes
/// therefore adopts them on wake instead of pushing its stale layout back.
///
/// Pure logic lives here (no Riverpod) so tests need no socket or provider
/// container — the [WorkspaceController] only wires timers, subscriptions,
/// and the channel's send into it.
class WorkspaceSync {
  WorkspaceSync({
    required this._deviceId,
    required this._getState,
    required this._applyRemote,
    required this._send,
    this._pushDebounce = const Duration(milliseconds: 400),
  });

  final String Function() _deviceId;
  final WorkspaceState Function() _getState;
  final void Function(WorkspaceState) _applyRemote;
  final bool Function(Map<String, dynamic>) _send;
  final Duration _pushDebounce;

  // Last state the server confirmed (snapshot, broadcast, or ack) and its
  // revision. Null until the first workspace_state frame of this app run —
  // NOT seeded with the boot state: restored-from-disk panes are a guess, so
  // pushes stay gated until the server has been read (see pushLocal).
  WorkspaceState? _base;
  int _baseRevision = 0;
  // Update sent but not yet acked/rejected. One write in flight at a time, so
  // every write carries the revision it was built on.
  WorkspaceState? _inflight;
  bool _awaitingSnapshot = false;
  Timer? _pushTimer;

  /// True while a `workspace.get` is unanswered — a reply that never comes
  /// means the socket died while the app slept.
  bool get awaitingSnapshot => _awaitingSnapshot;

  /// Local edits not yet confirmed by the server.
  bool get hasPendingEdits => _base != null && !_sameState(_getState(), _base!);

  static String _serialize(WorkspaceState state) => jsonEncode(state.toJson());

  static bool _sameState(WorkspaceState a, WorkspaceState b) => _serialize(a) == _serialize(b);

  /// Sends `workspace.get`; call whenever the socket (re)opens and whenever
  /// the app returns to the foreground. An update in flight on a previous
  /// socket is forgotten — the snapshot shows whether it landed, and any edit
  /// it carried is still a local-vs-base diff that gets rebased and re-sent.
  void requestSnapshot() {
    _inflight = null;
    if (_send({'type': 'workspace.get', 'deviceId': _deviceId()})) {
      _awaitingSnapshot = true;
    }
  }

  /// Debounced push after a local mutation.
  void schedulePush() {
    _pushTimer?.cancel();
    _pushTimer = Timer(_pushDebounce, pushLocal);
  }

  /// Sends a pending debounced push right away — the app is going to the
  /// background and timers may never fire.
  void flush() {
    _pushTimer?.cancel();
    pushLocal();
  }

  void pushLocal() {
    final base = _base;
    // Never write before reading: a boot-time push (restored Hive panes or the
    // auto-seeded picker pane) would broadcast this device's stale layout over
    // every other device's live workspace.
    if (base == null || _inflight != null) return;
    final state = _getState();
    if (_sameState(state, base)) return;
    final sent = _send({
      'type': 'workspace.update',
      'state': state.toJson(),
      'baseRevision': _baseRevision,
      'deviceId': _deviceId(),
    });
    // A failed send leaves the edit as a local-vs-base diff; the snapshot on
    // reconnect rebases and re-sends it.
    if (sent) _inflight = state;
  }

  /// One inbound ws frame. Non-workspace frames are ignored.
  void handleFrame(Map<String, dynamic> frame) {
    switch (frame['kind']) {
      case 'workspace_ack':
        _onAck(frame);
      case 'workspace_state':
        _onState(frame);
    }
  }

  void _onAck(Map<String, dynamic> frame) {
    final sent = _inflight;
    final revision = frame['revision'];
    if (sent == null || revision is! int) return;
    _inflight = null;
    _base = sent;
    _baseRevision = revision;
    // Edits made while the write was in flight.
    pushLocal();
  }

  void _onState(Map<String, dynamic> frame) {
    final revision = frame['revision'] is int ? frame['revision'] as int : 0;
    final isReply = frame['originDeviceId'] == null;
    if (isReply) _awaitingSnapshot = false;
    if (frame['conflict'] == true) _inflight = null;

    final base = _base;
    // A broadcast older than what we already hold (e.g. overtaken by our own
    // acked write) carries nothing new.
    if (base != null && revision < _baseRevision) return;

    final raw = frame['state'];
    final remote = raw is Map ? WorkspaceState.sanitize(raw) : const WorkspaceState();
    _base = remote;
    _baseRevision = revision;

    if (base == null) {
      // First contact of this app run. Local panes are restored-from-disk or
      // auto-seeded guesses — the server's copy wins. An empty server is
      // seeded with this device's workspace instead.
      if (raw is Map) {
        _applyRemote(remote);
      } else {
        pushLocal();
      }
      return;
    }

    final merged = mergeWorkspace(base: base, local: _getState(), remote: remote);
    if (!_sameState(merged, _getState())) _applyRemote(merged);
    pushLocal();
  }

  void dispose() => _pushTimer?.cancel();
}

/// Three-way merge of the pane layout: replays the local edits (`base` →
/// `local`) on top of the server's `remote`. With no local edits the result is
/// exactly `remote`, so the server always wins over a stale device; panes the
/// user opened, closed, re-bound or reordered locally survive a concurrent
/// change made on another device.
WorkspaceState mergeWorkspace({
  required WorkspaceState base,
  required WorkspaceState local,
  required WorkspaceState remote,
}) {
  String key(SplitPane p) => jsonEncode(p.toJson());
  final baseById = {for (final p in base.panes) p.id: p};
  final localIds = {for (final p in local.panes) p.id};

  final removed = {
    for (final id in baseById.keys)
      if (!localIds.contains(id)) id,
  };
  final updated = {
    for (final p in local.panes)
      if (baseById[p.id] case final b? when key(b) != key(p)) p.id: p,
  };

  var panes = [
    for (final p in remote.panes)
      if (!removed.contains(p.id)) updated[p.id] ?? p,
  ];

  // Local reorder of panes that already existed → local order wins for them.
  final baseOrder = [
    for (final p in base.panes)
      if (localIds.contains(p.id)) p.id,
  ];
  final localOrder = [
    for (final p in local.panes)
      if (baseById.containsKey(p.id)) p.id,
  ];
  if (baseOrder.join('\n') != localOrder.join('\n')) {
    final rank = {for (final (i, id) in localOrder.indexed) id: i};
    final ordered = [...panes.where((p) => rank.containsKey(p.id))]
      ..sort((a, b) => rank[a.id]!.compareTo(rank[b.id]!));
    panes = [...ordered, ...panes.where((p) => !rank.containsKey(p.id))];
  }

  final present = {for (final p in panes) p.id};
  for (final p in local.panes) {
    if (!baseById.containsKey(p.id) && !present.contains(p.id)) panes.add(p);
  }
  panes = panes.take(maxSplitPanes).toList();
  final ids = {for (final p in panes) p.id};

  String? pick(String? baseValue, String? localValue, String? remoteValue) =>
      localValue != baseValue ? localValue : remoteValue;
  final wanted = pick(base.activePaneId, local.activePaneId, remote.activePaneId);
  final active = ids.contains(wanted)
      ? wanted
      : (ids.contains(remote.activePaneId)
            ? remote.activePaneId
            : (panes.isEmpty ? null : panes.first.id));

  return WorkspaceState(
    panes: panes,
    activePaneId: active,
    lastUsedProjectId: pick(
      base.lastUsedProjectId,
      local.lastUsedProjectId,
      remote.lastUsedProjectId,
    ),
    maximizedPaneId: local.maximizedPaneId,
  );
}
