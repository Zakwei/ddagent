import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

class AppMenuItem {
  const AppMenuItem({required this.label, this.icon, this.onTap, this.destructive = false});

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool destructive;
}

/// Context menu — wraps the child; long-press / right-click opens a popover
/// menu on the `popover` surface.
class AppContextMenu extends StatelessWidget {
  const AppContextMenu({super.key, required this.items, required this.child});

  final List<AppMenuItem> items;
  final Widget child;

  Future<void> _open(BuildContext context, Offset position) async {
    final c = context.appColors;
    final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    await showMenu<void>(
      context: context,
      color: c.popover,
      position: RelativeRect.fromRect(position & const Size(1, 1), Offset.zero & overlay.size),
      items: [
        for (final item in items)
          PopupMenuItem<void>(
            onTap: item.onTap,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 16,
                    color: item.destructive ? c.destructive : c.popoverForeground,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  item.label,
                  style: TextStyle(color: item.destructive ? c.destructive : c.popoverForeground),
                ),
              ],
            ),
          ),
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
