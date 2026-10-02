import 'dart:typed_data';

import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/transcript_view.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/misc/data/misc_repository.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeMisc extends MiscRepository {
  _FakeMisc({this.bytes}) : super(Dio());
  final Uint8List? bytes;
  int calls = 0;

  @override
  Future<Uint8List> downloadAssetFile(String name) async {
    calls++;
    final b = bytes;
    if (b == null) throw Exception('404');
    return b;
  }
}

class _FakeFiles extends FileTreeRepository {
  _FakeFiles({this.bytes}) : super(Dio());
  final Uint8List? bytes;
  int calls = 0;

  @override
  Future<Uint8List> readFileBlob(String projectId, String path) async {
    calls++;
    final b = bytes;
    if (b == null) throw Exception('404');
    return b;
  }
}

SessionMessage _msg() => SessionMessage(
  id: 'm1',
  sessionId: 's',
  timestamp: 't',
  provider: 'claude',
  kind: 'text',
  role: 'user',
  files: [
    {
      'name': 'report.pdf',
      'path': '/tmp/assets/report.pdf',
      'size': 2048,
      'mimeType': 'application/pdf',
    },
  ],
);

Widget _app(_FakeMisc misc, _FakeFiles files, {String? projectId}) => ProviderScope(
  overrides: [
    miscRepositoryProvider.overrideWithValue(misc),
    fileTreeRepositoryProvider.overrideWithValue(files),
  ],
  child: MaterialApp(
    theme: AppTheme.ocChat(),
    home: Scaffold(
      body: MessageAttachments(message: _msg(), projectId: projectId),
    ),
  ),
);

void main() {
  testWidgets('attachment card shows name + size, downloads via asset store', (tester) async {
    final misc = _FakeMisc(bytes: Uint8List.fromList([1, 2, 3]));
    final files = _FakeFiles(bytes: Uint8List.fromList([9]));
    await tester.pumpWidget(_app(misc, files, projectId: 'p1'));

    expect(find.text('report.pdf'), findsOneWidget);
    expect(find.text('2 KB'), findsOneWidget);

    // Real file IO inside the download path — run on the real event loop.
    await tester.runAsync(() async {
      await tester.tap(find.text('report.pdf'));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();
    });

    expect(misc.calls, 1);
    expect(files.calls, 0);
    expect(find.textContaining('Saved'), findsOneWidget); // toast
  });

  testWidgets('asset 404 falls back to the project files route', (tester) async {
    final misc = _FakeMisc(); // always throws
    final files = _FakeFiles(bytes: Uint8List.fromList([4, 5]));
    await tester.pumpWidget(_app(misc, files, projectId: 'p1'));

    await tester.runAsync(() async {
      await tester.tap(find.text('report.pdf'));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();
    });

    expect(misc.calls, 1);
    expect(files.calls, 1);
    expect(find.textContaining('Saved'), findsOneWidget);
  });

  testWidgets('both sources failing shows the retry state', (tester) async {
    final misc = _FakeMisc();
    final files = _FakeFiles();
    await tester.pumpWidget(_app(misc, files, projectId: 'p1'));

    await tester.runAsync(() async {
      await tester.tap(find.text('report.pdf'));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();
    });

    expect(find.text('Download failed — click to retry'), findsOneWidget);
  });
}
