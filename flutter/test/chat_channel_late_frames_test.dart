import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'transcript_test.dart' show FakeWs;

void main() {
  test('a finished run still delivers asks and task counts, only from the latest run', () async {
    final ws = FakeWs();
    final channel = ChatChannel(ws)..start();
    final kinds = <String>[];
    final sub = channel.events.listen((e) => kinds.add('${e.runId}:${e.kind}'));
    Future<void> frame(String run, int seq, String kind) async {
      ws.emitFrame({
        'sessionId': 's1',
        'runId': run,
        'seq': seq,
        'kind': kind,
        'provider': 'claude',
      });
      await Future<void>.delayed(Duration.zero);
    }

    await frame('r1', 1, 'stream_delta');
    await frame('r1', 2, 'complete');
    // Background work of r1 reports after its complete.
    await frame('r1', 3, 'permission_request');
    await frame('r1', 4, 'background_tasks');
    await frame('r1', 5, 'text'); // anything else stays sealed
    await frame('r1', 6, 'error'); // the run's late failure
    await frame('r1', 7, 'status'); // plain status stays sealed
    ws.emitFrame({
      'sessionId': 's1',
      'runId': 'r1',
      'seq': 8,
      'kind': 'status',
      'notice': true,
      'text': 'Rate limited',
    });
    await Future<void>.delayed(Duration.zero);
    // A newer run takes over; r1's late frames are now stale.
    await frame('r2', 1, 'stream_delta');
    await frame('r1', 9, 'permission_request');

    expect(kinds, [
      'r1:stream_delta',
      'r1:complete',
      'r1:permission_request',
      'r1:background_tasks',
      'r1:error',
      'r1:status',
      'r2:stream_delta',
    ]);
    await sub.cancel();
  });
}
