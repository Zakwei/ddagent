import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_models.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_repository.dart';
import 'package:ddagent_app/features/orchestrator/view/orchestrator_cards.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

SessionMessage msg(Map<String, dynamic> context) => SessionMessage(
  id: 'm1',
  sessionId: 's1',
  timestamp: '',
  provider: 'orchestrator',
  kind: 'status',
  context: context,
);

class FakeOrchestratorRepository extends OrchestratorRepository {
  FakeOrchestratorRepository() : super(Dio());

  Map<String, dynamic>? confirmBody;
  (String, Map<String, dynamic>)? resumeCall;

  @override
  Future<Map<String, dynamic>> confirmPlan(Map<String, dynamic> body) async => confirmBody = body;

  @override
  Future<Map<String, dynamic>> resume(String sessionId, Map<String, dynamic> body) async =>
      (resumeCall = (sessionId, body)).$2;
}

Widget wrap(Widget child, {FakeOrchestratorRepository? repo}) => TranslationProvider(
  child: ProviderScope(
    overrides: [if (repo != null) orchestratorRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  ),
);

void main() {
  group('model parsing', () {
    test('readSteps defaults missing fields, drops non-map entries', () {
      final steps = readSteps([
        {'title': 'Do thing'},
        'junk',
        42,
        {
          'id': 's2',
          'type': 'gate',
          'title': '',
          'dependsOn': ['s1'],
          'enabled': false,
          'command': 'make test',
        },
      ]);
      expect(steps.length, 2);
      expect(steps[0].id, 'step-1');
      expect(steps[0].type, 'task');
      expect(steps[0].enabled, isTrue);
      expect(steps[1].id, 's2');
      expect(steps[1].enabled, isFalse);
      expect(steps[1].dependsOn, ['s1']);
      expect(steps[1].command, 'make test');
      expect(readSteps(null), isEmpty);
      expect(readSteps({'a': 1}), isEmpty);
    });

    test('str/strList/readResults defensive decoding', () {
      expect(str(' x '), ' x ');
      expect(str(''), isNull);
      expect(str(5), isNull);
      expect(strList(['a', '', 3]), ['a', '3']);
      expect(strList('nope'), isEmpty);
      final results = readResults([
        {'title': 'T', 'summary': 'S'},
        {'title': 'no summary'},
        'junk',
      ]);
      expect(results.single.title, 'T');
    });
  });

  testWidgets('plan card renders steps, toggle flips enabled, confirm posts', (tester) async {
    final repo = FakeOrchestratorRepository();
    await tester.pumpWidget(
      wrap(
        OrchestratorCard(
          message: msg({
            'orchestratorKind': 'plan',
            'awaitingConfirm': true,
            'steps': [
              {'id': 'a', 'type': 'task', 'title': 'First step', 'dependsOn': <String>[]},
              {
                'id': 'b',
                'type': 'gate',
                'title': 'Second',
                'dependsOn': ['a'],
                'command': 'make',
              },
            ],
          }),
          sessionId: 's1',
        ),
        repo: repo,
      ),
    );
    await tester.pump();
    expect(find.text('First step'), findsOneWidget);
    expect(find.text('Waiting for plan confirmation.'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(find.text('disabled'), findsOneWidget);

    await tester.tap(find.text('Run plan'));
    await tester.pump();
    final body = repo.confirmBody!;
    expect(body['sessionId'], 's1');
    final steps = body['steps'] as List;
    expect(steps[0]['id'], 'a');
    expect(steps[0]['enabled'], isFalse);
    expect(steps[1]['enabled'], isTrue);
    expect(steps[1]['command'], 'make');
    expect(body['language'], isA<String>());
  });

  testWidgets('gate card renders command, exit code, output tail', (tester) async {
    final output = List.generate(40, (i) => 'line $i').join('\n');
    await tester.pumpWidget(
      wrap(
        OrchestratorCard(
          message: msg({
            'orchestratorKind': 'gate',
            'status': 'failed',
            'command': 'npm test -- --runInBand',
            'exitCode': 1,
            'output': output,
            'durationMs': 1234,
            'timedOut': false,
          }),
          sessionId: 's1',
        ),
      ),
    );
    await tester.pump();
    expect(find.text('npm test -- --runInBand'), findsOneWidget);
    expect(find.text('exit 1'), findsOneWidget);
    expect(find.text('failed'), findsOneWidget);
    expect(find.text('1.2s'), findsOneWidget);
    // Tail is capped at ~30 lines: last line in, first line dropped.
    expect(find.textContaining('line 39'), findsOneWidget);
    expect(find.textContaining('line 0\n'), findsNothing);
  });

  testWidgets('gate card with missing output does not crash', (tester) async {
    await tester.pumpWidget(
      wrap(
        OrchestratorCard(
          message: msg({
            'orchestratorKind': 'gate',
            'status': 'done',
            'command': 'true',
            'exitCode': 0,
          }),
          sessionId: 's1',
        ),
      ),
    );
    await tester.pump();
    expect(find.text('exit 0'), findsOneWidget);
  });

  testWidgets('delegation card shows metrics row, tolerates missing fields', (tester) async {
    await tester.pumpWidget(
      wrap(
        OrchestratorCard(
          message: msg({
            'orchestratorKind': 'delegation',
            'status': 'done',
            'title': 'Implement feature',
            'provider': 'claude',
            'model': 'opus',
            'attempt': 2,
            'durationMs': 184000,
            'stepId': 'st-1',
            'finalText': 'all good',
          }),
          sessionId: 's1',
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Implement feature'), findsOneWidget);
    expect(find.text('attempt 2'), findsOneWidget);
    expect(find.textContaining('3m 04s'), findsOneWidget);
    expect(find.textContaining('2 attempts'), findsOneWidget);
    expect(find.text('Continue / Fix'), findsOneWidget);
  });

  testWidgets('delegation retry posts resume with stepId', (tester) async {
    final repo = FakeOrchestratorRepository();
    await tester.pumpWidget(
      wrap(
        OrchestratorCard(
          message: msg({
            'orchestratorKind': 'delegation',
            'status': 'failed',
            'stepId': 'st-9',
            'error': 'boom',
          }),
          sessionId: 's1',
        ),
        repo: repo,
      ),
    );
    await tester.pump();
    // failed cards start collapsed — expand first.
    await tester.tap(find.text('st-9'));
    await tester.pump();
    expect(find.text('boom'), findsOneWidget);
    await tester.tap(find.text('Retry / Fix'));
    await tester.pump();
    expect(repo.resumeCall?.$1, 's1');
    expect(repo.resumeCall?.$2['stepId'], 'st-9');
  });

  testWidgets('summary card buttons post expected resume bodies', (tester) async {
    final repo = FakeOrchestratorRepository();
    await tester.pumpWidget(
      wrap(
        OrchestratorCard(
          message: msg({
            'orchestratorKind': 'summary',
            'text': 'done',
            'results': [
              {'title': 'A', 'summary': 'ok'},
            ],
            'failed': <String>[],
          }),
          sessionId: 's1',
        ),
        repo: repo,
      ),
    );
    await tester.pump();
    expect(find.text('Continue work'), findsOneWidget);
    await tester.tap(find.text('Run next task'));
    await tester.pump();
    expect(repo.resumeCall?.$2['mode'], 'complete-all-tasks');
    expect(repo.resumeCall?.$2['maxTasks'], 1);
  });

  testWidgets('unknown orchestrator kind renders muted fallback', (tester) async {
    await tester.pumpWidget(
      wrap(
        OrchestratorCard(message: msg({'orchestratorKind': 'weird-future-kind'}), sessionId: 's1'),
      ),
    );
    await tester.pump();
    expect(find.text('weird-future-kind'), findsOneWidget);
  });
}
