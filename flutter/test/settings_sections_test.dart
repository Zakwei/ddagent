import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/settings/state/api_credentials_controller.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

Dio _fakeDio(Map<String, dynamic> routes) {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        final key = '${o.method} ${o.path}';
        var res = routes[key];
        if (res is Function) res = res(o);
        if (res is Exception) {
          h.reject(
            DioException(
              requestOptions: o,
              response: Response(
                requestOptions: o,
                statusCode: 500,
                data: {'error': res.toString()},
              ),
            ),
          );
        } else {
          h.resolve(Response(requestOptions: o, data: res));
        }
      },
    ),
  );
  return dio;
}

ProviderContainer _container(Map<String, dynamic> routes) =>
    ProviderContainer(overrides: [dioProvider.overrideWithValue(_fakeDio(routes))]);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('/tmp/ddagent_settings_sections_test');
  });

  setUp(() async {
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
    await Hive.box<dynamic>('settings').clear();
  });

  group('UiPreferencesController', () {
    test('defaults match the web uiPreferences blob', () {
      final prefs = _container({}).read(uiPreferencesProvider);
      expect(prefs.focusFollowsPointer, isFalse);
      expect(prefs.showThinking, isTrue);
      expect(prefs.sidebarVisible, isTrue);
    });

    test('toggle persists into the settings box', () async {
      final container = _container({});
      container.read(uiPreferencesProvider.notifier).setFocusFollowsPointer(true);
      expect(container.read(uiPreferencesProvider).focusFollowsPointer, isTrue);
      final stored = Hive.box<dynamic>('settings').get('uiPreferences') as Map;
      expect(stored['focusFollowsPointer'], isTrue);
      // A fresh controller rehydrates the stored value.
      expect(_container({}).read(uiPreferencesProvider).focusFollowsPointer, isTrue);
    });
  });

  group('ApiCredentialsController', () {
    test('loads snake_case keys + github_token credentials', () async {
      final container = _container({
        'GET /api/settings/api-keys': {
          'apiKeys': [
            {
              'id': 3,
              'key_name': 'prod',
              'api_key': 'abc1234567...',
              'created_at': '2026-01-02T00:00:00Z',
              'is_active': 1,
            },
          ],
        },
        'GET /api/settings/credentials': {
          'credentials': [
            {
              'id': 7,
              'credential_name': 'repos',
              'credential_type': 'github_token',
              'description': 'work',
              'created_at': '2026-01-03T00:00:00Z',
              'is_active': 0,
            },
          ],
        },
      });
      final provider = apiCredentialsProvider;
      // Wait for the microtask refresh kicked off in build().
      await Future<void>.delayed(Duration.zero);
      await container.read(provider.notifier).refresh();
      final state = container.read(provider);
      expect(state.loading, isFalse);
      expect(state.apiKeys.single.name, 'prod');
      expect(state.apiKeys.single.maskedKey, 'abc1234567...');
      expect(state.apiKeys.single.isActive, isTrue);
      expect(state.githubCredentials.single.name, 'repos');
      expect(state.githubCredentials.single.isActive, isFalse);
      container.dispose();
    });

    test('createApiKey stores the one-time key, toggle sends isActive', () async {
      final calls = <String>[];
      final container = _container({
        'GET /api/settings/api-keys': (RequestOptions o) => {
          'apiKeys': calls.contains('created')
              ? <Map<String, dynamic>>[
                  {'id': 1, 'key_name': 'x', 'api_key': 'k...', 'is_active': 1},
                ]
              : <Map<String, dynamic>>[],
        },
        'GET /api/settings/credentials': {'credentials': <Map<String, dynamic>>[]},
        'POST /api/settings/api-keys': (RequestOptions o) {
          calls.add('created');
          return {
            'success': true,
            'apiKey': {'id': 1, 'keyName': 'x', 'apiKey': 'full-secret'},
          };
        },
        'PATCH /api/settings/api-keys/1/toggle': (RequestOptions o) {
          calls.add('toggle:${(o.data as Map)['isActive']}');
          return {'success': true};
        },
      });
      final ctrl = container.read(apiCredentialsProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      await ctrl.refresh();

      expect(await ctrl.createApiKey('x'), isNull);
      expect(container.read(apiCredentialsProvider).newlyCreatedKey?.key, 'full-secret');
      container.read(apiCredentialsProvider.notifier).dismissNewlyCreatedKey();
      expect(container.read(apiCredentialsProvider).newlyCreatedKey, isNull);

      final key = container.read(apiCredentialsProvider).apiKeys.single;
      expect(await ctrl.toggleApiKey(key), isNull);
      expect(calls, contains('toggle:false'));
      container.dispose();
    });
  });
}
