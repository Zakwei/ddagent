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

  /// The server broadcasts kanban frames to *all* connected clients without
  /// project scoping — drop events for other boards so foreign cards never
  /// leak into this project's state until a reload.
  void handleServerEvent(ServerEvent e) {
    final kind = e.kind;
    if (kind != 'kanban-card-upserted' &&
        kind != 'kanban-card-deleted' &&
        kind != 'board-config-updated' &&
        kind != 'kanban-board-config-updated' &&
        kind != 'kanban-comment-added') {
      return;
    }
    final pid =
        (e.raw['projectId'] ??
                (e.raw['card'] as Map<String, dynamic>?)?['projectId'])
            as String?;
    if (pid != null && state.projectId.isNotEmpty && pid != state.projectId) {
      return;
    }

    if (kind == 'kanban-card-upserted') {
      final cardRaw = e.raw['card'] as Map<String, dynamic>? ?? e.raw;
      if (cardRaw.containsKey('cardId') || cardRaw.containsKey('id')) {
        final updatedCard = KanbanCard.fromApi(cardRaw);
        final index = state.cards.indexWhere(
          (c) => c.cardId == updatedCard.cardId,
        );
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
    } else if (kind == 'kanban-comment-added') {
      final cardId = e.raw['cardId'] as String?;
      final commentRaw = e.raw['comment'] as Map<String, dynamic>?;
      if (cardId != null && commentRaw != null) {
        final list = state.comments[cardId];
        if (list != null) {
          state = state.copyWith(
            comments: {
              ...state.comments,
              cardId: [...list, KanbanComment.fromJson(commentRaw)],
            },
          );
        }
      }
    } else {
      final config =
          e.raw['boardConfig'] as Map<String, dynamic>? ??
          e.raw['config'] as Map<String, dynamic>? ??
          Map<String, dynamic>.from(e.raw);
      state = state.copyWith(boardConfig: config);
    }
  }

  /// The REST payload wraps the config (`{boardConfig: {...}}`) while the WS
  /// frame already carries the inner map — normalize to the inner config.
  static Map<String, dynamic> _configOf(Map<String, dynamic> payload) =>
      payload['boardConfig'] is Map<String, dynamic>
      ? payload['boardConfig'] as Map<String, dynamic>
      : payload;

  Future<void> load([String? projectId]) async {
    final pid =
        projectId ?? (state.projectId.isNotEmpty ? state.projectId : 'default');
    state = state.copyWith(isLoading: true, error: () => null, projectId: pid);

    try {
      final results = await Future.wait([
        // Archived cards must load too — the Archived column filters them out
        // of the active board client-side.
        _repo.cards(pid, includeArchived: true),
        _repo.boardConfig(pid),
      ]);
      if (!ref.mounted || state.projectId != pid) return;
      state = state.copyWith(
        cards: results[0] as List<KanbanCard>,
        boardConfig: _configOf(results[1] as Map<String, dynamic>),
        isLoading: false,
      );
    } on AppError catch (e) {
      if (!ref.mounted || state.projectId != pid) return;
      state = state.copyWith(isLoading: false, error: () => e.message);
    } on Object catch (e) {
      if (!ref.mounted || state.projectId != pid) return;
      state = state.copyWith(isLoading: false, error: () => e.toString());
    }
  }

  Future<KanbanCard?> createCard(
    Map<String, dynamic> body, {
    String? projectId,
  }) async {
    final pid =
        projectId ?? (state.projectId.isNotEmpty ? state.projectId : 'default');
    final assigneeUserId = body['assigneeUserId'] as int?;
    state = state.copyWith(error: () => null);

    try {
      final card = await _repo.create(pid, body);
      if (!ref.mounted) return card;
      state = state.copyWith(cards: [...state.cards, card]);
      if (assigneeUserId == null) return card;
      // POST ignores assigneeUserId, so the assignment is patched right after.
      // A failed patch is swallowed: the card exists, and surfacing it would
      // keep the dialog in create mode so the next submit mints a duplicate.
      try {
        final assigned = await _repo.update(card.cardId, {
          'assigneeUserId': assigneeUserId,
        });
        if (!ref.mounted) return assigned;
        state = state.copyWith(
          cards: state.cards
              .map((c) => c.cardId == card.cardId ? assigned : c)
              .toList(),
        );
        return assigned;
      } on Object {
        return card;
      }
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      return null;
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
      return null;
    }
  }

  Future<KanbanCard?> updateCard(
    String cardId,
    Map<String, dynamic> body,
  ) async {
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

  /// Failures land in [KanbanState.error] — callers fire this via
  /// `unawaited(...)`, so a rethrow would die as an unhandled async error.
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
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
    }
  }

  Future<bool> moveCard(
    String cardId,
    String targetStatus,
    int targetPosition,
  ) async {
    final cardIndex = state.cards.indexWhere((c) => c.cardId == cardId);
    if (cardIndex < 0) return false;

    final oldCards = state.cards;
    final card = oldCards[cardIndex];
    final updatedCard = card.copyWith(
      status: targetStatus,
      position: targetPosition,
    );

    // Optimistic update
    state = state.copyWith(
      cards: state.cards
          .map((c) => c.cardId == cardId ? updatedCard : c)
          .toList(),
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
        cards: state.cards
            .map((c) => c.cardId == cardId ? c.copyWith(status: 'backlog') : c)
            .toList(),
      );
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
    }
  }

  Future<List<KanbanComment>> loadComments(String cardId) async {
    try {
      final list = await _repo.comments(cardId);
      if (!ref.mounted) return list;
      state = state.copyWith(comments: {...state.comments, cardId: list});
      return list;
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      return [];
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
      return [];
    }
  }

  /// Board agent defaults (provider/model/effort) — `PUT /api/kanban/board-config`.
  Future<bool> saveBoardConfig(
    Map<String, dynamic> config, {
    String? projectId,
  }) async {
    final pid =
        projectId ?? (state.projectId.isNotEmpty ? state.projectId : 'default');
    state = state.copyWith(error: () => null);
    try {
      await _repo.saveBoardConfig(pid, config);
      if (ref.mounted) {
        // The WS broadcast will also upsert this, but optimistically merge so
        // the settings sheet reflects the save even without a socket.
        state = state.copyWith(boardConfig: {...state.boardConfig, ...config});
      }
      return true;
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      return false;
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: () => null);

  Future<void> addComment(String cardId, String body) async {
    state = state.copyWith(error: () => null);

    try {
      await _repo.addComment(cardId, body);
      await loadComments(cardId);
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
    } on Object catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.toString());
    }
  }
}

final kanbanControllerProvider =
    NotifierProvider<KanbanController, KanbanState>(KanbanController.new);

final kanbanProvider = kanbanControllerProvider;
