import 'dart:convert';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/view/session_subheader.dart';
import 'package:ddagent_app/features/chat/view/transcript_view.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/state/activity_poller.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Real assistant reply the selection broke on (bare links, `→` lines, inline code, lists).
final _reply = jsonDecode(
  r'''"Linki do miejsc, w których dopisujesz adresy powrotu (Client ID są publiczne, więc mogę je podać w całości):\n\n**1. Google, klient poczty:**\nhttps://console.cloud.google.com/auth/clients/882519768295-hr3b9k26g646cs2e9kq84054i2518bn1.apps.googleusercontent.com\n→ dopisz: `https://zawai-virtual-machine.tailc03f97.ts.net:8445/email-accounts/oauth/callback`\n\n**2. Google, klient kalendarza:**\nhttps://console.cloud.google.com/auth/clients/882519768295-djq8nmi6p1jmjikgvfj9arqnm6f3q6ch.apps.googleusercontent.com\n→ dopisz: `https://zawai-virtual-machine.tailc03f97.ts.net:8445/calendar/google/callback`\n\nJeśli link nie otworzy klienta: https://console.cloud.google.com/apis/credentials, potem wybierz klienta z tym ID.\n\n**3. Microsoft Entra, aplikacja `0c58913a-…` (od razu sekcja Authentication):**\nhttps://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Authentication/appId/0c58913a-bb5f-4090-a54b-b314975e6e6d\n→ dopisz:\n- `https://zawai-virtual-machine.tailc03f97.ts.net:8445/email-accounts/oauth/microsoft/callback`\n- `https://zawai-virtual-machine.tailc03f97.ts.net:8445/calendar/outlook/callback`\n\n**4. Slack:**\nhttps://api.slack.com/apps → wybierz aplikację z Client ID `1864779475…` → **OAuth & Permissions → Redirect URLs**\n→ dopisz: `https://zawai-virtual-machine.tailc03f97.ts.net:8445/settings/slack/oauth/callback`\n\n**5. ITBoard dev:**\nhttps://zawai-virtual-machine.tailc03f97.ts.net:8445/login\n- login: `admin@devtest.local`\n\n**Następny krok:** otwórz link 3."''',
) as String;

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

SessionMessage _message(String id, {String? content}) => SessionMessage(
  id: id,
  sessionId: 's1',
  timestamp: '2025-01-01T00:00:00Z',
  provider: 'claude',
  kind: 'text',
  role: 'assistant',
  content: content ?? 'message $id',
);

Dio _dio() => Dio(BaseOptions(baseUrl: 'http://test'))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) => handler.resolve(
        Response(
          requestOptions: options,
          data: options.path.endsWith('/messages')
              ? {
                  'success': true,
                  'data': {'messages': <dynamic>[], 'total': 0, 'hasMore': false},
                }
              : options.path.contains('voice')
              ? {'success': true, 'data': <String, dynamic>{}}
              : {
                  'success': true,
                  'data': {
                    'session': {'id': 's1', 'provider': 'claude'},
                  },
                },
        ),
      ),
    ),
  );

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_transcript_reply_selection_test'); // path ignored on web
    await ChatStorage.init();
    await Hive.openBox<dynamic>('settings');
  });

  // The pane swaps the browser menu for Flutter's while hovered; a rebuild
  // after that flip used to leave the SelectionArea with nothing selectable.
  testWidgets('assistant reply with links, code and lists is selectable and copyable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.contextMenu, (_) async => null);
    String? clip;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (c) async {
      if (c.method == 'Clipboard.setData') clip = (c.arguments as Map)['text'] as String?;
      return null;
    });
    final container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(_dio()),
        chatChannelProvider.overrideWithValue(_Channel()),
        activityPollerProvider.overrideWith((ref) {}),
        quotaSnapshotProvider.overrideWith((ref) => const Stream<QuotaSnapshot?>.empty()),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TranslationProvider(
          child: const MaterialApp(
            home: Scaffold(body: TranscriptView(sessionId: 's1')),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    container
        .read(sessionMessageStoreProvider.notifier)
        .appendRealtime('s1', _message('m1', content: _reply));
    await tester.pump(const Duration(milliseconds: 200));

    // What hovering the pane does on web: swap the browser menu for Flutter's
    // (`flutter test --platform chrome` covers that path).
    if (kIsWeb) {
      await BrowserContextMenu.disableContextMenu();
      addTearDown(BrowserContextMenu.enableContextMenu);
    }
    // Any later rebuild (new rows, follow state) must keep the region alive.
    container.read(sessionMessageStoreProvider.notifier).appendRealtime('s1', _message('m2'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);

    // Web leaves Ctrl+A/Ctrl+C to the browser — invoke the region's intents
    // (what the keys and the Flutter menu trigger) from inside the message.
    BuildContext inside() => tester.element(find.textContaining('hr3b9k26', findRichText: true));
    Actions.invoke(inside(), const SelectAllTextIntent(SelectionChangedCause.keyboard));
    await tester.pump();
    Actions.invoke(inside(), CopySelectionTextIntent.copy);
    await tester.pump();
    expect(
      clip,
      allOf(contains('Linki do miejsc'), contains('hr3b9k26'), contains('otwórz link 3')),
    );
    expect(tester.takeException(), isNull);
  }, variant: const TargetPlatformVariant({TargetPlatform.linux}));
}
