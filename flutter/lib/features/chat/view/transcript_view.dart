import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/core/widgets/auth_image.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/chat/view/tool_blocks.dart';
import 'package:ddagent_app/features/collab/role.dart';
import 'package:ddagent_app/features/collab/state/presence_controller.dart';
import 'package:ddagent_app/features/collab/view/presence_avatars.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Transcript pane for one session (T13): virtualized list of all
/// MessageKinds, top-of-list older-page loading, jump-to-bottom + unread
/// counter, presence announce (`{kind:'session'}`) while mounted.
class TranscriptView extends ConsumerStatefulWidget {
  const TranscriptView({
    required this.sessionId,
    this.projectId,
    this.projectPath,
    super.key,
  });

  final String sessionId;
  final String? projectId;
  final String? projectPath;

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
                    return ListTile(
                      dense: true,
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

  void _export(String format, List<SessionMessage> messages) {
    final text = format == 'html'
        ? transcriptToHtml(messages, title: 'Session ${widget.sessionId}')
        : transcriptToMarkdown(messages, title: 'Session ${widget.sessionId}');
    unawaited(Clipboard.setData(ClipboardData(text: text)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transcript copied as ${format.toUpperCase()}')),
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

    return Scaffold(
      appBar: AppBar(
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
            : const Text('Session'),
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
              onSelected: (f) => _export(f, messages),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'markdown', child: Text('Copy Markdown')),
                PopupMenuItem(value: 'html', child: Text('Copy HTML')),
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
                        padding: const EdgeInsets.all(12),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: ChatComposer(
                  sessionId: sessionId,
                  projectId: widget.projectId,
                  projectPath: widget.projectPath,
                  provider: messages.lastOrNull?.provider ?? 'claude',
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
        return _wrap(
          ExpansionTile(
            dense: true,
            tilePadding: EdgeInsets.zero,
            leading: const Icon(Icons.psychology_alt_outlined, size: 18),
            title: Text(
              'Thinking',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.outline),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 8),
                child: AppMarkdown(data: message.content ?? ''),
              ),
            ],
          ),
        );
      case 'tool_use':
        return _wrap(ToolUseTile(message: message, childrenMap: childrenMap));
      case 'tool_result':
        return _wrap(ToolResultTile(message: message));
      case 'status':
        final orchKind = message.context?['orchestratorKind']?.toString();
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
      case 'permission_cancelled':
        return _wrap(
          Text(
            'Permission request cancelled',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.outline,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      case 'session_created':
        return _wrap(
          Align(
            alignment: Alignment.center,
            child: Chip(
              avatar: const Icon(Icons.fiber_new, size: 14),
              label: Text('Session started · ${message.provider}'),
            ),
          ),
        );
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
    return _wrap(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.provider.isNotEmpty &&
              previous?.provider != message.provider)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                message.provider,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.outline),
              ),
            ),
          AppMarkdown(data: message.content ?? ''),
          if (live)
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          MessageAttachments(message: message),
        ],
      ),
    );
  }

  Widget _userBubble(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _wrap(
      Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(message.content ?? ''),
                MessageAttachments(message: message),
              ],
            ),
          ),
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
class MessageActions extends StatelessWidget {
  const MessageActions({required this.message, required this.child, super.key});

  final SessionMessage message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final stamp = message.timestamp.isEmpty
        ? ''
        : DateTime.tryParse(message.timestamp)?.toLocal().toString() ??
              message.timestamp;
    return Tooltip(
      message: stamp,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: child),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 14),
            padding: EdgeInsets.zero,
            iconSize: 14,
            onSelected: (v) async {
              if (v == 'copy') {
                await Clipboard.setData(
                  ClipboardData(text: message.content ?? message.text ?? ''),
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
