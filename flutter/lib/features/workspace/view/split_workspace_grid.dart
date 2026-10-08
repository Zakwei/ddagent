import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/pane_header_metrics.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';

/// Kind icon per pane (port of PANE_KIND_ICONS in SplitWorkspaceGrid.tsx).
IconData paneKindIcon(PaneKind kind) => switch (kind) {
  PaneKind.chat => Icons.chat_bubble_outline,
  PaneKind.browser => Icons.public,
  PaneKind.terminal => Icons.terminal,
  PaneKind.notes => Icons.edit_note,
  PaneKind.editor => Icons.code,
  PaneKind.git => Icons.alt_route,
};

/// Shared `focusFollowsPointer` guard (web `onPointerEnter` in Shell.tsx
/// and ChatInterface.tsx): the focused editable keeps focus when it is a
/// single-line field (web `INPUT`), or any editable outside a workspace
/// pane (`TEXTAREA` without `[data-pane-id]`); pane-local multi-line
/// fields — chat composers, the xterm helper input — hand off harmlessly.
bool hoverFocusBlockedByField() {
  final focused = FocusManager.instance.primaryFocus?.context;
  if (focused == null) return false;
  final editable = focused.findAncestorWidgetOfExactType<EditableText>();
  if (editable == null) return false;
  return editable.maxLines == 1 ||
      focused.findAncestorWidgetOfExactType<SplitWorkspaceGrid>() == null;
}

/// Split-pane grid (port of SplitWorkspaceGrid.tsx):
/// - `getSplitLayout` column/row math + last-row-partial spanning via flex,
/// - compact (<600pt): tab strip + only the active pane mounted; tabs whose
///   agent finished in the background turn green until opened, tabs waiting
///   on the user turn amber,
/// - maximized pane: hidden panes stay mounted (Offstage) so chats/terminals
///   keep state,
/// - per-pane header with drag handle (Draggable + DragTarget reorder),
///   maximize + close buttons, active-pane accent border.
class SplitWorkspaceGrid extends StatefulWidget {
  const SplitWorkspaceGrid({
    super.key,
    required this.panes,
    required this.onClosePane,
    required this.onReorderPanes,
    required this.renderPane,
    this.activePaneId,
    this.onActivatePane,
    this.renderPaneHeaderContent,
    this.paneTitle,
    this.maximizedPaneId,
    this.onToggleMaximizePane,
    this.finishedPaneIds = const {},
    this.actionPaneIds = const {},
  });

  final List<SplitPane> panes;
  final String? activePaneId;
  final ValueChanged<String>? onActivatePane;
  final ValueChanged<String> onClosePane;
  final void Function(String fromId, int toIndex) onReorderPanes;
  final Widget Function(SplitPane pane, bool isActive) renderPane;
  final Widget Function(SplitPane pane, List<Widget> actions)? renderPaneHeaderContent;
  final String Function(SplitPane pane)? paneTitle;
  final String? maximizedPaneId;
  final ValueChanged<String>? onToggleMaximizePane;

  /// Panes whose agent finished while they were in the background — their
  /// compact tab turns green until opened.
  final Set<String> finishedPaneIds;

  /// Panes waiting on the user (question / permission) — their compact tab
  /// turns amber; this wins over [finishedPaneIds].
  final Set<String> actionPaneIds;

  @override
  State<SplitWorkspaceGrid> createState() => _SplitWorkspaceGridState();
}

class _SplitWorkspaceGridState extends State<SplitWorkspaceGrid> {
  int? _dragOverIndex;

  @override
  Widget build(BuildContext context) {
    final panes = widget.panes;
    if (panes.isEmpty) return const SizedBox.shrink();
    final compact = context.breakpoint.isCompact;
    final single = panes.length == 1;
    // Tab mode: the persisted split survives, but only the active pane mounts.
    final tabMode = compact && panes.length > 1;
    final activePane = tabMode
        ? panes.firstWhere((p) => p.id == widget.activePaneId, orElse: () => panes.first)
        : null;
    final maximizeActive =
        !tabMode && panes.length > 1 && panes.any((p) => p.id == widget.maximizedPaneId);

    return Column(
      children: [
        if (activePane != null) _tabStrip(panes, activePane),
        Expanded(
          child: maximizeActive
              ? _maximized(panes)
              : tabMode
              ? _tile(
                  activePane!,
                  panes.indexOf(activePane),
                  single: false,
                  tabMode: true,
                  maximizeActive: false,
                )
              : single
              ? _tile(panes.first, 0, single: true, tabMode: false, maximizeActive: false)
              : _grid(panes, maximizeActive: false),
        ),
      ],
    );
  }

  Widget _tabStrip(List<SplitPane> panes, SplitPane activePane) {
    final c = context.appColors;
    final m = topBarMetrics(context);
    return Container(
      height: m.barHeight,
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.5))),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        children: [
          for (final p in panes)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: _tab(p, selected: p.id == activePane.id),
            ),
        ],
      ),
    );
  }

  Widget _tab(SplitPane pane, {required bool selected}) {
    final c = context.appColors;
    final t = Theme.of(context);
    final m = topBarMetrics(context);
    // A pending question outranks "finished" — it blocks the agent.
    final (accent, accentIcon) = selected
        ? (null, null)
        : widget.actionPaneIds.contains(pane.id)
        ? (_actionColor, Icons.warning_amber_rounded)
        : widget.finishedPaneIds.contains(pane.id)
        ? (_finishedColor, Icons.check_circle)
        : (null, null);
    final fg = accent ?? (selected ? c.foreground : c.mutedForeground);
    return InkWell(
      borderRadius: AppRadii.borderMd,
      onTap: () => widget.onActivatePane?.call(pane.id),
      child: Container(
        // Border is always 1px so a tab turning green doesn't shift the strip.
        padding: EdgeInsets.symmetric(horizontal: 9, vertical: (m.hit - m.icon) / 2 - 1),
        decoration: BoxDecoration(
          color: accent?.withValues(alpha: 0.15) ?? (selected ? c.background : Colors.transparent),
          border: Border.all(color: accent?.withValues(alpha: 0.6) ?? Colors.transparent),
          borderRadius: AppRadii.borderMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(accentIcon ?? paneKindIcon(pane.kind), size: m.icon, color: fg),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                widget.paneTitle?.call(pane) ?? pane.kind.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.textTheme.labelSmall?.copyWith(
                  color: fg,
                  fontWeight: selected || accent != null ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Emerald — same hue as the session-list "running" dot.
  static const _finishedColor = Color(0xFF10B981);

  /// Amber — same as the pane header's pending-question triangle.
  static const _actionColor = Color(0xFFF59E0B);

  /// Desktop grid: rows of equal height; a partial last row stretches to the
  /// full width (finer unit grid — see SplitWorkspaceGrid.tsx).
  Widget _grid(List<SplitPane> panes, {required bool maximizeActive}) {
    final layout = getSplitLayout(panes.length);
    final lastRowStart = layout.columns * (layout.rows - 1);
    final lastRowCount = panes.length - lastRowStart;
    final partial = lastRowCount > 0 && lastRowCount < layout.columns;

    final rows = <Widget>[];
    for (var r = 0; r < layout.rows; r++) {
      final cells = <Widget>[];
      for (var col = 0; col < layout.columns; col++) {
        final index = r * layout.columns + col;
        if (index >= panes.length) break;
        final flex = partial ? (index < lastRowStart ? lastRowCount : layout.columns) : 1;
        cells.add(
          Expanded(
            flex: flex,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: _tile(
                panes[index],
                index,
                single: false,
                tabMode: false,
                maximizeActive: maximizeActive,
                draggable: true,
              ),
            ),
          ),
        );
      }
      rows.add(Expanded(child: Row(children: cells)));
    }
    return Column(children: rows);
  }

  /// Maximized: the focused pane fills the workspace; the rest stay mounted
  /// offstage so their chat/terminal state survives.
  Widget _maximized(List<SplitPane> panes) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (final p in panes)
          if (p.id != widget.maximizedPaneId)
            Positioned.fill(
              child: Offstage(
                child: _tile(
                  p,
                  panes.indexOf(p),
                  single: false,
                  tabMode: false,
                  maximizeActive: true,
                ),
              ),
            ),
        for (final p in panes)
          if (p.id == widget.maximizedPaneId)
            _tile(p, panes.indexOf(p), single: false, tabMode: false, maximizeActive: true),
      ],
    );
  }

  Widget _tile(
    SplitPane pane,
    int index, {
    required bool single,
    required bool tabMode,
    required bool maximizeActive,
    bool draggable = false,
  }) {
    final c = context.appColors;
    final isActive = widget.activePaneId == pane.id;
    final isMaximized = maximizeActive && pane.id == widget.maximizedPaneId;
    final showActiveChrome = isActive && !single && !tabMode;

    Widget tile = Container(
      decoration: BoxDecoration(
        // Web: a lone/tab-mode pane is just overflow-hidden — the frame only
        // appears once the grid splits into multiple tiles.
        border: single || tabMode
            ? null
            : Border.all(
                color: showActiveChrome
                    ? c.primary.withValues(alpha: 0.6)
                    : c.border.withValues(alpha: 0.5),
              ),
        borderRadius: single || tabMode ? BorderRadius.zero : AppRadii.borderSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _paneHeader(
            pane,
            single: single,
            tabMode: tabMode,
            isMaximized: isMaximized,
            maximizeActive: maximizeActive,
            showActiveChrome: showActiveChrome,
            draggable: draggable,
          ),
          Expanded(child: ClipRect(child: widget.renderPane(pane, isActive))),
        ],
      ),
    );
    if (draggable) {
      // Capture the tile first: reading the mutable `tile` inside the
      // builder would resolve to the DragTarget itself and recurse forever
      // (stack overflow whenever two panes are on screen).
      final inner = tile;
      tile = DragTarget<SplitPane>(
        onWillAcceptWithDetails: (d) {
          if (d.data.id == pane.id) return false;
          setState(() => _dragOverIndex = index);
          return true;
        },
        onLeave: (_) {
          if (_dragOverIndex == index) setState(() => _dragOverIndex = null);
        },
        onAcceptWithDetails: (d) {
          setState(() => _dragOverIndex = null);
          widget.onReorderPanes(d.data.id, index);
        },
        builder: (context, _, _) => Container(
          decoration: _dragOverIndex == index
              ? BoxDecoration(
                  border: Border.all(color: c.primary, width: 2),
                  borderRadius: AppRadii.borderSm,
                )
              : null,
          child: inner,
        ),
      );
    }
    return GestureDetector(
      onTapDown: (_) => widget.onActivatePane?.call(pane.id),
      behavior: HitTestBehavior.translucent,
      child: tile,
    );
  }

  Widget _paneHeader(
    SplitPane pane, {
    required bool single,
    required bool tabMode,
    required bool isMaximized,
    required bool maximizeActive,
    required bool showActiveChrome,
    required bool draggable,
  }) {
    final c = context.appColors;
    final i18n = Translations.of(context);
    final m = paneHeaderMetrics(context);
    final actions = <Widget>[
      if (draggable)
        Draggable<SplitPane>(
          data: pane,
          feedback: Material(
            color: Colors.transparent,
            child: Icon(paneKindIcon(pane.kind), size: 18, color: c.primary),
          ),
          childWhenDragging: SizedBox(width: m.hit),
          child: SizedBox(
            width: m.hit,
            height: m.hit,
            child: Icon(Icons.drag_indicator, size: m.icon, color: c.mutedForeground),
          ),
        ),
      if (!tabMode && (widget.panes.length > 1 || isMaximized))
        _headerButton(
          icon: isMaximized ? Icons.close_fullscreen : Icons.open_in_full,
          tooltip: isMaximized ? i18n.workspace.restorePanes : i18n.workspace.maximizePane,
          onPressed: () => widget.onToggleMaximizePane?.call(pane.id),
        ),
      _headerButton(
        icon: Icons.close,
        tooltip: i18n.workspace.closePane,
        onPressed: () => widget.onClosePane(pane.id),
      ),
    ];
    final content = widget.renderPaneHeaderContent?.call(pane, actions);
    return Container(
      constraints: BoxConstraints(minHeight: m.barHeight),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: showActiveChrome ? c.primary.withValues(alpha: 0.1) : c.muted.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.5))),
      ),
      child:
          content ??
          Row(
            children: [
              Expanded(
                child:
                    // Web pane chrome: text-xs muted — 12px/16, regular weight.
                    Text(
                      widget.paneTitle?.call(pane) ?? pane.kind.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, height: 16 / 12, color: c.mutedForeground),
                    ),
              ),
              ...actions,
            ],
          ),
    );
  }

  Widget _headerButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final c = context.appColors;
    final m = paneHeaderMetrics(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: m.icon, color: c.mutedForeground),
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      visualDensity: VisualDensity.standard,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(width: m.hit, height: m.hit),
    );
  }
}
