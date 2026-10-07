import 'dart:async';
import 'dart:math';

import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/state/message_merge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Per-session slice of the store.
class SessionSlot {
  List<SessionMessage> serverMessages = const [];
  List<SessionMessage> realtimeMessages = const [];
  List<SessionMessage>? _mergedCache;
  int total = 0;
  bool hasMore = false;
  int fetchedAt = 0;
  String? status;

  /// Lazy merge — recomputed on read only when inputs changed by reference.
  /// Frames for background sessions would otherwise cost a merge per mounted
  /// pane per delta.
  List<SessionMessage> get merged =>
      _mergedCache ??= computeMerged(serverMessages, realtimeMessages);
}

/// Normalized per-session message store (T43):
/// REST history (`serverMessages`) + live frames (`realtimeMessages`) merged
/// lazily; optimistic `local_*` echoes deduped against persisted turns;
/// cursor pagination via `hasMore`/`total`.
class SessionMessageStore extends Notifier<Map<String, SessionSlot>> {
  static const staleThresholdMs = 30 * 1000;

  @override
  Map<String, SessionSlot> build() => {};

  SessionSlot slot(String sessionId) =>
      state.putIfAbsent(sessionId, SessionSlot.new);

  void _notify() => state = {...state};

  List<SessionMessage> messages(String sessionId) =>
      state[sessionId]?.merged ?? const [];

  bool isStale(String sessionId) {
    final s = state[sessionId];
    return s == null ||
        DateTime.now().millisecondsSinceEpoch - s.fetchedAt > staleThresholdMs;
  }

  /// Apply a fetched latest page: splice over the cached tail by overlap.
  void applyLatestPage(
    String sessionId,
    List<SessionMessage> page, {
    required int total,
    required bool hasMore,
  }) {
    final s = slot(sessionId);
    final prevCount = s.serverMessages.length;
    final merged = mergeLatestServerPage(s.serverMessages, page);
    s.serverMessages = merged.messages;
    s.total = total;
    // AND with the previous boundary — once older pages were loaded, a tail
    // refresh must not resurrect hasMore (resolveLatestPagePagination).
    s.hasMore = prevCount == 0 ? hasMore : s.hasMore && hasMore;
    s.fetchedAt = DateTime.now().millisecondsSinceEpoch;
    s._mergedCache = null;
    _notify();
  }

  /// Wholesale replace of persisted rows — used by the `complete`-triggered
  /// tail refresh when the fetched window is authoritative (web
  /// `refreshLatestSlotFromServer`: a `!hasMore` page is the whole transcript
  /// and also clears rows the provider truncated).
  void replaceServerMessages(
    String sessionId,
    List<SessionMessage> messages, {
    required int total,
    required bool hasMore,
  }) {
    final s = slot(sessionId);
    s.serverMessages = messages;
    s.total = total;
    s.hasMore = hasMore;
    s.fetchedAt = DateTime.now().millisecondsSinceEpoch;
    s._mergedCache = null;
    _notify();
  }

  /// Prepend an older page (load-more cursor).
  void prependOlderPage(
    String sessionId,
    List<SessionMessage> older, {
    required bool hasMore,
  }) {
    final s = slot(sessionId);
    s.serverMessages = mergeOlderServerPage(s.serverMessages, older).messages;
    s.hasMore = hasMore;
    s._mergedCache = null;
    _notify();
  }

  /// Append one live frame — dedupe by id (replays) before storing.
  void appendRealtime(String sessionId, SessionMessage msg) {
    appendRealtimeBatch(sessionId, [msg]);
  }

  /// Tool rows are re-published under the same id as the call progresses
  /// (ACP `tool_call_update` snapshots, OpenCode part updates): the newer
  /// frame replaces the row in place. Every other kind is a replay.
  static bool _isSnapshotKind(SessionMessage msg) =>
      msg.kind == 'tool_result' || msg.kind == 'tool_use';

  void appendRealtimeBatch(String sessionId, List<SessionMessage> msgs) {
    final s = slot(sessionId);
    final seen = {for (final m in s.realtimeMessages) m.id};
    var list = s.realtimeMessages;
    var changed = false;
    for (final msg in msgs) {
      if (!seen.add(msg.id)) {
        if (!_isSnapshotKind(msg)) continue;
        final idx = list.indexWhere((m) => m.id == msg.id);
        if (idx < 0 || list[idx] == msg) continue;
        list = [...list]..[idx] = msg.copyWith(timestamp: list[idx].timestamp);
        changed = true;
        continue;
      }
      list = _upserted(list, msg);
      changed = true;
    }
    if (!changed) return;
    s.realtimeMessages = list;
    s._mergedCache = null;
    _notify();
  }

  /// Live orchestrator `status` frames re-publish one transcript row per
  /// patch with a fresh id each time — upsert by `orchestratorRowId` so a
  /// delegation renders as one card whose status updates in place instead of
  /// stacking stale snapshots. The first frame's timestamp is kept so the
  /// card doesn't re-sort to the tail on every patch.
  static List<SessionMessage> _upserted(
    List<SessionMessage> rows,
    SessionMessage msg,
  ) {
    final rowId = orchestratorRowId(msg);
    if (rowId == null) return [...rows, msg];
    final idx = rows.indexWhere((m) => orchestratorRowId(m) == rowId);
    if (idx < 0) return [...rows, msg];
    final list = [...rows];
    list[idx] = msg.copyWith(timestamp: rows[idx].timestamp);
    return list;
  }

  /// Patch realtime rows in place — used to stamp a permission decision onto
  /// the ask's transcript card so the answer stays visible after the request
  /// resolves (and dead asks stop rendering as interactive).
  void patchRealtime(
    String sessionId,
    bool Function(SessionMessage) test,
    SessionMessage Function(SessionMessage) update,
  ) {
    final s = state[sessionId];
    if (s == null) return;
    var changed = false;
    final list = [
      for (final m in s.realtimeMessages)
        if (test(m)) (changed = true, update(m)).$2 else m,
    ];
    if (!changed) return;
    s.realtimeMessages = list;
    s._mergedCache = null;
    _notify();
  }

  /// Optimistic echo for a sent message; removed once the persisted turn
  /// arrives (removeOptimisticUserEchoes).
  void appendLocalEcho(String sessionId, String text, String provider) {
    appendRealtime(
      sessionId,
      SessionMessage(
        id: 'local_${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(1 << 20)}',
        sessionId: sessionId,
        timestamp: DateTime.now().toIso8601String(),
        provider: provider,
        kind: 'text',
        role: 'user',
        content: text,
      ),
    );
  }

  /// Update the open live row (`__streaming_*` / `__thinking_*`) with the
  /// accumulated text — one row replaced per flush, not one row per delta.
  void updateStreaming(
    String sessionId,
    String accumulatedText,
    String provider, [
    String kind = 'stream_delta',
  ]) {
    final s = slot(sessionId);
    final id = streamingRowId(sessionId, kind);
    final idx = s.realtimeMessages.indexWhere((m) => m.id == id);
    final msg = SessionMessage(
      id: id,
      sessionId: sessionId,
      // Keep the row's creation timestamp so timestamp-sorted merges and
      // header boundaries don't jump on every delta.
      timestamp: idx >= 0
          ? s.realtimeMessages[idx].timestamp
          : DateTime.now().toIso8601String(),
      provider: provider,
      kind: kind,
      content: accumulatedText,
    );
    final list = [...s.realtimeMessages];
    if (idx >= 0) {
      list[idx] = msg;
    } else {
      list.add(msg);
    }
    s.realtimeMessages = list;
    s._mergedCache = null;
    _notify();
  }

  /// Replace the open live row with a canonical provider copy (corrects
  /// diverging streamed text in place).
  void replaceStreaming(String sessionId, String content, String provider) {
    final s = slot(sessionId);
    final id = streamingRowId(sessionId, 'stream_delta');
    final idx = s.realtimeMessages.indexWhere((m) => m.id == id);
    final msg = SessionMessage(
      id: id,
      sessionId: sessionId,
      timestamp: DateTime.now().toIso8601String(),
      provider: provider,
      kind: 'stream_delta',
      content: content,
    );
    final list = [...s.realtimeMessages];
    if (idx >= 0) {
      list[idx] = msg;
    } else {
      list.add(msg);
    }
    s.realtimeMessages = list;
    s._mergedCache = null;
    _notify();
  }

  /// Close a live row: unique id + stream_delta→assistant text so the next
  /// chunks start a fresh row.
  void finalizeStreaming(String sessionId, [String kind = 'stream_delta']) {
    final s = state[sessionId];
    if (s == null) return;
    final id = streamingRowId(sessionId, kind);
    final idx = s.realtimeMessages.indexWhere((m) => m.id == id);
    if (idx < 0) return;
    final stream = s.realtimeMessages[idx];
    final uniqueId =
        '${kind == 'thinking' ? 'thinking' : 'text'}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1 << 24).toRadixString(36)}';
    final list = [...s.realtimeMessages];
    list[idx] = kind == 'thinking'
        ? stream.copyWith(id: uniqueId)
        : stream.copyWith(id: uniqueId, kind: 'text', role: 'assistant');
    s.realtimeMessages = list;
    s._mergedCache = null;
    _notify();
  }

  /// Reclaim only rows in the fetched snapshot that now have persisted
  /// counterparts. A slow previous-run refresh must preserve newer live rows,
  /// including updates to the reusable streaming id and unpersisted Stop text.
  void reconcileRealtime(String sessionId, List<SessionMessage> snapshot) {
    final s = state[sessionId];
    if (s == null || s.serverMessages.isEmpty) return;
    final retained = computeMerged(
      s.serverMessages,
      snapshot,
    ).map((m) => m.id).toSet();
    final persistedIds = s.serverMessages.map((m) => m.id).toSet();
    final removed = snapshot
        .where(
          (m) =>
              !m.id.startsWith('__') &&
              (!retained.contains(m.id) || persistedIds.contains(m.id)),
        )
        .toSet();
    s.realtimeMessages = s.realtimeMessages
        .where((m) => !removed.contains(m))
        .toList();
    s._mergedCache = null;
    _notify();
  }

  /// Drop live rows once persisted history has caught up.
  void clearRealtime(String sessionId) {
    final s = state[sessionId];
    if (s == null || s.realtimeMessages.isEmpty) return;
    s.realtimeMessages = const [];
    s._mergedCache = null;
    _notify();
  }

  void setStatus(String sessionId, String status) {
    slot(sessionId).status = status;
    _notify();
  }

  void removeSession(String sessionId) {
    if (state.remove(sessionId) != null) _notify();
  }
}

final sessionMessageStoreProvider =
    NotifierProvider<SessionMessageStore, Map<String, SessionSlot>>(
      SessionMessageStore.new,
    );

/// Merged message list for one session — recomputes only when the slot's
/// inputs changed.
final sessionMessagesProvider = Provider.family<List<SessionMessage>, String>(
  (ref, sessionId) =>
      ref.watch(sessionMessageStoreProvider)[sessionId]?.merged ?? const [],
);

/// 60 ms delta buffer — batches stream_delta/thought_delta chunks into a
/// single store update per flush window (parity with the web client's
/// STREAM_FLUSH_INTERVAL_MS).
class StreamDeltaBuffer {
  StreamDeltaBuffer(this._store);

  static const flushInterval = Duration(milliseconds: 60);

  final SessionMessageStore _store;
  final _pending = <String, String>{};
  final _timers = <String, Timer>{};

  String _key(String sessionId, String kind) =>
      kind == 'thinking' ? '$sessionId::thought' : sessionId;

  /// Buffer one delta chunk; flushes at most once per 60 ms window.
  void add(
    String sessionId,
    String text,
    String provider, [
    String kind = 'stream_delta',
  ]) {
    final key = _key(sessionId, kind);
    _pending[key] = (_pending[key] ?? '') + text;
    _timers.putIfAbsent(
      key,
      () => Timer(flushInterval, () => flush(sessionId, kind, provider)),
    );
  }

  /// Timer path: push the *accumulated* text into the live row without
  /// clearing the buffer — deltas keep accumulating for the whole stream
  /// (parity with the web client's timer callback). The pending map is
  /// cleared only by [closeLiveRows].
  void flush(String sessionId, String kind, String provider) {
    final key = _key(sessionId, kind);
    _timers.remove(key)?.cancel();
    final text = _pending[key];
    if (text != null && text.isNotEmpty) {
      _store.updateStreaming(sessionId, text, provider, kind);
    }
  }

  /// A canonical replacement becomes the accumulator for subsequent deltas
  /// and completion; otherwise the next flush restores the superseded text.
  void replace(String sessionId, String text, String provider) {
    _timers.remove(sessionId)?.cancel();
    _pending[sessionId] = text;
    _store.replaceStreaming(sessionId, text, provider);
  }

  /// Flush + finalize both live rows (on stream_end/complete) — drops the
  /// accumulated buffers so the next run starts empty.
  void closeLiveRows(String sessionId, String provider) {
    for (final kind in const ['stream_delta', 'thinking']) {
      final key = _key(sessionId, kind);
      _timers.remove(key)?.cancel();
      final text = _pending.remove(key);
      if (text != null && text.isNotEmpty) {
        _store.updateStreaming(sessionId, text, provider, kind);
      }
    }
    _store
      ..finalizeStreaming(sessionId, 'stream_delta')
      ..finalizeStreaming(sessionId, 'thinking');
  }

  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
    _pending.clear();
  }
}

final streamDeltaBufferProvider = Provider<StreamDeltaBuffer>((ref) {
  final b = StreamDeltaBuffer(ref.watch(sessionMessageStoreProvider.notifier));
  ref.onDispose(b.dispose);
  return b;
});
