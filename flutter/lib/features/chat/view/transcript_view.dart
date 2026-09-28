import 'dart:convert';

import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/core/widgets/auth_image.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/collab/role.dart';
import 'package:ddagent_app/features/collab/state/presence_controller.dart';
import 'package:ddagent_app/features/collab/view/presence_avatars.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Transcript pane for one session (T13): virtualized list of all
/// MessageKinds, top-of-list older-page loading, jump-to-bottom + unread
/// counter, presence announce (`{kind:'session'}`) while mounted.
class TranscriptView extends ConsumerStatefulWidget {
  const TranscriptView({required this.sessionId, this.projectId, this.projectPath, super.key});

  final String sessionId;
  final String? projectId;
  final String? projectPath;

  TranscriptArg get _arg => (sessionId: sessionId, projectId: projectId);

  @override
  ConsumerState<TranscriptView> createState() => _TranscriptViewState();
}

class _TranscriptViewState extends ConsumerState<TranscriptView> {
  final _scroll = ScrollController();
  bool _atBottom = true;
  int _unread = 0;
  int _seenCount = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final atBottom =
          !_scroll.hasClients || _scroll.position.pixels >= _scroll.position.maxScrollExtent - 48;
      if (atBottom != _atBottom) setState(() => _atBottom = atBottom);
      if (atBottom) _unread = 0;
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _jumpToBottom() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    setState(() => _unread = 0);
  }

  @override
  Widget build(BuildContext context) {
    final sessionId = widget.sessionId;
    // Mounting the presence provider announces {kind:'session', id}; dispose
    // clears it — wiring T12.4 to a real surface.
    final roster = ref.watch(presenceProvider((kind: 'session', id: sessionId)));
    final state = ref.watch(transcriptProvider(widget._arg));
    final messages = ref.watch(sessionMessagesProvider(sessionId));
    final hasMore = ref.watch(
      sessionMessageStoreProvider.select((s) => s[sessionId]?.hasMore ?? false),
    );

    if (messages.length > _seenCount) {
      final added = messages.length - _seenCount;
      _seenCount = messages.length;
      if (!_atBottom) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _unread += added);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_scroll.hasClients) return;
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
        actions: [PresenceAvatars(roster: roster)],
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
                          onPressed: () =>
                              ref.read(transcriptProvider(widget._arg).notifier).loadOlder(),
                        ),
                ),
              if (state.olderError != null)
                TextButton(
                  onPressed: () => ref.read(transcriptProvider(widget._arg).notifier).loadOlder(),
                  child: Text('Retry loading older — ${state.olderError}'),
                ),
              Expanded(
                child: state.loading && messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : state.error != null && messages.isEmpty
                    ? Center(child: Text('${state.error}'))
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.all(12),
                        itemCount: messages.length,
                        itemBuilder: (context, i) => MessageTile(
                          key: ValueKey(messages[i].id),
                          message: messages[i],
                          previous: i > 0 ? messages[i - 1] : null,
                          sessionId: sessionId,
                        ),
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
  const MessageTile({required this.message, required this.sessionId, this.previous, super.key});

  final SessionMessage message;
  final SessionMessage? previous;
  final String sessionId;

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
        return message.role == 'user' ? _userBubble(context) : _assistantText(context);
      case 'stream_delta':
        return _assistantText(context, live: true);
      case 'thinking' || 'thought_delta':
        return _wrap(
          ExpansionTile(
            dense: true,
            tilePadding: EdgeInsets.zero,
            leading: const Icon(Icons.psychology_alt_outlined, size: 18),
            title: Text('Thinking', style: theme.textTheme.bodySmall?.copyWith(color: cs.outline)),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 8),
                child: AppMarkdown(data: message.content ?? ''),
              ),
            ],
          ),
        );
      case 'tool_use':
        return _wrap(
          ExpansionTile(
            dense: true,
            tilePadding: EdgeInsets.zero,
            leading: const Icon(Icons.build_outlined, size: 18),
            title: Text(message.toolName ?? 'tool', style: theme.textTheme.bodyMedium),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 8),
                  child: SelectableText(
                    const JsonEncoder.withIndent('  ').convert(message.toolInput),
                    style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'tool_result':
        final content = message.toolResult?['content']?.toString() ?? message.content ?? '';
        return _wrap(
          ExpansionTile(
            dense: true,
            tilePadding: EdgeInsets.zero,
            leading: Icon(
              message.isError ? Icons.error_outline : Icons.check_circle_outline,
              size: 18,
              color: message.isError ? cs.error : cs.outline,
            ),
            title: Text(
              message.toolName ?? 'result',
              style: theme.textTheme.bodySmall?.copyWith(
                color: message.isError ? cs.error : cs.outline,
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 8),
                  child: SelectableText(
                    content,
                    maxLines: 40,
                    style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'status':
        final orchKind = message.context?['orchestratorKind']?.toString();
        return _wrap(
          Row(
            children: [
              Icon(_orchestratorIcons[orchKind] ?? Icons.info_outline, size: 14, color: cs.outline),
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
                  onPressed: () =>
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Resend from the composer'))),
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
                  style: theme.textTheme.labelSmall?.copyWith(color: cs.outline),
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
                          child: Text(o is Map ? '${o['number'] ?? ''}. ${o['text'] ?? o}' : '$o'),
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        );
      case 'task_notification':
        return _wrap(
          _card(
            cs,
            icon: Icons.notifications_outlined,
            title: 'Notification',
            child: SelectableText(message.content ?? ''),
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
          if (message.provider.isNotEmpty && previous?.provider != message.provider)
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
    return _wrap(
      _card(
        cs,
        color: cs.tertiaryContainer,
        icon: Icons.lock_outline,
        title: 'Permission request',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(message.content ?? message.text ?? ''),
            const SizedBox(height: 8),
            // Server also enforces roleAtLeast('member') on this frame.
            RequireRole(
              minimum: 'member',
              fallback: Text(
                'Viewers cannot approve',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline),
              ),
              child: Row(
                children: [
                  FilledButton.tonal(
                    onPressed: requestId == null
                        ? null
                        : () => ref
                              .read(
                                transcriptProvider((sessionId: sessionId, projectId: null))
                                    .notifier,
                              )
                              .permissionResponse(requestId, allow: true),
                    child: const Text('Allow'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: requestId == null
                        ? null
                        : () => ref
                              .read(
                                transcriptProvider((sessionId: sessionId, projectId: null))
                                    .notifier,
                              )
                              .permissionResponse(requestId, allow: false),
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
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
        : DateTime.tryParse(message.timestamp)?.toLocal().toString() ?? message.timestamp;
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
                await Clipboard.setData(ClipboardData(text: message.content ?? message.text ?? ''));
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
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
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
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: '${f['path'] ?? f['name'] ?? ''}')),
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
