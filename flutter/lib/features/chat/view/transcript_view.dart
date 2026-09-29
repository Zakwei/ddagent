import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/auth_image.dart';
import 'package:ddagent_app/features/chat/state/pending_permissions.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/chat/view/session_subheader.dart';
import 'package:ddagent_app/features/chat/view/tool_blocks.dart';
import 'package:ddagent_app/features/collab/role.dart';
import 'package:ddagent_app/features/collab/state/presence_controller.dart';
import 'package:ddagent_app/features/collab/view/presence_avatars.dart';
import 'package:ddagent_app/features/file_tree/data/file_saver.dart';
import 'package:ddagent_app/features/orchestrator/view/orchestrator_cards.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/features/voice/state/tts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Transcript pane for one session (T13): virtualized list of all
/// MessageKinds, top-of-list older-page loading, jump-to-bottom + unread
/// counter, presence announce (`{kind:'session'}`) while mounted.
class TranscriptView extends ConsumerStatefulWidget {
  const TranscriptView({
    required this.sessionId,
    this.projectId,
    this.projectPath,
    this.dense = false,
    super.key,
  });

  final String sessionId;
  final String? projectId;
  final String? projectPath;

  /// `[data-split-rows="2"]` parity — the subheader collapses to a slim
  /// strip (no path/separators) when the split grid stacks two rows.
  final bool dense;

  TranscriptArg get _arg => (sessionId: sessionId, projectId: projectId);

  @override
  ConsumerState<TranscriptView> createState() => _TranscriptViewState();
}

class _TranscriptViewState extends ConsumerState<TranscriptView> {
  final _itemScroll = ItemScrollController();
  final _positions = ItemPositionsListener.create();
  bool _atBottom = true;
  int _unread = 0;
  int _seenCount = 0;
  int _rowCount = 0;

  // T17.1 transcript search
  final _searchCtrl = TextEditingController();
  bool _searchOpen = false;
  List<int> _matches = const [];
  int _matchPos = -1;

  // T17.7 scroll anchoring across older-page prepends
  (int, double)? _prependAnchor;
  int _prependCount = 0;

  @override
  void initState() {
    super.initState();
    _positions.itemPositions.addListener(() {
      final positions = _positions.itemPositions.value;
      final atBottom =
          positions.isEmpty ||
          positions.any(
            (p) => p.index >= _rowCount - 1 && p.itemTrailingEdge <= 1.01,
          );
      if (atBottom != _atBottom) setState(() => _atBottom = atBottom);
      if (atBottom) _unread = 0;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _loadOlder() {
    // Capture the first visible row so the prepend doesn't shift the viewport.
    final positions = _positions.itemPositions.value;
    if (positions.isNotEmpty) {
      final first = positions.reduce((a, b) => a.index < b.index ? a : b);
      _prependAnchor = (first.index, first.itemLeadingEdge);
      _prependCount = _rowCount;
    }
    unawaited(ref.read(transcriptProvider(widget._arg).notifier).loadOlder());
  }

  void _onSearchChanged(String query) {
    setState(() {
      _matchPos = -1;
      _matches = query.isEmpty ? const [] : _findMatches(query);
      if (_matches.isNotEmpty) _goToMatch(0);
    });
  }

  bool _messageMatches(SessionMessage m, String q) =>
      (m.content ?? '').toLowerCase().contains(q) ||
      (m.toolName ?? '').toLowerCase().contains(q) ||
      (m.toolResult?.toString() ?? '').toLowerCase().contains(q);

  List<int> _findMatches(String query) {
    final q = query.toLowerCase();
    final out = <int>[];
    for (var i = 0; i < _lastRows.length; i++) {
      final r = _lastRows[i];
      if (r is SessionMessage) {
        final children = _lastChildren[r.toolId] ?? const [];
        if (_messageMatches(r, q) ||
            children.any((c) => _messageMatches(c, q))) {
          out.add(i);
        }
      } else if (r is ToolGroup) {
        if (r.messages.any((m) => _messageMatches(m, q))) out.add(i);
      }
    }
    return out;
  }

  Map<String, List<SessionMessage>> _lastChildren = const {};

  List<Object> _lastRows = const [];

  void _goToMatch(int pos) {
    if (pos < 0 || pos >= _matches.length) return;
    _matchPos = pos;
    if (_itemScroll.isAttached) {
      _itemScroll.scrollTo(
        index: _matches[pos],
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  Future<void> _showChangedFiles(BuildContext context) async {
    final files = await ref
        .read(sessionsRepositoryProvider)
        .changedFiles(widget.sessionId);
    if (!context.mounted) return;
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (ctx) => SafeArea(
          child: files.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No changed files'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: files.length,
                  itemBuilder: (_, i) {
                    final f = files[i];
                    final adds = f['additions'] ?? f['added'] ?? 0;
                    final dels = f['deletions'] ?? f['removed'] ?? 0;
                    final path =
                        f['path']?.toString() ?? f['file']?.toString() ?? '';
                    return ListTile(
                      dense: true,
                      // ReviewFilesPanel parity — tapping a row opens it.
                      onTap: path.isEmpty || widget.projectId == null
                          ? null
                          : () {
                              Navigator.of(ctx).pop();
                              context.go(
                                '/editor?projectId=${widget.projectId}'
                                '&file=${Uri.encodeComponent(path)}',
                              );
                            },
                      leading: const Icon(Icons.description_outlined, size: 18),
                      title: Text(
                        f['path']?.toString() ?? f['file']?.toString() ?? '$f',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      subtitle: f['status'] == null
                          ? null
                          : Text('${f['status']}'),
                      trailing: Text(
                        '+$adds −$dels',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _jumpToBottom() {
    if (_rowCount == 0 || !_itemScroll.isAttached) return;
    _itemScroll.scrollTo(
      index: _rowCount - 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: 1,
    );
    setState(() => _unread = 0);
  }

  Future<void> _export(String format, List<SessionMessage> messages) async {
    final text = format == 'html'
        ? transcriptToHtml(messages, title: 'Session ${widget.sessionId}')
        : transcriptToMarkdown(messages, title: 'Session ${widget.sessionId}');
    if (format == 'copy') {
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) AppToast.show(context, 'Transcript copied');
      return;
    }
    // ChatExportMenu parity — the old menu saves a real file.
    final ext = format == 'html' ? 'html' : 'md';
    final path = await downloadText(
      'session-${widget.sessionId}.$ext',
      text,
      mime: format == 'html' ? 'text/html' : 'text/markdown',
    );
    if (!mounted) return;
    AppToast.show(
      context,
      path == null ? 'Transcript downloaded' : 'Saved $path',
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionId = widget.sessionId;
    // Mounting the presence provider announces {kind:'session', id}; dispose
    // clears it — wiring T12.4 to a real surface.
    final roster = ref.watch(
      presenceProvider((kind: 'session', id: sessionId)),
    );
    final state = ref.watch(transcriptProvider(widget._arg));
    final messages = ref.watch(sessionMessagesProvider(sessionId));
    final provider = messages.lastOrNull?.provider ?? 'claude';
    // T15.8/11 — group consecutive tool rows; nest subagent children.
    final grouped = groupToolRuns(messages);
    _lastRows = grouped.rows;
    _lastChildren = grouped.children;
    _rowCount = grouped.rows.length;
    final hasMore = ref.watch(
      sessionMessageStoreProvider.select((s) => s[sessionId]?.hasMore ?? false),
    );

    // T17.3 — provider assigned a real session id; swap the route so
    // subsequent deep-links/reloads land on the canonical session.
    ref.listen(transcriptProvider(widget._arg).select((s) => s.replacedWith), (
      _,
      next,
    ) {
      if (next == null || !mounted) return;
      final query = Uri(
        queryParameters: {
          if (widget.projectId != null) 'projectId': widget.projectId!,
          if (widget.projectPath != null) 'projectPath': widget.projectPath!,
        },
      ).query;
      context.replace('/chat/$next${query.isEmpty ? '' : '?$query'}');
    });

    // T17.7 — restore viewport anchor once the older page landed.
    if (_prependAnchor != null && _rowCount > _prependCount) {
      final (idx, edge) = _prependAnchor!;
      final delta = _rowCount - _prependCount;
      _prependAnchor = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _itemScroll.isAttached) {
          _itemScroll.jumpTo(index: idx + delta, alignment: edge);
        }
      });
    }

    if (messages.length > _seenCount) {
      final added = messages.length - _seenCount;
      _seenCount = messages.length;
      if (!_atBottom) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _unread += added);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_itemScroll.isAttached || _rowCount == 0) return;
          _itemScroll.jumpTo(index: _rowCount - 1, alignment: 1);
        });
      }
    }

    // `.oc-chat` parity — the pane always renders the opencode TUI palette
    // (dark + monospace) regardless of the app light/dark mode.
    return Theme(
      data: AppTheme.ocChat(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 36,
          // The web chat opens with a thin status strip (`* Devin ·
          // DeepSeek … · /workspace/…`) rather than a page title.
          title: _searchOpen
              ? TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search transcript…',
                    isDense: true,
                    suffixText: _matches.isEmpty
                        ? ''
                        : '${_matchPos + 1}/${_matches.length}',
                  ),
                  onChanged: _onSearchChanged,
                )
              : _StatusStrip(
                  provider: messages.lastOrNull?.provider,
                  projectPath: widget.projectPath,
                ),
          actions: [
            if (_searchOpen) ...[
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_up, size: 20),
                onPressed: _matches.isEmpty
                    ? null
                    : () => _goToMatch((_matchPos - 1) % _matches.length),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                onPressed: _matches.isEmpty
                    ? null
                    : () => _goToMatch((_matchPos + 1) % _matches.length),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => setState(() {
                  _searchOpen = false;
                  _searchCtrl.clear();
                  _matches = const [];
                }),
              ),
            ] else ...[
              IconButton(
                tooltip: 'Search transcript',
                icon: const Icon(Icons.search, size: 20),
                onPressed: () => setState(() => _searchOpen = true),
              ),
              // T17.4 — token usage chip (context % + breakdown dialog).
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: TokenUsageChip(sessionId: sessionId),
              ),
              // T17.5/6 — export/copy transcript.
              PopupMenuButton<String>(
                tooltip: 'Export chat',
                icon: const Icon(Icons.download_outlined, size: 20),
                onSelected: (f) => unawaited(_export(f, messages)),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'markdown',
                    child: Text('Download Markdown'),
                  ),
                  PopupMenuItem(value: 'html', child: Text('Download HTML')),
                  PopupMenuItem(value: 'copy', child: Text('Copy Markdown')),
                ],
              ),
              // T15.12 — blast-radius review list (changed files this session).
              IconButton(
                tooltip: 'Review changed files',
                icon: const Icon(Icons.difference_outlined, size: 20),
                onPressed: () => _showChangedFiles(context),
              ),
            ],
            PresenceAvatars(roster: roster),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // `.oc-banner` — provider · model · path · ctx gauge ·
                // quota, pinned above the transcript.
                SessionSubheader(
                  sessionId: sessionId,
                  provider: provider,
                  projectId: widget.projectId,
                  projectPath: widget.projectPath,
                  dense: widget.dense,
                ),
                if (hasMore)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: state.loadingOlder
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : TextButton.icon(
                            icon: const Icon(Icons.history, size: 16),
                            label: const Text('Load older messages'),
                            onPressed: _loadOlder,
                          ),
                  ),
                if (state.olderError != null)
                  TextButton(
                    onPressed: _loadOlder,
                    child: Text('Retry loading older — ${state.olderError}'),
                  ),
                Expanded(
                  child: state.loading && messages.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : state.error != null && messages.isEmpty
                      ? Center(child: Text('${state.error}'))
                      : ScrollablePositionedList.builder(
                          itemScrollController: _itemScroll,
                          itemPositionsListener: _positions,
                          initialScrollIndex: grouped.rows.isEmpty
                              ? 0
                              : grouped.rows.length - 1,
                          initialAlignment: 1,
                          // `.chat-messages-pane .mx-auto { max-width: 900px }`
                          // — the transcript keeps a reading column instead of
                          // stretching edge to edge on wide panes.
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: _readingColumnPadding(
                              MediaQuery.sizeOf(context).width,
                            ),
                          ),
                          itemCount: grouped.rows.length,
                          itemBuilder: (context, i) {
                            final row = grouped.rows[i];
                            if (row is ToolGroup) {
                              return ToolGroupTile(
                                key: ValueKey(row.messages.first.id),
                                group: row,
                                tileBuilder: (m) => MessageTile(
                                  message: m,
                                  sessionId: sessionId,
                                  projectId: widget.projectId,
                                  childrenMap: grouped.children,
                                ),
                              );
                            }
                            final m = row as SessionMessage;
                            final prevIdx = messages.indexWhere(
                              (x) => x.id == m.id,
                            );
                            return MessageTile(
                              key: ValueKey(m.id),
                              message: m,
                              previous: prevIdx > 0
                                  ? messages[prevIdx - 1]
                                  : null,
                              sessionId: sessionId,
                              projectId: widget.projectId,
                              childrenMap: grouped.children,
                            );
                          },
                        ),
                ),
                _PermissionBanner(
                  sessionId: sessionId,
                  projectId: widget.projectId,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: ChatComposer(
                    sessionId: sessionId,
                    projectId: widget.projectId,
                    projectPath: widget.projectPath,
                    provider: provider,
                  ),
                ),
              ],
            ),
            if (!_atBottom)
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton.small(
                  onPressed: _jumpToBottom,
                  child: Badge.count(
                    count: _unread,
                    isLabelVisible: _unread > 0,
                    child: const Icon(Icons.arrow_downward),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

const _orchestratorIcons = {
  'routing': Icons.alt_route,
  'plan': Icons.map_outlined,
  'delegation': Icons.call_split,
  'summary': Icons.summarize_outlined,
  'user': Icons.person_outline,
};

/// One transcript row — dispatch on `kind` covering every MessageKind.
class MessageTile extends ConsumerWidget {
  const MessageTile({
    required this.message,
    required this.sessionId,
    this.projectId,
    this.previous,
    this.childrenMap = const {},
    super.key,
  });

  final SessionMessage message;
  final SessionMessage? previous;
  final String sessionId;
  final String? projectId;

  /// Subagent children index from `groupToolRuns` (T15.8).
  final Map<String, List<SessionMessage>> childrenMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (message.isLocalCommand || message.isLocalCommandStdout) {
      return _wrap(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            message.isLocalCommand
                ? '! ${message.commandMessage ?? message.content ?? ''}'
                : (message.content ?? message.commandMessage ?? ''),
            style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
        ),
      );
    }

    if (message.isCompactSummary) {
      return _wrap(
        _card(
          cs,
          icon: Icons.compress,
          title: 'Compacted summary',
          child: AppMarkdown(data: message.content ?? message.summary ?? ''),
        ),
      );
    }

    switch (message.kind) {
      case 'text':
        return message.role == 'user'
            ? _userBubble(context)
            : _assistantText(context);
      case 'stream_delta':
        return _assistantText(context, live: true);
      case 'thinking' || 'thought_delta':
        // Reasoning trigger — `ⓘ Thought for a few seconds ⌄` with the
        // chevron right after the label (Reasoning.tsx), not pushed to the
        // far edge of the column.
        return _wrap(
          _ReasoningRow(
            label: message.kind == 'thought_delta'
                ? 'Thinking...'
                : 'Thought for a few seconds',
            content: message.content ?? '',
          ),
        );
      case 'tool_use':
        return _wrap(ToolUseTile(message: message, childrenMap: childrenMap));
      case 'tool_result':
        // The web transcript folds a tool's output into its own row —
        // standalone result lines only survive as errors.
        if (!message.isError) return const SizedBox.shrink();
        return _wrap(ToolResultTile(message: message));
      case 'status':
        final orchKind = message.context?['orchestratorKind']?.toString();
        // Empty status rows carry no text — the old transcript skips them.
        if (orchKind == null &&
            (message.status ?? message.content ?? '').isEmpty) {
          return const SizedBox.shrink();
        }
        if (orchKind != null) {
          return _wrap(
            OrchestratorCard(
              message: message,
              sessionId: sessionId,
              projectId: projectId,
            ),
          );
        }
        return _wrap(
          Row(
            children: [
              Icon(
                _orchestratorIcons[orchKind] ?? Icons.info_outline,
                size: 14,
                color: cs.outline,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  message.status ?? message.content ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.outline,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      case 'error':
        return _wrap(
          _card(
            cs,
            color: cs.errorContainer,
            icon: Icons.error_outline,
            title: 'Error',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(message.content ?? message.text ?? ''),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resend from the composer')),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      case 'complete':
        return _wrap(
          Row(
            children: [
              Expanded(child: Divider(color: cs.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Run complete',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.outline,
                  ),
                ),
              ),
              Expanded(child: Divider(color: cs.outlineVariant)),
            ],
          ),
        );
      case 'permission_request':
        return _permissionCard(context, ref);
      // Control events — the web transcript never renders these
      // (`useChatMessages.ts` skips stream_end/complete/session_created).
      case 'stream_end' || 'complete' || 'session_created':
        return const SizedBox.shrink();
      case 'permission_cancelled':
        return const SizedBox.shrink();
      case 'interactive_prompt':
        final options = message.context?['options'];
        return _wrap(
          _card(
            cs,
            icon: Icons.help_outline,
            title: message.content ?? 'Question',
            child: options is List
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final o in options)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            o is Map
                                ? '${o['number'] ?? ''}. ${o['text'] ?? o}'
                                : '$o',
                          ),
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        );
      case 'task_notification':
        final target = message.actualSessionId;
        return _wrap(
          _card(
            cs,
            icon: Icons.notifications_outlined,
            title: 'Notification',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(message.content ?? message.summary ?? ''),
                if (target != null && target.isNotEmpty && target != sessionId)
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: const Text('Open session'),
                    onPressed: () => context.go('/chat/$target'),
                  ),
              ],
            ),
          ),
        );
      default:
        return _wrap(
          SelectableText(
            message.content ?? message.text ?? '[${message.kind}]',
            style: theme.textTheme.bodySmall,
          ),
        );
    }
  }

  Widget _wrap(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: MessageActions(message: message, child: child),
  );

  Widget _assistantText(BuildContext context, {bool live = false}) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final time = clockTime(message.timestamp);
    final muted = t.labelSmall?.copyWith(color: c.mutedForeground);
    return _wrap(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppMarkdown(data: message.content ?? ''),
          if (live)
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          MessageAttachments(message: message),
          // `▣ <provider> · <time>` — oc-assistant-footer from index.css.
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                Text('▣', style: t.labelSmall?.copyWith(color: c.primary)),
                Text(
                  providerLabel(message.provider),
                  style: t.labelSmall?.copyWith(color: c.foreground),
                ),
                if (time.isNotEmpty) ...[
                  Text('·', style: muted),
                  Text(time, style: muted),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// User turn — `.oc-user-body`: panel bg, 3px accent left border, 8/12
  /// padding, square corners (opencode UserMessage).
  Widget _userBubble(BuildContext context) {
    final c = context.appColors;
    return _wrap(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: c.card,
          border: Border(left: BorderSide(color: c.primary, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(message.content ?? ''),
            MessageAttachments(message: message),
          ],
        ),
      ),
    );
  }

  Widget _permissionCard(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final requestId = message.requestId;
    final toolName =
        (message.context?['toolName'] ?? message.toolName)?.toString() ?? '';
    final input = message.toolInput is Map
        ? Map<String, dynamic>.from(message.toolInput as Map)
        : message.context?['input'] is Map
        ? Map<String, dynamic>.from(message.context!['input'] as Map)
        : <String, dynamic>{};
    final isAskUser =
        toolName.toLowerCase().replaceAll(' ', '_') == 'askuserquestion' ||
        toolName.toLowerCase().replaceAll(' ', '_') == 'ask_user_question' ||
        input['questions'] is List;
    final rememberEntry = message.context?['rememberEntry']?.toString();

    void decide({required bool allow, dynamic updatedInput, dynamic remember}) {
      if (requestId == null) return;
      ref
          .read(
            transcriptProvider((sessionId: sessionId, projectId: projectId))
                .notifier,
          )
          .decidePermission(
            requestId,
            allow: allow,
            updatedInput: updatedInput,
            rememberEntry: remember,
          );
    }

    return _wrap(
      _card(
        cs,
        color: cs.tertiaryContainer,
        icon: Icons.lock_outline,
        title: isAskUser ? 'Question' : 'Permission request · $toolName',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isAskUser)
              SelectableText(message.content ?? message.text ?? ''),
            if (!isAskUser) const SizedBox(height: 8),
            // Server also enforces roleAtLeast('member') on this frame.
            RequireRole(
              minimum: 'member',
              fallback: Text(
                'Viewers cannot approve',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: cs.outline),
              ),
              child: isAskUser && requestId != null
                  ? AskUserQuestionPanel(
                      requestId: requestId,
                      input: input,
                      onDecision: (allow, updatedInput) =>
                          decide(allow: allow, updatedInput: updatedInput),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        FilledButton.tonal(
                          onPressed: requestId == null
                              ? null
                              : () => decide(allow: true),
                          child: const Text('Allow'),
                        ),
                        if (rememberEntry != null)
                          FilledButton.tonal(
                            onPressed: requestId == null
                                ? null
                                : () => decide(
                                    allow: true,
                                    remember: rememberEntry,
                                  ),
                            child: const Text('Always'),
                          ),
                        TextButton(
                          onPressed: requestId == null
                              ? null
                              : () =>
                                    _editInputDialog(context, input).then((v) {
                                      if (v != null) {
                                        decide(allow: true, updatedInput: v);
                                      }
                                    }),
                          child: const Text('Edit & allow'),
                        ),
                        TextButton(
                          onPressed: requestId == null
                              ? null
                              : () => decide(allow: false),
                          child: const Text('Deny'),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _editInputDialog(
    BuildContext context,
    Map<String, dynamic> input,
  ) {
    final ctrl = TextEditingController(
      text: const JsonEncoder.withIndent('  ').convert(input),
    );
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit input'),
        content: SizedBox(
          width: 480,
          child: TextField(
            controller: ctrl,
            maxLines: 12,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              try {
                final v = jsonDecode(ctrl.text);
                Navigator.pop(
                  ctx,
                  v is Map ? Map<String, dynamic>.from(v) : input,
                );
              } on Object {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Invalid JSON')));
              }
            },
            child: const Text('Allow with changes'),
          ),
        ],
      ),
    );
  }

  static Widget _card(
    ColorScheme cs, {
    required IconData icon,
    required String title,
    required Widget child,
    Color? color,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color ?? cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: cs.outlineVariant),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    ),
  );
}

/// Copy + raw view + timestamp tooltip — hover actions on each row (T13.7).
class MessageActions extends ConsumerStatefulWidget {
  const MessageActions({required this.message, required this.child, super.key});

  final SessionMessage message;
  final Widget child;

  @override
  ConsumerState<MessageActions> createState() => _MessageActionsState();
}

class _MessageActionsState extends ConsumerState<MessageActions> {
  /// Row actions follow the web transcript: hidden until the row is hovered
  /// (`.oc-footer-actions { opacity: 0 }`).
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final child = widget.child;
    final stamp = clockTime(message.timestamp);
    final ttsState = ref.watch(ttsControllerProvider);
    final isSpeaking = ttsState.isSpeakingMessage(message.id);
    final textToSpeak = message.content ?? message.text ?? '';

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Tooltip(
        message: stamp,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: child),
            AnimatedOpacity(
              duration: AppMotion.base,
              opacity: _hover ? 1 : 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (textToSpeak.trim().isNotEmpty)
                    IconButton(
                      icon: Icon(
                        isSpeaking ? Icons.stop : Icons.volume_up_outlined,
                        size: 14,
                        color: isSpeaking
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      tooltip: isSpeaking
                          ? 'Stop speaking'
                          : 'Read aloud (TTS)',
                      padding: EdgeInsets.zero,
                      iconSize: 14,
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      onPressed: () {
                        if (isSpeaking) {
                          ref.read(ttsControllerProvider.notifier).stop();
                        } else {
                          unawaited(
                            ref
                                .read(ttsControllerProvider.notifier)
                                .speak(message.id, textToSpeak),
                          );
                        }
                      },
                    ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 14),
                    padding: EdgeInsets.zero,
                    iconSize: 14,
                    onSelected: (v) async {
                      if (v == 'copy') {
                        await Clipboard.setData(
                          ClipboardData(
                            text: message.content ?? message.text ?? '',
                          ),
                        );
                      } else if (v == 'raw' && context.mounted) {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SingleChildScrollView(
                              child: SelectableText(
                                const JsonEncoder.withIndent('  ').convert({
                                  'id': message.id,
                                  'kind': message.kind,
                                  'role': message.role,
                                  'provider': message.provider,
                                  'timestamp': message.timestamp,
                                  'seq': message.seq,
                                  'runId': message.runId,
                                  'content': message.content,
                                  'toolName': message.toolName,
                                  'toolInput': message.toolInput,
                                  'context': message.context,
                                }),
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'copy', child: Text('Copy')),
                      PopupMenuItem(value: 'raw', child: Text('Raw view')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Image attachments (data URL or `/api/assets/images/<file>`) + file chips.
class MessageAttachments extends StatelessWidget {
  const MessageAttachments({required this.message, super.key});

  final SessionMessage message;

  @override
  Widget build(BuildContext context) {
    final images = message.images ?? const [];
    final files = message.files ?? const [];
    if (images.isEmpty && files.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final img in images) _ImageThumb(image: img),
          for (final f in files)
            ActionChip(
              avatar: const Icon(Icons.attach_file, size: 14),
              label: Text('${f['name'] ?? f['path'] ?? 'file'}'),
              onPressed: () => Clipboard.setData(
                ClipboardData(text: '${f['path'] ?? f['name'] ?? ''}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({required this.image});

  final Map<String, dynamic> image;

  @override
  Widget build(BuildContext context) {
    final data = image['data']?.toString();
    final path = image['path']?.toString() ?? '';
    final filename = path.split(RegExp(r'[\\/]')).last;
    final Widget thumb = data != null && data.startsWith('data:image')
        ? Image.memory(
            base64Decode(data.split(',').last),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          )
        : AuthImage(url: '/api/assets/images/$filename', fit: BoxFit.cover);
    return GestureDetector(
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          child: InteractiveViewer(
            child: data != null && data.startsWith('data:image')
                ? Image.memory(base64Decode(data.split(',').last))
                : AuthImage(url: '/api/assets/images/$filename'),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: 120, height: 120, child: thumb),
      ),
    );
  }
}

/// Sticky pending-approval banner above the composer
/// (PermissionRequestsBanner.tsx parity): one row per unanswered request with
/// Allow / Allow all / Reject, so approvals can't be scrolled past.
class _PermissionBanner extends ConsumerWidget {
  const _PermissionBanner({required this.sessionId, this.projectId});

  final String sessionId;
  final String? projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(sessionPendingPermissionsProvider(sessionId));
    if (pending.isEmpty) return const SizedBox.shrink();
    final c = context.appColors;
    final t = Theme.of(context).textTheme;

    void decide(PendingPermission p, {required bool allow}) => ref
        .read(
          transcriptProvider((sessionId: sessionId, projectId: projectId))
              .notifier,
        )
        .decidePermission(
          p.requestId,
          allow: allow,
          rememberEntry: allow ? p.rememberEntry : null,
        );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: c.card,
        border: Border.all(color: const Color(0xFFF59E0B)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final p in pending)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.lock,
                    size: 14,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '${p.toolName} needs approval',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall?.copyWith(color: c.foreground),
                    ),
                  ),
                  TextButton(
                    onPressed: () => decide(p, allow: true),
                    child: const Text('Allow'),
                  ),
                  if (p.rememberEntry != null)
                    TextButton(
                      onPressed: () => decide(p, allow: true),
                      child: const Text('Always'),
                    ),
                  TextButton(
                    onPressed: () => decide(p, allow: false),
                    child: Text(
                      'Reject',
                      style: TextStyle(color: c.destructive),
                    ),
                  ),
                ],
              ),
            ),
          if (pending.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  for (final p in pending) {
                    decide(p, allow: true);
                  }
                },
                child: Text('Allow all (${pending.length})'),
              ),
            ),
        ],
      ),
    );
  }
}

/// Horizontal inset that keeps the transcript at the web's 900px reading
/// column (`.chat-messages-pane .mx-auto`), with the 12px gutter on narrow
/// panes.
double _readingColumnPadding(double width) {
  const gutter = 12.0;
  const column = 900.0;
  final side = (width - column) / 2;
  return side > gutter ? side : gutter;
}

/// Chat status strip — `* <Provider> · <project path>` in the old pane's
/// header (`oc-status` row above the transcript).
class _StatusStrip extends StatelessWidget {
  const _StatusStrip({this.provider, this.projectPath});

  final String? provider;
  final String? projectPath;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final style = t.bodySmall?.copyWith(color: c.mutedForeground, fontSize: 12);
    final path = projectPath ?? '';
    return Row(
      spacing: AppSpacing.sm,
      children: [
        Text('*', style: style?.copyWith(color: c.primary)),
        Flexible(
          child: Text(
            [
              if (provider != null && provider!.isNotEmpty)
                providerLabel(provider!),
              if (path.isNotEmpty) path,
            ].join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

/// Collapsed reasoning row — `ⓘ label ⌄` with the chevron inline, expanding
/// to the thinking text (web `Reasoning` trigger).
class _ReasoningRow extends StatefulWidget {
  const _ReasoningRow({required this.label, required this.content});

  final String label;
  final String content;

  @override
  State<_ReasoningRow> createState() => _ReasoningRowState();
}

class _ReasoningRowState extends State<_ReasoningRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final style = t.bodySmall?.copyWith(color: c.mutedForeground);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.sm,
              children: [
                Icon(LucideIcons.info, size: 14, color: c.mutedForeground),
                Text(widget.label, style: style),
                Icon(
                  _open ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  size: 14,
                  color: c.mutedForeground,
                ),
              ],
            ),
          ),
        ),
        if (_open)
          Padding(
            padding: const EdgeInsets.only(left: 22, bottom: 8),
            child: AppMarkdown(data: widget.content),
          ),
      ],
    );
  }
}
