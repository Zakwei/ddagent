import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/features/workspace/state/split_workspace.dart';

/// Port of src/components/main-content/utils/workspaceSync.ts — cross-device
/// sync of the split workspace over the /ws chat socket.
///
/// Server protocol: `workspace.get` → `workspace_state` reply to the requester;
/// `workspace.update` → persisted + broadcast `workspace_state` to the user's
/// other sockets. Conflicts are last-write-wins on the server.
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

  // Serialized state as last seen by the server. Null until the first
  // workspace_state frame or successful push — NOT seeded with the boot state,
  // because the notifier's `state` isn't readable while build() is still
  // running.
  String? _lastSyncedJson;
  // True when a local edit couldn't reach the server (socket down). The next
  // workspace_state reply then loses to our push — unsent edits beat remote
  // state the user never saw.
  bool _dirty = false;
  Timer? _pushTimer;

  bool get dirty => _dirty;

  static String _serialize(WorkspaceState state) => jsonEncode(state.toJson());

  /// Sends `workspace.get`; call whenever the socket (re)opens.
  void requestSnapshot() {
    _send({'type': 'workspace.get', 'deviceId': _deviceId()});
  }

  /// Debounced push after a local mutation. Echo frames land here too, but
  /// the serialized dedup inside [_push] makes them a no-op.
  void schedulePush() {
    _pushTimer?.cancel();
    _pushTimer = Timer(_pushDebounce, pushLocal);
  }

  void pushLocal() => _push(_getState());

  bool _push(WorkspaceState state) {
    final json = _serialize(state);
    if (json == _lastSyncedJson) return true;
    if (_send({'type': 'workspace.update', 'state': state.toJson(), 'deviceId': _deviceId()})) {
      _lastSyncedJson = json;
      return true;
    }
    _dirty = true;
    return false;
  }

  /// One inbound ws frame. Non-workspace frames are ignored.
  /// Order: dirty push → snapshot keep-local → apply remote → seed empty server.
  void handleFrame(Map<String, dynamic> frame) {
    if (frame['kind'] != 'workspace_state') return;

    if (_dirty) {
      // _push re-checks the serialized form, so a frame echoing our own
      // pending write becomes a no-op instead of a redundant send.
      _dirty = false;
      pushLocal();
      return;
    }

    final remote = frame['state'];
    if (remote is Map) {
      final next = WorkspaceState.sanitize(remote);
      _lastSyncedJson = _serialize(next);
      // A snapshot reply to `workspace.get` carries originDeviceId:null; a
      // genuine edit from another device carries its deviceId (server's
      // sendCurrent vs applyUpdate). A snapshot is a *reply*, not an edit: it
      // can be stale or partial (the server may predate this device's panes),
      // and clobbering a non-empty local workspace with it is what silently
      // closed the user's panes on every socket reconnect. Keep local and push
      // it so the server catches up; only adopt a snapshot when local is empty
      // (fresh device — the intended way to pick up another device's panes).
      if (frame['originDeviceId'] == null && _getState().panes.isNotEmpty) {
        pushLocal();
        return;
      }
      _applyRemote(next);
      return;
    }

    // Server holds nothing yet — seed it with this device's workspace. Forced
    // send: the payload equals the boot state, so the dedup inside _push would
    // swallow the seed.
    final state = _getState();
    if (_send({'type': 'workspace.update', 'state': state.toJson(), 'deviceId': _deviceId()})) {
      _lastSyncedJson = _serialize(state);
    } else {
      _dirty = true;
    }
  }

  void dispose() => _pushTimer?.cancel();
}
