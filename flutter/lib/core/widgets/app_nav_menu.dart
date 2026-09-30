import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Opens the compact navigation drawer from a screen's own header — web
/// `onMenuClick` parity. Renders nothing above the compact breakpoint (the
/// icon rail is the navigation there).
class AppNavMenuButton extends StatelessWidget {
  const AppNavMenuButton({super.key, this.size = 16});

  final double size;

  @override
  Widget build(BuildContext context) {
    if (!context.breakpoint.isCompact) return const SizedBox.shrink();
    final c = context.appColors;
    return IconButton(
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      icon: Icon(LucideIcons.menu, size: size, color: c.mutedForeground),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 28, height: 28),
      onPressed: () => AppDrawer.of(context)?.currentState?.openDrawer(),
    );
  }
}

/// Exposes the shell's drawer [ScaffoldState] to descendants, so any screen
/// header can open it without owning the shell Scaffold. Hosts of the drawer
/// wrap their subtree in this.
class AppDrawer extends InheritedWidget {
  const AppDrawer({super.key, required this.drawerKey, required super.child});

  final GlobalKey<ScaffoldState> drawerKey;

  static GlobalKey<ScaffoldState>? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDrawer>()?.drawerKey;

  @override
  bool updateShouldNotify(AppDrawer oldWidget) =>
      oldWidget.drawerKey != drawerKey;
}
