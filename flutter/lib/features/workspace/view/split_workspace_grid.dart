import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/workspace/state/pane_layout.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/pane_header_metrics.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Kind icon per pane (port of PANE_KIND_ICONS in SplitWorkspaceGrid.tsx).
IconData paneKindIcon(PaneKind kind) => switch (kind) {
  PaneKind.browser => LucideIcons.globe,
  PaneKind.terminal => LucideIcons.squareTerminal,
  PaneKind.notes => LucideIcons.notebookPen,
  PaneKind.editor => LucideIcons.code,
  PaneKind.git => LucideIcons.split,
  PaneKind.preview => LucideIcons.monitorSmartphone,
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
///   agent finished turn green until it starts again, tabs waiting
///   on the user turn amber,
/// - maximized pane: hidden panes stay mounted (Offstage) so chats/terminals
///   keep state,
/// - desktop: a VS Code-style split tree ([PaneLayout]) — sashes resize
///   (double-click equalizes), a pane dragged by its header docks onto
///   another pane's edge (split there) or centre (swap); a double-clicked
///   header maximizes,
/// - pane bodies carry stable global keys, so moving a pane around the tree
///   or (un)maximizing it never restarts its terminal or browser stream,
/// - per-pane header with maximize + close buttons, active-pane accent border.
class SplitWorkspaceGrid extends StatefulWidget {
  const SplitWorkspaceGrid({
    super.key,
    required this.panes,
    required this.onClosePane,
    required this.renderPane,
    this.layout,
    this.onLayoutChanged,
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

  /// The user's split tree; null renders the automatic grid.
  final PaneLayout? layout;

  /// A dock or a resize produced a new tree (the first one materializes the
  /// automatic grid into an explicit layout).
  final ValueChanged<PaneLayout>? onLayoutChanged;
  final Widget Function(SplitPane pane, bool isActive) renderPane;
  final Widget Function(SplitPane pane, List<Widget> actions)? renderPaneHeaderContent;
  final String Function(SplitPane pane)? paneTitle;
  final String? maximizedPaneId;
  final ValueChanged<String>? onToggleMaximizePane;

  /// Panes whose agent finished its turn — their compact tab turns green
  /// (except while selected) until the agent starts again.
  final Set<String> finishedPaneIds;

  /// Panes waiting on the user (question / permission) — their compact tab
  /// turns amber; this wins over [finishedPaneIds].
  final Set<String> actionPaneIds;

  @override
  State<SplitWorkspaceGrid> createState() => _SplitWorkspaceGridState();
}

class _SplitWorkspaceGridState extends State<SplitWorkspaceGrid> {
  /// One key per pane body: the subtree survives being re-parented by a
  /// dock, a split collapsing, or maximize/restore.
  final _bodyKeys = <String, GlobalKey>{};

  /// Live weights of the split whose sash is being dragged (path key → px
  /// weights); committed once on drag end, not per pointer move.
  final _liveWeights = <String, List<double>>{};

  /// Smallest pane extent a sash drag may leave.
  static const _minPaneExtent = 120.0;
  static const _sashExtent = 6.0;

  GlobalKey _bodyKey(String paneId) => _bodyKeys.putIfAbsent(paneId, GlobalKey.new);

  PaneLayout? get _effectiveLayout {
    final ids = [for (final p in widget.panes) p.id];
    return reconcileLayout(widget.layout, ids) ?? autoPaneLayout(ids);
  }

  @override
  void didUpdateWidget(SplitWorkspaceGrid old) {
    super.didUpdateWidget(old);
    final ids = {for (final p in widget.panes) p.id};
    _bodyKeys.removeWhere((id, _) => !ids.contains(id));
  }

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
              ? _tile(activePane!, single: false, tabMode: true, maximizeActive: false)
              : single
              ? _tile(panes.first, single: true, tabMode: false, maximizeActive: false)
              : Padding(
                  padding: const EdgeInsets.all(2),
                  child: _node(_effectiveLayout!, const []),
                ),
        ),
      ],
    );
  }

  // ─── Split tree ───────────────────────────────────────────────────────────

  Widget _node(PaneLayout node, List<int> path) {
    switch (node) {
      case PaneLeaf(:final paneId):
        final pane = widget.panes.where((p) => p.id == paneId).firstOrNull;
        if (pane == null) return const SizedBox.shrink();
        return _tile(pane, single: false, tabMode: false, maximizeActive: false, dockable: true);
      case PaneSplit():
        final key = path.join('.');
        final row = node.axis == PaneAxis.row;
        return LayoutBuilder(
          builder: (context, box) {
            final extent =
                (row ? box.maxWidth : box.maxHeight) - _sashExtent * (node.children.length - 1);
            final sum = node.weights.fold<int>(0, (a, b) => a + b);
            final px =
                _liveWeights[key] ??
                [for (final w in node.weights) extent * w / (sum <= 0 ? 1 : sum)];
            final children = <Widget>[];
            for (final (i, child) in node.children.indexed) {
              if (i > 0) {
                children.add(
                  _Sash(
                    axis: node.axis,
                    onDrag: (delta) => _dragSash(key, px, i - 1, delta),
                    onDragEnd: () => _commitSash(key, path),
                    onReset: () => _commitWeights(path, List.filled(node.children.length, 1)),
                  ),
                );
              }
              children.add(
                Expanded(
                  // Pixel weights keep the live drag exact; ×1000 keeps them ints.
                  flex: (px[i] * 1000).round().clamp(1, 1 << 30),
                  child: _node(child, [...path, i]),
                ),
              );
            }
            return Flex(direction: row ? Axis.horizontal : Axis.vertical, children: children);
          },
        );
    }
  }

  /// Moves the boundary between children [i] and [i] + 1 by [delta] px,
  /// leaving each at least [_minPaneExtent] (or its current size if smaller).
  void _dragSash(String key, List<double> px, int i, double delta) {
    final next = [...px];
    final a = next[i];
    final b = next[i + 1];
    final minA = a < _minPaneExtent ? a : _minPaneExtent;
    final minB = b < _minPaneExtent ? b : _minPaneExtent;
    final d = delta.clamp(minA - a, b - minB);
    next[i] = a + d;
    next[i + 1] = b - d;
    setState(() => _liveWeights[key] = next);
  }

  void _commitSash(String key, List<int> path) {
    final live = _liveWeights[key];
    if (live == null) return;
    _commitWeights(path, live);
    setState(() => _liveWeights.remove(key));
  }

  void _commitWeights(List<int> path, List<num> weights) {
    final next = setLayoutWeights(_effectiveLayout, path, weights);
    if (next != null) widget.onLayoutChanged?.call(next);
  }

  void _dock(String fromId, String targetId, PaneDropZone zone) {
    final next = movePaneInLayout(_effectiveLayout, fromId, targetId, zone);
    if (next != null) widget.onLayoutChanged?.call(next);
    widget.onActivatePane?.call(fromId);
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
        ? (_actionColor, LucideIcons.triangleAlert)
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
                widget.paneTitle?.call(pane) ?? paneKindLabel(pane.kind),
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
                // A hidden pane must not take focus: its terminal autofocuses
                // when (re)built, and keys then went into a shell off screen.
                child: ExcludeFocus(
                  child: _tile(p, single: false, tabMode: false, maximizeActive: true),
                ),
              ),
            ),
        for (final p in panes)
          if (p.id == widget.maximizedPaneId)
            _tile(p, single: false, tabMode: false, maximizeActive: true),
      ],
    );
  }

  Widget _tile(
    SplitPane pane, {
    required bool single,
    required bool tabMode,
    required bool maximizeActive,
    bool dockable = false,
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
            draggable: dockable,
          ),
          Expanded(
            child: ClipRect(
              child: KeyedSubtree(key: _bodyKey(pane.id), child: widget.renderPane(pane, isActive)),
            ),
          ),
        ],
      ),
    );
    if (dockable) {
      tile = _PaneDropTarget(
        paneId: pane.id,
        onDrop: (fromId, zone) => _dock(fromId, pane.id, zone),
        child: tile,
      );
    }
    // A raw pointer listener, not a tap recognizer: the pane body's own
    // recognizers (the terminal's tap/selection) win the arena on a quick
    // click, which then never reported a tap-down — the keyboard went to the
    // clicked terminal while another pane stayed the active one.
    return Listener(
      onPointerDown: (_) => widget.onActivatePane?.call(pane.id),
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
        Tooltip(
          message: i18n.workspace.dragPaneHint,
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: SizedBox(
              width: m.hit,
              height: m.hit,
              child: Icon(LucideIcons.gripVertical, size: m.icon, color: c.mutedForeground),
            ),
          ),
        ),
      if (!tabMode && (widget.panes.length > 1 || isMaximized))
        _headerButton(
          icon: isMaximized ? LucideIcons.minimize2 : LucideIcons.maximize2,
          tooltip: isMaximized ? i18n.workspace.restorePanes : i18n.workspace.maximizePane,
          onPressed: () => widget.onToggleMaximizePane?.call(pane.id),
        ),
      _headerButton(
        icon: LucideIcons.x,
        tooltip: i18n.workspace.closePane,
        onPressed: () => widget.onClosePane(pane.id),
      ),
    ];
    final content = widget.renderPaneHeaderContent?.call(pane, actions);
    Widget header = Container(
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
                      widget.paneTitle?.call(pane) ?? paneKindLabel(pane.kind),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, height: 16 / 12, color: c.mutedForeground),
                    ),
              ),
              ...actions,
            ],
          ),
    );
    if (!tabMode && !single && widget.onToggleMaximizePane != null) {
      // Double-click toggles maximize (VS Code: double-click the tab bar).
      // Timed by hand: a DoubleTap recognizer would hold the arena and delay
      // every click on the header buttons.
      header = Listener(
        onPointerDown: (e) {
          if (e.buttons != kPrimaryButton) return;
          final now = DateTime.now();
          final last = _lastHeaderDown;
          _lastHeaderDown = (pane.id, now);
          if (last != null && last.$1 == pane.id && now.difference(last.$2) < kDoubleTapTimeout) {
            _lastHeaderDown = null;
            widget.onToggleMaximizePane!(pane.id);
          }
        },
        child: header,
      );
    }
    if (!draggable) return header;
    // The whole header is the drag handle (VS Code drags a group by its
    // title); a plain click still reaches the buttons — the drag only starts
    // once the pointer moves past the touch slop.
    return Draggable<SplitPane>(
      data: pane,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: _PaneDragFeedback(
        icon: paneKindIcon(pane.kind),
        title: widget.paneTitle?.call(pane) ?? paneKindLabel(pane.kind),
      ),
      child: header,
    );
  }

  (String, DateTime)? _lastHeaderDown;

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

/// The chip that follows the pointer while a pane is dragged.
class _PaneDragFeedback extends StatelessWidget {
  const _PaneDragFeedback({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Transform.translate(
      offset: const Offset(12, 8),
      child: Material(
        color: c.popover,
        elevation: 6,
        borderRadius: AppRadii.borderSm,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: c.primary),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: c.popoverForeground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Resize handle between two children of a split (VS Code sash): invisible
/// until hovered or dragged, then a highlighted bar. Double-click resets the
/// split to equal sizes.
class _Sash extends StatefulWidget {
  const _Sash({
    required this.axis,
    required this.onDrag,
    required this.onDragEnd,
    required this.onReset,
  });

  final PaneAxis axis;
  final ValueChanged<double> onDrag;
  final VoidCallback onDragEnd;
  final VoidCallback onReset;

  @override
  State<_Sash> createState() => _SashState();
}

class _SashState extends State<_Sash> {
  bool _hover = false;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final row = widget.axis == PaneAxis.row;
    final lit = _hover || _dragging;
    void start(DragStartDetails _) => setState(() => _dragging = true);
    void end(DragEndDetails _) {
      setState(() => _dragging = false);
      widget.onDragEnd();
    }

    return MouseRegion(
      cursor: row ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: widget.onReset,
        onHorizontalDragStart: row ? start : null,
        onHorizontalDragUpdate: row ? (d) => widget.onDrag(d.delta.dx) : null,
        onHorizontalDragEnd: row ? end : null,
        onVerticalDragStart: row ? null : start,
        onVerticalDragUpdate: row ? null : (d) => widget.onDrag(d.delta.dy),
        onVerticalDragEnd: row ? null : end,
        child: SizedBox(
          width: row ? _SplitWorkspaceGridState._sashExtent : null,
          height: row ? null : _SplitWorkspaceGridState._sashExtent,
          child: Center(
            child: AnimatedContainer(
              duration: AppMotion.hover,
              width: row ? (lit ? 4 : 0) : null,
              height: row ? null : (lit ? 4 : 0),
              color: c.primary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Accepts a dragged pane and shows where it would land: the half next to
/// the nearest edge (split there) or the whole pane (swap), like VS Code's
/// editor-group drop overlay.
class _PaneDropTarget extends StatefulWidget {
  const _PaneDropTarget({required this.paneId, required this.onDrop, required this.child});

  final String paneId;
  final void Function(String fromId, PaneDropZone zone) onDrop;
  final Widget child;

  @override
  State<_PaneDropTarget> createState() => _PaneDropTargetState();
}

/// Zone for a pointer at fractional position ([x], [y]) inside a pane:
/// the nearest edge when it is within 30% of it, else the centre.
PaneDropZone paneDropZoneAt(double x, double y) {
  final distances = {
    PaneDropZone.left: x,
    PaneDropZone.right: 1 - x,
    PaneDropZone.top: y,
    PaneDropZone.bottom: 1 - y,
  };
  final nearest = distances.entries.reduce((a, b) => b.value < a.value ? b : a);
  return nearest.value <= 0.3 ? nearest.key : PaneDropZone.center;
}

class _PaneDropTargetState extends State<_PaneDropTarget> {
  PaneDropZone? _zone;

  void _update(Offset global) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.isEmpty) return;
    final local = box.globalToLocal(global);
    final zone = paneDropZoneAt(local.dx / box.size.width, local.dy / box.size.height);
    if (zone != _zone) setState(() => _zone = zone);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return DragTarget<SplitPane>(
      onWillAcceptWithDetails: (d) => d.data.id != widget.paneId,
      onMove: (d) => _update(d.offset),
      onLeave: (_) => setState(() => _zone = null),
      onAcceptWithDetails: (d) {
        final zone = _zone ?? PaneDropZone.center;
        setState(() => _zone = null);
        widget.onDrop(d.data.id, zone);
      },
      builder: (context, candidates, _) {
        final zone = candidates.isEmpty ? null : _zone;
        return Stack(
          fit: StackFit.passthrough,
          children: [
            widget.child,
            if (zone != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: LayoutBuilder(
                    builder: (context, box) {
                      final w = box.maxWidth;
                      final h = box.maxHeight;
                      final rect = switch (zone) {
                        PaneDropZone.left => Rect.fromLTWH(0, 0, w / 2, h),
                        PaneDropZone.right => Rect.fromLTWH(w / 2, 0, w / 2, h),
                        PaneDropZone.top => Rect.fromLTWH(0, 0, w, h / 2),
                        PaneDropZone.bottom => Rect.fromLTWH(0, h / 2, w, h / 2),
                        PaneDropZone.center => Rect.fromLTWH(0, 0, w, h),
                      };
                      return Stack(
                        children: [
                          AnimatedPositioned(
                            duration: AppMotion.base,
                            curve: AppMotion.standard,
                            left: rect.left,
                            top: rect.top,
                            width: rect.width,
                            height: rect.height,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: c.primary.withValues(alpha: 0.18),
                                border: Border.all(color: c.primary.withValues(alpha: 0.7)),
                                borderRadius: AppRadii.borderSm,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
