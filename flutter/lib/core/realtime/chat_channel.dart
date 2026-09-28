import 'dart:async';

import 'package:ddagent_app/core/realtime/ws_client.dart';

/// Message kinds produced by provider runtimes (server/shared/types.ts
/// `MessageKind`) plus gateway kinds (`GatewayEventKind`) and broadcast kinds
/// emitted by server modules (kanban-*, taskmaster-*, presence-roster, …).
enum MessageKind {
  text,
  toolUse,
  toolResult,
  thinking,
  streamDelta,
  thoughtDelta,
  streamReplace,
  streamEnd,
  error,
  complete,
  status,
  permissionRequest,
  permissionCancelled,
  sessionCreated,
  interactivePrompt,
  taskNotification,
}

enum GatewayKind { chatSubscribed, sessionUpserted, loadingProgress, protocolError }

/// Well-known broadcast `kind` strings sent to every /ws client by server
/// modules (not part of `MessageKind`/`GatewayEventKind` — matched by prefix
/// or literal, so stay as raw strings).
abstract final class BroadcastKinds {
  static const presenceRoster = 'presence-roster';
  static const queuedMessagesUpdated = 'queued-messages-updated';
  static const notification = 'notification';
  static const sessionRemoved = 'session_removed';
  static const kanbanPrefix = 'kanban-';
  static const taskmasterPrefix = 'taskmaster-';
}

MessageKind? messageKindOf(String kind) {
  const map = {
    'text': MessageKind.text,
    'tool_use': MessageKind.toolUse,
    'tool_result': MessageKind.toolResult,
    'thinking': MessageKind.thinking,
    'stream_delta': MessageKind.streamDelta,
    'thought_delta': MessageKind.thoughtDelta,
    'stream_replace': MessageKind.streamReplace,
    'stream_end': MessageKind.streamEnd,
    'error': MessageKind.error,
    'complete': MessageKind.complete,
    'status': MessageKind.status,
    'permission_request': MessageKind.permissionRequest,
    'permission_cancelled': MessageKind.permissionCancelled,
    'session_created': MessageKind.sessionCreated,
    'interactive_prompt': MessageKind.interactivePrompt,
    'task_notification': MessageKind.taskNotification,
  };
  return map[kind];
}

/// One decoded server frame. [raw] keeps every field — provider payloads are
/// intentionally heterogeneous (NormalizedMessage has an index signature).
class ServerEvent {
  const ServerEvent({required this.raw});

  final Map<String, dynamic> raw;

  String get kind => raw['kind'] as String? ?? '';
  String? get sessionId => raw['sessionId'] as String?;
  int? get seq => (raw['seq'] as num?)?.toInt();
  String? get runId => raw['runId'] as String?;
  String? get requestId => raw['requestId'] as String?;

  MessageKind? get messageKind => messageKindOf(kind);
  bool get isGateway => switch (kind) {
    'chat_subscribed' || 'session_upserted' || 'loading_progress' || 'protocol_error' => true,
    _ => false,
  };
  bool get isBroadcast =>
      kind == BroadcastKinds.presenceRoster ||
      kind == BroadcastKinds.queuedMessagesUpdated ||
      kind == BroadcastKinds.notification ||
      kind == BroadcastKinds.sessionRemoved ||
      kind.startsWith(BroadcastKinds.kanbanPrefix) ||
      kind.startsWith(BroadcastKinds.taskmasterPrefix);
}

/// Replay cursor for one session — `{runId, seq}` pair (seq restarts per run).
class ReplayCursor {
  const ReplayCursor({this.runId, this.lastSeq = 0});

  final String? runId;
  final int lastSeq;

  /// Dedupe key: an event is new iff it belongs to a later run or has a
  /// strictly greater seq within the same run.
  bool isNew(ServerEvent e) {
    if (e.runId == null || e.seq == null) {
      return true; // unsequenced → pass through
    }
    if (runId != e.runId) return true; // newer run — cursor resets server-side
    return e.seq! > lastSeq;
  }

  ReplayCursor advance(ServerEvent e) =>
      e.seq == null ? this : ReplayCursor(runId: e.runId ?? runId, lastSeq: e.seq!);
}

/// `/ws` channel — chat protocol + gateway/broadcast dispatch (Task 6.2–6.4).
///
/// Inbound (client → server):
///   chat.send {sessionId, content, options?}
///   chat.abort {sessionId}
///   chat.subscribe {sessions:[{sessionId, lastSeq?, runId?}]}
///   chat.permission-response {requestId, allow, updatedInput?, message?, rememberEntry?}
///   chat.set-permission-mode {sessionId, permissionMode}
///   presence {viewing}
///
/// Outbound frames are exposed as a typed stream; replay cursors are updated
/// automatically and dedupe replayed `(runId, seq)` pairs.
class ChatChannel {
  ChatChannel(this._ws);

  final WsClient _ws;
  final _events = StreamController<ServerEvent>.broadcast();
  final _cursors = <String, ReplayCursor>{};
  StreamSubscription<Map<String, dynamic>>? _framesSub;
  StreamSubscription<WsState>? _statesSub;

  /// Sessions subscribed since the channel started — re-subscribed after each
  /// reconnect (the registry drops socket subscribers on close).
  final _subscriptions = <String>{};

  Stream<ServerEvent> get events => _events.stream;
  Stream<WsState> get states => _ws.states;
  WsState get wsState => _ws.state;

  /// Live cursor per session — used to seed `lastSeq`/`runId` on resubscribe.
  ReplayCursor cursor(String sessionId) => _cursors[sessionId] ?? const ReplayCursor();

  /// Binds the frame pump. Call once, right after construction.
  void start() {
    _framesSub ??= _ws.frames.listen(_onFrame);
    // Re-attach subscriptions whenever the socket comes back.
    _statesSub = _ws.states.listen((state) {
      if (state == WsState.open && _subscriptions.isNotEmpty) {
        _sendSubscribe(_subscriptions.toList());
      }
    });
  }

  Future<void> connect() => _ws.connect();
  Future<void> close() => _ws.close();

  // --- outbound (6.4) ---

  void sendMessage(String sessionId, String content, {Map<String, dynamic>? options}) => _ws.send({
    'type': 'chat.send',
    'sessionId': sessionId,
    'content': content,
    'options': ?options,
  });

  void abort(String sessionId) => _ws.send({'type': 'chat.abort', 'sessionId': sessionId});

  /// Subscribe (or re-subscribe) to live frames for [sessionIds]. Sends the
  /// stored `{runId, lastSeq}` cursor so the server replays only missed
  /// events (registry replays `seq > lastSeq` for running runs).
  void subscribe(Iterable<String> sessionIds) {
    _subscriptions.addAll(sessionIds);
    if (_ws.state == WsState.open) _sendSubscribe(sessionIds.toList());
  }

  void unsubscribe(String sessionId) => _subscriptions.remove(sessionId);

  void _sendSubscribe(List<String> sessionIds) {
    _ws.send({
      'type': 'chat.subscribe',
      'sessions': [
        for (final id in sessionIds)
          {'sessionId': id, 'lastSeq': cursor(id).lastSeq, 'runId': ?cursor(id).runId},
      ],
    });
  }

  void permissionResponse(
    String requestId, {
    required bool allow,
    dynamic updatedInput,
    String? message,
    dynamic rememberEntry,
  }) => _ws.send({
    'type': 'chat.permission-response',
    'requestId': requestId,
    'allow': allow,
    'updatedInput': ?updatedInput,
    'message': ?message,
    'rememberEntry': ?rememberEntry,
  });

  void setPermissionMode(String sessionId, String permissionMode) => _ws.send({
    'type': 'chat.set-permission-mode',
    'sessionId': sessionId,
    'permissionMode': permissionMode,
  });

  /// Presence announce — `viewing` is `{kind: session|card|board, id}` per
  /// server `readPresenceViewing`; null clears the announce. The first frame
  /// on a socket doubles as the roster subscription. No-op while offline.
  void presence(Map<String, dynamic>? viewing) {
    try {
      _ws.send({'type': 'presence', 'viewing': ?viewing});
    } on StateError {
      // Socket closed — the roster just won't see us until reconnect.
    }
  }

  // --- inbound dispatch (6.2 + 6.3 replay/dedupe) ---

  void _onFrame(Map<String, dynamic> raw) {
    final event = ServerEvent(raw: raw);
    final sid = event.sessionId;

    // chat_subscribed carries the authoritative run id — reseed the cursor so
    // a new run (seq restarting at 1) replays in full instead of being skipped.
    if (event.kind == 'chat_subscribed' && sid != null) {
      final serverRunId = event.runId;
      if (serverRunId != null && serverRunId != _cursors[sid]?.runId) {
        _cursors[sid] = ReplayCursor(runId: serverRunId);
      }
      _events.add(event);
      return;
    }

    if (sid != null && !event.isBroadcast && !event.isGateway) {
      final cursor = _cursors[sid] ?? const ReplayCursor();
      if (!cursor.isNew(event)) return; // replayed frame — drop
      _cursors[sid] = cursor.advance(event);
    }

    _events.add(event);
  }

  /// `runId`/`lastSeq` JSON for persistence (per-session cursors).
  Map<String, dynamic> cursorsJson() => {
    for (final e in _cursors.entries) e.key: {'runId': e.value.runId, 'lastSeq': e.value.lastSeq},
  };

  void restoreCursors(Map<String, dynamic> json) {
    for (final e in json.entries) {
      final v = e.value;
      if (v is Map) {
        _cursors[e.key] = ReplayCursor(
          runId: v['runId'] as String?,
          lastSeq: (v['lastSeq'] as num?)?.toInt() ?? 0,
        );
      }
    }
  }

  Future<void> dispose() async {
    await _framesSub?.cancel();
    await _statesSub?.cancel();
    await _events.close();
    await _ws.dispose();
  }
}
