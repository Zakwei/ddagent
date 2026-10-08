import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/update_badge.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

/// Server whose self-update downloads a release tarball but has no launcher
/// to restart it — the reply a bundle started by hand gives.
class _StagingRepository extends SystemRepository {
  _StagingRepository() : super(Dio());

  @override
  Future<Map<String, dynamic>> update() async => {
    'success': true,
    'staged': true,
    'restarting': false,
  };
}

Widget _app(List<Override> overrides, Widget child) => TranslationProvider(
  child: ProviderScope(
    overrides: [
      latestReleaseProvider.overrideWith((ref) async => const Release(tagName: 'v9.9.9')),
      activeServerIsLocalProvider.overrideWithValue(false),
      ...overrides,
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: Center(child: child)),
    ),
  ),
);

void main() {
  testWidgets('the badge offers a separate button for each available update', (tester) async {
    await tester.pumpWidget(
      _app([
        availableUpdatesProvider.overrideWith((ref) => [UpdateTarget.app, UpdateTarget.server]),
      ], const UpdateBadge()),
    );
    // The badge's pulse dot animates forever — pump instead of settling.
    await tester.pump();
    await tester.pump();
    await tester.tap(find.byType(UpdateBadge));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Updates available'), findsOneWidget);
    expect(find.text('Update app'), findsOneWidget);
    expect(find.text('Update server'), findsOneWidget);

    await tester.tap(find.text('Update server'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('Update to v9.9.9?'), findsOneWidget);
  });

  testWidgets('a server that cannot restart itself says to restart it after the download', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        [systemRepositoryProvider.overrideWithValue(_StagingRepository())],
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showUpdateDialog(context, UpdateTarget.server),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Update server'));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('Update v9.9.9 downloaded — restart the server to install it.'),
      findsOneWidget,
    );
  });
}
