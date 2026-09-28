import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:flutter/material.dart';

/// Kind icon per pane (port of PANE_KIND_ICONS in SplitWorkspaceGrid.tsx).
IconData paneKindIcon(PaneKind kind) => switch (kind) {
  PaneKind.chat => Icons.chat_bubble_outline,
  PaneKind.browser => Icons.public,
  PaneKind.terminal => Icons.terminal,
  PaneKind.preview => Icons.play_circle_outline,
  PaneKind.notes => Icons.edit_note,
  PaneKind.editor => Icons.code,
  PaneKind.git => Icons.alt_route,
};

/// Split-pane grid (port of SplitWorkspaceGrid.tsx):
/// - `getSplitLayout` column/row math + last-row-partial spanning via flex,
/// - compact (<600pt): tab strip + only the active pane mounted,
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
  });

  final List<SplitPane> panes;
  final String? activePaneId;
  final ValueChanged<String>? onActivatePane;
  final ValueChanged<String> onClosePane;
  final void Function(String fromId, int toIndex) onReorderPanes;
  final Widget Function(SplitPane pane, bool isActive) renderPane;
  final Widget Function(SplitPane pane)? renderPaneHeaderContent;
  final String Function(SplitPane pane)? paneTitle;
  final String? maximizedPaneId;
  final ValueChanged<String>? onToggleMaximizePane;

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
        ? panes.firstWhere(
            (p) => p.id == widget.activePaneId,
            orElse: () => panes.first,
          )
        : null;
    final maximizeActive =
        !tabMode &&
        panes.length > 1 &&
        panes.any((p) => p.id == widget.maximizedPaneId);

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
              ? _tile(
                  panes.first,
                  0,
                  single: true,
                  tabMode: false,
                  maximizeActive: false,
                )
              : _grid(panes, maximizeActive: false),
        ),
      ],
    );
  }

  Widget _tabStrip(List<SplitPane> panes, SplitPane activePane) {
    final c = context.appColors;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
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
    return InkWell(
      borderRadius: AppRadii.borderMd,
      onTap: () => widget.onActivatePane?.call(pane.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? c.background : Colors.transparent,
          borderRadius: AppRadii.borderMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              paneKindIcon(pane.kind),
              size: 14,
              color: selected ? c.foreground : c.mutedForeground,
            ),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                widget.paneTitle?.call(pane) ?? pane.kind.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.textTheme.labelSmall?.copyWith(
                  color: selected ? c.foreground : c.mutedForeground,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        final flex = partial
            ? (index < lastRowStart ? lastRowCount : layout.columns)
            : 1;
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
            _tile(
              p,
              panes.indexOf(p),
              single: false,
              tabMode: false,
              maximizeActive: true,
            ),
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
        border: Border.all(
          color: showActiveChrome ? c.primary.withValues(alpha: 0.6) : c.border,
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
          child: tile,
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
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: showActiveChrome
            ? c.primary.withValues(alpha: 0.1)
            : c.muted.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          if (draggable)
            Draggable<SplitPane>(
              data: pane,
              feedback: Material(
                color: Colors.transparent,
                child: Icon(
                  paneKindIcon(pane.kind),
                  size: 18,
                  color: c.primary,
                ),
              ),
              childWhenDragging: const SizedBox(width: 24),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  Icons.drag_indicator,
                  size: 14,
                  color: c.mutedForeground,
                ),
              ),
            ),
          Expanded(
            child:
                widget.renderPaneHeaderContent?.call(pane) ??
                Text(
                  widget.paneTitle?.call(pane) ?? pane.kind.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: c.mutedForeground),
                ),
          ),
          if (!tabMode && (widget.panes.length > 1 || isMaximized))
            _headerButton(
              icon: isMaximized ? Icons.close_fullscreen : Icons.open_in_full,
              tooltip: isMaximized ? 'Restore panes' : 'Maximize pane',
              onPressed: () => widget.onToggleMaximizePane?.call(pane.id),
            ),
          _headerButton(
            icon: Icons.close,
            tooltip: 'Close pane',
            onPressed: () => widget.onClosePane(pane.id),
          ),
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
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 14, color: c.mutedForeground),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 24, height: 24),
    );
  }
}
