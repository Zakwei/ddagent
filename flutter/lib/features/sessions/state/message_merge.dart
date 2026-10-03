import 'dart:convert';

import 'package:ddagent_app/features/sessions/data/session_message.dart';

/// Pure merge/dedupe/pagination helpers — port of
/// `src/stores/sessionMessageReconciliation.ts` + `sessionMessagePagination.ts`
/// + the merge half of `useSessionStore.ts`.

const localUserDedupeWindowMs = 5 * 60 * 1000;
const localUserDedupeClockSkewMs = 10 * 1000;
const localAttachmentOnlyDedupeWindowMs = 30 * 1000;
const realtimeUserDedupeWindowMs = 3000;

const sessionMessagesPageSize = 40;
const initialHistoryMinTextMessages = 2;
const initialHistoryMaxExtraPages = 3;
const initialHistoryPageSize = sessionMessagesPageSize * 5;

int? _time(SessionMessage m) {
  final t = DateTime.tryParse(m.timestamp);
  return t?.millisecondsSinceEpoch;
}

String _serialized(dynamic v) {
  if (v == null) return '';
  try {
    return jsonEncode(v);
  } on Object {
    return v.toString();
  }
}

/// Two rows are the same persisted transcript row when ids match, or — for
/// providers that regenerate ids per read (Codex) — all stable transcript
/// fields agree. Enrichment like toolResult is deliberately excluded.
bool samePersistedRow(SessionMessage a, SessionMessage b) {
  if (a.id == b.id) return true;
  if (a.provider != b.provider ||
      a.kind != b.kind ||
      a.timestamp != b.timestamp ||
      a.role != b.role) {
    return false;
  }
  if (a.toolId != null || b.toolId != null) return a.toolId == b.toolId;
  if (a.rowid != null || b.rowid != null) return a.rowid == b.rowid;
  if (a.sequence != null || b.sequence != null) {
    return a.sequence == b.sequence;
  }
  return (a.content ?? '') == (b.content ?? '') &&
      (a.text ?? '') == (b.text ?? '') &&
      (a.toolName ?? '') == (b.toolName ?? '') &&
      (a.commandName ?? '') == (b.commandName ?? '') &&
      (a.parentToolUseId ?? '') == (b.parentToolUseId ?? '') &&
      _serialized(a.toolInput) == _serialized(b.toolInput);
}

// ─── User-turn fingerprint dedupe ────────────────────────────────────────────

typedef _Fingerprint = ({String text, int imageCount, int fileCount});

/// First-turn injections the server prepends to the outbound prompt
/// (`chat-dispatch` effectiveContent): `<unified-rules>…</unified-rules>` and
/// an optional shared-context block. The persisted/echoed user turn carries
/// them, the local optimistic echo holds only the typed text — fingerprints
/// used to claim that echo must compare user text alone, otherwise the orphan
/// grabs the next same-text candidate and leaves a permanent duplicate.
final _injectedPrefixPatterns = [
  RegExp(r'^<unified-rules>[\s\S]*?</unified-rules>\s*'),
  RegExp(
    r'^The following shared context is maintained by the ddagent workspace[\s\S]*?\n\n---\n\n',
  ),
];

String _stripInjectedPrefix(String text) {
  var t = text;
  for (final pattern in _injectedPrefixPatterns) {
    t = t.replaceFirst(pattern, '');
  }
  return t.trim();
}

_Fingerprint? _fingerprint(SessionMessage m, {bool stripInjectedPrefix = false}) {
  if (!m.isUserText) return null;
  var text = (m.content ?? '').trim();
  if (stripInjectedPrefix) text = _stripInjectedPrefix(text);
  final images = m.images?.length ?? 0;
  final files = m.files?.length ?? 0;
  if (text.isEmpty && images == 0 && files == 0) return null;
  return (text: text, imageCount: images, fileCount: files);
}

bool _fingerprintsMatch(_Fingerprint local, _Fingerprint server) {
  if (local.text != server.text) return false;
  if (local.text.isNotEmpty) return true;
  return local.imageCount == server.imageCount && local.fileCount == server.fileCount;
}

class _ServerRow {
  _ServerRow(this.message, {bool stripPrefix = false})
    : fingerprint = _fingerprint(message, stripInjectedPrefix: stripPrefix),
      time = _time(message);
  final SessionMessage message;
  final _Fingerprint? fingerprint;
  final int? time;
}

/// Local optimistic `local_*` row → matching persisted/echoed server row.
/// Claims are per candidate *instance*, not per id: a persisted row and its
/// realtime echo share the id but are distinct rows, and each can absorb one
/// orphan local echo.
_ServerRow? _findServerEchoForLocal(
  SessionMessage local,
  List<_ServerRow> rows,
  Set<_ServerRow> claimed, {
  bool stripInjectedPrefix = false,
}) {
  final fp = _fingerprint(local, stripInjectedPrefix: stripInjectedPrefix);
  final lt = _time(local);
  if (fp == null || lt == null) return null;
  final window = fp.text.isNotEmpty ? localUserDedupeWindowMs : localAttachmentOnlyDedupeWindowMs;
  _ServerRow? best;
  var bestDiff = 1 << 62;
  for (final row in rows) {
    if (claimed.contains(row)) continue;
    final sfp = row.fingerprint;
    if (sfp == null || !_fingerprintsMatch(fp, sfp)) continue;
    final st = row.time;
    if (st == null || st < lt - localUserDedupeClockSkewMs || st - lt > window) {
      continue;
    }
    final diff = (st - lt).abs();
    if (diff < bestDiff) {
      best = row;
      bestDiff = diff;
    }
  }
  return best;
}

/// Drops local `local_*` echoes once the persisted turn exists server-side.
List<SessionMessage> removeOptimisticUserEchoes(
  List<SessionMessage> server,
  List<SessionMessage> realtime,
) {
  final claimed = <_ServerRow>{};
  final rows = [for (final m in server) _ServerRow(m, stripPrefix: true)];
  return realtime.where((m) {
    if (!m.isLocalEcho) return true;
    final echo = _findServerEchoForLocal(m, rows, claimed, stripInjectedPrefix: true);
    if (echo == null) return true;
    claimed.add(echo);
    return false;
  }).toList();
}

/// Drops realtime user rows that duplicate a persisted row within 3 s
/// (history row delivered via both WS and REST page refresh).
List<SessionMessage> removeRealtimeUserDuplicateEchoes(
  List<SessionMessage> server,
  List<SessionMessage> realtime,
) {
  final claimed = <_ServerRow>{};
  final rows = [for (final m in server) _ServerRow(m)];
  return realtime.where((m) {
    if (m.isLocalEcho || !m.isUserText) return true;
    final fp = _fingerprint(m);
    final mt = _time(m);
    if (fp == null || mt == null) return true;
    _ServerRow? best;
    var bestDiff = 1 << 62;
    for (final row in rows) {
      if (claimed.contains(row)) continue;
      final sfp = row.fingerprint;
      if (sfp == null || !_fingerprintsMatch(fp, sfp)) continue;
      final st = row.time;
      if (st == null) continue;
      final diff = (st - mt).abs();
      if (diff <= realtimeUserDedupeWindowMs && diff < bestDiff) {
        best = row;
        bestDiff = diff;
      }
    }
    if (best == null) return true;
    claimed.add(best);
    return false;
  }).toList();
}

// ─── Server echo index (content-based dedupe) ────────────────────────────────

class _EchoIndex {
  final assistantTexts = <String>{};
  final thinkingTexts = <String>{};
  final toolUseIds = <String>{};
  final orchestratorContexts = <String>{};
  final orchestratorRowIds = <int>{};
}

/// Stable orchestrator transcript row identity. The server re-publishes one
/// persisted row as a live `status` frame on every patch (running → done,
/// lastEvent previews), minting a fresh frame id each time — the row id in
/// `context.orchestratorRowId` is the only key that survives across those
/// frames. Persisted rows carry the same field; `orch-<id>` ids cover pages
/// cached before the field existed.
int? orchestratorRowId(SessionMessage m) {
  if (m.kind != 'status') return null;
  final v = m.context?['orchestratorRowId'];
  if (v is num) return v.toInt();
  final match = RegExp(r'^orch-(\d+)$').firstMatch(m.id);
  return match == null ? null : int.tryParse(match.group(1)!);
}

/// Fingerprint for `kind: 'status'` rows carrying an orchestrator payload —
/// persisted row and live frame share `context = {orchestratorKind, …}`, so
/// serialization matches across the id gap.
String? _orchestratorFingerprint(SessionMessage m) {
  if (m.kind != 'status' || m.context == null) return null;
  final kind = m.context!['orchestratorKind'];
  if (kind is! String || kind.isEmpty) return null;
  return _serialized(m.context);
}

_EchoIndex _echoIndex(List<SessionMessage> server) {
  final idx = _EchoIndex();
  for (final m in server) {
    final text = (m.content ?? '').trim();
    if (m.kind == 'text' && m.role == 'assistant' && text.isNotEmpty) {
      idx.assistantTexts.add(text);
    } else if (m.kind == 'thinking' && text.isNotEmpty) {
      idx.thinkingTexts.add(text);
    }
    if (m.kind == 'tool_use' && m.toolId != null) {
      idx.toolUseIds.add(m.toolId!);
    }
    final fp = _orchestratorFingerprint(m);
    if (fp != null) idx.orchestratorContexts.add(fp);
    final rid = orchestratorRowId(m);
    if (rid != null) idx.orchestratorRowIds.add(rid);
  }
  return idx;
}

/// Adjacent identical assistant rows collapse — stream_delta → text when the
/// persisted copy lands right behind the finalized stream row, and
/// text+text for provider echoes. Adjacent-only: repeats far apart are real.
List<SessionMessage> dedupeAdjacentAssistantEchoes(List<SessionMessage> msgs) {
  final out = <SessionMessage>[];
  for (final m in msgs) {
    final prev = out.isEmpty ? null : out.last;
    if (prev != null) {
      final ms = (m.content ?? '').trim();
      if (prev.kind == 'stream_delta' &&
          m.kind == 'text' &&
          m.role == 'assistant' &&
          ms.isNotEmpty &&
          ms == (prev.content ?? '').trim()) {
        out[out.length - 1] = m;
        continue;
      }
      if (prev.kind == 'text' &&
          m.kind == 'text' &&
          prev.role == 'assistant' &&
          m.role == 'assistant' &&
          ms.isNotEmpty &&
          ms == (prev.content ?? '').trim()) {
        continue;
      }
    }
    out.add(m);
  }
  return out;
}

String streamingRowId(String sessionId, String kind) =>
    kind == 'thinking' ? '__thinking_$sessionId' : '__streaming_$sessionId';

/// Fold each `tool_result` row into its `tool_use` card by toolId and drop
/// the standalone result (web `useChatMessages` `toolResultMap` attachment).
/// Orphan results (no matching tool_use) stay as rows — errors render there.
List<SessionMessage> attachToolResults(List<SessionMessage> messages) {
  final results = <String, SessionMessage>{};
  for (final m in messages) {
    if (m.kind == 'tool_result' && m.toolId != null) results[m.toolId!] = m;
  }
  if (results.isEmpty) return messages;
  final toolUseIds = <String>{
    for (final m in messages)
      if (m.kind == 'tool_use' && m.toolId != null) m.toolId!,
  };
  final out = <SessionMessage>[];
  for (final m in messages) {
    if (m.kind == 'tool_result' && m.toolId != null && toolUseIds.contains(m.toolId)) {
      continue;
    }
    final res = m.kind == 'tool_use' && m.toolResult == null && m.toolId != null
        ? results[m.toolId]
        : null;
    out.add(
      res == null
          ? m
          : m.copyWith(
              toolResult: {
                'content': res.content ?? res.text ?? '',
                'isError': res.isError,
                if (res.exitCode != null) 'exitCode': res.exitCode,
              },
            ),
    );
  }
  return out;
}

/// Merge persisted history with live frames (T43.4):
/// 1. local echoes claimed by server rows
/// 2. realtime user duplicates collapsed
/// 3. realtime rows already persisted dropped by id/content
/// 4. remainder interleaved by timestamp
/// 5. tool results attached to their tool_use cards
List<SessionMessage> computeMerged(List<SessionMessage> server, List<SessionMessage> realtime) {
  List<SessionMessage> userEchoCandidates() => [
    ...server,
    ...realtime.where((m) => !m.isLocalEcho && m.isUserText),
  ];

  if (realtime.isEmpty) {
    return attachToolResults(dedupeAdjacentAssistantEchoes(server));
  }
  final reconciled = removeOptimisticUserEchoes(userEchoCandidates(), realtime);
  final deduped = removeRealtimeUserDuplicateEchoes(server, reconciled);

  // Live re-publications of one orchestrator row — the newest frame per row
  // id wins (earlier patches to the same row are stale snapshots).
  final liveByRowId = <int, SessionMessage>{};
  for (final m in deduped) {
    final rid = orchestratorRowId(m);
    if (rid != null) liveByRowId[rid] = m;
  }
  final liveDeduped = liveByRowId.isEmpty
      ? deduped
      : deduped.where((m) {
          final rid = orchestratorRowId(m);
          return rid == null || identical(liveByRowId[rid], m);
        }).toList();

  if (server.isEmpty) {
    return attachToolResults(dedupeAdjacentAssistantEchoes(liveDeduped));
  }

  final serverIds = {for (final m in server) m.id};
  final echoes = _echoIndex(server);

  // A live frame for a row the server already persisted folds into that row:
  // the persisted position/id stays, the payload comes from the newest frame
  // the client actually saw — a stale in-flight history page can't flip a
  // settled card back to 'running'.
  final patchedServer = [
    for (final m in server)
      if (liveByRowId[orchestratorRowId(m) ?? -1] case final live?)
        m.copyWith(context: live.context, summary: live.summary)
      else
        m,
  ];

  final extra = liveDeduped.where((m) {
    if (serverIds.contains(m.id)) return false;
    final rid = orchestratorRowId(m);
    if (rid != null) {
      // Folded into the persisted row above — not a standalone extra.
      return !echoes.orchestratorRowIds.contains(rid);
    }
    if ((m.kind == 'text' && m.role == 'assistant') ||
        m.kind == 'stream_delta' ||
        m.id == streamingRowId(m.sessionId, 'stream_delta')) {
      if (echoes.assistantTexts.contains((m.content ?? '').trim())) {
        return false;
      }
    }
    if (m.kind == 'thinking' || m.id == streamingRowId(m.sessionId, 'thinking')) {
      if (echoes.thinkingTexts.contains((m.content ?? '').trim())) {
        return false;
      }
    }
    if (m.kind == 'tool_use' && m.toolId != null && echoes.toolUseIds.contains(m.toolId)) {
      return false;
    }
    final fp = _orchestratorFingerprint(m);
    if (fp != null && echoes.orchestratorContexts.contains(fp)) return false;
    return true;
  }).toList();

  if (extra.isEmpty) {
    return attachToolResults(dedupeAdjacentAssistantEchoes(patchedServer));
  }
  final decorated = [
    for (final m in [...patchedServer, ...extra]) (m: m, t: _time(m) ?? 0),
  ]..sort((a, b) => a.t.compareTo(b.t));
  return attachToolResults(dedupeAdjacentAssistantEchoes([for (final e in decorated) e.m]));
}

// ─── Pagination ──────────────────────────────────────────────────────────────

String buildSessionMessagesUrl(String sessionId, {int? limit, int offset = 0}) {
  final base = '/api/providers/sessions/${Uri.encodeComponent(sessionId)}/messages';
  if (limit == null) return base;
  return '$base?limit=$limit&offset=$offset';
}

/// Longest cached-suffix/latest-prefix overlap for the latest-page merge.
int findLatestPageOverlapLength(List<SessionMessage> cached, List<SessionMessage> latest) {
  final max = cached.length < latest.length ? cached.length : latest.length;
  for (var len = max; len > 0; len--) {
    final start = cached.length - len;
    var ok = true;
    for (var i = 0; i < len; i++) {
      if (!samePersistedRow(cached[start + i], latest[i])) {
        ok = false;
        break;
      }
    }
    if (ok) return len;
  }
  return 0;
}

/// Replace the overlapping cached tail with the latest persisted window.
({List<SessionMessage> messages, int overlapLength}) mergeLatestServerPage(
  List<SessionMessage> cached,
  List<SessionMessage> latest,
) {
  if (cached.isEmpty) return (messages: latest, overlapLength: 0);
  if (latest.isEmpty) return (messages: cached, overlapLength: 0);
  final overlap = findLatestPageOverlapLength(cached, latest);
  if (overlap == 0) return (messages: cached, overlapLength: 0);
  return (
    messages: [...cached.sublist(0, cached.length - overlap), ...latest],
    overlapLength: overlap,
  );
}

/// A fetched bridge chunk is sane only when its newest row is not ahead of
/// the window it precedes (web `olderPagePrecedesCachedHistory`).
bool olderPagePrecedesCachedHistory(List<SessionMessage> older, List<SessionMessage> cached) {
  final olderNewest = older.isEmpty ? null : older.last;
  final cachedOldest = cached.isEmpty ? null : cached.first;
  if (olderNewest == null || cachedOldest == null) return true;
  final olderTime = _time(olderNewest);
  final cachedTime = _time(cachedOldest);
  return olderTime == null || cachedTime == null || olderTime <= cachedTime;
}

/// Prepend an older page, stitching over the cached suffix when the
/// transcript grew while the request was in flight.
({List<SessionMessage> messages, int overlapLength, int prependedCount}) mergeOlderServerPage(
  List<SessionMessage> cached,
  List<SessionMessage> older,
) {
  final max = cached.length < older.length ? cached.length : older.length;
  var overlap = 0;
  for (var len = max; len > 0; len--) {
    final start = older.length - len;
    var ok = true;
    for (var i = 0; i < len; i++) {
      if (!samePersistedRow(older[start + i], cached[i])) {
        ok = false;
        break;
      }
    }
    if (ok) {
      overlap = len;
      break;
    }
  }
  return (
    messages: [...older.sublist(0, older.length - overlap), ...cached],
    overlapLength: overlap,
    prependedCount: older.length - overlap,
  );
}

/// Preserves the cached oldest-page boundary after a tail stitch: once older
/// pages were loaded, a fresh latest page must not resurrect `hasMore`.
({int offset, bool hasMore}) resolveLatestPagePagination({
  required int previousMessageCount,
  required int mergedMessageCount,
  required bool previousHasMore,
  required bool oldestFetchedPageHasMore,
}) => (
  offset: mergedMessageCount,
  hasMore: previousMessageCount == 0
      ? oldestFetchedPageHasMore
      : previousHasMore && oldestFetchedPageHasMore,
);

/// Next finite bridge chunk when a turn added ≥1 page with no id overlap
/// (Codex-style regenerated ids).
({int offset, int limit})? planLatestPageBridge(
  List<SessionMessage> cached,
  List<SessionMessage> latest,
  int previousTotal,
  int nextTotal, [
  int bridgeRowsFetched = 0,
]) {
  if (cached.isEmpty || latest.isEmpty || findLatestPageOverlapLength(cached, latest) > 0) {
    return null;
  }
  final added = nextTotal - previousTotal;
  final missing = (added > 0 ? added : 0) - latest.length - bridgeRowsFetched;
  final preferred = bridgeRowsFetched == 0
      ? (missing + 1 > 1 ? missing + 1 : 1)
      : sessionMessagesPageSize;
  return (offset: latest.length + bridgeRowsFetched, limit: preferred);
}

/// True once a backward bridge reached the cached tail's time range —
/// stops an id-rewritten transcript from walking history forever.
bool hasReachedCachedTailTimeBoundary(List<SessionMessage> cached, List<SessionMessage> fetched) {
  if (cached.isEmpty || fetched.isEmpty) return false;
  final c = DateTime.tryParse(cached.last.timestamp);
  final f = DateTime.tryParse(fetched.first.timestamp);
  if (c == null || f == null) return false;
  return !f.isAfter(c);
}

/// Initial load keeps walking older pages until ≥2 text rows are visible —
/// tool-heavy turns can swallow a whole 40-row page.
bool shouldFetchOlderInitialHistory(
  List<SessionMessage> messages,
  bool hasMore,
  int extraPagesFetched,
) {
  if (!hasMore || extraPagesFetched >= initialHistoryMaxExtraPages) {
    return false;
  }
  var textRows = 0;
  for (final m in messages) {
    if (m.kind == 'text' && ++textRows >= initialHistoryMinTextMessages) {
      return false;
    }
  }
  return true;
}
