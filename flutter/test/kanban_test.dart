import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/kanban/data/kanban_repository.dart';
import 'package:ddagent_app/features/kanban/state/kanban_controller.dart';
import 'package:ddagent_app/features/kanban/view/kanban_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeKanbanRepository extends KanbanRepository {
  FakeKanbanRepository() : super(Dio());

  final calls = <String>[];
  List<KanbanCard> cardsList = [];
  Map<String, dynamic> configMap = {
    'columns': [
      'backlog',
      'ready',
      'working',
      'needs_decision',
      'done',
      'archived',
    ],
  };
  Map<String, List<KanbanComment>> commentsMap = {};
  Object? errorToThrow;

  void _call(String name) => calls.add(name);

  @override
  Future<List<KanbanCard>> cards(String projectId, {bool includeArchived = false}) async {
    _call('cards:$projectId');
    if (errorToThrow != null) throw errorToThrow!;
    return List.from(cardsList);
  }

  @override
  Future<Map<String, dynamic>> boardConfig(String projectId) async {
    _call('boardConfig:$projectId');
    if (errorToThrow != null) throw errorToThrow!;
    return Map.from(configMap);
  }

  @override
  Future<KanbanCard> create(String projectId, Map<String, dynamic> body) async {
    _call('create:$projectId:${body['title']}');
    if (errorToThrow != null) throw errorToThrow!;
    final card = KanbanCard(
      cardId: 'card-${cardsList.length + 1}',
      projectId: projectId,
      title: body['title'] as String?,
      status: body['status'] as String? ?? 'backlog',
      position: cardsList.length,
      raw: body,
    );
    cardsList.add(card);
    return card;
  }

  @override
  Future<KanbanCard> update(String cardId, Map<String, dynamic> body) async {
    _call('update:$cardId');
    if (errorToThrow != null) throw errorToThrow!;
    final index = cardsList.indexWhere((c) => c.cardId == cardId);
    if (index >= 0) {
      final old = cardsList[index];
      final updated = old.copyWith(
        title: body['title'] as String? ?? old.title,
        status: body['status'] as String? ?? old.status,
        position: body['position'] as int? ?? old.position,
        raw: {...old.raw, ...body},
      );
      cardsList[index] = updated;
      return updated;
    }
    final created = KanbanCard.fromApi({'cardId': cardId, ...body});
    cardsList.add(created);
    return created;
  }

  @override
  Future<void> delete(String cardId) async {
    _call('delete:$cardId');
    if (errorToThrow != null) throw errorToThrow!;
    cardsList.removeWhere((c) => c.cardId == cardId);
  }

  @override
  Future<void> move(String cardId, String status, int position) async {
    _call('move:$cardId:$status:$position');
    if (errorToThrow != null) throw errorToThrow!;
    final index = cardsList.indexWhere((c) => c.cardId == cardId);
    if (index >= 0) {
      cardsList[index] = cardsList[index].copyWith(
        status: status,
        position: position,
      );
    }
  }

  @override
  Future<void> abort(String cardId) async {
    _call('abort:$cardId');
    if (errorToThrow != null) throw errorToThrow!;
    final index = cardsList.indexWhere((c) => c.cardId == cardId);
    if (index >= 0) {
      cardsList[index] = cardsList[index].copyWith(status: 'backlog');
    }
  }

  @override
  Future<List<KanbanComment>> comments(String cardId) async {
    _call('comments:$cardId');
    if (errorToThrow != null) throw errorToThrow!;
    return List.from(commentsMap[cardId] ?? []);
  }

  @override
  Future<void> addComment(String cardId, String body) async {
    _call('addComment:$cardId:$body');
    if (errorToThrow != null) throw errorToThrow!;
    final list = commentsMap[cardId] ?? <KanbanComment>[];
    list.add(
      KanbanComment(
        id: 'cm-${list.length + 1}',
        cardId: cardId,
        body: body,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    commentsMap[cardId] = list;
  }
}

class FakeChatChannel extends ChatChannel {
  FakeChatChannel() : super(WsClient(urlBuilder: () async => Uri.parse('ws://t')));

  final _controller = StreamController<ServerEvent>.broadcast();

  @override
  Stream<ServerEvent> get events => _controller.stream;

  void emit(Map<String, dynamic> raw) {
    _controller.add(ServerEvent(raw: raw));
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

Widget _buildKanbanTestApp({
  required FakeKanbanRepository repo,
  FakeChatChannel? channel,
  String projectId = 'test-proj',
}) {
  return ProviderScope(
    overrides: [
      kanbanRepositoryProvider.overrideWithValue(repo),
      if (channel != null) chatChannelProvider.overrideWithValue(channel),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: KanbanScreen(projectId: projectId),
    ),
  );
}

Future<void> _pumpKanbanScreen(
  WidgetTester tester, {
  required FakeKanbanRepository repo,
  FakeChatChannel? channel,
  String projectId = 'test-proj',
}) async {
  tester.view.physicalSize = const Size(1920, 1080);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    _buildKanbanTestApp(repo: repo, channel: channel, projectId: projectId),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('1. Testy jednostkowe KanbanController', () {
    late FakeKanbanRepository repo;
    late FakeChatChannel channel;
    late ProviderContainer container;
    late KanbanController controller;

    setUp(() {
      repo = FakeKanbanRepository();
      channel = FakeChatChannel();
      container = ProviderContainer(
        overrides: [
          kanbanRepositoryProvider.overrideWithValue(repo),
          chatChannelProvider.overrideWithValue(channel),
        ],
      );
      controller = container.read(kanbanControllerProvider.notifier);
    });

    tearDown(() {
      channel.close();
      container.dispose();
    });

    test('Poprawne ładowanie kart i konfiguracji tablicy', () async {
      repo.cardsList = [
        const KanbanCard(
          cardId: 'c1',
          projectId: 'p1',
          title: 'Card 1',
          status: 'backlog',
          position: 0,
        ),
        const KanbanCard(
          cardId: 'c2',
          projectId: 'p1',
          title: 'Card 2',
          status: 'ready',
          position: 1,
        ),
      ];
      repo.configMap = {
        'columns': ['backlog', 'ready', 'working', 'needs_decision', 'done'],
        'defaultProvider': 'anthropic',
      };

      await controller.load('p1');

      final state = container.read(kanbanControllerProvider);
      expect(state.isLoading, isFalse);
      expect(state.cards.length, equals(2));
      expect(state.cards[0].title, equals('Card 1'));
      expect(state.cards[1].title, equals('Card 2'));
      expect(state.boardConfig['defaultProvider'], equals('anthropic'));
      expect(repo.calls, contains('cards:p1'));
      expect(repo.calls, contains('boardConfig:p1'));
    });

    test('Operacje CRUD na kartach (create, update, delete)', () async {
      await controller.load('p1');

      // Create
      final newCard = await controller.createCard({
        'title': 'New Feature',
        'status': 'backlog',
      }, projectId: 'p1');
      expect(newCard, isNotNull);
      expect(newCard!.title, equals('New Feature'));
      expect(container.read(kanbanControllerProvider).cards.length, equals(1));
      expect(repo.calls, contains('create:p1:New Feature'));

      final cardId = newCard.cardId;

      // Update
      final updatedCard = await controller.updateCard(cardId, {
        'title': 'Updated Feature',
      });
      expect(updatedCard, isNotNull);
      expect(updatedCard!.title, equals('Updated Feature'));
      expect(
        container.read(kanbanControllerProvider).cards.first.title,
        equals('Updated Feature'),
      );
      expect(repo.calls, contains('update:$cardId'));

      // Delete
      await controller.deleteCard(cardId);
      expect(container.read(kanbanControllerProvider).cards.isEmpty, isTrue);
      expect(repo.calls, contains('delete:$cardId'));
    });

    test(
      'Przenoszenie kart (move) między kolumnami i zmiana pozycji (optymistyczna zmiana + rollback na błąd)',
      () async {
        repo.cardsList = [
          const KanbanCard(
            cardId: 'c1',
            projectId: 'p1',
            title: 'Card 1',
            status: 'backlog',
            position: 0,
          ),
        ];
        await controller.load('p1');

        // Sukces: optymistyczna zmiana i wywołanie API
        final moveSuccess = await controller.moveCard('c1', 'ready', 3);
        expect(moveSuccess, isTrue);
        expect(repo.calls, contains('move:c1:ready:3'));
        final readyCards =
            container.read(kanbanControllerProvider).cardsForStatus('ready');
        expect(readyCards.length, equals(1));
        expect(readyCards.first.cardId, equals('c1'));
        expect(readyCards.first.position, equals(3));

        // Błąd API: wycofanie (rollback) do poprzedniego stanu
        repo.errorToThrow = const NetworkError('Network connection lost');
        final moveFailed = await controller.moveCard('c1', 'done', 0);
        expect(moveFailed, isFalse);
        final stateAfterFail = container.read(kanbanControllerProvider);
        expect(stateAfterFail.cards.first.status, equals('ready'));
        expect(stateAfterFail.cards.first.position, equals(3));
        expect(stateAfterFail.error, contains('Network connection lost'));
      },
    );

    test('Akcja abort dla zadania working', () async {
      repo.cardsList = [
        const KanbanCard(
          cardId: 'c-work',
          projectId: 'p1',
          title: 'Working Task',
          status: 'working',
          position: 0,
        ),
      ];
      await controller.load('p1');

      await controller.abortCard('c-work');

      expect(repo.calls, contains('abort:c-work'));
      final state = container.read(kanbanControllerProvider);
      expect(state.cards.first.status, equals('backlog'));
    });

    test('Dodawanie komentarzy i ich odczyt', () async {
      await controller.load('p1');

      await controller.addComment('c1', 'First comment');
      expect(repo.calls, contains('addComment:c1:First comment'));

      final comments = await controller.loadComments('c1');
      expect(comments.length, equals(1));
      expect(comments.first.body, equals('First comment'));
      expect(
        container.read(kanbanControllerProvider).comments['c1']?.first.body,
        equals('First comment'),
      );
    });

    test(
      'Reakcja na zdarzenia WebSocket: kanban-card-upserted, kanban-card-deleted, board-config-updated',
      () async {
        await controller.load('p1');

        // 1. kanban-card-upserted (nowa karta)
        channel.emit({
          'type': 'kanban-card-upserted',
          'card': {
            'cardId': 'ws-1',
            'projectId': 'p1',
            'title': 'WS Added Card',
            'status': 'backlog',
            'position': 0,
          },
        });
        await Future<void>.delayed(Duration.zero);
        expect(
          container.read(kanbanControllerProvider).cards.any(
                (c) => c.cardId == 'ws-1' && c.title == 'WS Added Card',
              ),
          isTrue,
        );

        // 2. kanban-card-upserted (aktualizacja istniejącej karty)
        channel.emit({
          'type': 'kanban-card-upserted',
          'card': {
            'cardId': 'ws-1',
            'projectId': 'p1',
            'title': 'WS Updated Card',
            'status': 'working',
            'position': 1,
          },
        });
        await Future<void>.delayed(Duration.zero);
        final updated = container
            .read(kanbanControllerProvider)
            .cards
            .firstWhere((c) => c.cardId == 'ws-1');
        expect(updated.title, equals('WS Updated Card'));
        expect(updated.status, equals('working'));

        // 3. board-config-updated
        channel.emit({
          'type': 'board-config-updated',
          'boardConfig': {'theme': 'dark-blue', 'wipLimit': 5},
        });
        await Future<void>.delayed(Duration.zero);
        expect(
          container.read(kanbanControllerProvider).boardConfig['wipLimit'],
          equals(5),
        );

        // 4. kanban-card-deleted
        channel.emit({
          'type': 'kanban-card-deleted',
          'cardId': 'ws-1',
        });
        await Future<void>.delayed(Duration.zero);
        expect(
          container.read(kanbanControllerProvider).cards.any((c) => c.cardId == 'ws-1'),
          isFalse,
        );
      },
    );

    test('Ramki WS z innego projektu są ignorowane', () async {
      await controller.load('p1');
      final count = container.read(kanbanControllerProvider).cards.length;

      channel.emit({
        'type': 'kanban-card-upserted',
        'projectId': 'other-project',
        'card': {
          'cardId': 'foreign-1',
          'projectId': 'other-project',
          'title': 'Foreign',
          'status': 'backlog',
          'position': 0,
        },
      });
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(kanbanControllerProvider).cards.length,
        equals(count),
      );
      expect(
        container
            .read(kanbanControllerProvider)
            .cards
            .any((c) => c.cardId == 'foreign-1'),
        isFalse,
      );
    });

    test('kanban-comment-added dopisuje komentarz bez refetchu', () async {
      await controller.load('p1');
      await controller.loadComments('c1');

      channel.emit({
        'type': 'kanban-comment-added',
        'projectId': 'p1',
        'cardId': 'c1',
        'comment': {'id': 'cm-1', 'cardId': 'c1', 'body': 'hi'},
      });
      await Future<void>.delayed(Duration.zero);
      final comments = container.read(kanbanControllerProvider).comments['c1'];
      expect(comments?.last.body, equals('hi'));
    });
  });

  group('2. Testy widgetowe KanbanScreen', () {
    late FakeKanbanRepository repo;
    late FakeChatChannel channel;

    setUp(() {
      repo = FakeKanbanRepository();
      channel = FakeChatChannel();
    });

    tearDown(() {
      channel.close();
    });

    testWidgets('Renderowanie kolumn statusów i kafelków kart', (tester) async {
      repo.cardsList = [
        const KanbanCard(
          cardId: 'c1',
          projectId: 'test-proj',
          title: 'Card In Backlog',
          status: 'backlog',
          position: 0,
        ),
        const KanbanCard(
          cardId: 'c2',
          projectId: 'test-proj',
          title: 'Card In Working',
          status: 'working',
          position: 0,
        ),
        const KanbanCard(
          cardId: 'c3',
          projectId: 'test-proj',
          title: 'Card In Done',
          status: 'done',
          position: 0,
        ),
      ];

      await _pumpKanbanScreen(tester, repo: repo, channel: channel);

      // Kolumny
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Ready to start'), findsOneWidget);
      expect(find.text('Working'), findsOneWidget);
      expect(find.text('Needs your decision'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Archived'), findsOneWidget);

      // Karty
      expect(find.text('Card In Backlog'), findsOneWidget);
      expect(find.text('Card In Working'), findsOneWidget);
      expect(find.text('Card In Done'), findsOneWidget);
    });

    testWidgets('Otwarcie dialogu tworzenia karty i dodanie nowej', (
      tester,
    ) async {
      await _pumpKanbanScreen(tester, repo: repo, channel: channel);

      // Kliknięcie w przycisk 'New card'
      await tester.tap(find.byKey(const Key('add-card-button')));
      await tester.pumpAndSettle();

      // Weryfikacja otwarcia dialogu
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byKey(const Key('card-title-input')), findsOneWidget);
      expect(find.byKey(const Key('card-description-input')), findsOneWidget);

      // Wpisanie danych nowej karty
      await tester.enterText(
        find.byKey(const Key('card-title-input')),
        'Brand New Task',
      );
      await tester.enterText(
        find.byKey(const Key('card-description-input')),
        'Details for the task',
      );

      // Zapisanie karty
      await tester.tap(find.byKey(const Key('save-card-button')));
      await tester.pumpAndSettle();

      // Dialog zamknięty, nowa karta na tablicy
      expect(find.text('Brand New Task'), findsOneWidget);
      expect(repo.calls.any((c) => c.startsWith('create:')), isTrue);
    });

    testWidgets('Kliknięcie przycisku Abort na karcie w statusie working', (
      tester,
    ) async {
      repo.cardsList = [
        const KanbanCard(
          cardId: 'c-working',
          projectId: 'test-proj',
          title: 'Active Working Task',
          status: 'working',
          position: 0,
        ),
      ];

      await _pumpKanbanScreen(tester, repo: repo, channel: channel);

      expect(find.text('Active Working Task'), findsOneWidget);
      final abortButton = find.byKey(const Key('abort-button-c-working'));
      expect(abortButton, findsOneWidget);
      expect(find.text('Abort'), findsOneWidget);

      // Kliknięcie Abort
      await tester.tap(abortButton);
      await tester.pumpAndSettle();

      // Sprawdzenie wywołania abort w repozytorium i zmiany statusu
      expect(repo.calls, contains('abort:c-working'));
      // Karta przeniesiona do backlog - nie ma już przycisku Abort
      expect(find.byKey(const Key('abort-button-c-working')), findsNothing);
    });

    testWidgets('Otwarcie dialogu szczegółów i dodanie komentarza', (
      tester,
    ) async {
      repo.cardsList = [
        const KanbanCard(
          cardId: 'c-detail',
          projectId: 'test-proj',
          title: 'Task To Comment On',
          status: 'backlog',
          position: 0,
        ),
      ];

      await _pumpKanbanScreen(tester, repo: repo, channel: channel);

      // Kliknięcie w kafelek karty
      await tester.tap(find.text('Task To Comment On'));
      await tester.pumpAndSettle();

      // Dialog szczegółów z komentarzami
      expect(find.text('Comments'), findsOneWidget);
      expect(find.byKey(const Key('comment-input')), findsOneWidget);
      expect(find.byKey(const Key('add-comment-button')), findsOneWidget);

      // Wpisanie komentarza i dodanie
      await tester.enterText(
        find.byKey(const Key('comment-input')),
        'LGTM! Ready for testing.',
      );
      await tester.tap(find.byKey(const Key('add-comment-button')));
      await tester.pumpAndSettle();

      // Komentarz pojawił się w widoku
      expect(find.text('LGTM! Ready for testing.'), findsOneWidget);
      expect(
        repo.calls,
        contains('addComment:c-detail:LGTM! Ready for testing.'),
      );
    });

    testWidgets('Przeciąganie karty między kolumnami (drag & drop)', (
      tester,
    ) async {
      repo.cardsList = [
        const KanbanCard(
          cardId: 'c-drag',
          projectId: 'test-proj',
          title: 'Card To Drag',
          status: 'backlog',
          position: 0,
        ),
      ];

      await _pumpKanbanScreen(tester, repo: repo, channel: channel);

      expect(find.text('Card To Drag'), findsOneWidget);

      final cardLocation = tester.getCenter(find.text('Card To Drag'));
      final targetColumnLocation = tester.getCenter(find.text('Ready to start'));

      // Wykonanie gestu drag & drop
      final gesture = await tester.startGesture(cardLocation);
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.moveTo(targetColumnLocation);
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.up();
      await tester.pumpAndSettle();

      // Karta przeniesiona, wywołanie repozytorium move
      expect(repo.calls.any((c) => c.startsWith('move:c-drag:ready:')), isTrue);
    });
  });
}
