import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/mini_orchestrator/view/mini_orchestration_section.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression cover for the mini-orchestration settings section: its role
/// model used to be a hand-typed `TextField`; it is now the same searchable
/// model picker the full orchestrator uses (fed by the shared catalog).
Map<String, dynamic> _cand(String id) => {
  'id': id,
  'provider': 'devin',
  'model': '',
  'tier': 'mid',
  'label': id,
};

Map<String, dynamic> _config() => {
  'enabled': true,
  'thinker': [_cand('thinker')],
  'worker': [_cand('worker')],
  'roles': <String, dynamic>{},
  'planner': {'mode': 'auto', 'requireConfirm': false},
  'execution': {'maxParallel': 2, 'maxSteps': 12, 'stepTimeoutMs': 0, 'runTimeoutMs': 0},
};

Dio _dio(List<Map<String, dynamic>> puts) {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        final path = o.path;
        if (path == '/api/mini-orchestrator/config' && o.method == 'PUT') {
          puts.add(Map<String, dynamic>.from(o.data as Map));
          h.resolve(
            Response(
              requestOptions: o,
              data: {
                'success': true,
                'data': {'config': _config()},
              },
            ),
          );
          return;
        }
        if (path == '/api/mini-orchestrator/config') {
          h.resolve(
            Response(
              requestOptions: o,
              data: {
                'success': true,
                'data': {'config': _config()},
              },
            ),
          );
          return;
        }
        final match = RegExp(r'^/api/providers/([^/]+)/models$').firstMatch(path);
        if (match != null) {
          final provider = match.group(1)!;
          h.resolve(
            Response(
              requestOptions: o,
              data: {
                'success': true,
                'data': {
                  'provider': provider,
                  'models': {
                    'OPTIONS': [
                      {'value': '${provider}m0', 'label': '$provider model 0'},
                      {'value': '${provider}m700', 'label': '$provider model 700'},
                    ],
                  },
                },
              },
            ),
          );
          return;
        }
        h.resolve(
          Response(requestOptions: o, data: {'success': true, 'data': <String, dynamic>{}}),
        );
      },
    ),
  );
  return dio;
}

Future<void> _pumpSection(WidgetTester tester, List<Map<String, dynamic>> puts) async {
  tester.view.physicalSize = const Size(1200, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [dioProvider.overrideWithValue(_dio(puts))],
      child: TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: MiniOrchestrationSection()),
        ),
      ),
    ),
  );
  // Flush the config + catalog microtasks.
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  testWidgets('model is picked from the catalog, not typed', (tester) async {
    final puts = <Map<String, dynamic>>[];
    await _pumpSection(tester, puts);

    // Both roles start with no model chosen (hint shown by the picker).
    expect(find.text('Select a model'), findsWidgets);

    await tester.tap(find.text('Select a model').first);
    await tester.pumpAndSettle();

    expect(find.text('Search models...'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, 'model 700');
    await tester.pumpAndSettle();
    expect(find.text('devin model 700'), findsOneWidget);
    expect(find.text('devin model 0'), findsNothing);

    await tester.tap(find.text('devin model 700'));
    await tester.pumpAndSettle();
    expect(find.text('Search models...'), findsNothing);
    expect(find.text('devin model 700'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(puts, hasLength(1));
    final thinker = (puts.single['config'] as Map)['thinker'] as List;
    expect((thinker.first as Map)['model'], 'devinm700');
    expect(tester.takeException(), isNull);
  });
}
