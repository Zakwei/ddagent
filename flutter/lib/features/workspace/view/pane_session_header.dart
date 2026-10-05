import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/chat/state/transcript_tools_controller.dart';
import 'package:ddagent_app/features/orchestrator/state/orchestrator_controller.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/pane_header_metrics.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Chat-pane header row (port of PaneSessionHeader.tsx): provider logo,
/// click-to-rename session title (pencil on hover), required-action indicator,
/// and trailing session/pane actions. Narrow panes wrap actions below the title.
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
    this.trailingActions = const [],
    this.action = PaneAction.idle,
    this.onChangeWorkspace,
    this.onNavigateToSession,
  });

  final String sessionId;
  final String title;
  final String? projectName;
  final String? provider;
  final List<Widget> trailingActions;
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
    final i18n = Translations.of(context);
    final field = TextEditingController(text: widget.title);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: i18n.common.sessions.renameSession,
        content: AppInput(controller: field, autofocus: true),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(i18n.chat.orchestrator.summary.cancelTasks),
          ),
          AppButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(i18n.codeEditor.actions.save),
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
    final i18n = Translations.of(context);
    final c = context.appColors;
    // Delegated sessions carry an orchestrator parent — the arrow-left button
    // rebinds this pane to it (web `backToParent`). Orchestrator roots and
    // missing parents render nothing.
    final parentId = widget.provider == 'orchestrator'
        ? null
        : ref.watch(orchestratorParentProvider(widget.sessionId)).value;
    final guarded = widget.action != PaneAction.idle;
    final m = paneHeaderMetrics(context);
    final title = Row(
      children: [
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
            child: Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFF59E0B)),
          )
        else if (widget.action == PaneAction.processing)
          const Padding(
            padding: EdgeInsets.only(right: AppSpacing.xs),
            child: SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF10B981)),
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
              message: i18n.common.sessions.renameSession,
              child: GestureDetector(
                onTap: () => unawaited(_renameDialog(context)),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Expanded(
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
                        child: Icon(LucideIcons.pencil, size: 12, color: c.mutedForeground),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
    final actions = <Widget>[
      if (parentId != null && widget.onNavigateToSession != null)
        _headerIcon(
          icon: LucideIcons.arrowLeft,
          tooltip: Translations.of(context).chat.orchestrator.backToParent,
          onPressed: () => widget.onNavigateToSession!(parentId),
        ),
      ..._transcriptTools(context),
      // History — the web's "Switch session" h-4 w-4 button (h-3 icon).
      _headerIcon(
        icon: LucideIcons.history,
        tooltip: i18n.chat.paneHeader.switchSession,
        onPressed: widget.onChangeSession,
      ),
      PopupMenuButton<String>(
        constraints: const BoxConstraints(minWidth: 160),
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
          PopupMenuItem(value: 'rename', child: Text(i18n.common.fileOperations.rename)),
          PopupMenuItem(value: 'change', child: Text(i18n.chat.sessionPicker.changeSession)),
          if (widget.onChangeWorkspace != null)
            PopupMenuItem(
              value: 'workspace',
              // Web disables cwd repoint mid-run — tools would run in the
              // wrong folder.
              enabled: !guarded,
              child: Text(i18n.sidebar.workspace.submit),
            ),
          // Web disables archive/delete while processing or awaiting a
          // permission answer — the server rejects those mid-run anyway.
          PopupMenuItem(
            value: 'archive',
            enabled: !guarded,
            child: Text(i18n.sidebar.search.archiveOnly),
          ),
          PopupMenuItem(
            value: 'delete',
            enabled: !guarded,
            child: Text(
              i18n.sidebar.deleteConfirmation.deleteSessionPermanently,
              style: TextStyle(color: c.destructive),
            ),
          ),
        ],
        child: SizedBox(
          width: m.hit,
          height: m.hit,
          child: Icon(Icons.more_vert, size: m.icon, color: c.mutedForeground),
        ),
      ),
      ...widget.trailingActions,
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep a useful title area before wrapping the fixed-size actions.
        final tools = ref.watch(transcriptToolsProvider(widget.sessionId));
        final actionWidth =
            actions.length * m.hit +
            (tools.searchActive ? (context.breakpoint.isCompact ? 96 : 140) - m.hit : 0) +
            (tools.searching ? 80 - m.hit : 0);
        if (constraints.maxWidth >= actionWidth + 80) {
          return Row(
            children: [
              Expanded(child: title),
              ...actions,
            ],
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: m.hit, child: title),
            Wrap(alignment: WrapAlignment.end, children: actions),
          ],
        );
      },
    );
  }

  /// Fixed hit area shared with the toolbar and the surrounding pane actions.
  Widget _headerIcon({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final c = context.appColors;
    final m = paneHeaderMetrics(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(3),
        child: SizedBox(
          width: m.hit,
          height: m.hit,
          child: Icon(icon, size: m.icon, color: c.mutedForeground),
        ),
      ),
    );
  }

  /// Export menu + review toggle + collapsible search field, inline before
  /// the history/menu icons. The search field expands in place so the bar
  /// never reserves the space while idle.
  List<Widget> _transcriptTools(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final m = paneHeaderMetrics(context);
    final controller = ref.read(transcriptToolsProvider(widget.sessionId).notifier);
    final tools = ref.watch(transcriptToolsProvider(widget.sessionId));

    Widget iconButton({
      required IconData icon,
      required String tooltip,
      required VoidCallback? onTap,
      bool active = false,
    }) => Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(3),
        child: SizedBox(
          width: m.hit,
          height: m.hit,
          child: Icon(icon, size: m.icon, color: active ? c.primary : c.mutedForeground),
        ),
      ),
    );

    return [
      // Export chat — markdown / html / pdf.
      PopupMenuButton<String>(
        tooltip: i18n.workspace.exportChat,
        padding: EdgeInsets.zero,
        position: PopupMenuPosition.under,
        offset: const Offset(0, 8),
        color: c.card,
        elevation: 6,
        constraints: const BoxConstraints.tightFor(width: 192),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.borderLg,
          side: BorderSide(color: c.border.withValues(alpha: 0.5)),
        ),
        onSelected: (f) => unawaited(
          exportTranscript(
            context,
            widget.sessionId,
            ref.read(sessionMessagesProvider(widget.sessionId)),
            f,
          ),
        ),
        itemBuilder: (_) => [
          PopupMenuItem<String>(
            enabled: false,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Export as:',
              style: t.labelSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: c.mutedForeground,
              ),
            ),
          ),
          _exportItem('markdown', LucideIcons.fileText, 'Markdown (.md)'),
          _exportItem('html', LucideIcons.fileJson, 'Web Page (.html)'),
          _exportItem('pdf', LucideIcons.fileJson, 'PDF (Print to File)'),
        ],
        child: SizedBox(
          width: m.hit,
          height: m.hit,
          child: Icon(LucideIcons.download, size: m.icon, color: c.mutedForeground),
        ),
      ),
      // Review changed files.
      iconButton(
        icon: LucideIcons.filter,
        tooltip: tools.reviewOpen
            ? i18n.common.quota.backToChat
            : i18n.workspace.reviewChangedFiles,
        active: tools.reviewOpen,
        onTap: controller.toggleReview,
      ),
      // Search — icon only until tapped, then the field + nav grow in place.
      if (!tools.searchActive)
        iconButton(
          icon: LucideIcons.search,
          tooltip: i18n.workspace.searchTranscript,
          onTap: controller.openSearch,
        )
      else ...[
        if (tools.searching) ...[
          SizedBox(
            width: 80,
            child: Text(
              tools.matches.isEmpty ? '0 of 0' : '${tools.matchPos + 1} of ${tools.matches.length}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.labelSmall?.copyWith(color: c.mutedForeground, fontSize: 11),
            ),
          ),
          iconButton(
            icon: LucideIcons.chevronUp,
            tooltip: i18n.workspace.previousMatch,
            onTap: tools.matches.isEmpty
                ? null
                : () => controller.goToMatch(
                    (tools.matchPos - 1 + tools.matches.length) % tools.matches.length,
                  ),
          ),
          iconButton(
            icon: LucideIcons.chevronDown,
            tooltip: i18n.workspace.nextMatch,
            onTap: tools.matches.isEmpty
                ? null
                : () => controller.goToMatch((tools.matchPos + 1) % tools.matches.length),
          ),
        ],
        SizedBox(
          width: context.breakpoint.isCompact ? 96 : 140,
          child: Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
                controller.closeSearch();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: TextField(
              controller: controller.searchController,
              focusNode: controller.searchFocus,
              style: t.labelSmall?.copyWith(fontSize: 12),
              decoration: InputDecoration(
                hintText: i18n.common.buttons.search,
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: controller.onQueryChanged,
            ),
          ),
        ),
        iconButton(
          icon: LucideIcons.x,
          tooltip: i18n.workspace.closeSearch,
          onTap: controller.closeSearch,
        ),
      ],
    ];
  }

  PopupMenuItem<String> _exportItem(String value, IconData icon, String label) {
    final c = context.appColors;
    return PopupMenuItem<String>(
      value: value,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        spacing: 8,
        children: [
          Icon(icon, size: 16, color: c.mutedForeground),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
