import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/view/disk_usage.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _gb = 1024 * 1024 * 1024;

class _FakeSystemRepository extends SystemRepository {
  _FakeSystemRepository(this.volumes) : super(Dio());

  final List<DiskVolume> volumes;

  @override
  Future<List<DiskVolume>> diskUsage() async => volumes;
}

DiskVolume _volume({required bool low}) => DiskVolume.fromJson({
  'locations': [
    {'kind': 'app', 'path': '/srv/app'},
    {'kind': 'workspace', 'path': '/workspace'},
  ],
  'totalBytes': 100 * _gb,
  'freeBytes': (low ? 3 : 40) * _gb,
  'low': low,
});

Future<void> _pump(WidgetTester tester, List<DiskVolume> volumes, Widget child) async {
  await tester.pumpWidget(
    TranslationProvider(
      child: ProviderScope(
        overrides: [systemRepositoryProvider.overrideWithValue(_FakeSystemRepository(volumes))],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: child),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('banner shows for a low disk and hides after dismiss', (tester) async {
    await _pump(tester, [_volume(low: true)], const LowDiskBanner());
    expect(find.textContaining('3 GB left on /srv/app, /workspace'), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pump();
    expect(find.textContaining('Low disk space'), findsNothing);
  });

  testWidgets('no banner while there is enough space', (tester) async {
    await _pump(tester, [_volume(low: false)], const LowDiskBanner());
    expect(find.textContaining('Low disk space'), findsNothing);
  });

  testWidgets('settings block lists free space and what lives on the disk', (tester) async {
    await _pump(tester, [_volume(low: false)], const DiskUsageBlock());
    expect(find.text('40 GB free of 100 GB'), findsOneWidget);
    expect(find.text('App: /srv/app'), findsOneWidget);
    expect(find.text('Workspaces: /workspace'), findsOneWidget);
  });
}
