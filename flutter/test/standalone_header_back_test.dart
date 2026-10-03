import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/session_subheader.dart';
import 'package:ddagent_app/features/chat/view/transcript_view.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_repository.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/state/activity_poller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _Ws extends WsClient {
  _Ws() : super(urlBuilder: () async => Uri.parse('ws://test'));

  @override
  Stream<Map<String, dynamic>> get frames => const Stream.empty();
  @override
  Stream<WsState> get states => const Stream.empty();
  @override
  WsState get state => WsState.closed;
  @override
  Future<void> connect() async {}
}

class _Channel extends ChatChannel {
  _Channel() : super(_Ws());
  @override
  Future<void> connect() async {}
}

class _FakeOrchestratorRepo extends OrchestratorRepository {
  _FakeOrchestratorRepo({this.parent}) : super(Dio());

  final String? parent;

  @override
  Future<String?> parentSession(String sessionId) async => parent;
}

Dio _dio() => Dio(BaseOptions(baseUrl: 'http://test'))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) => handler.resolve(
        Response(
          requestOptions: options,
          data: {
            'success': true,
            'data': {
              'messages': <dynamic>[],
              'total': 0,
              'hasMore': false,
              'session': {'id': 'child-1', 'provider': 'claude'},
            },
          },
        ),
      ),
    ),
  );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Hive.init('/tmp/ddagent_standalone_header_back_test');
    await ChatStorage.init();
    await Hive.openBox<dynamic>('settings');
  });

  Future<GoRouter> pumpStandalone(
    WidgetTester tester, {
    String? parent,
    String initial = '/chat/child-1',
  }) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1;

    final container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(_dio()),
        chatChannelProvider.overrideWithValue(_Channel()),
        activityPollerProvider.overrideWith((ref) {}),
        quotaSnapshotProvider.overrideWith((ref) => const Stream<QuotaSnapshot?>.empty()),
        orchestratorRepositoryProvider.overrideWithValue(_FakeOrchestratorRepo(parent: parent)),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(
          path: '/chat/:id',
          builder: (_, s) => Scaffold(
            body: TranscriptView(sessionId: s.pathParameters['id'] ?? '', standalone: true),
          ),
        ),
        GoRoute(
          path: '/sessions',
          builder: (_, _) => const Scaffold(body: Text('sessions')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TranslationProvider(
          child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump();
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('standalone delegated session shows back-to-orchestration', (tester) async {
    final router = await pumpStandalone(tester, parent: 'parent-9');

    final back = find.byTooltip('Back to orchestration');
    expect(back, findsOneWidget);

    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(router.routerDelegate.currentConfiguration.uri.path, '/chat/parent-9');
  });

  testWidgets('standalone root session has no back button', (tester) async {
    await pumpStandalone(tester);
    expect(find.byTooltip('Back to orchestration'), findsNothing);
  });
}
