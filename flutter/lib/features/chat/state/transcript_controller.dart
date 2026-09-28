import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/notifications/data/notifications_repository.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
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
  });

  final bool loading;
  final bool loadingOlder;
  final AppError? error;
  final AppError? olderError;
  final bool allLoaded;

  /// 'running' | 'done' | 'error' — derived from status/complete/error frames.
  final String? runStatus;

  TranscriptState copyWith({
    bool? loading,
    bool? loadingOlder,
    AppError? Function()? error,
    AppError? Function()? olderError,
    bool? allLoaded,
    String? Function()? runStatus,
  }) => TranscriptState(
    loading: loading ?? this.loading,
    loadingOlder: loadingOlder ?? this.loadingOlder,
    error: error != null ? error() : this.error,
    olderError: olderError != null ? olderError() : this.olderError,
    allLoaded: allLoaded ?? this.allLoaded,
    runStatus: runStatus != null ? runStatus() : this.runStatus,
  );
}

/// Per-session transcript controller (T13.1–13.5, 13.8):
/// initial REST page + tail-walk, WS subscribe + frame dispatch into
/// [SessionMessageStore], load-older pagination, send/abort passthrough.
class TranscriptController extends Notifier<TranscriptState> {
  TranscriptController(this._sessionId, {this.projectId});

  final String _sessionId;

  /// Project the session belongs to — needed to key the offline send queue
  /// (`ddagent_offline_queue_<projectId>`). Null = caller doesn't know it;
  /// offline sends then degrade to a dropped frame, same as before T13.
  final String? projectId;
  StreamSubscription<ServerEvent>? _eventsSub;
  StreamSubscription<WsState>? _statesSub;
  bool _initialLoaded = false;

  SessionMessageStore get _store =>
      ref.read(sessionMessageStoreProvider.notifier);
  ChatChannel get _channel => ref.read(chatChannelProvider);
  StreamDeltaBuffer get _buffer => ref.read(streamDeltaBufferProvider);

  @override
  TranscriptState build() {
    final channel = ref.watch(chatChannelProvider);
    channel.subscribe([_sessionId]);
    _eventsSub = channel.events.listen(_onEvent);
    _statesSub = channel.states.listen((s) {
      if (s == WsState.open) unawaited(_flushOffline());
    });
    ref.onDispose(() {
      channel.unsubscribe(_sessionId);
      unawaited(_eventsSub?.cancel());
      unawaited(_statesSub?.cancel());
    });
    if (!_initialLoaded) {
      _initialLoaded = true;
      Future(loadInitial);
    }
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
    final pid = projectId;
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
    final pid = projectId;
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
    if (e.sessionId != _sessionId) return;
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
        break;
      case 'error':
        _buffer.closeLiveRows(_sessionId, provider);
        _store.setStatus(_sessionId, 'error');
        state = state.copyWith(runStatus: () => 'error');
        break;
      case 'status':
        _store.setStatus(_sessionId, 'running');
        state = state.copyWith(runStatus: () => 'running');
        break;
    }
    _store.appendRealtime(
      _sessionId,
      SessionMessage.fromJson({...raw, 'sessionId': _sessionId}),
    );
  }
}

typedef TranscriptArg = ({String sessionId, String? projectId});

final transcriptProvider =
    NotifierProvider.family<
      TranscriptController,
      TranscriptState,
      TranscriptArg
    >((arg) => TranscriptController(arg.sessionId, projectId: arg.projectId));
