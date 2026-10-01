import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/orchestrator/state/orchestrator_controller.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Chat-pane header row (port of PaneSessionHeader.tsx): provider logo,
/// click-to-rename session title (pencil on hover), workspace name,
/// required-action indicator, history switch button and actions menu.
/// `projectName` follows the web's `hidden sm:inline` — compact (mobile)
/// panes drop it.
class PaneSessionHeader extends ConsumerStatefulWidget {
  const PaneSessionHeader({
    super.key,
    required this.sessionId,
    required this.title,
    required this.onChangeSession,
    required this.onRename,
    required this.onArchive,
    required this.onDelete,
    this.projectName,
    this.provider,
    this.action = PaneAction.idle,
    this.onChangeWorkspace,
    this.onNavigateToSession,
  });

  final String sessionId;
  final String title;
  final String? projectName;
  final String? provider;
  final PaneAction action;
  final VoidCallback onChangeSession;

  /// Null on the standalone `/chat/:id` route — the menu then drops the
  /// "Change workspace" entry (there is no pane to rebind).
  final VoidCallback? onChangeWorkspace;
  final ValueChanged<String> onRename;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  /// Rebinds this pane to another session — used by the back-to-orchestration
  /// button shown on delegated (subsession) panes.
  final ValueChanged<String>? onNavigateToSession;

  @override
  ConsumerState<PaneSessionHeader> createState() => _PaneSessionHeaderState();
}

class _PaneSessionHeaderState extends ConsumerState<PaneSessionHeader> {
  bool _titleHover = false;

  Future<void> _renameDialog(BuildContext context) async {
    final field = TextEditingController(text: widget.title);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Rename session',
        content: AppInput(controller: field, autofocus: true),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved == true && field.text.trim().isNotEmpty) {
      widget.onRename(field.text.trim());
    }
    field.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    // Delegated sessions carry an orchestrator parent — the arrow-left button
    // rebinds this pane to it (web `backToParent`). Orchestrator roots and
    // missing parents render nothing.
    final parentId = widget.provider == 'orchestrator'
        ? null
        : ref.watch(orchestratorParentProvider(widget.sessionId)).value;
    final guarded = widget.action != PaneAction.idle;
    return Row(
      children: [
        if (parentId != null && widget.onNavigateToSession != null)
          _headerIcon(
            icon: LucideIcons.arrowLeft,
            tooltip: 'Back to orchestration',
            onPressed: () => widget.onNavigateToSession!(parentId),
          ),
        // LLMProviderLogo h-3.5 — identifies the pane's provider at a glance.
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.xs),
          child: ProviderLogo(provider: widget.provider, size: 14),
        ),
        // requiredAction icons (PaneSessionHeader.tsx): amber triangle for a
        // pending question, a spinning emerald ring while processing.
        if (widget.action == PaneAction.question)
          const Padding(
            padding: EdgeInsets.only(right: AppSpacing.xs),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 14,
              color: Color(0xFFF59E0B),
            ),
          )
        else if (widget.action == PaneAction.processing)
          const Padding(
            padding: EdgeInsets.only(right: AppSpacing.xs),
            child: SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF10B981),
              ),
            ),
          ),
        // `group/pane-title` — the title is the rename affordance; the pencil
        // appears on hover like the web's group-hover icon.
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _titleHover = true),
            onExit: (_) => setState(() => _titleHover = false),
            child: Tooltip(
              message: 'Rename session',
              child: GestureDetector(
                onTap: () => unawaited(_renameDialog(context)),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        // text-xs font-medium text-foreground
                        style: t.textTheme.labelSmall?.copyWith(
                          color: c.foreground,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                        ),
                      ),
                    ),
                    if (_titleHover)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          LucideIcons.pencil,
                          size: 12,
                          color: c.mutedForeground,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.projectName != null && !context.breakpoint.isCompact)
          Flexible(
            child: Text(
              widget.projectName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.textTheme.labelSmall?.copyWith(
                color: c.mutedForeground.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ),
        // History — the web's "Switch session" h-4 w-4 button (h-3 icon).
        _headerIcon(
          icon: LucideIcons.history,
          tooltip: 'Switch session',
          onPressed: widget.onChangeSession,
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, size: 14, color: c.mutedForeground),
          padding: EdgeInsets.zero,
          onSelected: (v) {
            switch (v) {
              case 'rename':
                unawaited(_renameDialog(context));
              case 'change':
                widget.onChangeSession();
              case 'workspace':
                widget.onChangeWorkspace?.call();
              case 'archive':
                widget.onArchive();
              case 'delete':
                widget.onDelete();
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'rename', child: Text('Rename')),
            const PopupMenuItem(value: 'change', child: Text('Change session')),
            if (widget.onChangeWorkspace != null)
              PopupMenuItem(
                value: 'workspace',
                // Web disables cwd repoint mid-run — tools would run in the
                // wrong folder.
                enabled: !guarded,
                child: const Text('Change workspace'),
              ),
            // Web disables archive/delete while processing or awaiting a
            // permission answer — the server rejects those mid-run anyway.
            PopupMenuItem(
              value: 'archive',
              enabled: !guarded,
              child: const Text('Archive'),
            ),
            PopupMenuItem(
              value: 'delete',
              enabled: !guarded,
              child: Text(
                'Delete permanently',
                style: TextStyle(color: c.destructive),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// PaneSessionHeader.tsx button — h-4 w-4 hit area, h-3 w-3 icon,
  /// `text-muted-foreground hover:text-foreground`.
  Widget _headerIcon({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final c = context.appColors;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(3),
        child: SizedBox(
          width: 16,
          height: 16,
          child: Icon(icon, size: 12, color: c.mutedForeground),
        ),
      ),
    );
  }
}
