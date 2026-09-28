import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/kanban/data/kanban_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KanbanState {
  const KanbanState({
    this.projectId = '',
    this.cards = const [],
    this.boardConfig = const {},
    this.comments = const {},
    this.isLoading = false,
    this.error,
  });

  final String projectId;
  final List<KanbanCard> cards;
  final Map<String, dynamic> boardConfig;
  final Map<String, List<KanbanComment>> comments;
  final bool isLoading;
  final String? error;

  List<KanbanCard> cardsForStatus(String status) {
    final filtered = cards.where((c) => c.status == status).toList();
    filtered.sort((a, b) => a.position.compareTo(b.position));
    return filtered;
  }

  KanbanState copyWith({
    String? projectId,
    List<KanbanCard>? cards,
    Map<String, dynamic>? boardConfig,
    Map<String, List<KanbanComment>>? comments,
    bool? isLoading,
    String? Function()? error,
  }) => KanbanState(
    projectId: projectId ?? this.projectId,
    cards: cards ?? this.cards,
    boardConfig: boardConfig ?? this.boardConfig,
    comments: comments ?? this.comments,
    isLoading: isLoading ?? this.isLoading,
    error: error != null ? error() : this.error,
  );
}

class KanbanController extends Notifier<KanbanState> {
  StreamSubscription<ServerEvent>? _eventsSub;

  KanbanRepository get _repo => ref.read(kanbanRepositoryProvider);

  @override
  KanbanState build() {
    _eventsSub?.cancel();
    _eventsSub = ref.read(chatChannelProvider).events.listen(handleServerEvent);

    ref.onDispose(() {
      unawaited(_eventsSub?.cancel());
    });

    return const KanbanState();
  }

  void handleServerEvent(ServerEvent e) {
    final kind = e.kind;
    if (kind == 'kanban-card-upserted') {
      final cardRaw = e.raw['card'] as Map<String, dynamic>? ?? e.raw;
      if (cardRaw.containsKey('cardId') || cardRaw.containsKey('id')) {
        final updatedCard = KanbanCard.fromApi(cardRaw);
        final index = state.cards.indexWhere((c) => c.cardId == updatedCard.cardId);
        final newCards = List<KanbanCard>.from(state.cards);
        if (index >= 0) {
          newCards[index] = updatedCard;
        } else {
          newCards.add(updatedCard);
        }
        state = state.copyWith(cards: newCards);
      }
    } else if (kind == 'kanban-card-deleted') {
      final cardId = (e.raw['cardId'] ?? e.raw['id']) as String?;
      if (cardId != null) {
        state = state.copyWith(
          cards: state.cards.where((c) => c.cardId != cardId).toList(),
        );
      }
    } else if (kind == 'board-config-updated' || kind == 'kanban-board-config-updated') {
      final config = e.raw['boardConfig'] as Map<String, dynamic>? ??
          e.raw['config'] as Map<String, dynamic>? ??
          Map<String, dynamic>.from(e.raw);
      state = state.copyWith(boardConfig: config);
    }
  }

  Future<void> load([String? projectId]) async {
    final pid = projectId ?? (state.projectId.isNotEmpty ? state.projectId : 'default');
    state = state.copyWith(isLoading: true, error: () => null, projectId: pid);

    try {
      final results = await Future.wait([
        _repo.cards(pid),
        _repo.boardConfig(pid),
      ]);
      if (!ref.mounted) return;
      state = state.copyWith(
        cards: results[0] as List<KanbanCard>,
        boardConfig: results[1] as Map<String, dynamic>,
        isLoading: false,
      );
    } on AppError catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: () => e.message);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: () => e.toString());
    }
  }

  Future<KanbanCard?> createCard(Map<String, dynamic> body, {String? projectId}) async {
    final pid = projectId ?? (state.projectId.isNotEmpty ? state.projectId : 'default');
    state = state.copyWith(error: () => null);

    try {
      final card = await _repo.create(pid, body);
      if (!ref.mounted) return card;
      state = state.copyWith(cards: [...state.cards, card]);
      return card;
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      return null;
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
      return null;
    }
  }

  Future<KanbanCard?> updateCard(String cardId, Map<String, dynamic> body) async {
    state = state.copyWith(error: () => null);

    try {
      final card = await _repo.update(cardId, body);
      if (!ref.mounted) return card;
      state = state.copyWith(
        cards: state.cards.map((c) => c.cardId == cardId ? card : c).toList(),
      );
      return card;
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      return null;
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
      return null;
    }
  }

  Future<void> deleteCard(String cardId) async {
    state = state.copyWith(error: () => null);

    try {
      await _repo.delete(cardId);
      if (!ref.mounted) return;
      state = state.copyWith(
        cards: state.cards.where((c) => c.cardId != cardId).toList(),
      );
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      rethrow;
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
      rethrow;
    }
  }

  Future<bool> moveCard(String cardId, String targetStatus, int targetPosition) async {
    final cardIndex = state.cards.indexWhere((c) => c.cardId == cardId);
    if (cardIndex < 0) return false;

    final oldCards = state.cards;
    final card = oldCards[cardIndex];
    final updatedCard = card.copyWith(status: targetStatus, position: targetPosition);

    // Optimistic update
    state = state.copyWith(
      cards: state.cards.map((c) => c.cardId == cardId ? updatedCard : c).toList(),
      error: () => null,
    );

    try {
      await _repo.move(cardId, targetStatus, targetPosition);
      return true;
    } on AppError catch (e) {
      // Rollback on failure
      if (ref.mounted) {
        state = state.copyWith(cards: oldCards, error: () => e.message);
      }
      return false;
    } on Object catch (e) {
      // Rollback on failure
      if (ref.mounted) {
        state = state.copyWith(cards: oldCards, error: () => e.toString());
      }
      return false;
    }
  }

  Future<void> abortCard(String cardId) async {
    state = state.copyWith(error: () => null);

    try {
      await _repo.abort(cardId);
      if (!ref.mounted) return;
      state = state.copyWith(
        cards: state.cards.map((c) => c.cardId == cardId ? c.copyWith(status: 'backlog') : c).toList(),
      );
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      rethrow;
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
      rethrow;
    }
  }

  Future<List<KanbanComment>> loadComments(String cardId) async {
    try {
      final list = await _repo.comments(cardId);
      if (!ref.mounted) return list;
      state = state.copyWith(
        comments: {...state.comments, cardId: list},
      );
      return list;
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      return [];
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
      return [];
    }
  }

  Future<void> addComment(String cardId, String body) async {
    state = state.copyWith(error: () => null);

    try {
      await _repo.addComment(cardId, body);
      await loadComments(cardId);
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      rethrow;
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
      rethrow;
    }
  }
}

final kanbanControllerProvider = NotifierProvider<KanbanController, KanbanState>(
  KanbanController.new,
);

final kanbanProvider = kanbanControllerProvider;
