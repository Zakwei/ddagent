import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/session_subheader.dart';
import 'package:ddagent_app/features/commands/data/commands_repository.dart';
import 'package:ddagent_app/features/provider_accounts/data/provider_accounts_repository.dart';
import 'package:ddagent_app/features/queue/data/queue_repository.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _FakeSessions extends SessionsRepository {
  _FakeSessions({this.modelLabel = 'Devin Default'}) : super(Dio());

  final String modelLabel;

  @override
  Future<Map<String, dynamic>> tokenUsage(String sessionId) async => {
    'used': 50000,
    'inputTokens': 40000,
    'outputTokens': 10000,
    'total': 120000,
  };

  @override
  Future<({List<Map<String, dynamic>> options, String? defaultModel})> models(
    String provider, {
    bool refresh = false,
  }) async => (
    options: [
      {'id': 'devin-default', 'label': modelLabel},
    ],
    defaultModel: 'devin-default',
  );

  @override
  Future<Map<String, dynamic>> activeModel(
    String provider,
    String sessionId, {
    String? requestedModel,
  }) async => {'model': 'devin-default'};
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
            'kind': 'weekly',
            'percent': 62.5,
            'resetsAt': '2026-10-01T12:00:00Z',
          },
        ],
      },
    ],
  };
}

class _FakeQuotaWide extends QuotaRepository {
  _FakeQuotaWide() : super(Dio());

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
          {'label': '5h', 'kind': 'session', 'percent': 12},
          {'label': 'Daily', 'kind': 'daily', 'percent': 40},
          {'label': 'Weekly', 'kind': 'weekly', 'percent': 62.5},
          {'label': 'Monthly', 'kind': 'monthly', 'percent': 88},
        ],
      },
    ],
  };
}

Widget _app(
  Widget child, {
  double width = 900,
  QuotaRepository? quota,
  SessionsRepository? sessions,
}) => ProviderScope(
  overrides: [
    sessionsRepositoryProvider.overrideWithValue(sessions ?? _FakeSessions()),
    quotaRepositoryProvider.overrideWithValue(quota ?? _FakeQuota()),
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

  test(
    'windowMatchesModel keeps only the matching Claude family weekly cap',
    () {
      expect(windowMatchesModel('Sonnet · Weekly', 'sonnet'), isTrue);
      expect(windowMatchesModel('Sonnet · Weekly', 'opus[1m]'), isFalse);
      expect(windowMatchesModel('Opus · Weekly', 'claude-opus-4-1'), isTrue);
      expect(windowMatchesModel('Opus · Weekly', 'sonnet'), isFalse);
      expect(windowMatchesModel('Fable · Weekly', 'claude-fable-5-1'), isTrue);
      expect(windowMatchesModel('Fable · Weekly', 'opus'), isFalse);
    },
  );

  test('quotaAccountFor picks the pinned login, else the ambient one', () {
    const accounts = [
      QuotaAccount(id: 'devin', provider: 'devin'),
      QuotaAccount(id: 'claude', provider: 'claude', accountLabel: 'ambient'),
      QuotaAccount(id: 'acct-2', provider: 'claude', accountLabel: 'second'),
      QuotaAccount(id: 'acct-cx', provider: 'codex'),
    ];
    expect(quotaAccountFor(accounts, 'claude', null)?.id, 'claude');
    expect(quotaAccountFor(accounts, 'claude', 'acct-2')?.id, 'acct-2');
    // A pin from another provider never leaks another subscription's %.
    expect(quotaAccountFor(accounts, 'claude', 'acct-cx')?.id, 'claude');
    expect(quotaAccountFor(accounts, 'claude', 'gone')?.id, 'claude');
    expect(quotaAccountFor(accounts, 'gemini', null), isNull);
    // Only extra logins configured → the first of them stands in.
    expect(quotaAccountFor(accounts.sublist(2), 'claude', null)?.id, 'acct-2');
  });

  test(
    'quotaPeriodSegments keeps all present kinds in order, including 0%',
    () {
      const account = QuotaAccount(
        id: 'commandcode',
        windows: [
          QuotaWindow(label: '5h', kind: 'session', percent: 0),
          QuotaWindow(label: 'Weekly', kind: 'weekly', percent: 17),
          QuotaWindow(label: 'Monthly', kind: 'monthly', percent: 35),
        ],
      );
      expect(quotaPeriodSegments(account, 'commandcode/x'), [
        ('session', 0.0, null, '5h'),
        ('weekly', 17.0, null, 'W'),
        ('monthly', 35.0, null, 'M'),
      ]);
      expect(quotaPeriodSegments(null, 'devin'), isEmpty);
    },
  );

  test('quotaPeriodSegments marks Claude model-scoped weekly caps apart', () {
    const account = QuotaAccount(
      id: 'claude',
      windows: [
        QuotaWindow(label: '5h', kind: 'session', percent: 6),
        QuotaWindow(label: 'Weekly', kind: 'weekly', percent: 20),
        QuotaWindow(label: 'Fable · Weekly', kind: 'weekly', percent: 3),
        QuotaWindow(label: 'Opus · Weekly', kind: 'weekly', percent: 50),
      ],
    );
    expect(quotaPeriodSegments(account, 'claude-fable-5-1'), [
      ('session', 6.0, null, '5h'),
      ('weekly', 20.0, null, 'W'),
      ('weekly', 3.0, null, 'FW'),
    ]);
    expect(quotaPeriodSegments(account, 'opus').map((s) => s.$4), [
      '5h',
      'W',
      'OW',
    ]);
  });

  test('quotaTimeRemainingPercent measures the clock until reset', () {
    final now = DateTime.utc(2026, 9, 30).millisecondsSinceEpoch;
    // Weekly (7 d): reset za 3.5 d → zostało 50% czasu okna.
    expect(
      quotaTimeRemainingPercent('weekly', '2026-10-03T12:00:00Z', now),
      50,
    );
    // Tuż przed resetem → 0%; świeżo po resecie → 100%.
    expect(quotaTimeRemainingPercent('daily', '2026-09-30T00:00:00Z', now), 0);
    expect(
      quotaTimeRemainingPercent('daily', '2026-10-01T00:00:00Z', now),
      100,
    );
    expect(quotaTimeRemainingPercent('weekly', null, now), isNull);
    expect(quotaTimeRemainingPercent('weekly', 'not-a-date', now), isNull);
  });

  test('quotaToneFor flags usage overtaking the elapsed window time', () {
    // 5h: zużycie 5%, zostało 24% czasu (upłynęło 76%) → 5 < 76 → zielony.
    expect(quotaToneFor(5, 24), 'ok');
    // W: 5% zużycia przy 74% pozostałego czasu → zielony.
    expect(quotaToneFor(5, 74), 'ok');
    // M: 43% zużycia przy 33% pozostałego czasu (upłynęło 67%) → zielony.
    expect(quotaToneFor(43, 33), 'ok');
    // Zbliża się do granicy (≥75% upływu) → pomarańczowy.
    expect(quotaToneFor(37, 50), 'ok');
    expect(quotaToneFor(38, 50), 'warn');
    // Na granicy (zużycie == upływ) → pomarańczowy.
    expect(quotaToneFor(50, 50), 'warn');
    // Przekroczone: zostało 50% czasu, zużyte 51% → czerwony.
    expect(quotaToneFor(51, 50), 'critical');
    expect(quotaToneFor(5, null), 'ok');
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
    // QuotaBadge: weekly window pill renders as `62.5%W`.
    expect(find.text('62.5%W'), findsOneWidget);
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
    expect(find.text('62.5%W'), findsOneWidget);
  });

  testWidgets('quota badge stays at the right content edge', (tester) async {
    const longPath =
        '/workspace/very-long-segment/very-long-segment/'
        'very-long-segment/very-long-segment/app';
    const longModel = 'Devin Default With An Extremely Long Display Label Here';
    final wideQuota = _FakeQuotaWide();
    final longModelSessions = _FakeSessions(modelLabel: longModel);

    // Rect of the strip's content Row — the only ancestor Row sized to the
    // full width (the trailing gauge+badge Row is `MainAxisSize.min`).
    Rect stripRowRect() => tester.getRect(
      find.ancestor(
        of: find.byType(QuotaBadge),
        matching: find.byWidgetPredicate(
          (w) => w is Row && w.mainAxisSize == MainAxisSize.max,
        ),
      ),
    );

    // Rect of the decorated strip Container (the only ancestor Container
    // with a margin).
    Rect stripContainerRect() => tester.getRect(
      find.ancestor(
        of: find.byType(QuotaBadge),
        matching: find.byWidgetPredicate(
          (w) => w is Container && w.margin != null,
        ),
      ),
    );

    Future<void> pumpCase({
      required double width,
      String path = '/a',
      QuotaRepository? quota,
      SessionsRepository? sessions,
      bool menu = false,
    }) async {
      // Real surface size — overriding only MediaQuery would change the
      // breakpoint but leave the row laid out at the 800px test default.
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _app(
          SessionSubheader(
            sessionId: 's1',
            provider: 'devin',
            projectPath: path,
            showMenuButton: menu,
          ),
          width: width,
          quota: quota,
          sessions: sessions,
        ),
      );
      await tester.pumpAndSettle();

      // No RenderFlex overflow / layout exception at any combination.
      expect(tester.takeException(), isNull, reason: 'width=$width');

      final badge = tester.getRect(find.byType(QuotaBadge));
      final row = stripRowRect();
      final strip = stripContainerRect();
      final compact = width < 600;
      final margin = compact ? 6.0 : 18.0;
      final padding = compact ? 6.0 : 10.0;

      // Right edge flush with the strip's inner content edge, measured two
      // ways: against the content Row and independently against the
      // decorated Container (right - margin - 1px border - padding).
      expect(badge.right, moreOrLessEquals(row.right, epsilon: 0.6));
      expect(
        badge.right,
        moreOrLessEquals(strip.right - margin - 1 - padding, epsilon: 0.6),
      );
      // Never paints past the strip's right edge.
      expect(badge.right, lessThanOrEqualTo(strip.right + 0.5));

      // No overlap with neighbours: every left-cluster text and the
      // context gauge must end at or before badge.left.
      final leftFinders = [
        find.text('Devin'),
        find.text(longModel),
        find.text('Devin Default'),
        find.text(path, findRichText: true),
      ];
      for (final finder in leftFinders) {
        for (final e in finder.evaluate()) {
          expect(
            tester.getRect(find.byWidget(e.widget)).right,
            lessThanOrEqualTo(badge.left + 0.5),
          );
        }
      }
      for (final e in find.text('42%').evaluate()) {
        expect(
          tester.getRect(find.byWidget(e.widget)).right,
          lessThanOrEqualTo(badge.left + 0.5),
        );
      }
    }

    // Narrow compact: menu button, wide four-pill badge, long model and
    // long path — the worst overlap/overflow case.
    await pumpCase(
      width: 360,
      menu: true,
      quota: wideQuota,
      sessions: longModelSessions,
      path: longPath,
    );
    // Narrow compact, short neighbours, single-pill badge.
    await pumpCase(width: 360);
    // Medium width: long path + long model against the wide badge.
    await pumpCase(
      width: 700,
      quota: wideQuota,
      sessions: longModelSessions,
      path: longPath,
    );
    // Medium width, short neighbours.
    await pumpCase(width: 700);
    // Wider than the strip's `maxWidth: 900` cap: strip stays ≤900 and the
    // badge still sits at its right edge.
    await pumpCase(width: 1400, quota: wideQuota, path: longPath);
    expect(stripContainerRect().width, lessThanOrEqualTo(900));
  });
}
