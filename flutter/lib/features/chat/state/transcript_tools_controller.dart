import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/chat/view/tool_blocks.dart';
import 'package:ddagent_app/features/file_tree/data/file_saver.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Export the transcript in [format] (`markdown` / `html` / `pdf`). Free
/// function because the chat export menu now lives in the pane header, away
/// from the transcript widget that owns the messages provider.
Future<void> exportTranscript(
  BuildContext context,
  String sessionId,
  List<SessionMessage> messages,
  String format,
) async {
  final html = format != 'markdown'
      ? transcriptToHtml(messages, title: 'Session $sessionId')
      : null;
  if (format == 'pdf') {
    try {
      await printHtmlDocument(html!);
    } on Exception {
      if (context.mounted) AppToast.show(context, 'PDF export failed');
    }
    return;
  }
  final text = html ?? transcriptToMarkdown(messages, title: 'Session $sessionId');
  final ext = format == 'html' ? 'html' : 'md';
  final path = await downloadText(
    'session-$sessionId.$ext',
    text,
    mime: format == 'html' ? 'text/html' : 'text/markdown',
  );
  if (!context.mounted) return;
  AppToast.show(context, path == null ? 'Transcript downloaded' : 'Saved $path');
}

class TranscriptToolsState {
  const TranscriptToolsState({
    this.reviewOpen = false,
    this.reviewFiles = const [],
    this.reviewLoading = false,
    this.reviewError = false,
    this.searchActive = false,
    this.searchQuery = '',
    this.matches = const [],
    this.matchPos = -1,
  });

  final bool reviewOpen;
  final List<Map<String, dynamic>> reviewFiles;
  final bool reviewLoading;
  final bool reviewError;

  /// Search field expanded in the header (the icon collapsed in otherwise).
  final bool searchActive;
  final String searchQuery;
  final List<int> matches;
  final int matchPos;

  bool get searching => searchQuery.trim().isNotEmpty;

  TranscriptToolsState copyWith({
    bool? reviewOpen,
    List<Map<String, dynamic>>? reviewFiles,
    bool? reviewLoading,
    bool? reviewError,
    bool? searchActive,
    String? searchQuery,
    List<int>? matches,
    int? matchPos,
  }) => TranscriptToolsState(
    reviewOpen: reviewOpen ?? this.reviewOpen,
    reviewFiles: reviewFiles ?? this.reviewFiles,
    reviewLoading: reviewLoading ?? this.reviewLoading,
    reviewError: reviewError ?? this.reviewError,
    searchActive: searchActive ?? this.searchActive,
    searchQuery: searchQuery ?? this.searchQuery,
    matches: matches ?? this.matches,
    matchPos: matchPos ?? this.matchPos,
  );
}

/// Shared state for the transcript tools that live in the pane header
/// (export / review / transcript search), keyed by session id so both the
/// header chrome and the transcript body read the same instance.
///
/// Match indices are row indices into `groupToolRuns(messages).rows` — the
/// same list the transcript renders — so scrolling stays in sync without a
/// second grouping pass.
class TranscriptToolsController extends Notifier<TranscriptToolsState> {
  TranscriptToolsController(this._sessionId);

  final String _sessionId;

  final searchController = TextEditingController();
  final searchFocus = FocusNode();

  /// Set by the transcript so a match jump scrolls its virtualized list.
  void Function(int rowIndex)? onScrollToIndex;

  @override
  TranscriptToolsState build() {
    ref.onDispose(() {
      searchController.dispose();
      searchFocus.dispose();
    });
    return const TranscriptToolsState();
  }

  void toggleReview() {
    final open = !state.reviewOpen;
    state = state.copyWith(reviewOpen: open, reviewError: false);
    if (open) loadReviewFiles();
  }

  void closeReview() => state = state.copyWith(reviewOpen: false);

  Future<void> loadReviewFiles() async {
    state = state.copyWith(reviewLoading: true);
    try {
      final files = await ref.read(sessionsRepositoryProvider).changedFiles(_sessionId);
      state = state.copyWith(reviewFiles: files, reviewLoading: false);
    } on Object {
      // Any failure surfaces as an error state — never leave the panel stuck.
      state = state.copyWith(reviewFiles: const [], reviewLoading: false, reviewError: true);
    }
  }

  void openSearch() {
    state = state.copyWith(searchActive: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => searchFocus.requestFocus());
  }

  void closeSearch() {
    searchController.clear();
    state = state.copyWith(searchActive: false, searchQuery: '', matches: const [], matchPos: -1);
  }

  void onQueryChanged(String query) {
    final matches = query.trim().isEmpty ? const <int>[] : _findMatches(query);
    final pos = matches.isEmpty ? -1 : 0;
    state = state.copyWith(searchQuery: query, matches: matches, matchPos: pos);
    if (pos >= 0) onScrollToIndex?.call(matches[pos]);
  }

  void goToMatch(int pos) {
    if (pos < 0 || pos >= state.matches.length) return;
    state = state.copyWith(matchPos: pos);
    onScrollToIndex?.call(state.matches[pos]);
  }

  bool _messageMatches(SessionMessage m, String q) =>
      (m.content ?? '').toLowerCase().contains(q) ||
      (m.toolName ?? '').toLowerCase().contains(q) ||
      (m.toolResult?.toString() ?? '').toLowerCase().contains(q);

  List<int> _findMatches(String query) {
    final q = query.toLowerCase();
    final grouped = groupToolRuns(ref.read(sessionMessagesProvider(_sessionId)));
    final out = <int>[];
    for (var i = 0; i < grouped.rows.length; i++) {
      final r = grouped.rows[i];
      if (r is SessionMessage) {
        final children = grouped.children[r.toolId] ?? const [];
        if (_messageMatches(r, q) || children.any((c) => _messageMatches(c, q))) {
          out.add(i);
        }
      } else if (r is ToolGroup) {
        if (r.messages.any((m) => _messageMatches(m, q))) out.add(i);
      }
    }
    return out;
  }
}

final transcriptToolsProvider =
    NotifierProvider.family<TranscriptToolsController, TranscriptToolsState, String>(
      TranscriptToolsController.new,
    );
