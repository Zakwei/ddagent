import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/settings/view/sections/orchestration_section.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression cover for the orchestration settings section. The model field
/// used to be a `DropdownButton` fed the whole provider catalog — Devin ships
/// 700+ models, so a full pool materialized ~10k offstage rows on every build
/// and made the section janky. It is now a lazy, searchable picker.
Map<String, dynamic> _cand(String id, String provider, String model) => {
  'id': id,
  'provider': provider,
  'model': model,
  'tier': 'mid',
  'label': id,
};

Map<String, dynamic> _config() => {
  'enabled': true,
  'pool': [
    _cand('d0', 'devin', ''),
    _cand('d1', 'devin', ''),
    _cand('d2', 'devin', ''),
    _cand('a0', 'antigravity', ''),
  ],
  'rules': {
    'code': ['d0', 'a0'],
  },
  'planner': {'mode': 'auto', 'candidateId': 'd0'},
  'execution': <String, dynamic>{},
};

Dio _dio() {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        final path = o.path;
        if (path == '/api/orchestrator/config') {
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
        if (path == '/api/provider-accounts') {
          h.resolve(
            Response(
              requestOptions: o,
              data: {
                'success': true,
                'data': {'accounts': <dynamic>[]},
              },
            ),
          );
          return;
        }
        final match = RegExp(r'^/api/providers/([^/]+)/models$').firstMatch(path);
        if (match != null) {
          final provider = match.group(1)!;
          final count = provider == 'devin' ? 721 : 8;
          h.resolve(
            Response(
              requestOptions: o,
              data: {
                'success': true,
                'data': {
                  'provider': provider,
                  'models': {
                    'OPTIONS': [
                      for (var i = 0; i < count; i++)
                        {'value': '${provider}m$i', 'label': '$provider model $i'},
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

Future<void> _pumpSection(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1200, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [dioProvider.overrideWithValue(_dio())],
      child: TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: OrchestrationSection()),
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
  testWidgets('mounts a full pool without materializing every model option', (tester) async {
    await _pumpSection(tester);

    // The 721-model Devin catalog must not be inflated into dropdown items.
    final built = find.byType(DropdownMenuItem<String>, skipOffstage: false).evaluate().length;
    expect(built, lessThan(1000));
    expect(tester.takeException(), isNull);
  });

  testWidgets('model picker searches and selects', (tester) async {
    await _pumpSection(tester);

    // Every pool row starts with no model chosen.
    await tester.tap(find.text('Select a model').first);
    await tester.pumpAndSettle();

    expect(find.text('Search models...'), findsOneWidget);
    expect(find.text('devin model 0'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'model 700');
    await tester.pumpAndSettle();
    expect(find.text('devin model 700'), findsOneWidget);
    expect(find.text('devin model 0'), findsNothing);

    await tester.tap(find.text('devin model 700'));
    await tester.pumpAndSettle();
    // Dialog closed and the trigger now shows the picked model.
    expect(find.text('Search models...'), findsNothing);
    expect(find.text('devin model 700'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
