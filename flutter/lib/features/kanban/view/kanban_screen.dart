import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/collab/state/presence_controller.dart';
import 'package:ddagent_app/features/collab/view/collab_section.dart';
import 'package:ddagent_app/features/collab/view/presence_avatars.dart';
import 'package:ddagent_app/features/kanban/data/kanban_repository.dart';
import 'package:ddagent_app/features/kanban/state/kanban_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KanbanColumnDef {
  const KanbanColumnDef({
    required this.status,
    required this.title,
    this.color,
  });

  final String status;
  final String title;
  final Color? color;
}

const defaultKanbanColumns = <KanbanColumnDef>[
  KanbanColumnDef(status: 'backlog', title: 'Backlog'),
  KanbanColumnDef(status: 'ready', title: 'Ready to start'),
  KanbanColumnDef(status: 'working', title: 'Working'),
  KanbanColumnDef(status: 'needs_decision', title: 'Needs your decision'),
  KanbanColumnDef(status: 'done', title: 'Done'),
  KanbanColumnDef(status: 'archived', title: 'Archived'),
];

class KanbanScreen extends ConsumerStatefulWidget {
  const KanbanScreen({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends ConsumerState<KanbanScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(kanbanControllerProvider.notifier).load(widget.projectId);
      }
    });
  }

  void _showCreateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _CreateCardDialog(projectId: widget.projectId),
    );
  }

  void _showCardDetails(BuildContext context, KanbanCard card) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _CardDetailsDialog(card: card),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kanbanControllerProvider);
    final c = context.appColors;
    final pid = widget.projectId ??
        (state.projectId.isNotEmpty ? state.projectId : 'default');
    final roster = ref.watch(presenceProvider((kind: 'board', id: pid)));

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text('Agent Board'),
        backgroundColor: c.background,
        elevation: 0,
        actions: [
          PresenceAvatars(roster: roster),
          IconButton(
            key: const Key('board-activity-button'),
            tooltip: 'Activity',
            icon: const Icon(Icons.history, size: 20),
            onPressed: () => _showActivity(context, pid),
          ),
          IconButton(
            key: const Key('board-settings-button'),
            tooltip: 'Board agent settings',
            icon: const Icon(Icons.settings_outlined, size: 20),
            onPressed: () => _showBoardSettings(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: AppButton(
              key: const Key('add-card-button'),
              size: AppButtonSize.sm,
              onPressed: () => _showCreateDialog(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  Text('New card'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: state.isLoading && state.cards.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (state.error != null)
                  MaterialBanner(
                    key: const Key('kanban-error-banner'),
                    backgroundColor: c.destructive.withValues(alpha: 0.12),
                    content: Text(
                      state.error!,
                      style: TextStyle(color: c.destructive, fontSize: 13),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => ref
                            .read(kanbanControllerProvider.notifier)
                            .clearError(),
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final col in defaultKanbanColumns) ...[
                              _KanbanColumnWidget(
                                column: col,
                                cards: state.cardsForStatus(col.status),
                                onCardTap: (card) =>
                                    _showCardDetails(context, card),
                                onCardAbort: (card) {
                                  ref
                                      .read(kanbanControllerProvider.notifier)
                                      .abortCard(card.cardId);
                                },
                                onCardDropped: (card, targetStatus) {
                                  final currentCards =
                                      state.cardsForStatus(targetStatus);
                                  ref
                                      .read(kanbanControllerProvider.notifier)
                                      .moveCard(
                                        card.cardId,
                                        targetStatus,
                                        currentCards.length,
                                      );
                                },
                              ),
                              const SizedBox(width: AppSpacing.md),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showBoardSettings(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _BoardSettingsDialog(projectId: widget.projectId),
    );
  }

  void _showActivity(BuildContext context, String projectId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _ActivityDialog(projectId: projectId),
    );
  }
}

class _KanbanColumnWidget extends StatelessWidget {
  const _KanbanColumnWidget({
    required this.column,
    required this.cards,
    required this.onCardTap,
    required this.onCardAbort,
    required this.onCardDropped,
  });

  final KanbanColumnDef column;
  final List<KanbanCard> cards;
  final ValueChanged<KanbanCard> onCardTap;
  final ValueChanged<KanbanCard> onCardAbort;
  final void Function(KanbanCard card, String targetStatus) onCardDropped;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return DragTarget<KanbanCard>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        onCardDropped(details.data, column.status);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return Container(
          width: 280,
          decoration: BoxDecoration(
            color: isHovered ? c.muted.withValues(alpha: 0.5) : c.card,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(
              color: isHovered ? c.primary : c.border,
              width: isHovered ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Column header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        column.title,
                        style: TextStyle(
                          color: c.foreground,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: c.muted,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        '${cards.length}',
                        style: TextStyle(
                          color: c.mutedForeground,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Cards list
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  children: [
                    for (final card in cards)
                      _KanbanCardWidget(
                        key: ValueKey(card.cardId),
                        card: card,
                        onTap: () => onCardTap(card),
                        onAbort: () => onCardAbort(card),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KanbanCardWidget extends StatelessWidget {
  const _KanbanCardWidget({
    super.key,
    required this.card,
    required this.onTap,
    required this.onAbort,
  });

  final KanbanCard card;
  final VoidCallback onTap;
  final VoidCallback onAbort;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    final cardContent = Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.title ?? 'Untitled',
            key: Key('card-title-${card.cardId}'),
            style: TextStyle(
              color: c.foreground,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          if (card.status == 'working') ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                key: Key('abort-button-${card.cardId}'),
                variant: AppButtonVariant.destructive,
                size: AppButtonSize.sm,
                onPressed: onAbort,
                child: const Text('Abort'),
              ),
            ),
          ],
        ],
      ),
    );

    return Draggable<KanbanCard>(
      data: card,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 260,
          child: Opacity(opacity: 0.9, child: cardContent),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: cardContent,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: cardContent,
      ),
    );
  }
}

class _CreateCardDialog extends ConsumerStatefulWidget {
  const _CreateCardDialog({this.projectId});

  final String? projectId;

  @override
  ConsumerState<_CreateCardDialog> createState() => _CreateCardDialogState();
}

class _CreateCardDialogState extends ConsumerState<_CreateCardDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return AlertDialog(
      backgroundColor: c.popover,
      title: const Text('New card'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.xs),
            AppInput(
              key: const Key('card-title-input'),
              controller: _titleController,
              hint: 'Title',
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.xs),
            AppInput(
              key: const Key('card-description-input'),
              controller: _descController,
              hint: 'Description',
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          key: const Key('save-card-button'),
          onPressed: () async {
            final title = _titleController.text.trim();
            if (title.isNotEmpty) {
              await ref.read(kanbanControllerProvider.notifier).createCard({
                'title': title,
                'description': _descController.text.trim(),
                'status': 'backlog',
              }, projectId: widget.projectId);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _CardDetailsDialog extends ConsumerStatefulWidget {
  const _CardDetailsDialog({required this.card});

  final KanbanCard card;

  @override
  ConsumerState<_CardDetailsDialog> createState() => _CardDetailsDialogState();
}

class _CardDetailsDialogState extends ConsumerState<_CardDetailsDialog> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref
            .read(kanbanControllerProvider.notifier)
            .loadComments(widget.card.cardId);
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kanbanControllerProvider);
    final comments = state.comments[widget.card.cardId] ?? const [];
    final c = context.appColors;

    return AlertDialog(
      backgroundColor: c.popover,
      title: Text(widget.card.title ?? 'Card Details'),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status: ${widget.card.status}',
                style: TextStyle(color: c.mutedForeground, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Comments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (comments.isEmpty)
                Text(
                  'No comments yet',
                  style: TextStyle(color: c.mutedForeground, fontSize: 13),
                )
              else
                ...comments.map(
                  (cm) => Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: c.muted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                    child: Text(cm.body ?? ''),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppInput(
                      key: const Key('comment-input'),
                      controller: _commentController,
                      hint: 'Add comment',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    key: const Key('add-comment-button'),
                    size: AppButtonSize.sm,
                    onPressed: () async {
                      final body = _commentController.text.trim();
                      if (body.isNotEmpty) {
                        await ref
                            .read(kanbanControllerProvider.notifier)
                            .addComment(widget.card.cardId, body);
                        _commentController.clear();
                      }
                    },
                    child: const Text('Add comment'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Board agent defaults (provider/model/effort) — edits `PUT /board-config`.
class _BoardSettingsDialog extends ConsumerStatefulWidget {
  const _BoardSettingsDialog({this.projectId});

  final String? projectId;

  @override
  ConsumerState<_BoardSettingsDialog> createState() =>
      _BoardSettingsDialogState();
}

class _BoardSettingsDialogState extends ConsumerState<_BoardSettingsDialog> {
  late final TextEditingController _provider;
  late final TextEditingController _model;
  late final TextEditingController _effort;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final cfg = ref.read(kanbanControllerProvider).boardConfig;
    _provider = TextEditingController(text: '${cfg['provider'] ?? ''}');
    _model = TextEditingController(text: '${cfg['model'] ?? ''}');
    _effort = TextEditingController(text: '${cfg['effort'] ?? ''}');
  }

  @override
  void dispose() {
    _provider.dispose();
    _model.dispose();
    _effort.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    String? v(TextEditingController t) =>
        t.text.trim().isEmpty ? null : t.text.trim();

    return AlertDialog(
      backgroundColor: c.popover,
      title: const Text('Board agent settings'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Defaults for sessions started from ready cards.',
              style: TextStyle(color: c.mutedForeground, fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Provider', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.xs),
            AppInput(
              key: const Key('board-provider-input'),
              controller: _provider,
              hint: 'e.g. claude, devin',
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Model', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.xs),
            AppInput(
              key: const Key('board-model-input'),
              controller: _model,
              hint: 'Optional model override',
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Effort', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.xs),
            AppInput(
              key: const Key('board-effort-input'),
              controller: _effort,
              hint: 'Optional effort level',
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          key: const Key('save-board-settings-button'),
          onPressed: _saving
              ? null
              : () async {
                  setState(() => _saving = true);
                  final ok = await ref
                      .read(kanbanControllerProvider.notifier)
                      .saveBoardConfig({
                        'provider': v(_provider),
                        'model': v(_model),
                        'effort': v(_effort),
                      }, projectId: widget.projectId);
                  if (context.mounted) {
                    setState(() => _saving = false);
                    if (ok) Navigator.of(context).pop();
                  }
                },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

/// Project activity feed — the board shares `/api/activity` with Collab.
class _ActivityDialog extends ConsumerWidget {
  const _ActivityDialog({required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final activity = ref.watch(collabActivityProvider(projectId));

    return AlertDialog(
      backgroundColor: c.popover,
      title: const Text('Activity'),
      content: SizedBox(
        width: 420,
        height: 400,
        child: activity.when(
          data: (events) => events.isEmpty
              ? Text(
                  'No activity yet',
                  style: TextStyle(color: c.mutedForeground, fontSize: 13),
                )
              : ListView(
                  children: [
                    for (final e in events.take(50))
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('${e['summary'] ?? e['kind'] ?? ''}'),
                        subtitle: Text('${e['createdAt'] ?? ''}'),
                      ),
                  ],
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
