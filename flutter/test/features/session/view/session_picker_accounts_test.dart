import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/provider_accounts/data/provider_accounts_repository.dart';
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/workspace/view/session_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Inert `/ws` transport — the picker only needs the channel's `events`
/// stream to exist; nothing is emitted in these tests.
class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://test'));

  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();

  @override
  Stream<Map<String, dynamic>> get frames => _frames.stream;
  @override
  Stream<WsState> get states => _states.stream;
  @override
  WsState get state => WsState.closed;

  @override
  void send(Map<String, dynamic> frame) {}
  @override
  Future<void> connect() async {}
  @override
  Future<void> close() async {}
  @override
  Future<void> dispose() async {
    await _frames.close();
    await _states.close();
  }
}

class _FakeSessions extends SessionsRepository {
  _FakeSessions() : super(Dio());

  @override
  Future<Map<String, dynamic>> capabilities([String? provider]) async => {
    'providers': [
      {'provider': 'claude'},
      {'provider': 'codex'},
    ],
  };

  @override
  Future<SessionsPage> recent({int limit = 40, int offset = 0}) async => const SessionsPage();
}

class _FakeProjects extends ProjectsRepository {
  _FakeProjects() : super(Dio());

  @override
  Future<List<Project>> list({
    bool skipSync = false,
    int? sessionsLimit,
    int? sessionsOffset,
  }) async => const [];

  @override
  Future<List<Project>> archived() async => const [];
}

class _FakeAccounts extends ProviderAccountsRepository {
  _FakeAccounts(this._accounts, {this.error}) : super(Dio());

  final List<ProviderAccount> _accounts;
  final Object? error;

  @override
  Future<List<ProviderAccount>> list() async {
    if (error != null) throw error!;
    return _accounts;
  }
}

class _FakeQuota extends QuotaRepository {
  _FakeQuota(this._snapshot) : super(Dio());

  final Map<String, dynamic> _snapshot;

  @override
  Future<Map<String, dynamic>> snapshot() async => _snapshot;
}

/// Two providers; `claude` carries a healthy and a danger account so the
/// quota-tone dots can be asserted in both colours.
final _accounts = <ProviderAccount>[
  const ProviderAccount(id: 'claude-1', provider: 'claude', label: 'Primary'),
  const ProviderAccount(id: 'claude-2', provider: 'claude', label: 'Backup'),
  const ProviderAccount(id: 'codex-1', provider: 'codex', label: 'Codex Default'),
];

final _quotaSnapshot = <String, dynamic>{
  'overview': {'watchThreshold': 75, 'dangerThreshold': 90},
  'accounts': [
    {
      'id': 'claude-1',
      'provider': 'claude',
      'status': 'active',
      'quality': 'live',
      'windows': [
        {'label': 'Weekly', 'percent': 8},
      ],
    },
    {
      'id': 'claude-2',
      'provider': 'claude',
      'status': 'active',
      'quality': 'live',
      'windows': [
        {'label': 'Weekly', 'percent': 97},
      ],
    },
    {
      'id': 'codex-1',
      'provider': 'codex',
      'status': 'active',
      'quality': 'live',
      'windows': [
        {'label': 'Weekly', 'percent': 40},
      ],
    },
  ],
};

Widget _harness({
  required List<ProviderAccount> accounts,
  required void Function(String provider, String? accountId) onNewChat,
  Map<String, dynamic>? quota,
  Object? accountsError,
}) {
  final channel = ChatChannel(_FakeWs())..start();
  addTearDown(channel.dispose);
  return ProviderScope(
    overrides: [
      chatChannelProvider.overrideWithValue(channel),
      sessionsRepositoryProvider.overrideWithValue(_FakeSessions()),
      projectsRepositoryProvider.overrideWithValue(_FakeProjects()),
      providerAccountsRepositoryProvider.overrideWithValue(
        _FakeAccounts(accounts, error: accountsError),
      ),
      quotaRepositoryProvider.overrideWithValue(_FakeQuota(quota ?? _quotaSnapshot)),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: SessionPickerPane(
          openSessionIds: const {},
          processingSessionIds: const {},
          onSelectSession: (_) {},
          onNewChat: (provider, {accountId}) => onNewChat(provider, accountId),
          canCancel: true,
          onCancel: () {},
        ),
      ),
    ),
  );
}

/// Opens the provider dialog through the pane's "+ New chat" row.
Future<void> _openPicker(WidgetTester t) async {
  await t.tap(find.text('+ New chat'));
  await t.pumpAndSettle();
}

/// Colour of the 10px quota dot rendered on the account row with [label].
Color _dotColor(WidgetTester t, String label) {
  final row = find.ancestor(of: find.text(label), matching: find.byType(Row)).first;
  final dot = find.descendant(of: row, matching: find.byType(Container)).first;
  final decoration = t.widget<Container>(dot).decoration;
  return (decoration! as BoxDecoration).color!;
}

void main() {
  testWidgets('groups accounts by provider and paints quota-tone dots', (t) async {
    final picks = <(String, String?)>[];
    await t.pumpWidget(_harness(accounts: _accounts, onNewChat: (p, a) => picks.add((p, a))));
    await t.pumpAndSettle();

    await _openPicker(t);

    // Provider headers plus one row per named account.
    expect(find.text('claude'), findsOneWidget);
    expect(find.text('codex'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Backup'), findsOneWidget);
    expect(find.text('Codex Default'), findsOneWidget);

    // Healthy window → emerald; exhausted window → red.
    expect(_dotColor(t, 'Primary'), quotaToneColor(QuotaTone.safe));
    expect(_dotColor(t, 'Backup'), quotaToneColor(QuotaTone.danger));
    expect(_dotColor(t, 'Codex Default'), quotaToneColor(QuotaTone.safe));

    // Tapping a row pins both the provider and the account id.
    await t.tap(find.text('Backup'));
    await t.pumpAndSettle();
    expect(picks, hasLength(1));
    expect(picks.single.$1, 'claude');
    expect(picks.single.$2, 'claude-2');
  });

  testWidgets('falls back to a flat provider list when the accounts API errors', (t) async {
    final picks = <(String, String?)>[];
    await t.pumpWidget(
      _harness(
        accounts: const [],
        accountsError: const ServerError('accounts down', 500),
        onNewChat: (p, a) => picks.add((p, a)),
      ),
    );
    await t.pumpAndSettle();

    await _openPicker(t);

    // No account rows — just the raw providers.
    expect(find.text('Primary'), findsNothing);
    expect(find.text('claude'), findsOneWidget);
    expect(find.text('codex'), findsOneWidget);

    await t.tap(find.text('claude'));
    await t.pumpAndSettle();
    expect(picks, hasLength(1));
    expect(picks.single.$1, 'claude');
    expect(picks.single.$2, isNull);
  });

  testWidgets('falls back to a flat provider list when the accounts API is empty', (t) async {
    final picks = <(String, String?)>[];
    await t.pumpWidget(_harness(accounts: const [], onNewChat: (p, a) => picks.add((p, a))));
    await t.pumpAndSettle();

    await _openPicker(t);

    expect(find.text('Primary'), findsNothing);
    expect(find.text('claude'), findsOneWidget);
    expect(find.text('codex'), findsOneWidget);

    await t.tap(find.text('codex'));
    await t.pumpAndSettle();
    expect(picks, hasLength(1));
    expect(picks.single.$1, 'codex');
    expect(picks.single.$2, isNull);
  });
}
