import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/settings/data/agent_install.dart';
import 'package:ddagent_app/features/settings/state/provider_auth_controller.dart';
import 'package:ddagent_app/features/settings/view/sections/agents_section.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _names = {
  'claude': 'Claude',
  'cursor': 'Cursor',
  'codex': 'Codex',
  'opencode': 'OpenCode',
  'commandcode': 'Command Code',
  'antigravity': 'Antigravity',
  'devin': 'Devin',
};

const _legacyLabels = [
  'Authenticated',
  'Auth Token',
  'API Key Auth',
  'Configured via settings.json',
  'OAuth Token (long-lived)',
  'Logged in',
  'COMMAND_CODE_API_KEY',
  'Command Code account',
  'provider credentials',
  'GEMINI_API_KEY',
  'Google account',
  'Windsurf API key',
  'Environment API key',
  'Devin config',
  'ANTHROPIC_API_KEY',
  'OPENAI_API_KEY',
  'GOOGLE_GENERATIVE_AI_API_KEY',
  'GROQ_API_KEY',
  'OPENROUTER_API_KEY',
  'anthropic credentials',
  'openai credentials',
];

/// Exercises the real repository/envelope parsing without making HTTP requests.
class _Backend {
  _Backend() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final Object data;
            if (options.path.endsWith('/auth/status')) {
              data = await auth(options.path.split('/')[3]);
            } else if (options.path.endsWith('/auth/logout')) {
              logoutCalls += 1;
              data = await auth(options.path.split('/')[3]);
            } else if (options.path == '/api/provider-accounts') {
              data = {
                'accounts': [
                  {
                    'id': 'separate-account',
                    'provider': options.queryParameters['provider'],
                    'label': 'Konto zespołowe',
                    'envOverrides': <String, String>{},
                    'isDefault': false,
                  },
                ],
              };
            } else {
              throw StateError('Unexpected request: ${options.path}');
            }
            handler.resolve(
              Response<dynamic>(requestOptions: options, data: {'success': true, 'data': data}),
            );
          } on Object catch (error) {
            handler.reject(DioException(requestOptions: options, error: error));
          }
        },
      ),
    );
  }

  final dio = Dio(BaseOptions(baseUrl: 'http://test.invalid'));
  Future<Map<String, dynamic>> Function(String) auth = (_) async => {'authenticated': false};
  int logoutCalls = 0;
}

void main() {
  setUpAll(() async {
    await LocaleSettings.setLocale(AppLocale.pl);
  });
  group('ProviderAuthStatus', () {
    for (final identity in [' person@example.com ', ' my-user ']) {
      test('preserves real display identity $identity', () {
        final status = ProviderAuthStatus.fromJson({'authenticated': true, 'email': identity});
        expect(status.email, identity.trim());
        expect(status.hasRealIdentity, isTrue);
      });
    }

    for (final identity in <Object?>[null, '', '   ', 42, {}, ..._legacyLabels]) {
      test('discards missing, invalid or legacy identity: $identity', () {
        final status = ProviderAuthStatus.fromJson({'authenticated': true, 'email': identity});
        expect(status.authenticated, isTrue);
        expect(status.email, isNull);
        expect(status.hasRealIdentity, isFalse);
      });
    }

    test('missing auth flag or logout discards even a valid email', () {
      for (final authenticated in [null, false, 'true']) {
        final status = ProviderAuthStatus.fromJson({
          'authenticated': authenticated,
          'email': 'old@example.com',
        });
        expect(status.email, isNull);
        expect(status.hasRealIdentity, isFalse);
      }
      expect(ProviderAuthStatus(email: 'old@example.com').email, isNull);
    });
  });

  test('invalidation clears cached identity and ignores late responses', () async {
    final backend = _Backend();
    final requests = <Completer<Map<String, dynamic>>>[];
    backend.auth = (_) {
      final request = Completer<Map<String, dynamic>>();
      requests.add(request);
      return request.future;
    };
    final container = ProviderContainer(overrides: [dioProvider.overrideWithValue(backend.dio)]);
    addTearDown(container.dispose);
    final provider = providerAuthStatusProvider('codex');
    container.listen(provider, (_, _) {});
    await pumpEventQueue();
    requests[0].complete({'authenticated': true, 'email': 'old@example.com'});
    await pumpEventQueue();
    expect(container.read(provider).value?.email, 'old@example.com');

    container.invalidate(provider);
    expect(container.read(provider).isLoading, isTrue);
    expect(container.read(provider).value, isNull);
    await pumpEventQueue();
    container.invalidate(provider);
    container.read(provider);
    await pumpEventQueue();
    requests[2].complete({'authenticated': false, 'email': 'old@example.com'});
    await pumpEventQueue();
    expect(container.read(provider).value?.authenticated, isFalse);
    requests[1].complete({'authenticated': true, 'email': 'late@example.com'});
    await pumpEventQueue();
    expect(container.read(provider).value?.email, isNull);
    expect(container.read(provider).value?.authenticated, isFalse);
  });

  for (final entry in _names.entries) {
    testWidgets('${entry.key}: identity, missing data, logout, refresh and error', (tester) async {
      tester.view.physicalSize = const Size(1600, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      LocaleSettings.setLocaleSync(AppLocale.pl);
      addTearDown(() => LocaleSettings.setLocaleSync(AppLocale.en));

      final backend = _Backend();
      Map<String, dynamic> current = {'authenticated': true, 'email': ' person@example.com '};
      backend.auth = (provider) async => provider == entry.key ? current : {'authenticated': false};
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dioProvider.overrideWithValue(backend.dio)],
          child: TranslationProvider(
            child: MaterialApp(
              theme: AppTheme.light(),
              home: const Scaffold(body: AgentsSection()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(entry.value).first);
      await tester.pumpAndSettle();

      final authT = t.settings.agents.authStatus;
      final defaultLabel = t.settings.agents.accounts.kDefault;
      final fallbackLabel = authT.providerAccount(provider: entry.value);
      void expectIdentity(String identity) {
        expect(find.text(authT.loggedInAs(email: identity)), findsOneWidget);
        expect(find.text('$defaultLabel · $identity'), findsOneWidget);
        expect(find.text('Konto zespołowe'), findsOneWidget);
        expect(find.text('Konto zespołowe · $identity'), findsNothing);
      }

      // Authenticated but no real account identity: the status card and the
      // ambient row fall back to the provider-scoped label.
      void expectFallback() {
        expect(find.text(fallbackLabel), findsOneWidget);
        expect(find.text('$defaultLabel · $fallbackLabel'), findsOneWidget);
        expect(find.textContaining('person@example.com'), findsNothing);
        expect(find.textContaining('my-user'), findsNothing);
      }

      void expectNoIdentity() {
        expect(find.text(defaultLabel), findsOneWidget);
        expect(find.textContaining(' · '), findsNothing);
        expect(find.textContaining('person@example.com'), findsNothing);
        expect(find.textContaining('my-user'), findsNothing);
      }

      Future<void> refresh() async {
        await tester.tap(find.byTooltip(t.common.buttons.refresh));
        await tester.pumpAndSettle();
      }

      expectIdentity('person@example.com');
      current = {'authenticated': true, 'email': ' my-user '};
      await refresh();
      expectIdentity('my-user');

      for (final identity in <String?>[null, '', '   ', ..._legacyLabels]) {
        // Return to a known account before each loss of identity.
        current = {'authenticated': true, 'email': 'person@example.com'};
        await refresh();
        expectIdentity('person@example.com');
        current = {'authenticated': true, 'email': identity, 'method': 'api_key'};
        await refresh();
        expectFallback();
        expect(find.text(authT.connected), findsOneWidget);
      }

      current = {'authenticated': true, 'email': 'person@example.com'};
      await refresh();
      current = {'authenticated': false, 'email': 'person@example.com'};
      await refresh();
      expectNoIdentity();
      expect(find.text(authT.notConnected), findsOneWidget);

      current = {'authenticated': true, 'email': 'person@example.com'};
      await refresh();
      final pending = Completer<Map<String, dynamic>>();
      backend.auth = (_) async {
        await pending.future;
        throw StateError('connection lost');
      };
      await tester.tap(find.byTooltip(t.common.buttons.refresh));
      await tester.pump();
      expectNoIdentity();
      expect(find.text(authT.checkingAuth), findsOneWidget);
      pending.complete({});
      await tester.pumpAndSettle();
      expectNoIdentity();
      expect(find.text(authT.notConnected), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('missing CLI shows the install card instead of login', (tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    LocaleSettings.setLocaleSync(AppLocale.pl);
    addTearDown(() => LocaleSettings.setLocaleSync(AppLocale.en));

    final backend = _Backend();
    backend.auth = (_) async => {'installed': false, 'authenticated': false};
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(backend.dio)],
        child: TranslationProvider(
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: AgentsSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final installT = t.settings.agents.install;
    expect(find.text(installT.title(agent: 'Claude')), findsOneWidget);
    expect(find.text(providerInstallCommand('claude')), findsOneWidget);
    expect(find.text(installT.button), findsOneWidget);
    expect(find.text(installT.docs), findsOneWidget);
    expect(find.text(t.settings.agents.accounts.title), findsNothing);
    expect(find.text(t.settings.agents.login.button), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('logout confirms, calls the server, and refreshes the status', (tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    LocaleSettings.setLocaleSync(AppLocale.pl);
    addTearDown(() => LocaleSettings.setLocaleSync(AppLocale.en));

    final backend = _Backend();
    var loggedOut = false;
    backend.auth = (provider) async => provider == 'claude' && !loggedOut
        ? {'authenticated': true, 'email': 'person@example.com', 'canLogout': true}
        : {'authenticated': false, 'canLogout': true};
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(backend.dio)],
        child: TranslationProvider(
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: AgentsSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Claude').first);
    await tester.pumpAndSettle();

    final logoutT = t.settings.agents.logout;
    Finder logoutButton() => find.widgetWithText(AppButton, logoutT.button);
    expect(logoutButton(), findsOneWidget);

    // Cancelling the confirmation leaves the login untouched.
    await tester.tap(logoutButton());
    await tester.pumpAndSettle();
    expect(find.text(logoutT.confirmTitle(agent: 'Claude')), findsOneWidget);
    await tester.tap(find.widgetWithText(AppButton, t.common.buttons.cancel));
    await tester.pumpAndSettle();
    expect(backend.logoutCalls, 0);

    loggedOut = true;
    await tester.tap(logoutButton());
    await tester.pumpAndSettle();
    await tester.tap(logoutButton().last);
    await tester.pumpAndSettle();

    expect(backend.logoutCalls, 1);
    expect(find.text(t.settings.agents.authStatus.notConnected), findsOneWidget);
    expect(find.text(logoutT.success), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
