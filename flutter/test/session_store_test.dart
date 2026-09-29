import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/state/message_merge.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

SessionMessage _m(
  String id, {
  String kind = 'text',
  String? role = 'assistant',
  String? content,
  String? ts,
  String? toolId,
}) => SessionMessage(
  id: id,
  sessionId: 's1',
  // Distinct per-id defaults: timestamp equality is a persisted-row
  // fingerprint field, so identical fixtures would falsely dedupe.
  timestamp: ts ?? '2026-01-01T00:00:${(id.hashCode.abs() % 60).toString().padLeft(2, '0')}Z',
  provider: 'claude',
  kind: kind,
  role: role,
  content: content ?? 'c$id',
  toolId: toolId,
);

void main() {
  group('merge/dedupe', () {
    test('optimistic local_ echo dropped once server turn persists', () {
      final local = _m('local_1', role: 'user', content: 'hi', ts: '2026-01-01T00:00:00Z');
      final server = _m('srv_1', role: 'user', content: 'hi', ts: '2026-01-01T00:00:02Z');
      final merged = computeMerged([server], [local]);
      expect(merged.map((m) => m.id), ['srv_1']);
    });

    test('realtime user row within 3s of persisted row is collapsed', () {
      final server = _m('srv', role: 'user', content: 'x', ts: '2026-01-01T00:00:00Z');
      final rt = _m('rt', role: 'user', content: 'x', ts: '2026-01-01T00:00:02Z');
      expect(computeMerged([server], [rt]).map((m) => m.id), ['srv']);
    });

    test('realtime rows interleave by timestamp, dedupe by id/tool', () {
      final server = [
        _m('a', content: 'first', ts: '2026-01-01T00:00:01Z'),
        _m('c', kind: 'tool_use', role: null, toolId: 't1', ts: '2026-01-01T00:00:03Z'),
      ];
      final rt = [
        _m('c', kind: 'tool_use', role: null, toolId: 't1', ts: '2026-01-01T00:00:03Z'),
        _m('b', role: 'user', content: 'second', ts: '2026-01-01T00:00:02Z'),
      ];
      expect(computeMerged(server, rt).map((m) => m.id), ['a', 'b', 'c']);
    });

    test('tool_result folds into its tool_use card; orphan result stays', () {
      final merged = computeMerged([], [
        _m('u1', kind: 'tool_use', toolId: 't1'),
        _m('r1', kind: 'tool_result', toolId: 't1', content: 'out'),
        _m('r2', kind: 'tool_result', toolId: 'ghost', content: 'orphan'),
      ]);
      // The matched result disappears as a row and rides on the card.
      expect(merged.map((m) => m.id), ['u1', 'r2']);
      expect(merged.first.toolResult?['content'], 'out');
    });

    test('adjacent identical assistant echoes collapse', () {
      final dup = _m('d1', content: 'same', ts: '2026-01-01T00:00:01Z');
      final dup2 = _m('d2', content: 'same', ts: '2026-01-01T00:00:02Z');
      final ok = _m('ok', content: 'other', ts: '2026-01-01T00:00:03Z');
      expect(dedupeAdjacentAssistantEchoes([dup, dup2, ok]).map((m) => m.id), ['d1', 'ok']);
    });
  });

  group('pagination', () {
    test('latest page replaces overlapping tail', () {
      final cached = [_m('1'), _m('2'), _m('3')];
      final latest = [_m('2'), _m('3'), _m('4')];
      final r = mergeLatestServerPage(cached, latest);
      expect(r.messages.map((m) => m.id), ['1', '2', '3', '4']);
      expect(r.overlapLength, 2);
    });

    test('older page prepends, stitching growth overlap', () {
      final older = [_m('0'), _m('1'), _m('2')];
      final cached = [_m('2'), _m('3')];
      final r = mergeOlderServerPage(cached, older);
      expect(r.messages.map((m) => m.id), ['0', '1', '2', '3']);
      expect(r.prependedCount, 2);
    });

    test('bridge planned only when page has no overlap and transcript grew', () {
      final cached = [_m('1')];
      final latest = [_m('9'), _m('10')];
      final plan = planLatestPageBridge(cached, latest, 1, 10);
      expect(plan, isNotNull);
      expect(plan!.offset, 2);
      expect(planLatestPageBridge(latest, latest, 0, 0), isNull);
    });
  });

  group('SessionMessageStore', () {
    test('appendRealtime dedupes by id; streaming row accumulates', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final store = c.read(sessionMessageStoreProvider.notifier);
      store.appendRealtime('s1', _m('r1', role: 'user', content: 'hi'));
      store.appendRealtime('s1', _m('r1', role: 'user', content: 'hi'));
      store.updateStreaming('s1', 'hel', 'claude');
      store.updateStreaming('s1', 'hello', 'claude');
      final msgs = c.read(sessionMessagesProvider('s1'));
      expect(msgs.length, 2);
      expect(msgs.last.content, 'hello');
    });

    test('delta buffer accumulates across flush windows', () async {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final buf = c.read(streamDeltaBufferProvider);
      buf.add('s1', 'hel', 'claude');
      await Future<void>.delayed(const Duration(milliseconds: 80));
      buf.add('s1', 'lo', 'claude');
      await Future<void>.delayed(const Duration(milliseconds: 80));
      buf.closeLiveRows('s1', 'claude');
      final msgs = c.read(sessionMessagesProvider('s1'));
      expect(msgs.single.content, 'hello');
    });

    test('finalizeStreaming converts stream row to assistant text', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final store = c.read(sessionMessageStoreProvider.notifier);
      store.updateStreaming('s1', 'done', 'claude');
      store.finalizeStreaming('s1');
      final msgs = c.read(sessionMessagesProvider('s1'));
      expect(msgs.single.kind, 'text');
      expect(msgs.single.role, 'assistant');
    });
  });

  group('SessionActivityController', () {
    test('stale idle ack cannot clear a newer request', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final act = c.read(sessionActivityProvider.notifier);
      act.markProcessing('s1');
      final started = c.read(sessionActivityProvider)['s1']!.startedAt;
      act.markIdle('s1', ifStartedBefore: started);
      expect(c.read(sessionActivityProvider).containsKey('s1'), true);
      act.markIdle('s1', ifStartedBefore: started + 1);
      expect(c.read(sessionActivityProvider).containsKey('s1'), false);
    });

    test('sync keeps local marks inside the 10s grace window', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final act = c.read(sessionActivityProvider.notifier);
      act.markProcessing('local');
      act.sync([(sessionId: 'server', statusText: null, canInterrupt: true, startedAt: 1)]);
      final state = c.read(sessionActivityProvider);
      expect(state.keys, containsAll(['local', 'server']));
    });
  });
}
