import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/chat/view/composer_model_menu.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The composer mode/model popovers are anchored to the composer box. The
/// compact `+` action sheet re-hosts the option bar in its own route, so a
/// menu opened from there must anchor to its trigger instead — otherwise it
/// lands behind the sheet, at the top of the screen, far from the tap.
class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://t'));

  final inbound = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();

  @override
  Stream<Map<String, dynamic>> get frames => inbound.stream;
  @override
  Stream<WsState> get states => _states.stream;
  @override
  WsState get state => WsState.closed;
  @override
  Future<void> connect() async {}
}

Dio _fakeDio() {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        final data = switch (o.path) {
          '/api/providers/claude/models' => {
            'models': [
              {'id': 'm1', 'label': 'Model One'},
            ],
          },
          '/api/providers/claude/sessions/s1/active-model' => {'id': 'm1'},
          '/api/providers/claude/capabilities' => {
            'permissionModes': ['default', 'auto', 'plan', 'bypassPermissions'],
          },
          '/api/providers/capabilities' => {
            'permissionModes': ['default', 'auto', 'plan', 'bypassPermissions'],
          },
          '/api/provider-accounts' => {'accounts': const <dynamic>[]},
          '/api/queue' => {'messages': const <Map<String, dynamic>>[]},
          '/api/commands/list' => {'builtIn': const <dynamic>[], 'custom': const <dynamic>[]},
          '/api/providers/claude/skills' => {'skills': const <dynamic>[]},
          '/api/providers/sessions/recent' => {'conversations': const <Map<String, dynamic>>[]},
          _ => <String, dynamic>{},
        };
        h.resolve(Response(requestOptions: o, data: {'success': true, 'data': data}));
      },
    ),
  );
  return dio;
}

/// Insets must be set on the test view (not an injected `MediaQuery`), because
/// the popover lives in the app's `Overlay` — above the route, so it only sees
/// the view-derived `MediaQuery`.
void _setView(WidgetTester tester, {double keyboard = 0, double topInset = 0}) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(400, 800);
  tester.view.padding = FakeViewPadding(top: topInset);
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  addTearDown(tester.view.reset);
}

Widget _app() => TranslationProvider(
  child: ProviderScope(
    overrides: [
      dioProvider.overrideWithValue(_fakeDio()),
      chatChannelProvider.overrideWithValue(ChatChannel(_FakeWs())..start()),
    ],
    child: MaterialApp(
      theme: AppTheme.ocChat(),
      home: const Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 400,
            child: ChatComposer(sessionId: 's1', projectId: 'p1'),
          ),
        ),
      ),
    ),
  ),
);

/// Mirrors the app's `ShellRoute`: the chat page lives in a nested navigator
/// inside a `Scaffold` body, which shrinks above the keyboard (and strips
/// `viewInsets` from its subtree), so that navigator's overlay is shorter
/// than the screen.
Widget _shellApp() => TranslationProvider(
  child: ProviderScope(
    overrides: [
      dioProvider.overrideWithValue(_fakeDio()),
      chatChannelProvider.overrideWithValue(ChatChannel(_FakeWs())..start()),
    ],
    child: MaterialApp(
      theme: AppTheme.ocChat(),
      home: Scaffold(
        body: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => const Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 400,
                  child: ChatComposer(sessionId: 's1', projectId: 'p1'),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);

Finder _modeTrigger() => find.byIcon(LucideIcons.hand);

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_composer_menu_hive');
    await ChatStorage.init();
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() {
    ChatStorage.writeDraft(ChatStorage.draftKey(sessionId: 's1'), '');
    Hive.box<dynamic>('settings').delete('command_history_p1');
  });

  testWidgets('compact footer: mode menu opens just above the composer', (tester) async {
    _setView(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final trigger = _modeTrigger();
    expect(trigger, findsOneWidget);
    final trigRect = tester.getRect(trigger);

    await tester.tap(trigger);
    await tester.pumpAndSettle();

    final menu = tester.getRect(find.byType(ComposerMenuSurface));
    // The popover still grows above the whole composer box, right-aligned to
    // the trigger.
    expect(menu.right, moreOrLessEquals(trigRect.right, epsilon: 1));
    expect(menu.left, greaterThanOrEqualTo(-0.5));
    expect(menu.bottom, lessThan(trigRect.top));
  });

  testWidgets('compact action sheet: mode menu opens next to its trigger', (tester) async {
    _setView(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // The option bar is re-hosted inside the `+` bottom sheet.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    final sheetTrigger = find.descendant(of: find.byType(BottomSheet), matching: _modeTrigger());
    expect(sheetTrigger, findsOneWidget);
    final trigRect = tester.getRect(sheetTrigger);
    final sheetRect = tester.getRect(find.byType(BottomSheet));

    await tester.tap(sheetTrigger);
    await tester.pumpAndSettle();

    final menu = tester.getRect(find.byType(ComposerMenuSurface));
    // Anchored to the tapped control: 8px above it and right-aligned to it,
    // not stranded at the top of the screen behind the sheet (the old bug put
    // its bottom well inside the sheet at ~y464 while the trigger sat at
    // ~y745).
    expect(trigRect.top - menu.bottom, moreOrLessEquals(8, epsilon: 1));
    expect(menu.right, moreOrLessEquals(trigRect.right, epsilon: 1));
    expect(menu.bottom, greaterThan(sheetRect.top));
  });

  testWidgets('footer menu with the keyboard open stays between status bar and keyboard', (
    tester,
  ) async {
    // Keyboard open (300px) and a 40px status bar.
    _setView(tester, keyboard: 300, topInset: 40);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(_modeTrigger());
    await tester.pumpAndSettle();

    final menu = tester.getRect(find.byType(ComposerMenuSurface));
    // Never behind the status bar, never behind the keyboard.
    expect(menu.top, greaterThanOrEqualTo(40 - 0.5));
    expect(menu.bottom, lessThanOrEqualTo(800 - 300 + 0.5));
  });

  testWidgets('shell layout with the keyboard open: menu sits right above the composer', (
    tester,
  ) async {
    _setView(tester, keyboard: 300, topInset: 40);
    await tester.pumpWidget(_shellApp());
    await tester.pumpAndSettle();

    final trigger = _modeTrigger();
    final trigRect = tester.getRect(trigger);
    // The composer is lifted above the keyboard by the shrinking shell body.
    expect(trigRect.bottom, lessThanOrEqualTo(800 - 300 + 0.5));

    await tester.tap(trigger);
    await tester.pumpAndSettle();

    final menu = tester.getRect(find.byType(ComposerMenuSurface));
    // Old bug: the nested navigator's overlay ended at the keyboard top while
    // the anchor measured from the screen bottom, so the menu floated a whole
    // keyboard height too high.
    expect(menu.bottom, lessThan(trigRect.top));
    // Above the whole composer box (~100px over the footer trigger), not ~400.
    expect(trigRect.top - menu.bottom, lessThan(150));
  });

  testWidgets('action-sheet menu with the keyboard open does not fall behind it', (tester) async {
    _setView(tester, keyboard: 300, topInset: 40);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    final sheetTrigger = find.descendant(of: find.byType(BottomSheet), matching: _modeTrigger());
    await tester.tap(sheetTrigger);
    await tester.pumpAndSettle();

    final menu = tester.getRect(find.byType(ComposerMenuSurface));
    expect(menu.top, greaterThanOrEqualTo(40 - 0.5));
    expect(menu.bottom, lessThanOrEqualTo(800 - 300 + 0.5));
  });

  testWidgets('opening the compact + sheet drops the composer focus (keyboard closes)', (
    tester,
  ) async {
    _setView(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final field = find.byType(TextField).first;
    await tester.tap(field);
    await tester.pumpAndSettle();
    final node = tester.widget<TextField>(field).focusNode;
    expect(node?.hasFocus, isTrue);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // A route-level sheet cannot dodge the keyboard, so focus must be dropped
    // first — otherwise the sheet (and the option bar it re-hosts) opens behind
    // it.
    expect(node?.hasFocus, isFalse);
  });
}
