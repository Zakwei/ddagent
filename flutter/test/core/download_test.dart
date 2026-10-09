import 'dart:io';

import 'package:ddagent_app/core/network/download.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HttpServer server;
  late Directory dir;

  setUp(() async {
    server = await HttpServer.bind('127.0.0.1', 0);
    dir = await Directory.systemTemp.createTemp('dl_test');
    server.listen((req) async {
      req.response.headers.contentLength = 100;
      req.response.add(List.filled(10, 1));
      await req.response.flush();
      if (req.uri.path == '/ok') {
        req.response.add(List.filled(90, 1));
        await req.response.close();
      }
      // '/stall': headers + 10 bytes, then nothing — never closes.
    });
  });

  tearDown(() async {
    await server.close(force: true);
    await dir.delete(recursive: true);
  });

  test('completes a normal download', () async {
    final path = '${dir.path}/ok.bin';
    await downloadWithStallTimeout(Dio(), 'http://127.0.0.1:${server.port}/ok', path);
    expect(await File(path).length(), 100);
  });

  test('fails with receiveTimeout when the body stalls', () async {
    await expectLater(
      downloadWithStallTimeout(
        Dio(),
        'http://127.0.0.1:${server.port}/stall',
        '${dir.path}/stall.bin',
        stallTimeout: const Duration(milliseconds: 300),
      ),
      throwsA(isA<DioException>().having((e) => e.type, 'type', DioExceptionType.receiveTimeout)),
    );
  });
}
