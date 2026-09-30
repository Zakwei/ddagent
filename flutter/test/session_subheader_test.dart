import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/session_subheader.dart';
import 'package:ddagent_app/features/commands/data/commands_repository.dart';
import 'package:ddagent_app/features/provider_accounts/data/provider_accounts_repository.dart';
import 'package:ddagent_app/features/queue/data/queue_repository.dart';
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _FakeSessions extends SessionsRepository {
  _FakeSessions() : super(Dio());

  @override
  Future<Map<String, dynamic>> tokenUsage(String sessionId) async => {
    'used': 50000,
    'inputTokens': 40000,
    'outputTokens': 10000,
    'total': 120000,
  };

  @override
  Future<({List<Map<String, dynamic>> options, String? defaultModel})> models(
    String provider,
  ) async => (
    options: [
      {'id': 'devin-default', 'label': 'Devin Default'},
    ],
    defaultModel: 'devin-default',
  );

  @override
  Future<Map<String, dynamic>> activeModel(
    String provider,
    String sessionId,
  ) async => {'model': 'devin-default'};
}

class _FakeAccounts extends ProviderAccountsRepository {
  _FakeAccounts() : super(Dio());

  @override
  Future<List<ProviderAccount>> list() async => [];
}

class _FakeQueue extends QueueRepository {
  _FakeQueue() : super(Dio());

  @override
  Future<List<Map<String, dynamic>>> list(String sessionId) async => [];
}

class _FakeCommands extends CommandsRepository {
  _FakeCommands() : super(Dio());

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> body) async => {
    'commands': <Map<String, dynamic>>[],
  };
}

class _FakeQuota extends QuotaRepository {
  _FakeQuota() : super(Dio());

  @override
  Future<Map<String, dynamic>> snapshot() async => {
    'overview': {'watchThreshold': 70, 'dangerThreshold': 90},
    'accounts': [
      {
        'provider': 'devin',
        'providerLabel': 'Devin',
        'plan': 'Team',
        'status': 'active',
        'windows': [
          {
            'label': 'Weekly',
            'percent': 62.5,
            'resetsAt': '2026-10-01T12:00:00Z',
          },
        ],
      },
    ],
  };
}

Widget _app(Widget child, {double width = 900}) => ProviderScope(
  overrides: [
    sessionsRepositoryProvider.overrideWithValue(_FakeSessions()),
    quotaRepositoryProvider.overrideWithValue(_FakeQuota()),
    providerAccountsRepositoryProvider.overrideWithValue(_FakeAccounts()),
    queueRepositoryProvider.overrideWithValue(_FakeQueue()),
    commandsRepositoryProvider.overrideWithValue(_FakeCommands()),
  ],
  child: MaterialApp(
    theme: AppTheme.ocChat(),
    home: MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: Scaffold(body: child),
    ),
  ),
);

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_subheader_hive');
    for (final name in ['settings', 'chat']) {
      if (!Hive.isBoxOpen(name)) await Hive.openBox<dynamic>(name);
    }
  });

  test('sectionForModel maps provider/model prefixes to quota sections', () {
    expect(sectionForModel('google/gemini-3'), 'gemini');
    expect(sectionForModel('antigravity-x'), 'gemini');
    expect(sectionForModel('commandcode/a'), 'commandcode');
    expect(sectionForModel('opencode/gpt-5'), 'opencode');
    expect(sectionForModel('opencode-go/x'), 'opencode');
    expect(sectionForModel('nvidia/nim'), 'byok');
    expect(sectionForModel('claude-sonnet-4'), isNull);
    expect(sectionForModel(null), isNull);
  });

  test('windowMatchesModel filters devin model groups', () {
    expect(windowMatchesModel('Gemini Models 5h', 'gemini-2.5-pro'), isTrue);
    expect(windowMatchesModel('Gemini Models 5h', 'claude-sonnet-4'), isFalse);
    expect(windowMatchesModel('Claude and GPT weekly', 'gpt-5'), isTrue);
    expect(windowMatchesModel('Weekly', 'anything'), isTrue);
    expect(windowMatchesModel('Gemini Models 5h', null), isTrue);
  });

  testWidgets('desktop subheader shows logo label, model, path, ctx, quota', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const SessionSubheader(
          sessionId: 's1',
          provider: 'devin',
          projectId: 'p1',
          projectPath: '/workspace/app',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Devin'), findsOneWidget);
    expect(find.text('Devin Default'), findsOneWidget);
    expect(find.text('/workspace/app'), findsOneWidget);
    // Context gauge: 50000/120000 → 42%, total shown as 120K.
    expect(find.text('42%'), findsOneWidget);
    expect(find.text('120K'), findsOneWidget);
    // QuotaBadge: worst devin window is Weekly 62.5%.
    expect(find.text('62.5%'), findsOneWidget);
  });

  testWidgets('dense subheader drops path and separators', (tester) async {
    await tester.pumpWidget(
      _app(
        const SessionSubheader(
          sessionId: 's1',
          provider: 'devin',
          projectPath: '/workspace/app',
          dense: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('/workspace/app'), findsNothing);
    expect(find.text('·'), findsNothing);
    expect(find.text('42%'), findsOneWidget);
    expect(find.text('62.5%'), findsOneWidget);
  });
}
