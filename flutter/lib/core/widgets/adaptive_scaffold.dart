import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Root navigation entries — first tab of each top-level section.
/// Order defines both rail destinations and bottom-nav items.
const _destinations = [
  (
    icon: Icons.folder_outlined,
    selected: Icons.folder,
    label: 'Projects',
    path: '/projects',
  ),
  (
    icon: Icons.chat_bubble_outline,
    selected: Icons.chat_bubble,
    label: 'Sessions',
    path: '/sessions',
  ),
  (
    icon: Icons.grid_view_outlined,
    selected: Icons.grid_view,
    label: 'Workspace',
    path: '/workspace',
  ),
  (
    icon: Icons.dashboard_outlined,
    selected: Icons.dashboard,
    label: 'Board',
    path: '/board',
  ),
  (
    icon: Icons.checklist_outlined,
    selected: Icons.checklist,
    label: 'Tasks',
    path: '/tasks',
  ),
  (
    icon: Icons.settings_outlined,
    selected: Icons.settings,
    label: 'Settings',
    path: '/settings',
  ),
];

/// Adaptive shell: NavigationRail (expanded/collapsed, persisted in the
/// `settings` Hive box) on medium+ widths, bottom NavigationBar on compact.
class AdaptiveScaffold extends StatefulWidget {
  const AdaptiveScaffold({super.key, required this.child});

  final Widget child;

  static const _railKey = 'navRailExpanded';

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  late bool _expanded =
      Hive.box<dynamic>('settings').get(AdaptiveScaffold._railKey) == true;

  /// Null on routes outside the nav set (/chat/:id, /files, /editor, …) —
  /// nothing should be highlighted there.
  int? _selectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    final i = _destinations.indexWhere(
      (d) => loc == d.path || loc.startsWith('${d.path}/'),
    );
    return i < 0 ? null : i;
  }

  void _go(int i) => context.go(_destinations[i].path);

  void _toggleRail() {
    setState(() => _expanded = !_expanded);
    Hive.box<dynamic>('settings').put(AdaptiveScaffold._railKey, _expanded);
  }

  @override
  Widget build(BuildContext context) {
    final index = _selectedIndex(context);
    final bp = context.breakpoint;
    if (bp.isCompact) {
      return Scaffold(
        body: widget.child,
        bottomNavigationBar: NavigationBarTheme(
          // NavigationBar requires a valid index — hide the indicator on
          // routes outside the nav set instead of mis-highlighting Projects.
          data: index == null
              ? const NavigationBarThemeData(indicatorColor: Colors.transparent)
              : const NavigationBarThemeData(),
          child: NavigationBar(
            selectedIndex: index ?? 0,
            onDestinationSelected: _go,
            destinations: [
              for (final d in _destinations)
                NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(index == null ? d.icon : d.selected),
                  label: d.label,
                ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: _expanded && bp.isExpanded,
            minExtendedWidth: 180,
            selectedIndex: index,
            onDestinationSelected: _go,
            leading: IconButton(
              tooltip: _expanded ? 'Collapse' : 'Expand',
              icon: Icon(_expanded ? Icons.menu_open : Icons.menu),
              onPressed: _toggleRail,
            ),
            destinations: [
              for (final d in _destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selected),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
