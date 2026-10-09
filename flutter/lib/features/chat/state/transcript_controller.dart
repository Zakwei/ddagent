import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/chat/state/pending_permissions.dart';
import 'package:ddagent_app/features/notifications/data/notifications_repository.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/message_merge.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/voice/state/tts_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// History page size for the initial load — matches the web client's
/// INITIAL_HISTORY_PAGE_SIZE (5 × 40); tool-heavy turns otherwise push the
/// last assistant reply out of a single page.
const initialHistoryPageSize = 200;
const initialHistoryMinText = 2;
const initialHistoryMaxExtraPages = 3;
const olderPageSize = 40;

/// Run status a `complete` frame settles to: `aborted` → stopped, a non-zero
/// `exitCode` → error, else done.
String runEndStatus(Map<String, dynamic> complete) {
  if (complete['aborted'] == true) return 'stopped';
  final exit = complete['exitCode'];
  return exit is num && exit != 0 ? 'error' : 'done';
}

class TranscriptState {
  const TranscriptState({
    this.loading = false,
    this.loadingOlder = false,
    this.error,
    this.olderError,
    this.allLoaded = false,
    this.runStatus,
    this.offlineCount = 0,
  });

  final bool loading;
  final bool loadingOlder;
  final AppError? error;
  final AppError? olderError;
  final bool allLoaded;

  /// 'running' | 'done' | 'stopped' | 'error' — derived from
  /// status/complete/error frames (`complete` carries `aborted`/`exitCode`).
  final String? runStatus;

  /// Messages sitting in the `ddagent_offline_queue_<project>` bucket for
  /// this session — drives the amber OfflineQueueCard (web parity).
  final int offlineCount;

  TranscriptState copyWith({
    bool? loading,
    bool? loadingOlder,
    AppError? Function()? error,
    AppError? Function()? olderError,
    bool? allLoaded,
    String? Function()? runStatus,
    int? offlineCount,
  }) => TranscriptState(
    loading: loading ?? this.loading,
    loadingOlder: loadingOlder ?? this.loadingOlder,
    error: error != null ? error() : this.error,
    olderError: olderError != null ? olderError() : this.olderError,
    allLoaded: allLoaded ?? this.allLoaded,
    runStatus: runStatus != null ? runStatus() : this.runStatus,
    offlineCount: offlineCount ?? this.offlineCount,
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
  String? get _projectId => ref.read(sessionDetailsProvider(_sessionId)).value?.projectId;
  StreamSubscription<ServerEvent>? _eventsSub;
  StreamSubscription<WsState>? _statesSub;
  bool _initialLoaded = false;
  String? _runId;

  /// Coalesced row writes (see [_queueRow]).
  final _pendingRows = <SessionMessage>[];
  Timer? _flushTimer;
  int _unsequencedRowId = 0;

  /// Options of this pane's last send — the error row's Retry reuses them.
  Map<String, dynamic>? _lastSendOptions;

  /// Decisions sent recently, kept so a FORBIDDEN_ROLE reply can put the ask
  /// back instead of leaving it stamped as decided.
  final _recentDecisions = <String, ({PendingPermission? pending, int at})>{};
  static const _decisionRejectWindowMs = 5000;

  /// Completers waiting for the current run to settle (see
  /// [answerQuestionWithText]).
  final _settleWaiters = <Completer<void>>[];

  SessionMessageStore get _store => ref.read(sessionMessageStoreProvider.notifier);
  ChatChannel get _channel => ref.read(chatChannelProvider);
  StreamDeltaBuffer get _buffer => ref.read(streamDeltaBufferProvider);
  SessionActivityController get _activity => ref.read(sessionActivityProvider.notifier);

  /// ChatChannel filters replies issued before a newer local send, so this
  /// acknowledgement can settle both the activity indicator and composer.
  void _applySubscribeAck(Map<String, dynamic> raw) {
    _syncPendingPermissions(raw['pendingPermissions']);
    // Authoritative running-task count — a stale one from before a reload or
    // a missed `background_tasks` frame must not linger.
    final background = raw['backgroundTasks'];
    if (background is num) {
      final count = background.toInt();
      final known = ref.read(backgroundTasksProvider)[_sessionId]?.tasks ?? const [];
      ref
          .read(backgroundTasksProvider.notifier)
          .set(_sessionId, count, count > 0 ? known : const []);
    }
    if (raw['isProcessing'] == true) {
      _activity.markProcessing(
        _sessionId,
        canInterrupt: true,
        startedAt: (raw['startedAt'] as num?)?.toInt(),
      );
      _markRunRunning();
      return;
    }
    // An idle ack must not rewrite how the last run ended (stopped/failed).
    final ended = state.runStatus;
    _settleRun(ended == null || ended == 'running' ? 'done' : ended);
    // Skip the tail refetch when nothing needs reconciling: right after a
    // fresh history load with no live frames it would rewrite the
    // just-rendered page (visible reload). Leftover live rows, a stale slot,
    // or a recently completed run (`runId` on the ack) still merit it.
    final slot = ref.read(sessionMessageStoreProvider)[_sessionId];
    final hasLiveRows = slot?.realtimeMessages.isNotEmpty ?? false;
    final fresh = slot != null && !_store.isStale(_sessionId);
    if (hasLiveRows || !fresh || raw['runId'] != null) {
      unawaited(_refreshLatestSafely());
    }
  }

  /// Rebuilds this session's answerable asks from the subscribe ack, which
  /// carries the server's authoritative pending set. A client that subscribed
  /// after the live `permission_request` frame — a freshly opened window, a
  /// reload, or a reconnected socket — otherwise sees the persisted ask as a
  /// read-only recap and can never deliver its answer. Runs before the
  /// `isProcessing` early-return because an agent blocked on a question is
  /// exactly the processing case that must still show the panel.
  void _syncPendingPermissions(dynamic raw) {
    if (raw is! List) return;
    final notifier = ref.read(pendingPermissionsProvider.notifier);
    notifier.removeForSession(_sessionId);
    for (final entry in raw) {
      if (entry is! Map) continue;
      final requestId = entry['requestId']?.toString();
      if (requestId == null || requestId.isEmpty) continue;
      notifier.add(
        PendingPermission(
          sessionId: entry['sessionId']?.toString() ?? _sessionId,
          requestId: requestId,
          toolName: entry['toolName']?.toString() ?? 'UnknownTool',
          input: entry['input'] is Map
              ? Map<String, dynamic>.from(entry['input'] as Map)
              : const <String, dynamic>{},
          context: entry['context'] is Map
              ? Map<String, dynamic>.from(entry['context'] as Map)
              : null,
        ),
      );
    }
  }

  void _settleRun([String status = 'done']) {
    _buffer.closeLiveRows(_sessionId, '');
    _store.setStatus(_sessionId, status);
    state = state.copyWith(runStatus: () => status);
    _activity.markIdle(_sessionId);
    _lastSentText = null;
    for (final waiter in _settleWaiters) {
      if (!waiter.isCompleted) waiter.complete();
    }
    _settleWaiters.clear();
  }

  Future<void> _refreshLatestSafely() async {
    try {
      await _refreshLatest();
    } on Object {
      // Keep the live transcript when persisted history is unavailable.
    }
  }

  /// Frames that mean a run is producing work for this session — re-arms the
  /// activity entry and the composer's running state. Terminal semantics stay
  /// with `complete` alone: `stream_end` is a message boundary providers emit
  /// mid-run (every tool call, every continuation round) and `error` rows are
  /// informational, so neither settles the run here (web parity).
  /// Run whose `complete` this pane has seen. Its process may still ask for
  /// permission afterwards (background work); such a late ask must not flip
  /// the pane back to running, since no second `complete` will follow.
  String? _completedRunId;

  void _markRunRunning() {
    _activity.markProcessing(_sessionId);
    // Both writes notify listeners — skip the redundant churn on frames that
    // arrive per token (stream_delta) once the run is already marked.
    if (ref.read(sessionMessageStoreProvider)[_sessionId]?.status != 'running') {
      _store.setStatus(_sessionId, 'running');
    }
    if (state.runStatus != 'running') {
      state = state.copyWith(runStatus: () => 'running');
    }
  }

  @override
  TranscriptState build() {
    final channel = ref.watch(chatChannelProvider);
    channel.subscribe([_sessionId]);
    _eventsSub = channel.events.listen(_onEvent);
    _statesSub = channel.states.listen((s) {
      if (s == WsState.open) {
        unawaited(_flushOffline());
      }
    });
    // The activity map is also cleared by the running-sessions poll and by
    // frames this pane never sees (a sessionless INTERNAL_ERROR on send) — a
    // run the server no longer reports must not keep the composer running.
    ref.listen(sessionActivityProvider.select((m) => m.containsKey(_sessionId)), (was, now) {
      if (was == true && !now && state.runStatus == 'running') {
        _settleRun();
        unawaited(_refreshLatestSafely());
      }
    });
    final background = ref.read(backgroundTasksProvider.notifier);
    ref.onDispose(() {
      _flushPendingRows();
      channel.unsubscribe(_sessionId);
      // A closed pane stops receiving `background_tasks`; its count would go
      // stale. The next subscribe ack restores it.
      Future.microtask(() {
        try {
          background.set(_sessionId, 0, const []);
        } on Object {
          // Container already gone.
        }
      });
      unawaited(_eventsSub?.cancel());
      unawaited(_statesSub?.cancel());
    });
    if (!_initialLoaded) {
      _initialLoaded = true;
      Future(loadInitial);
    }
    // Offline queue survives reloads — surface the badge once the session's
    // project id resolves (sessions may still be loading at build time).
    Future(_syncOfflineCount);
    ref.listen(sessionDetailsProvider(_sessionId), (_, _) {
      _syncOfflineCount();
    });
    return const TranscriptState(loading: true);
  }

  List<SessionMessage> get _serverMessages =>
      ref.read(sessionMessageStoreProvider)[_sessionId]?.serverMessages ?? const [];

  bool get _hasMore => ref.read(sessionMessageStoreProvider)[_sessionId]?.hasMore ?? false;

  int get _total => ref.read(sessionMessageStoreProvider)[_sessionId]?.total ?? 0;

  /// Serializes persisted-history writes — a `complete` tail refresh must not
  /// interleave with the initial tail-walk or a user `loadOlder` page splice
  /// (web `enqueueHistoryMutation`).
  Future<void> _historyOp = Future.value();

  Future<T> _withHistoryLock<T>(Future<T> Function() op) {
    final run = _historyOp.then((_) => op());
    _historyOp = run.then((_) {}, onError: (_) {});
    return run;
  }

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
      _historyRetry = 0;
      if (ref.mounted) state = state.copyWith(loading: false);
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(loading: false, error: () => e);
      _scheduleHistoryRetry();
    } on Object {
      if (ref.mounted) state = state.copyWith(loading: false);
      _scheduleHistoryRetry();
    }
  }

  /// A failed first load would otherwise leave a pane opened mid-run showing
  /// only the live replay — nothing refetches history until `complete`.
  static const _historyRetryDelays = [2, 5, 15, 30];
  int _historyRetry = 0;

  void _scheduleHistoryRetry() {
    if (_historyRetry >= _historyRetryDelays.length) return;
    final delay = Duration(seconds: _historyRetryDelays[_historyRetry++]);
    Future<void>.delayed(delay, () {
      if (ref.mounted && _serverMessages.isEmpty) unawaited(loadInitial());
    });
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

  Future<void> _fetchLatest() => _withHistoryLock(() async {
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
  });

  /// Load one older page (tail-offset = already-loaded row count).
  /// Returns false when nothing new was prepended.
  Future<bool> _fetchOlder() => _withHistoryLock(() async {
    final res = await ref
        .read(sessionsRepositoryProvider)
        .messages(_sessionId, limit: olderPageSize, offset: providerRowCount(_serverMessages));
    final msgs = _parsePage(res);
    _store.prependOlderPage(_sessionId, msgs, hasMore: res['hasMore'] == true);
    return msgs.isNotEmpty;
  });

  /// Web `refreshLatestSlotFromServer` — a bounded persisted-tail reconcile
  /// fired on `complete`. Replaces the cached rows wholesale when the latest
  /// page is the authoritative transcript (`!hasMore`) or nothing is cached;
  /// otherwise stitches by overlap, bridging backward when ids regenerated
  /// or the provider switched sources mid-turn (Devin DB ↔ DDAgent JSONL).
  /// Either way the persisted copy of the just-finished turn lands, which is
  /// what lets `removeOptimisticUserEchoes` reclaim any orphan `local_*` row.
  Future<void> _refreshLatest() => _withHistoryLock(() async {
    if (!ref.mounted) return;
    _flushPendingRows();
    final snapshot = List<SessionMessage>.of(_store.slot(_sessionId).realtimeMessages);
    await _refreshLatestLocked();
    if (ref.mounted) _store.reconcileRealtime(_sessionId, snapshot);
  });

  Future<void> _refreshLatestLocked() async {
    if (!ref.mounted) return;
    final repo = ref.read(sessionsRepositoryProvider);
    final previous = _serverMessages;
    final previousTotal = _total;
    final previousHasMore = _hasMore;
    final latestRes = await repo.messages(_sessionId, limit: sessionMessagesPageSize, offset: 0);
    if (!ref.mounted) return;
    final latestPage = _parsePage(latestRes);
    final latestTotal = (latestRes['total'] as num?)?.toInt() ?? latestPage.length;
    final latestHasMore = latestRes['hasMore'] == true;

    if (!latestHasMore || previous.isEmpty) {
      _store.replaceServerMessages(
        _sessionId,
        latestPage,
        total: latestTotal,
        hasMore: latestHasMore,
      );
      return;
    }

    var window = latestPage;
    var oldestHasMore = latestHasMore;
    var bridgedRows = 0;
    var reachedStart = false;
    var merged = mergeLatestServerPage(previous, window);
    while (merged.overlapLength == 0 && !hasReachedCachedTailTimeBoundary(previous, window)) {
      final request = planLatestPageBridge(
        previous,
        latestPage,
        previousTotal,
        latestTotal,
        bridgedRows,
      );
      if (request == null) break;
      final bridgeRes = await repo.messages(
        _sessionId,
        limit: request.limit,
        offset: request.offset,
      );
      if (!ref.mounted) return;
      final bridgeTotal = (bridgeRes['total'] as num?)?.toInt();
      if (bridgeTotal != latestTotal) return; // history shifted mid-flight
      final bridgePage = _parsePage(bridgeRes);
      if (bridgePage.isEmpty) break;
      final bridgeMerge = mergeOlderServerPage(window, bridgePage);
      if (bridgeMerge.overlapLength > 0 || !olderPagePrecedesCachedHistory(bridgePage, window)) {
        return; // window overlaps or outruns the cache — keep what we have
      }
      window = bridgeMerge.messages;
      oldestHasMore = bridgeRes['hasMore'] == true;
      bridgedRows += providerRowCount(bridgePage);
      merged = mergeLatestServerPage(previous, window);
      if (!oldestHasMore) {
        reachedStart = true;
        break;
      }
    }

    if (reachedStart) {
      // The fetched window covers the whole transcript but under regenerated
      // ids — adopt the cached ids so tiles keep identity and mounted state.
      _store.replaceServerMessages(
        _sessionId,
        restampRewrittenIds(window, previous),
        total: latestTotal,
        hasMore: false,
      );
    } else if (merged.overlapLength > 0) {
      _store.replaceServerMessages(
        _sessionId,
        merged.messages,
        total: latestTotal,
        hasMore: resolveLatestPagePagination(
          previousMessageCount: previous.length,
          mergedMessageCount: merged.messages.length,
          previousHasMore: previousHasMore,
          oldestFetchedPageHasMore: oldestHasMore,
        ).hasMore,
      );
    }
    // Zero overlap without reaching the start: the cached tail disagrees with
    // the server — keep it rather than stitching on an unrelated window.
  }

  List<SessionMessage> _parsePage(Map<String, dynamic> res) {
    final list = res['messages'] as List? ?? const [];
    return [
      for (final m in list)
        SessionMessage.fromJson({...m as Map, 'sessionId': _sessionId}.cast<String, dynamic>()),
    ];
  }

  Future<void> loadOlder() async {
    if (state.loadingOlder || state.allLoaded || !_hasMore) return;
    state = state.copyWith(loadingOlder: true, olderError: () => null);
    try {
      final fetched = await _fetchOlder();
      if (ref.mounted) {
        state = state.copyWith(loadingOlder: false, allLoaded: !fetched && !_hasMore);
      }
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loadingOlder: false, olderError: () => e);
      }
    }
  }

  /// Web `loadAllMessages` — page backwards until `hasMore` is gone.
  /// Safety cap: 50 pages × 40 rows; bigger histories still stop cleanly.
  Future<void> loadAll() async {
    if (state.loadingOlder || state.allLoaded || !_hasMore) return;
    state = state.copyWith(loadingOlder: true, olderError: () => null);
    try {
      var pages = 0;
      while (ref.mounted && _hasMore && pages < 50) {
        if (!await _fetchOlder()) break;
        pages++;
      }
      if (ref.mounted) {
        state = state.copyWith(loadingOlder: false, allLoaded: !_hasMore);
      }
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loadingOlder: false, olderError: () => e);
      }
    }
  }

  /// An identical re-send inside this window is a double-fire artifact, not
  /// a second turn — on web a late DOM editing delta can resurrect the
  /// cleared composer input so the next Enter repeats the same text, and a
  /// held Enter key repeats the intent. One send = one optimistic row + one
  /// `chat.send` frame (the persisted echo still reconciles the first).
  static const duplicateSendWindowMs = 1500;
  String? _lastSentText;
  int _lastSentAt = 0;

  void send(String text, {Map<String, dynamic>? options}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (text == _lastSentText && now - _lastSentAt < duplicateSendWindowMs) {
      return;
    }
    _lastSentText = text;
    _lastSentAt = now;
    _lastSendOptions = options;
    // Optimistic: show the activity indicator immediately, before the server's
    // `status` frame lands (web `onSessionProcessing` on send).
    _markRunRunning();
    final provider =
        ref.read(sessionMessageStoreProvider)[_sessionId]?.merged.lastOrNull?.provider ?? '';
    try {
      _channel.sendMessage(_sessionId, text, options: options);
    } on StateError {
      // Socket closed (reconnect/offline) — persist for the next open, parity
      // with the web client's ddagent_offline_queue_* bucket.
      _enqueueOffline(text, options);
    }
    final attachments = options?['attachments'] is List
        ? [
            for (final a in options!['attachments'] as List)
              if (a is Map) Map<String, dynamic>.from(a),
          ]
        : const <Map<String, dynamic>>[];
    _store.appendLocalEcho(_sessionId, text, provider, attachments: attachments);
  }

  /// Error-row Retry: resend this session's last user message, with this
  /// pane's last send options (model, effort, mode, attachments) when known.
  bool retryLastUserMessage() {
    final last = _store
        .messages(_sessionId)
        .where((m) => m.isUserText && (m.content ?? '').trim().isNotEmpty)
        .lastOrNull;
    if (last == null) return false;
    _lastSentText = null; // a deliberate retry is not a double-fire
    send(last.content!, options: _lastSendOptions);
    return true;
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
      }).then((_) => _syncOfflineCount()),
    );
  }

  /// This session's entries inside the project bucket.
  int _offlineCountFor(String projectId) =>
      ChatStorage.readOfflineQueue(projectId).where((e) => e['sessionId'] == _sessionId).length;

  void _syncOfflineCount() {
    // Deferred `Future(_syncOfflineCount)` may outlive the provider —
    // `ref.read` after dispose throws, so gate on mounted before reading.
    if (!ref.mounted) return;
    final pid = _projectId;
    if (pid == null) return;
    final n = _offlineCountFor(pid);
    if (n != state.offlineCount) {
      state = state.copyWith(offlineCount: n);
    }
  }

  /// OfflineQueueCard 'Cancel' — drop this session's queued offline sends.
  Future<void> clearOfflineQueue() async {
    final pid = _projectId;
    if (pid == null) return;
    final q = ChatStorage.readOfflineQueue(pid)..removeWhere((e) => e['sessionId'] == _sessionId);
    await ChatStorage.writeOfflineQueue(pid, q);
    _syncOfflineCount();
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
    _syncOfflineCount();
  }

  void abort() => _channel.abort(_sessionId);

  /// ACP providers (command-code / Devin) can only echo a picked option id, so
  /// a typed question answer cannot ride the ACP reply. End the blocked turn
  /// and send the text as the next turn, so the answer is applied right away
  /// instead of after the agent finishes guessing.
  ///
  /// Sequential on purpose: sending while the aborted run is still live races
  /// RUN_IN_PROGRESS (the server queues the text, so it showed both as an
  /// optimistic bubble and a queued card) and a send clears an abort still
  /// waiting for its runId.
  ///
  /// [abortRun] false (Command Code): the server's `cancelled` reply already
  /// ends the turn, so only wait for its `complete`.
  Future<void> answerQuestionWithText(String text, {bool abortRun = true}) async {
    final value = text.trim();
    if (value.isEmpty) return;
    if (state.runStatus == 'running' || _activity.isProcessing(_sessionId)) {
      final settled = Completer<void>();
      _settleWaiters.add(settled);
      if (abortRun) abort();
      // shortcut: a run that never settles (ABORT_FAILED) still gets the text
      // after 15 s — the server queues it behind the live run.
      await settled.future.timeout(const Duration(seconds: 15), onTimeout: () {});
      if (!ref.mounted) return;
    }
    send(value);
  }

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
    final pending = ref.read(pendingPermissionsProvider)[requestId];
    final row = _store
        .messages(_sessionId)
        .where((m) => m.kind == 'permission_request' && m.requestId == requestId)
        .firstOrNull;
    _recentDecisions[requestId] = (pending: pending, at: DateTime.now().millisecondsSinceEpoch);
    final planMode = planExitModeFor(
      pending?.toolName ?? row?.toolName ?? '',
      pending?.input ??
          (row?.toolInput is Map ? Map<String, dynamic>.from(row!.toolInput as Map) : const {}),
      allow: allow,
      updatedInput: updatedInput,
    );
    if (planMode != null) ref.read(planExitProvider(_sessionId).notifier).request(planMode);
    ref.read(pendingPermissionsProvider.notifier).remove(requestId);
    final answers = updatedInput is Map ? updatedInput['answers'] : null;
    _store.patchRealtime(
      _sessionId,
      (m) => m.kind == 'permission_request' && m.requestId == requestId,
      (m) {
        final input = m.toolInput is Map
            ? Map<String, dynamic>.from(m.toolInput as Map)
            : <String, dynamic>{};
        input['resolved'] = true;
        if (answers is Map) input['answers'] = Map<String, dynamic>.from(answers);
        return m.copyWith(toolInput: input);
      },
    );
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
    // REST contract: {decision: 'allow'|'deny'|'always'} plus the same
    // optional fields the WS frame carries — without them a question answered
    // while the socket reconnects reached the agent with no answers.
    final decision = !allow
        ? 'deny'
        : rememberEntry != null
        ? 'always'
        : 'allow';
    await ref.read(notificationsRepositoryProvider).respondToApproval(requestId, {
      'decision': decision,
      if (updatedInput is Map) 'updatedInput': updatedInput,
      'message': ?message,
      if (rememberEntry is String) 'rememberEntry': rememberEntry,
    });
  }

  void _onEvent(ServerEvent e) {
    // Answers a permission response this pane sent; often carries no sessionId.
    if (e.kind == 'protocol_error' && e.raw['code'] == 'FORBIDDEN_ROLE') {
      _restoreRejectedDecisions(e.raw['requestId']?.toString());
    }
    if (e.sessionId != _sessionId) return;
    final raw = e.raw;
    // `chat_subscribed` is the authoritative processing ack: it is how the
    // activity indicator comes back after a reload, when no live frame was
    // observed. It is not a transcript row, so handle it and stop here.
    if (e.kind == 'chat_subscribed') {
      _applySubscribeAck(raw);
      return;
    }
    if (e.kind == 'protocol_error') {
      final code = raw['code']?.toString();
      // The run outlives these: an interrupt the provider refused, an abort
      // aimed at an older run, or a role-gated frame. Say so, keep running.
      if (protocolErrorKeepsRun(raw) || protocolErrorIsNotice(raw)) {
        AppToast.global(raw['error']?.toString() ?? t.chat.transcript.requestFailed, isError: true);
        return;
      }
      // A rejected send/run settles the run immediately — no `complete`
      // follows. `NO_ACTIVE_RUN` is the benign abort-vs-complete race and
      // deserves no error row (web parity); either way the activity entry
      // must go.
      _settleRun(code == 'NO_ACTIVE_RUN' ? 'done' : 'error');
      if (code != 'NO_ACTIVE_RUN') {
        _queueRow(
          SessionMessage.fromJson({
            ...raw,
            'id': 'protocol_error_${DateTime.now().millisecondsSinceEpoch}',
            'sessionId': _sessionId,
            'kind': 'error',
            'content': raw['error']?.toString() ?? t.chat.transcript.requestFailed,
            'timestamp': DateTime.now().toIso8601String(),
          }),
        );
      }
      return;
    }
    // A transcript written outside this app (a CLI in tmux, another tool)
    // reaches the pane only as the file watcher's upsert — pull the new tail.
    // Own runs stream live and reconcile on `complete`, so skip them.
    if (e.kind == 'session_upserted') {
      if (state.runStatus != 'running') unawaited(_refreshLatestSafely());
      return;
    }
    // Remaining gateway/broadcast frames (presence, kanban…) are not
    // transcript rows — web `useChatMessages` only converts message kinds.
    if (e.isGateway || e.isBroadcast) return;
    // Work outliving the turn (Claude subagents, background shells) — reported
    // after the turn's `complete` too, so it must not touch run/row state.
    if (e.kind == 'background_tasks') {
      final tasks = raw['tasks'] is List
          ? [
              for (final task in raw['tasks'] as List)
                if (task is Map) BackgroundTask.fromJson(Map<String, dynamic>.from(task)),
            ]
          : const <BackgroundTask>[];
      ref
          .read(backgroundTasksProvider.notifier)
          .set(_sessionId, (raw['count'] as num?)?.toInt() ?? tasks.length, tasks);
      return;
    }
    final provider = raw['provider']?.toString() ?? '';
    if (e.runId != null && e.runId != _runId) {
      _buffer.closeLiveRows(_sessionId, provider);
      _runId = e.runId;
    }
    switch (e.kind) {
      case 'stream_delta':
        _markRunRunning();
        _buffer.add(_sessionId, raw['content']?.toString() ?? '', provider);
        return;
      case 'thought_delta':
        _markRunRunning();
        _buffer.add(_sessionId, raw['content']?.toString() ?? '', provider, 'thinking');
        return;
      case 'stream_replace':
        _markRunRunning();
        _buffer.replace(_sessionId, raw['content']?.toString() ?? '', provider);
        return;
      case 'stream_end':
        // Row boundary, NOT a terminal event: providers emit one per message
        // (before every tool call, between continuation rounds). Only the
        // live row closes — the run keeps streaming.
        _buffer.closeLiveRows(_sessionId, provider);
        return;
      case 'complete':
        _completedRunId = e.runId;
        _buffer.closeLiveRows(_sessionId, provider);
        _settleRun(runEndStatus(raw));
        // Asks and background work can outlive the turn (Claude background
        // subagents), so neither is expired here — re-subscribe for the
        // server's authoritative pending set and task count instead.
        if ((ref.read(backgroundTasksProvider)[_sessionId]?.count ?? 0) > 0 ||
            ref.read(pendingPermissionsProvider).values.any((p) => p.sessionId == _sessionId)) {
          _channel.subscribe([_sessionId]);
        }
        _maybeAutoRead(raw);
        // Web `requestLatestMessages`: once the turn is persisted, pull the
        // latest page so the server's copy replaces the realtime echo and
        // reclaims any orphan optimistic rows.
        unawaited(_refreshLatestSafely());
        break;
      case 'error':
        _buffer.closeLiveRows(_sessionId, provider);
        _store.setStatus(_sessionId, 'error');
        // Mid-run stderr/tool errors are informational — `complete` is the
        // only terminal frame, so a live run keeps its running state (and the
        // activity pill) instead of flickering idle on every error row.
        if (!_activity.isProcessing(_sessionId)) {
          state = state.copyWith(runStatus: () => 'error');
        }
        break;
      case 'status':
        // Notices are transcript lines, and may trail the run's `complete`.
        if (raw['notice'] != true) _markRunRunning();
        break;
      case 'tool_use' || 'tool_result':
        _markRunRunning();
        break;
      case 'permission_request':
        if (e.runId == null || e.runId != _completedRunId) _markRunRunning();
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
        final requestId = raw['requestId']?.toString();
        ref.read(pendingPermissionsProvider.notifier).remove(requestId);
        // A 'resolved' cancel carries the picked answers, so a window that did
        // not answer still shows them instead of falling back to "Skipped".
        final cancelledAnswers = raw['answers'] is Map
            ? Map<String, dynamic>.from(raw['answers'] as Map)
            : const <String, dynamic>{};
        // Resolved elsewhere (another client, auto-approval, dead process) —
        // stamp the card so it stops offering a decision that no longer exists.
        if (requestId != null) {
          _store.patchRealtime(
            _sessionId,
            (m) => m.kind == 'permission_request' && m.requestId == requestId,
            (m) {
              final input = m.toolInput is Map
                  ? Map<String, dynamic>.from(m.toolInput as Map)
                  : <String, dynamic>{};
              input['resolved'] = true;
              if (cancelledAnswers.isNotEmpty) input['answers'] = cancelledAnswers;
              // Why it closed when nobody answered it here (timeout, stop,
              // auto-approval) — the recap must not claim it was "Decided".
              final reason = raw['reason']?.toString();
              if (reason != null && reason != 'resolved') input['cancelReason'] = reason;
              return m.copyWith(toolInput: input);
            },
          );
        }
        break;
    }
    // Plain `status` frames are control events (React renders only the
    // orchestrator-payload rows); everything else here is a transcript row.
    if (e.kind == 'status' && raw['notice'] != true) {
      final orchKind = raw['context'] is Map ? (raw['context'] as Map)['orchestratorKind'] : null;
      if (orchKind == null || orchKind == 'user') return;
    }
    _queueRow(SessionMessage.fromJson({...raw, 'sessionId': _sessionId}));
  }

  /// FORBIDDEN_ROLE answered a permission response: the server never applied
  /// it, so put the ask back instead of showing it as decided. Without a
  /// requestId on the error, the decisions sent in the last few seconds are
  /// the ones it can refer to.
  void _restoreRejectedDecisions(String? requestId) {
    final now = DateTime.now().millisecondsSinceEpoch;
    _recentDecisions.removeWhere((_, d) => now - d.at > _decisionRejectWindowMs);
    // The server echoes the rejected permission's requestId; a FORBIDDEN_ROLE
    // without one answered some other frame and must not undo accepted answers.
    if (requestId == null) return;
    for (final id in [if (_recentDecisions.containsKey(requestId)) requestId]) {
      final pending = _recentDecisions.remove(id)?.pending;
      if (pending != null) ref.read(pendingPermissionsProvider.notifier).add(pending);
      _store.patchRealtime(_sessionId, (m) => m.kind == 'permission_request' && m.requestId == id, (
        m,
      ) {
        final input = m.toolInput is Map
            ? Map<String, dynamic>.from(m.toolInput as Map)
            : <String, dynamic>{};
        input
          ..remove('resolved')
          ..remove('answers');
        return m.copyWith(toolInput: input);
      });
    }
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
          ref.read(ttsControllerProvider.notifier).maybeSpeakCompletion(_sessionId, seq, speech);
        }
        return;
      }
    }
  }

  /// Coalesced store writes — a reconnect replays the whole run in one burst
  /// (thousands of frames), and one store notify + list rebuild per frame
  /// leaves the pane minutes behind the live tail.
  void _queueRow(SessionMessage msg) {
    // Live status frames can omit the persisted row id. The store dedupes by
    // id, so leaving it empty would discard every update after the first.
    // Preserve explicit ids; sequenced events have a stable replay identity.
    if (msg.id.isEmpty) {
      final identity = msg.runId != null && msg.seq != null
          ? '${Uri.encodeComponent(msg.runId!)}_${msg.seq}'
          : 'local_${DateTime.now().microsecondsSinceEpoch}_${++_unsequencedRowId}';
      msg = msg.copyWith(id: 'realtime_${Uri.encodeComponent(_sessionId)}_$identity');
    }
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
final transcriptProvider = NotifierProvider.family<TranscriptController, TranscriptState, String>(
  TranscriptController.new,
);
