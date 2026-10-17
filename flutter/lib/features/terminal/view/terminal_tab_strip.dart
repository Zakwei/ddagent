import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_theme.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Windows Terminal tab row: equal-width tabs that shrink to fit, the active
/// tab painted in the pane colour so it merges into the terminal below, a
/// `+` for a new default-profile tab right after the last tab and a `⌄`
/// dropdown with the profile list and every other action.
///
/// Mouse: drag to reorder, middle-click closes, right-click opens the tab
/// menu, double-click renames. Touch: long-press opens the tab menu.
class TerminalTabStrip extends StatelessWidget {
  const TerminalTabStrip({
    super.key,
    required this.tabs,
    required this.activeTabId,
    required this.onSelect,
    required this.onClose,
    required this.onReorder,
    required this.onRename,
    required this.onDuplicate,
    required this.onCloseOthers,
    required this.onCloseToRight,
    required this.onNewTab,
    required this.menuController,
    required this.menuChildren,
    this.trailing = const [],
  });

  final List<TerminalTab> tabs;
  final String? activeTabId;
  final void Function(String tabId) onSelect;
  final void Function(String tabId) onClose;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(String tabId, String title) onRename;
  final void Function(String tabId) onDuplicate;
  final void Function(String tabId) onCloseOthers;
  final void Function(String tabId) onCloseToRight;
  final VoidCallback onNewTab;

  /// The `⌄` dropdown — owned by the screen so Ctrl+Shift+P can open it.
  final MenuController menuController;
  final List<Widget> menuChildren;

  /// Compact icon buttons pinned at the far right (find, key bar toggle).
  final List<Widget> trailing;

  static const double height = 36;
  static const double _tabMin = 84;
  static const double _tabMax = 220;

  /// Width reserved after the tabs for `+` and `⌄`.
  static const double _footerWidth = 64;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    final t = Translations.of(context);

    return Container(
      height: height,
      color: palette.tabStrip,
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final count = tabs.isEmpty ? 1 : tabs.length;
                final tabWidth = ((constraints.maxWidth - _footerWidth) / count).clamp(
                  _tabMin,
                  _tabMax,
                );
                return ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  buildDefaultDragHandles: false,
                  padding: const EdgeInsets.only(left: 4),
                  proxyDecorator: (child, _, _) => Material(
                    color: Colors.transparent,
                    elevation: 4,
                    shadowColor: Colors.black54,
                    child: child,
                  ),
                  onReorderItem: onReorder,
                  footer: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _StripIconButton(
                          tooltip: t.terminal.actions.newTab,
                          icon: LucideIcons.plus,
                          onPressed: onNewTab,
                          palette: palette,
                        ),
                        MenuAnchor(
                          controller: menuController,
                          // Otherwise the toggle button's own tap re-opens the
                          // menu the outside-tap region just closed.
                          consumeOutsideTap: true,
                          // Cap the panel to the space under the strip so a
                          // short window scrolls the menu instead of shifting
                          // it up over the tab row.
                          style: MenuStyle(
                            maximumSize: WidgetStatePropertyAll(
                              Size(
                                360,
                                (MediaQuery.sizeOf(context).height - height - 16).clamp(
                                  120.0,
                                  900.0,
                                ),
                              ),
                            ),
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                          menuChildren: menuChildren,
                          builder: (context, controller, _) => _StripIconButton(
                            tooltip: t.terminal.menu.title,
                            icon: LucideIcons.chevronDown,
                            size: 14,
                            width: 24,
                            onPressed: () =>
                                controller.isOpen ? controller.close() : controller.open(),
                            palette: palette,
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemCount: tabs.length,
                  itemBuilder: (context, index) {
                    final tab = tabs[index];
                    final isActive = tab.id == activeTabId;
                    final nextIsActive =
                        index + 1 < tabs.length && tabs[index + 1].id == activeTabId;
                    return _MouseDragStartListener(
                      key: ValueKey('terminal-tab-${tab.id}'),
                      index: index,
                      child: _TerminalTabItem(
                        tab: tab,
                        width: tabWidth,
                        isActive: isActive,
                        showSeparator: !isActive && !nextIsActive && index < tabs.length - 1,
                        palette: palette,
                        onSelect: () => onSelect(tab.id),
                        onClose: () => onClose(tab.id),
                        onRename: () => _rename(context, tab),
                        onContextMenu: (position) => _showTabMenu(context, tab, position),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ...trailing,
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Future<void> _rename(BuildContext context, TerminalTab tab) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _RenameTabDialog(initial: tab.title),
    );
    if (result != null && result.trim().isNotEmpty) onRename(tab.id, result);
  }

  Future<void> _showTabMenu(BuildContext context, TerminalTab tab, Offset position) async {
    final t = Translations.of(context);
    final c = context.appColors;
    final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    final index = tabs.indexWhere((x) => x.id == tab.id);
    final hasRight = index != -1 && index < tabs.length - 1;

    PopupMenuEntry<VoidCallback> item(
      IconData icon,
      String label,
      VoidCallback? action, {
      bool destructive = false,
    }) {
      final color = destructive ? c.destructive : c.popoverForeground;
      return PopupMenuItem<VoidCallback>(
        value: action,
        enabled: action != null,
        height: 36,
        child: Row(
          children: [
            Icon(icon, size: 15, color: action == null ? c.mutedForeground : color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: action == null ? c.mutedForeground : color),
              ),
            ),
          ],
        ),
      );
    }

    final action = await showMenu<VoidCallback>(
      context: context,
      color: c.popover,
      position: RelativeRect.fromRect(position & const Size(1, 1), Offset.zero & overlay.size),
      items: [
        item(LucideIcons.pencil, t.terminal.menu.renameTab, () => _rename(context, tab)),
        item(LucideIcons.copyPlus, t.terminal.menu.duplicateTab, () => onDuplicate(tab.id)),
        const PopupMenuDivider(height: 8),
        item(LucideIcons.x, t.terminal.menu.closeTab, () => onClose(tab.id)),
        item(
          LucideIcons.circleX,
          t.terminal.menu.closeOtherTabs,
          tabs.length > 1 ? () => onCloseOthers(tab.id) : null,
        ),
        item(
          LucideIcons.chevronsRight,
          t.terminal.menu.closeTabsToRight,
          hasRight ? () => onCloseToRight(tab.id) : null,
        ),
      ],
    );
    action?.call();
  }
}

/// Starts a reorder drag for mouse pointers only — touch keeps the strip
/// scrollable and long-press free for the tab menu. A copy of
/// [ReorderableDragStartListener] gated on the pointer kind.
class _MouseDragStartListener extends StatelessWidget {
  const _MouseDragStartListener({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        if (event.kind != PointerDeviceKind.mouse || event.buttons != kPrimaryMouseButton) return;
        SliverReorderableList.maybeOf(context)?.startItemDragReorder(
          index: index,
          event: event,
          recognizer: ImmediateMultiDragGestureRecognizer(debugOwner: this),
        );
      },
      child: child,
    );
  }
}

class _TerminalTabItem extends StatefulWidget {
  const _TerminalTabItem({
    required this.tab,
    required this.width,
    required this.isActive,
    required this.showSeparator,
    required this.palette,
    required this.onSelect,
    required this.onClose,
    required this.onRename,
    required this.onContextMenu,
  });

  final TerminalTab tab;
  final double width;
  final bool isActive;
  final bool showSeparator;
  final TerminalPalette palette;
  final VoidCallback onSelect;
  final VoidCallback onClose;
  final VoidCallback onRename;
  final void Function(Offset globalPosition) onContextMenu;

  @override
  State<_TerminalTabItem> createState() => _TerminalTabItemState();
}

class _TerminalTabItemState extends State<_TerminalTabItem> {
  bool _hovered = false;

  Color? _statusColor(AppColors colors) => switch (widget.tab.status) {
    TerminalTabStatus.connected => null,
    TerminalTabStatus.connecting => const Color(0xFFF59E0B),
    TerminalTabStatus.disconnected => colors.mutedForeground,
    TerminalTabStatus.exited =>
      widget.tab.exitCode == 0 ? const Color(0xFF22C55E) : const Color(0xFFE74856),
  };

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final colors = context.appColors;
    final active = widget.isActive;
    final fg = active
        ? palette.tabStripForeground
        : palette.tabStripForeground.withValues(alpha: 0.72);
    final showClose = active || _hovered;
    final status = _statusColor(colors);
    const radius = Radius.circular(6);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Listener(
        // Middle-click closes the tab (WT / browser convention).
        onPointerDown: (event) {
          if (event.kind == PointerDeviceKind.mouse && event.buttons == kMiddleMouseButton) {
            widget.onClose();
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onSelect,
          onDoubleTap: widget.onRename,
          onSecondaryTapUp: (d) => widget.onContextMenu(d.globalPosition),
          onLongPressStart: (d) => widget.onContextMenu(d.globalPosition),
          child: SizedBox(
            width: widget.width,
            height: TerminalTabStrip.height,
            child: Stack(
              children: [
                // Tab body — sits on the strip's bottom edge so the active
                // tab's colour continues into the pane without a seam.
                Positioned(
                  left: 0,
                  right: 1,
                  top: 4,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: AppMotion.hover,
                    decoration: BoxDecoration(
                      color: active
                          ? palette.background
                          : _hovered
                          ? palette.tabHover
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(topLeft: radius, topRight: radius),
                    ),
                    padding: const EdgeInsets.only(left: 10, right: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Center(
                                child: Icon(
                                  terminalProfileIcon(
                                    widget.tab.provider,
                                    isPlainShell: widget.tab.isPlainShell,
                                  ),
                                  size: 14,
                                  color: fg,
                                ),
                              ),
                              if (status != null)
                                Positioned(
                                  right: -2,
                                  bottom: -1,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: status,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: active ? palette.background : palette.tabStrip,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.tab.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                              color: fg,
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: AppMotion.hover,
                          opacity: showClose ? 1 : 0,
                          child: IgnorePointer(
                            ignoring: !showClose,
                            child: _TabCloseButton(
                              color: fg,
                              hoverColor: palette.tabHover,
                              tooltip: Translations.of(context).terminal.menu.closeTab,
                              onPressed: widget.onClose,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.showSeparator && !_hovered)
                  Positioned(
                    right: 0,
                    top: 12,
                    bottom: 8,
                    child: Container(
                      width: 1,
                      color: palette.tabStripForeground.withValues(alpha: 0.18),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabCloseButton extends StatelessWidget {
  const _TabCloseButton({
    required this.color,
    required this.hoverColor,
    required this.tooltip,
    required this.onPressed,
  });

  final Color color;
  final Color hoverColor;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 600),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          hoverColor: hoverColor,
          child: SizedBox(
            width: 24,
            height: 24,
            child: Icon(LucideIcons.x, size: 13, color: color),
          ),
        ),
      ),
    );
  }
}

class _StripIconButton extends StatelessWidget {
  const _StripIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    required this.palette,
    this.size = 16,
    this.width = 30,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final TerminalPalette palette;
  final double size;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 600),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          hoverColor: palette.tabHover,
          child: SizedBox(
            width: width,
            height: 30,
            child: Icon(icon, size: size, color: palette.tabStripForeground),
          ),
        ),
      ),
    );
  }
}

/// Far-right strip action (find, key bar) — same hover treatment as `+`.
class TerminalStripAction extends StatelessWidget {
  const TerminalStripAction({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.active = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    final colors = context.appColors;
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 600),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          hoverColor: palette.tabHover,
          child: SizedBox(
            width: 32,
            height: 30,
            child: Icon(
              icon,
              size: 16,
              color: active ? colors.primary : palette.tabStripForeground.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rename dialog — owns its text controller so disposal waits for the
/// route's exit transition (a controller disposed on pop while the field
/// is still animating out throws asynchronously).
class _RenameTabDialog extends StatefulWidget {
  const _RenameTabDialog({required this.initial});

  final String initial;

  @override
  State<_RenameTabDialog> createState() => _RenameTabDialogState();
}

class _RenameTabDialogState extends State<_RenameTabDialog> {
  late final TextEditingController _controller = TextEditingController(text: widget.initial)
    ..selection = TextSelection(baseOffset: 0, extentOffset: widget.initial.length);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return AppDialog(
      title: t.terminal.rename.title,
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: t.terminal.rename.hint),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.common.buttons.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(t.common.buttons.save)),
      ],
    );
  }
}
