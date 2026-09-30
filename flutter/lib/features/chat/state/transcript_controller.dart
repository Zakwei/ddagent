import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/state/pending_permissions.dart';
import 'package:ddagent_app/features/notifications/data/notifications_repository.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/voice/state/tts_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// History page size for the initial load — matches the web client's
/// INITIAL_HISTORY_PAGE_SIZE (5 × 40); tool-heavy turns otherwise push the
/// last assistant reply out of a single page.
const initialHistoryPageSize = 200;
const initialHistoryMinText = 2;
const initialHistoryMaxExtraPages = 3;
const olderPageSize = 40;

class TranscriptState {
  const TranscriptState({
    this.loading = false,
    this.loadingOlder = false,
    this.error,
    this.olderError,
    this.allLoaded = false,
    this.runStatus,
    this.replacedWith,
  });

  final bool loading;
  final bool loadingOlder;
  final AppError? error;
  final AppError? olderError;
  final bool allLoaded;

  /// 'running' | 'done' | 'error' — derived from status/complete/error frames.
  final String? runStatus;

  /// T17.3 — set when a `session_created` frame assigns the real session id;
  /// the view listens and replaces the route (`/chat/<new>`).
  final String? replacedWith;

  TranscriptState copyWith({
    bool? loading,
    bool? loadingOlder,
    AppError? Function()? error,
    AppError? Function()? olderError,
    bool? allLoaded,
    String? Function()? runStatus,
    String? Function()? replacedWith,
  }) => TranscriptState(
    loading: loading ?? this.loading,
    loadingOlder: loadingOlder ?? this.loadingOlder,
    error: error != null ? error() : this.error,
    olderError: olderError != null ? olderError() : this.olderError,
    allLoaded: allLoaded ?? this.allLoaded,
    runStatus: runStatus != null ? runStatus() : this.runStatus,
    replacedWith: replacedWith != null ? replacedWith() : this.replacedWith,
  );
}

/// Per-session transcript controller (T13.1–13.5, 13.8):
/// initial REST page + tail-walk, WS subscribe + frame dispatch into
/// [SessionMessageStore], load-older pagination, send/abort passthrough.
class TranscriptController extends Notifier<TranscriptState> {
  TranscriptController(this._sessionId);

  final String _sessionId;

  /// Project the session belongs to — keys the offline send queue
  /// (`ddagent_offline_queue_<projectId>`). Resolved from the session row on
  /// demand rather than passed in: it is NOT part of the transcript's identity
  /// (that is only the session id), so a late-arriving projectId must not
  /// create a second controller and refetch the whole transcript.
  String? get _projectId =>
      ref.read(sessionDetailsProvider(_sessionId)).value?.projectId;
  StreamSubscription<ServerEvent>? _eventsSub;
  StreamSubscription<WsState>? _statesSub;
  bool _initialLoaded = false;

  /// Coalesced row writes (see [_queueRow]).
  final _pendingRows = <SessionMessage>[];
  Timer? _flushTimer;

  /// Set once this pane sent a prompt — lets `session_created` (which carries
  /// the provider-assigned id, not the draft route id) be attributed here.
  bool _sentAny = false;

  /// Wall-clock when this pane subscribed. The `chat_subscribed` ack can only
  /// speak for runs that already existed then, so a non-processing ack must not
  /// clear a request started after this point (web `statusCheckSentAt`).
  int _subscribeSentAt = 0;

  SessionMessageStore get _store =>
      ref.read(sessionMessageStoreProvider.notifier);
  ChatChannel get _channel => ref.read(chatChannelProvider);
  StreamDeltaBuffer get _buffer => ref.read(streamDeltaBufferProvider);
  SessionActivityController get _activity =>
      ref.read(sessionActivityProvider.notifier);

  /// Seed the processing map from the subscribe ack. A live run replays its
  /// `status` frame anyway, but a *finished* run (or a reloaded page) only
  /// learns the session is idle here — `ifStartedBefore` (the moment this pane
  /// subscribed) stops this late ack from clearing a request started after it.
  void _applySubscribeAck(Map<String, dynamic> raw) {
    if (raw['isProcessing'] == true) {
      _activity.markProcessing(_sessionId, canInterrupt: true);
      return;
    }
    _activity.markIdle(_sessionId, ifStartedBefore: _subscribeSentAt);
  }

  @override
  TranscriptState build() {
    final channel = ref.watch(chatChannelProvider);
    channel.subscribe([_sessionId]);
    _eventsSub = channel.events.listen(_onEvent);
    _statesSub = channel.states.listen((s) {
      if (s == WsState.open) unawaited(_flushOffline());
    });
    ref.onDispose(() {
      _flushPendingRows();
      channel.unsubscribe(_sessionId);
      unawaited(_eventsSub?.cancel());
      unawaited(_statesSub?.cancel());
    });
    if (!_initialLoaded) {
      _initialLoaded = true;
      Future(loadInitial);
    }
    _subscribeSentAt = DateTime.now().millisecondsSinceEpoch;
    return const TranscriptState(loading: true);
  }

  List<SessionMessage> get _serverMessages =>
      ref.read(sessionMessageStoreProvider)[_sessionId]?.serverMessages ??
      const [];

  bool get _hasMore =>
      ref.read(sessionMessageStoreProvider)[_sessionId]?.hasMore ?? false;

  /// Latest page + backward tail-walk until ≥2 text rows (or page budget).
  Future<void> loadInitial() async {
    if (!ref.mounted) return;
    state = state.copyWith(loading: true, error: () => null);
    try {
      var extra = 0;
      await _fetchLatest();
      while (_shouldWalkOlder(extra)) {
        extra++;
        final done = await _fetchOlder();
        if (!done) break;
      }
      if (ref.mounted) state = state.copyWith(loading: false);
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(loading: false, error: () => e);
    } on Object {
      if (ref.mounted) state = state.copyWith(loading: false);
    }
  }

  bool _shouldWalkOlder(int extra) {
    if (!_hasMore || extra >= initialHistoryMaxExtraPages) return false;
    var texts = 0;
    for (final m in _serverMessages) {
      if (m.kind == 'text') texts++;
      if (texts >= initialHistoryMinText) return false;
    }
    return true;
  }

  Future<void> _fetchLatest() async {
    final res = await ref
        .read(sessionsRepositoryProvider)
        .messages(_sessionId, limit: initialHistoryPageSize, offset: 0);
    final msgs = _parsePage(res);
    _store.applyLatestPage(
      _sessionId,
      msgs,
      total: (res['total'] as num?)?.toInt() ?? msgs.length,
      hasMore: res['hasMore'] == true,
    );
  }

  /// Load one older page (tail-offset = already-loaded row count).
  /// Returns false when nothing new was prepended.
  Future<bool> _fetchOlder() async {
    final res = await ref
        .read(sessionsRepositoryProvider)
        .messages(
          _sessionId,
          limit: olderPageSize,
          offset: _serverMessages.length,
        );
    final msgs = _parsePage(res);
    _store.prependOlderPage(_sessionId, msgs, hasMore: res['hasMore'] == true);
    return msgs.isNotEmpty;
  }

  List<SessionMessage> _parsePage(Map<String, dynamic> res) {
    final list = res['messages'] as List? ?? const [];
    return [
      for (final m in list)
        SessionMessage.fromJson(
          {...m as Map, 'sessionId': _sessionId}.cast<String, dynamic>(),
        ),
    ];
  }

  Future<void> loadOlder() async {
    if (state.loadingOlder || state.allLoaded || !_hasMore) return;
    state = state.copyWith(loadingOlder: true, olderError: () => null);
    try {
      final fetched = await _fetchOlder();
      if (ref.mounted) {
        state = state.copyWith(
          loadingOlder: false,
          allLoaded: !fetched && !_hasMore,
        );
      }
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loadingOlder: false, olderError: () => e);
      }
    }
  }

  void send(String text, {Map<String, dynamic>? options}) {
    _sentAny = true;
    // Optimistic: show the activity indicator immediately, before the server's
    // `status` frame lands (web `onSessionProcessing` on send).
    _activity.markProcessing(_sessionId, canInterrupt: true);
    final provider =
        ref
            .read(sessionMessageStoreProvider)[_sessionId]
            ?.merged
            .lastOrNull
            ?.provider ??
        '';
    try {
      _channel.sendMessage(_sessionId, text, options: options);
    } on StateError {
      // Socket closed (reconnect/offline) — persist for the next open, parity
      // with the web client's ddagent_offline_queue_* bucket.
      _enqueueOffline(text, options);
    }
    _store.appendLocalEcho(_sessionId, text, provider);
  }

  void _enqueueOffline(String text, Map<String, dynamic>? options) {
    final pid = _projectId;
    if (pid == null) return;
    unawaited(
      ChatStorage.enqueueOffline(pid, {
        'id': 'offline-msg-${DateTime.now().millisecondsSinceEpoch}',
        'sessionId': _sessionId,
        'content': text,
        'options': ?options,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      }),
    );
  }

  /// Resend this session's queued offline messages once the socket opens —
  /// entries leave storage only after their frame is sent (web `claim`
  /// semantics: a reload mid-flush replays rather than drops).
  Future<void> _flushOffline() async {
    final pid = _projectId;
    if (pid == null) return;
    final q = ChatStorage.readOfflineQueue(pid);
    final mine = q.where((e) => e['sessionId'] == _sessionId).toList();
    if (mine.isEmpty) return;
    for (final e in mine) {
      if (_channel.wsState != WsState.open) return;
      _channel.sendMessage(
        _sessionId,
        e['content'] as String,
        options: (e['options'] as Map?)?.cast<String, dynamic>(),
      );
      q.remove(e);
      await ChatStorage.writeOfflineQueue(pid, q);
    }
  }

  void abort() => _channel.abort(_sessionId);

  void permissionResponse(
    String requestId, {
    required bool allow,
    dynamic updatedInput,
    String? message,
    dynamic rememberEntry,
  }) => _channel.permissionResponse(
    requestId,
    allow: allow,
    updatedInput: updatedInput,
    message: message,
    rememberEntry: rememberEntry,
  );

  /// Permission decision (T15.4/6): WS frame when connected; REST counterpart
  /// `POST /api/notifications/approvals/:requestId` when the socket is down
  /// (offline approvals parity with the web banner).
  Future<void> decidePermission(
    String requestId, {
    required bool allow,
    dynamic updatedInput,
    String? message,
    dynamic rememberEntry,
  }) async {
    ref.read(pendingPermissionsProvider.notifier).remove(requestId);
    if (_channel.wsState == WsState.open) {
      _channel.permissionResponse(
        requestId,
        allow: allow,
        updatedInput: updatedInput,
        message: message,
        rememberEntry: rememberEntry,
      );
      return;
    }
    // REST contract: {decision: 'allow'|'deny'|'always'} — 'always' carries the
    // remember semantics; updatedInput/message are WS-only fields.
    final decision = !allow
        ? 'deny'
        : rememberEntry != null
        ? 'always'
        : 'allow';
    await ref.read(notificationsRepositoryProvider).respondToApproval(
      requestId,
      {'decision': decision},
    );
  }

  void _onEvent(ServerEvent e) {
    // Defensive: the server WS rewrite currently swallows session_created
    // (turns it into a DB mapping update). If a deployment forwards it,
    // the frame carries the provider-captured id — only a pane that sent a
    // prompt adopts the replacement id.
    if (e.kind == 'session_created') {
      final newId = e.raw['newSessionId']?.toString();
      if (_sentAny && newId != null && newId != _sessionId) {
        _sentAny = false;
        state = state.copyWith(replacedWith: () => newId);
      }
      return;
    }
    if (e.sessionId != _sessionId) return;
    // `chat_subscribed` is the authoritative processing ack: it is how the
    // activity indicator comes back after a reload, when no live frame was
    // observed. It is not a transcript row, so handle it and stop here.
    if (e.kind == 'chat_subscribed') {
      _applySubscribeAck(e.raw);
      return;
    }
    // Remaining gateway/broadcast frames (presence, kanban…) are not
    // transcript rows — web `useChatMessages` only converts message kinds.
    if (e.isGateway || e.isBroadcast) return;
    final raw = e.raw;
    final provider = raw['provider']?.toString() ?? '';
    switch (e.kind) {
      case 'stream_delta':
        _buffer.add(_sessionId, raw['content']?.toString() ?? '', provider);
        return;
      case 'thought_delta':
        _buffer.add(
          _sessionId,
          raw['content']?.toString() ?? '',
          provider,
          'thinking',
        );
        return;
      case 'stream_replace':
        _buffer.flush(_sessionId, 'stream_delta', provider);
        _store.replaceStreaming(
          _sessionId,
          raw['content']?.toString() ?? '',
          provider,
        );
        return;
      case 'stream_end' || 'complete':
        _buffer.closeLiveRows(_sessionId, provider);
        _store.setStatus(_sessionId, 'done');
        state = state.copyWith(runStatus: () => 'done');
        _activity.markIdle(_sessionId);
        _maybeAutoRead(raw);
        break;
      case 'error':
        _buffer.closeLiveRows(_sessionId, provider);
        _store.setStatus(_sessionId, 'error');
        state = state.copyWith(runStatus: () => 'error');
        _activity.markIdle(_sessionId);
        break;
      case 'status':
        _store.setStatus(_sessionId, 'running');
        state = state.copyWith(runStatus: () => 'running');
        _activity.markProcessing(_sessionId);
        break;
      case 'permission_request':
        final requestId = raw['requestId']?.toString();
        if (requestId != null) {
          ref
              .read(pendingPermissionsProvider.notifier)
              .add(
                PendingPermission(
                  sessionId: _sessionId,
                  requestId: requestId,
                  toolName: raw['toolName']?.toString() ?? 'UnknownTool',
                  input: raw['input'] is Map
                      ? Map<String, dynamic>.from(raw['input'] as Map)
                      : const {},
                  context: raw['context'] is Map
                      ? Map<String, dynamic>.from(raw['context'] as Map)
                      : null,
                ),
              );
        }
        break;
      case 'permission_cancelled':
        ref
            .read(pendingPermissionsProvider.notifier)
            .remove(raw['requestId']?.toString());
        break;
    }
    // Plain `status` frames are control events (React renders only the
    // orchestrator-payload rows); everything else here is a transcript row.
    if (e.kind == 'status') {
      final orchKind = raw['context'] is Map
          ? (raw['context'] as Map)['orchestratorKind']
          : null;
      if (orchKind == null || orchKind == 'user') return;
    }
    _queueRow(SessionMessage.fromJson({...raw, 'sessionId': _sessionId}));
  }

  /// Auto-read hook: on the `complete` frame, speak the last assistant text
  /// when this session is armed (web `maybeSpeakCompletion`, deduped by the
  /// frame's per-run `seq`).
  void _maybeAutoRead(Map<String, dynamic> raw) {
    final seq = (raw['seq'] as num?)?.toInt();
    if (seq == null) return;
    final messages = _store.messages(_sessionId);
    for (var i = messages.length - 1; i >= 0; i--) {
      final m = messages[i];
      if (m.kind == 'text' && m.role == 'assistant') {
        final speech = ttsSpeechText(m.content ?? m.text ?? '');
        if (speech.isNotEmpty) {
          ref
              .read(ttsControllerProvider.notifier)
              .maybeSpeakCompletion(_sessionId, seq, speech);
        }
        return;
      }
    }
  }

  /// Coalesced store writes — a reconnect replays the whole run in one burst
  /// (thousands of frames), and one store notify + list rebuild per frame
  /// leaves the pane minutes behind the live tail.
  void _queueRow(SessionMessage msg) {
    _pendingRows.add(msg);
    _flushTimer ??= Timer(const Duration(milliseconds: 50), () {
      _flushTimer = null;
      final rows = List<SessionMessage>.of(_pendingRows);
      _pendingRows.clear();
      if (rows.isEmpty) return;
      _store.appendRealtimeBatch(_sessionId, rows);
    });
  }

  void _flushPendingRows() {
    _flushTimer?.cancel();
    _flushTimer = null;
    final rows = List<SessionMessage>.of(_pendingRows);
    _pendingRows.clear();
    if (rows.isNotEmpty) _store.appendRealtimeBatch(_sessionId, rows);
  }
}

/// Transcript identity is the session id alone; the project is resolved from
/// the session row (see [_TranscriptController._projectId]) and must not key
/// the provider, or a late-arriving projectId would spawn a second controller
/// and refetch the whole transcript.
final transcriptProvider = NotifierProvider.family<
  TranscriptController,
  TranscriptState,
  String
>(TranscriptController.new);
