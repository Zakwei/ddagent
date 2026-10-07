import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FakeWs extends WsClient {
  FakeWs() : super(urlBuilder: () async => Uri.parse('ws://t'));

  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();

  @override
  Stream<Map<String, dynamic>> get frames => _frames.stream;
  @override
  Stream<WsState> get states => _states.stream;
  @override
  WsState get state => WsState.closed;
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

void main() {
  late ProviderContainer container;
  final putBodies = <List<String>>[];

  const arg = (sessionId: 's1', projectId: null, provider: 'claude', projectPath: null);

  Dio fakeDio({required List<String> serverFavorites}) {
    final dio = Dio(BaseOptions(baseUrl: 'http://t'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          if (o.path.endsWith('/favorite-models')) {
            final ids = o.method == 'PUT'
                ? [for (final id in (o.data as Map)['modelIds'] as List) '$id']
                : serverFavorites;
            if (o.method == 'PUT') putBodies.add(ids);
            h.resolve(
              Response(
                requestOptions: o,
                data: {
                  'success': true,
                  'data': {'provider': 'claude', 'modelIds': ids},
                },
              ),
            );
            return;
          }
          final data = switch (o.path) {
            '/api/providers/claude/models' => {
              'models': [
                {'id': 'm1', 'label': 'M1'},
              ],
            },
            '/api/providers/claude/capabilities' => {'permissionModes': const <String>[]},
            '/api/queue' => {'messages': const <Map<String, dynamic>>[]},
            _ => <String, dynamic>{},
          };
          h.resolve(Response(requestOptions: o, data: {'success': true, 'data': data}));
        },
      ),
    );
    return dio;
  }

  ProviderContainer make({required List<String> serverFavorites, FakeWs? ws}) => ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(fakeDio(serverFavorites: serverFavorites)),
      chatChannelProvider.overrideWithValue(ChatChannel(ws ?? FakeWs())..start()),
    ],
  );

  Future<void> pump([int ms = 200]) => Future<void>.delayed(Duration(milliseconds: ms));

  setUpAll(() async {
    Hive.init('/tmp/ddagent_composer_favorites_hive');
    await ChatStorage.init();
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() async {
    putBodies.clear();
    await Hive.box<dynamic>('settings').delete('favorite_models_claude');
  });

  tearDown(() => container.dispose());

  test('loads favorites from the server', () async {
    container = make(serverFavorites: ['m1', 'm2']);
    container.listen(composerProvider(arg), (_, _) {});
    await pump();
    expect(container.read(composerProvider(arg)).favorites, {'m1', 'm2'});
  });

  test('migrates a legacy Hive set once when the server has none', () async {
    await Hive.box<dynamic>('settings').put('favorite_models_claude', '["legacy"]');
    container = make(serverFavorites: const []);
    container.listen(composerProvider(arg), (_, _) {});
    await pump();
    expect(putBodies, [
      ['legacy'],
    ]);
    expect(container.read(composerProvider(arg)).favorites, {'legacy'});
    // Dropped after migration so it cannot be re-imported.
    expect(Hive.box<dynamic>('settings').get('favorite_models_claude'), isNull);
  });

  test('toggleFavorite persists the whole set to the server', () async {
    container = make(serverFavorites: ['m1']);
    container.listen(composerProvider(arg), (_, _) {});
    await pump();
    container.read(composerProvider(arg).notifier).toggleFavorite('m2');
    await pump();
    expect(putBodies.last, containsAll(<String>['m1', 'm2']));
  });
}
