import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppMenuItem {
  const AppMenuItem({
    required this.label,
    this.icon,
    this.onTap,
    this.destructive = false,
    this.checked,
    this.dividerBefore = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool destructive;

  /// Non-null renders a toggle row: a check mark when true, blank when false.
  final bool? checked;

  /// Draws a separator above this item (VS Code menu groups).
  final bool dividerBefore;
}

/// Context menu — wraps the child; long-press / right-click opens a popover
/// menu on the `popover` surface.
class AppContextMenu extends StatelessWidget {
  const AppContextMenu({super.key, required this.items, required this.child});

  final List<AppMenuItem> items;
  final Widget child;

  Future<void> _open(BuildContext context, Offset position) => show(context, position, items);

  /// Opens [items] as a popover menu at the global [position] — for menus
  /// triggered by a button or built lazily on demand.
  static Future<void> show(BuildContext context, Offset position, List<AppMenuItem> items) async {
    final c = context.appColors;
    final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    await showMenu<void>(
      context: context,
      color: c.popover,
      position: RelativeRect.fromRect(position & const Size(1, 1), Offset.zero & overlay.size),
      items: [
        for (final item in items) ...[
          if (item.dividerBefore) const PopupMenuDivider(height: 9),
          PopupMenuItem<void>(
            onTap: item.onTap,
            child: Row(
              children: [
                if (item.checked != null) ...[
                  SizedBox(
                    width: 16,
                    child: item.checked!
                        ? Icon(LucideIcons.check, size: 16, color: c.popoverForeground)
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ] else if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 16,
                    color: item.destructive ? c.destructive : c.popoverForeground,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: item.destructive ? c.destructive : c.popoverForeground),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (d) => _open(context, d.globalPosition),
      onSecondaryTapDown: (d) => _open(context, d.globalPosition),
      child: child,
    );
  }
}
