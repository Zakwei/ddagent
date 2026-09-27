import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/preview_ws.dart';
import 'package:ddagent_app/core/realtime/sse_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _StreamAdapter implements HttpClientAdapter {
  _StreamAdapter(this.bytes);
  final List<int> bytes;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? _, Future<void>? _) async {
    return ResponseBody(
      Stream.fromIterable([Uint8List.fromList(bytes)]),
      200,
      headers: {
        'content-type': ['text/event-stream'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('ServerEvent dispatch', () {
    test('kind parsing covers message/gateway/broadcast', () {
      expect(ServerEvent(raw: {'kind': 'text'}).messageKind, MessageKind.text);
      expect(ServerEvent(raw: {'kind': 'chat_subscribed'}).isGateway, isTrue);
      expect(ServerEvent(raw: {'kind': 'kanban-card-updated'}).isBroadcast, isTrue);
      expect(ServerEvent(raw: {'kind': 'taskmaster-progress'}).isBroadcast, isTrue);
      expect(ServerEvent(raw: {'kind': 'presence-roster'}).isBroadcast, isTrue);
      expect(ServerEvent(raw: {'kind': 'session_removed'}).isBroadcast, isTrue);
      expect(ServerEvent(raw: {'kind': 'queued-messages-updated'}).isBroadcast, isTrue);
      expect(ServerEvent(raw: {'kind': 'notification'}).isBroadcast, isTrue);
    });
  });

  group('ReplayCursor', () {
    const cursor = ReplayCursor(runId: 'r1', lastSeq: 5);
    ServerEvent ev(int seq, {String? runId}) =>
        ServerEvent(raw: {'kind': 'text', 'sessionId': 's', 'seq': seq, 'runId': ?runId});

    test('dedupes replayed seq within the same run', () {
      expect(cursor.isNew(ev(5, runId: 'r1')), isFalse);
      expect(cursor.isNew(ev(4, runId: 'r1')), isFalse);
      expect(cursor.isNew(ev(6, runId: 'r1')), isTrue);
    });

    test('accepts unsequenced frames and new run ids', () {
      expect(cursor.isNew(ServerEvent(raw: {'kind': 'text'})), isTrue);
      expect(cursor.isNew(ev(1, runId: 'r2')), isTrue);
    });

    test('advance tracks seq', () {
      expect(cursor.advance(ev(7, runId: 'r1')).lastSeq, 7);
      expect(cursor.advance(ServerEvent(raw: {'kind': 'text'})).lastSeq, 5);
    });
  });

  group('SseClient', () {
    test('parses named + typed frames and skips comments', () async {
      const payload =
          ': keep-alive\n'
          'event: progress\ndata: {"scanned":1}\n\n'
          'data: {"type":"complete","ok":true}\n\n'
          'event: done\ndata: {}\n\n';
      final dio = Dio(BaseOptions(baseUrl: 'http://x'))
        ..httpClientAdapter = _StreamAdapter(utf8.encode(payload));
      final events = await SseClient(dio).stream('/sse').toList();
      expect(events.length, 3);
      expect(events[0].event, 'progress');
      expect(events[0].data['scanned'], 1);
      expect(events[1].type, 'complete'); // type from data for unnamed frames
      expect(events[2].event, 'done');
    });
  });

  group('previewTunnelUrl', () {
    test('maps to /api/preview/<port>/<path> with token', () {
      final uri = previewTunnelUrl(
        baseUrl: 'https://srv:8443',
        port: 5173,
        upstreamPath: 'ws',
        token: 'jwt',
      );
      expect(uri.toString(), 'wss://srv:8443/api/preview/5173/ws?token=jwt');
    });
    test('http base → ws scheme', () {
      expect(previewTunnelUrl(baseUrl: 'http://h:10087', port: 80).scheme, 'ws');
    });
  });
}
