import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/collab/data/collab_repository.dart';
import 'package:ddagent_app/features/collab/state/presence_controller.dart';
import 'package:ddagent_app/features/collab/view/collab_section.dart';
import 'package:ddagent_app/features/collab/view/presence_avatars.dart';
import 'package:ddagent_app/features/kanban/data/kanban_repository.dart';
import 'package:ddagent_app/features/kanban/state/kanban_controller.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Column visual spec — port of `KANBAN_COLUMN_CONFIG`
/// (src/components/kanban/utils/kanbanColumns.ts). Header colors are the
/// Tailwind `*-100/*-800` pairs for light and `*-800 | *-900/60` + `*-200/300`
/// for dark.
class KanbanColumnDef {
  const KanbanColumnDef({
    required this.status,
    required this.title,
    required this.accent,
    required this.headerBgLight,
    required this.headerFgLight,
    required this.headerBgDark,
    required this.headerFgDark,
    this.headerBgDarkAlpha = 1,
  });

  final String status;
  final String title;

  /// Accent dot (Tailwind `*-500`, or `*-400` for the neutral shelves).
  final Color accent;
  final Color headerBgLight;
  final Color headerFgLight;
  final Color headerBgDark;
  final Color headerFgDark;

  /// Some dark header backgrounds are `*-900/60` — alpha applied at use site.
  final double headerBgDarkAlpha;
}

List<KanbanColumnDef> kanbanColumns(Translations t) => <KanbanColumnDef>[
  KanbanColumnDef(
    status: 'backlog',
    title: t.tasks.board.columns.backlog,
    accent: Color(0xFF94A3B8), // slate-400
    headerBgLight: Color(0xFFF1F5F9), // slate-100
    headerFgLight: Color(0xFF1E293B), // slate-800
    headerBgDark: Color(0xFF1E293B), // slate-800
    headerFgDark: Color(0xFFE2E8F0), // slate-200
  ),
  KanbanColumnDef(
    status: 'ready',
    title: t.tasks.board.columns.ready,
    accent: Color(0xFF0EA5E9), // sky-500
    headerBgLight: Color(0xFFE0F2FE), // sky-100
    headerFgLight: Color(0xFF075985), // sky-800
    headerBgDark: Color(0xFF0C4A6E), // sky-900/60
    headerFgDark: Color(0xFFBAE6FD), // sky-200
    headerBgDarkAlpha: 0.6,
  ),
  KanbanColumnDef(
    status: 'working',
    title: t.tasks.board.columns.working,
    accent: Color(0xFF3B82F6), // blue-500
    headerBgLight: Color(0xFFDBEAFE), // blue-100
    headerFgLight: Color(0xFF1E40AF), // blue-800
    headerBgDark: Color(0xFF1E3A8A), // blue-900/60
    headerFgDark: Color(0xFFBFDBFE), // blue-200
    headerBgDarkAlpha: 0.6,
  ),
  KanbanColumnDef(
    status: 'needs_decision',
    title: t.tasks.board.columns.needsDecision,
    accent: Color(0xFFF59E0B), // amber-500
    headerBgLight: Color(0xFFFEF3C7), // amber-100
    headerFgLight: Color(0xFF78350F), // amber-900
    headerBgDark: Color(0xFF78350F), // amber-900/60
    headerFgDark: Color(0xFFFDE68A), // amber-200
    headerBgDarkAlpha: 0.6,
  ),
  KanbanColumnDef(
    status: 'done',
    title: t.tasks.board.columns.done,
    accent: Color(0xFF10B981), // emerald-500
    headerBgLight: Color(0xFFD1FAE5), // emerald-100
    headerFgLight: Color(0xFF065F46), // emerald-800
    headerBgDark: Color(0xFF064E3B), // emerald-900/60
    headerFgDark: Color(0xFFA7F3D0), // emerald-200
    headerBgDarkAlpha: 0.6,
  ),
  KanbanColumnDef(
    status: 'archived',
    title: t.tasks.board.columns.archived,
    accent: Color(0xFF9CA3AF), // gray-400
    headerBgLight: Color(0xFFF3F4F6), // gray-100
    headerFgLight: Color(0xFF374151), // gray-700
    headerBgDark: Color(0xFF1F2937), // gray-800
    headerFgDark: Color(0xFFD1D5DB), // gray-300
  ),
];

/// Statuses the user may drop a card into — `USER_MOVABLE_STATUSES`.
const _userMovableStatuses = {'backlog', 'ready', 'archived'};

/// Per-status move targets — `MOVE_TARGETS` in KanbanCard.tsx.
const _moveTargets = <String, List<String>>{
  'backlog': ['ready', 'archived'],
  'ready': ['backlog', 'archived'],
  'working': ['archived'],
  'needs_decision': ['archived'],
  'done': ['backlog', 'ready', 'archived'],
  'archived': ['backlog', 'ready'],
};

/// Hardcoded provider list — same as `PROVIDERS` in useKanbanBoardConfig.ts.
const _kAgentProviders = [
  'claude',
  'cursor',
  'codex',
  'opencode',
  'commandcode',
  'antigravity',
  'devin',
];

extension on KanbanCard {
  String? get statusMessage => raw['statusMessage'] as String?;
  String? get branch => raw['branch'] as String?;
  String? get sessionId => raw['sessionId'] as String?;
  String? get prUrl => raw['prUrl'] as String?;
  String? get description => raw['description'] as String?;
  String? get updatedAt => raw['updatedAt'] as String?;
  num? get assigneeId => raw['assigneeUserId'] as num?;
}

/// `Intl.RelativeTimeFormat(numeric: auto)` output shape — "now",
/// "5 minutes ago", "1 hour ago", "5 days ago".
String _relTime(String? iso) {
  final dt = iso == null ? null : DateTime.tryParse(iso);
  if (dt == null) return '';
  // dart2js bit-shifts are 32-bit: `1 << 62` is 0 on web, clamping to 0s.
  final seconds = DateTime.now().difference(dt).inSeconds.clamp(0, double.infinity);
  if (seconds < 60) return t.kanban.time.now;
  final minutes = seconds ~/ 60;
  if (minutes < 60) return t.kanban.time.minutesAgo(count: minutes);
  final hours = minutes ~/ 60;
  if (hours < 24) return t.kanban.time.hoursAgo(count: hours);
  final days = hours ~/ 24;
  return t.kanban.time.daysAgo(count: days);
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    return parts[0].substring(0, parts[0].length.clamp(0, 2)).toUpperCase();
  }
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

/// Agent board screen — port of BoardPage + KanbanPanel: back-to-chat strip,
/// project header with agent/filter chips, status columns, activity footer.
class KanbanScreen extends ConsumerStatefulWidget {
  const KanbanScreen({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends ConsumerState<KanbanScreen> {
  /// Local project selection — like BoardPage the board owns its selection
  /// and never rewrites global state; the route param only seeds it.
  String? _requestedPid;
  String _assigneeFilter = 'all';

  @override
  void initState() {
    super.initState();
    _requestedPid = widget.projectId;
  }

  @override
  void didUpdateWidget(KanbanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.projectId != oldWidget.projectId) {
      _requestedPid = widget.projectId;
    }
  }

  String? _resolvePid(List<Project> projects, KanbanState state) {
    final requested = _requestedPid;
    if (requested != null &&
        requested.isNotEmpty &&
        (projects.isEmpty || projects.any((p) => p.projectId == requested))) {
      return requested;
    }
    if (state.projectId.isNotEmpty &&
        (projects.isEmpty || projects.any((p) => p.projectId == state.projectId))) {
      return state.projectId;
    }
    return projects.firstOrNull?.projectId;
  }

  void _selectProject(String pid) {
    if (pid == _requestedPid) return;
    setState(() => _requestedPid = pid);
  }

  List<KanbanCard> _filteredCards(KanbanState state) {
    if (_assigneeFilter == 'all') return state.cards;
    if (_assigneeFilter == 'none') {
      return state.cards.where((c) => c.assigneeId == null).toList();
    }
    final id = num.tryParse(_assigneeFilter);
    return state.cards.where((c) => c.assigneeId == id).toList();
  }

  void _showCardDialog(BuildContext context, {KanbanCard? card}) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _CreateCardDialog(projectId: _requestedPid, card: card),
    );
  }

  void _showCardDetails(BuildContext context, KanbanCard card) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _CardDetailsDialog(card: card),
    );
  }

  /// Card click opens the linked session; without one it edits the card
  /// (KanbanPanel.handleOpenCard parity).
  void _openCard(KanbanCard card) {
    final sid = card.sessionId;
    if (sid != null && sid.isNotEmpty) {
      context.go(
        Uri(
          path: '/chat/$sid',
          queryParameters: {
            'projectId': ?card.projectId,
            if (card.projectId == null && _requestedPid != null) 'projectId': _requestedPid!,
          },
        ).toString(),
      );
      return;
    }
    _showCardDialog(context, card: card);
  }

  void _confirmDelete(KanbanCard card) {
    final t = Translations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.appColors.popover,
        title: Text(t.tasks.board.deleteConfirm.title),
        content: Text(
          t.tasks.board.deleteConfirm.description(cardTitle: card.title ?? ''),
          style: TextStyle(color: context.appColors.mutedForeground, fontSize: 14),
        ),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.sm,
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.common.buttons.cancel),
          ),
          AppButton(
            variant: AppButtonVariant.destructive,
            size: AppButtonSize.sm,
            onPressed: () {
              Navigator.of(ctx).pop();
              unawaited(ref.read(kanbanControllerProvider.notifier).deleteCard(card.cardId));
            },
            child: Text(t.common.buttons.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kanbanControllerProvider);
    final projectsState = ref.watch(projectsProvider);
    final projects = projectsState.projects;
    final c = context.appColors;
    final pid = _resolvePid(projects, state);

    if (pid != null && pid != state.projectId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(ref.read(kanbanControllerProvider.notifier).load(pid));
        }
      });
    }

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SubpageHeader(),
            if (pid == null)
              Expanded(
                child: projectsState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : _EmptyBoard(),
              )
            else
              Expanded(child: _board(context, state, projects, pid, c)),
          ],
        ),
      ),
    );
  }

  Widget _board(
    BuildContext context,
    KanbanState state,
    List<Project> projects,
    String pid,
    AppColors c,
  ) {
    final t = Translations.of(context);
    final columns = kanbanColumns(t);
    final users = ref.watch(collabUsersProvider).value ?? const [];
    final usersById = {for (final u in users) u.id: u};
    final roster = ref.watch(presenceProvider((kind: 'board', id: pid)));
    final cards = _filteredCards(state);
    final activeProject = projects.where((p) => p.projectId == pid).firstOrNull;

    return Column(
      children: [
        // Panel header — `border-b border-border/60 px-4 py-2`.
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.6))),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (projects.isNotEmpty)
                      _ProjectMenu(
                        projects: projects,
                        selected: activeProject,
                        onSelect: (p) => _selectProject(p.projectId),
                      )
                    else
                      Text(
                        activeProject?.displayName ?? pid,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: c.foreground,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      t.tasks.board.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: c.mutedForeground, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PresenceAvatars(roster: roster),
              if (users.isNotEmpty) ...[
                const SizedBox(width: 4),
                _AssigneeMenu(
                  users: users,
                  value: _assigneeFilter,
                  onChanged: (v) => setState(() => _assigneeFilter = v),
                ),
              ],
              const SizedBox(width: 4),
              _BoardAgentChips(projectId: pid, config: state.boardConfig),
              const SizedBox(width: 4),
              AppButton(
                variant: AppButtonVariant.ghost,
                size: AppButtonSize.sm,
                onPressed: state.isLoading
                    ? null
                    : () => unawaited(ref.read(kanbanControllerProvider.notifier).load(pid)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.isLoading)
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: c.mutedForeground),
                      )
                    else
                      const Icon(LucideIcons.refreshCw, size: 16),
                    const SizedBox(width: 4),
                    Text(t.common.buttons.refresh, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              AppButton(
                key: const Key('add-card-button'),
                size: AppButtonSize.sm,
                onPressed: () => _showCardDialog(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.plus, size: 16),
                    const SizedBox(width: 4),
                    Text(t.tasks.board.newCard, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(state.error!, style: TextStyle(color: c.destructive, fontSize: 12)),
                ),
                InkWell(
                  onTap: ref.read(kanbanControllerProvider.notifier).clearError,
                  child: Icon(LucideIcons.x, size: 14, color: c.destructive),
                ),
              ],
            ),
          ),
        // Columns — `p-4`, responsive grid like KanbanPanel's
        // `md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6`, horizontal scroll
        // below that.
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final gridCols = width >= 1232
                  ? 6
                  : width >= 976
                  ? 3
                  : width >= 720
                  ? 2
                  : 0;
              final maxListHeight = (constraints.maxHeight - 48).clamp(120.0, double.infinity);

              Widget colWidget(KanbanColumnDef col, {double? w}) => _BoardColumn(
                column: col,
                cards: _sortedByPosition(cards.where((k) => k.status == col.status)),
                width: w,
                maxListHeight: maxListHeight,
                usersById: usersById,
                onOpen: _openCard,
                onEdit: (card) => _showCardDialog(context, card: card),
                onDetails: (card) => _showCardDetails(context, card),
                onDelete: _confirmDelete,
                onAbort: (card) =>
                    unawaited(ref.read(kanbanControllerProvider.notifier).abortCard(card.cardId)),
                onMove: (card, target) => unawaited(
                  ref.read(kanbanControllerProvider.notifier).moveCard(card.cardId, target, 0),
                ),
                onAdd: () => _showCardDialog(context),
                onDropped: (card, target) {
                  // Dropping back onto the same column is a no-op — it
                  // must not fire a move that bumps position and spams the
                  // activity feed (KanbanPanel.handleDropCard parity).
                  if (card.status == target) return;
                  final n = cards.where((k) => k.status == target).length;
                  unawaited(
                    ref.read(kanbanControllerProvider.notifier).moveCard(card.cardId, target, n),
                  );
                },
              );

              if (gridCols == 0) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < columns.length; i++) ...[
                        if (i > 0) const SizedBox(width: 16),
                        colWidget(columns[i], w: 240),
                      ],
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < columns.length; i++) ...[
                          if (i > 0) const SizedBox(width: 16),
                          Expanded(child: colWidget(columns[i])),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _ActivityFooter(projectId: pid, users: users),
      ],
    );
  }

  static List<KanbanCard> _sortedByPosition(Iterable<KanbanCard> cards) =>
      cards.toList()..sort((a, b) => a.position.compareTo(b.position));
}

/// `EmptyState` lg — centered icon tile + title + description.
class _EmptyBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.4),
              border: Border.all(color: c.border.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(LucideIcons.squareKanban, size: 28, color: c.mutedForeground),
          ),
          const SizedBox(height: 16),
          Text(
            t.kanban.empty.noProject,
            style: TextStyle(color: c.foreground, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(t.tasks.board.noProject, style: TextStyle(color: c.mutedForeground, fontSize: 14)),
        ],
      ),
    );
  }
}

/// Ghost dropdown trigger for the project picker — `h-7 gap-1 px-2
/// font-semibold text-foreground` with a localized project menu header.
class _ProjectMenu extends StatelessWidget {
  const _ProjectMenu({required this.projects, required this.selected, required this.onSelect});

  final List<Project> projects;
  final Project? selected;
  final ValueChanged<Project> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    return PopupMenuButton<Project>(
      tooltip: t.tasks.board.projectLabel,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      onSelected: onSelect,
      itemBuilder: (ctx) => [
        PopupMenuItem<Project>(
          enabled: false,
          height: 28,
          child: Text(
            t.tasks.board.projectLabel,
            style: TextStyle(color: c.mutedForeground, fontSize: 12),
          ),
        ),
        for (final p in projects)
          PopupMenuItem<Project>(
            value: p,
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.displayName.isEmpty ? p.projectId : p.displayName,
                  style: TextStyle(color: c.foreground, fontSize: 13),
                ),
                if ((p.fullPath ?? p.path).isNotEmpty)
                  Text(
                    p.fullPath ?? p.path,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: c.mutedForeground, fontSize: 11),
                  ),
              ],
            ),
          ),
      ],
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(borderRadius: AppRadii.borderMd),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.folder, size: 16, color: c.mutedForeground),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                selected == null
                    ? t.tasks.board.projectLabel
                    : (selected!.displayName.isEmpty ? selected!.projectId : selected!.displayName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: c.foreground, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(LucideIcons.chevronDown, size: 14, color: c.mutedForeground),
          ],
        ),
      ),
    );
  }
}

/// Small ghost dropdown chip — `h-7 gap-1 px-2 text-xs font-medium` — used
/// for the assignee filter and the board agent pickers.
class _MenuChip extends StatelessWidget {
  const _MenuChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      height: 28,
      constraints: const BoxConstraints(maxWidth: 160),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: AppRadii.borderMd),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c.mutedForeground),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: c.mutedForeground, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 2),
          Icon(LucideIcons.chevronDown, size: 12, color: c.mutedForeground),
        ],
      ),
    );
  }
}

/// Assignee filter — `ActionMenu` parity (All / Unassigned / per-user).
class _AssigneeMenu extends StatelessWidget {
  const _AssigneeMenu({required this.users, required this.value, required this.onChanged});

  final List<CollabUser> users;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final label = switch (value) {
      'all' => t.tasks.board.assignee.label,
      'none' => t.tasks.board.assignee.unassigned,
      _ => users.where((u) => '${u.id}' == value).firstOrNull?.displayName ?? value,
    };
    return PopupMenuButton<String>(
      tooltip: t.tasks.board.assignee.label,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      onSelected: onChanged,
      itemBuilder: (ctx) => [
        PopupMenuItem<String>(
          enabled: false,
          height: 28,
          child: Text(
            t.tasks.board.assignee.label,
            style: TextStyle(color: c.mutedForeground, fontSize: 12),
          ),
        ),
        _item(c, 'all', t.tasks.board.assignee.all),
        _item(c, 'none', t.tasks.board.assignee.unassigned),
        const PopupMenuDivider(height: 8),
        for (final u in users) _item(c, '${u.id}', u.displayName ?? u.username, subtitle: u.role),
      ],
      child: _MenuChip(icon: LucideIcons.userCircle2, label: label),
    );
  }

  PopupMenuItem<String> _item(AppColors c, String v, String label, {String? subtitle}) =>
      PopupMenuItem<String>(
        value: v,
        height: 36,
        child: subtitle == null
            ? Text(label, style: TextStyle(color: c.foreground, fontSize: 13))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: c.foreground, fontSize: 13)),
                  Text(subtitle, style: TextStyle(color: c.mutedForeground, fontSize: 11)),
                ],
              ),
      );
}

/// Board agent pickers — `BoardAgentSettings` parity: provider / model /
/// reasoning-effort chips that `PUT /api/kanban/board-config`. The model
/// menu is only rendered once a provider is picked (same as the web UI).
class _BoardAgentChips extends ConsumerStatefulWidget {
  const _BoardAgentChips({required this.projectId, required this.config});

  final String projectId;
  final Map<String, dynamic> config;

  @override
  ConsumerState<_BoardAgentChips> createState() => _BoardAgentChipsState();
}

class _BoardAgentChipsState extends ConsumerState<_BoardAgentChips> {
  List<Map<String, dynamic>> _models = const [];
  String? _modelsFor;
  bool _loadingModels = false;

  void _loadModels(String? provider) {
    if (provider == _modelsFor) return;
    _modelsFor = provider;
    _models = const [];
    if (provider == null) return;
    _loadingModels = true;
    ref
        .read(dioProvider)
        .get<dynamic>('/api/providers/$provider/models')
        .then((res) {
          if (!mounted || provider != _modelsFor) return;
          final opts =
              ((((res.data as Map?)?['data']) as Map?)?['models'] as Map?)?['OPTIONS'] as List?;
          setState(() {
            _models = [for (final o in opts ?? const []) Map<String, dynamic>.from(o as Map)];
            _loadingModels = false;
          });
        })
        .catchError((_) {
          if (mounted) setState(() => _loadingModels = false);
        });
  }

  Future<void> _save({String? provider, String? model, String? effort}) =>
      ref.read(kanbanControllerProvider.notifier).saveBoardConfig({
        'provider': provider,
        'model': model,
        'effort': effort,
      }, projectId: widget.projectId);

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final provider = widget.config['provider'] as String?;
    final model = widget.config['model'] as String?;
    final effort = widget.config['effort'] as String?;
    _loadModels(provider);

    final selected = _models.where((m) => m['value'] == model).firstOrNull;
    final effortValues = (selected?['effort'] as Map?)?['values'] as List? ?? const [];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _chipMenu(
          icon: LucideIcons.bot,
          label: provider ?? t.tasks.board.agent.anyProvider,
          header: t.tasks.board.agent.provider,
          entries: [
            (key: '__any', label: t.tasks.board.agent.anyProvider, subtitle: null),
            for (final p in _kAgentProviders) (key: p, label: p, subtitle: null),
          ],
          dividerAfterFirst: true,
          onSelected: (v) =>
              unawaited(_save(provider: v == '__any' ? null : v, model: null, effort: null)),
        ),
        if (provider != null) ...[
          const SizedBox(width: 4),
          _chipMenu(
            icon: LucideIcons.cpu,
            label: model ?? t.tasks.board.agent.defaultModel,
            header: t.tasks.board.agent.model,
            loading: _loadingModels,
            entries: [
              (key: '__default', label: t.tasks.board.agent.defaultModel, subtitle: null),
              for (final m in _models)
                (
                  key: '${m['value']}',
                  label: '${m['label'] ?? m['value']}',
                  subtitle: m['description'] as String?,
                ),
            ],
            dividerAfterFirst: true,
            onSelected: (v) => unawaited(
              _save(provider: provider, model: v == '__default' ? null : v, effort: null),
            ),
          ),
        ],
        const SizedBox(width: 4),
        _chipMenu(
          icon: LucideIcons.gauge,
          label: effort ?? t.tasks.board.agent.defaultEffort,
          header: t.tasks.board.agent.effort,
          entries: [
            (key: '__default', label: t.tasks.board.agent.defaultEffort, subtitle: null),
            for (final e in effortValues)
              (
                key: '${(e as Map)['value']}',
                label: '${e['value']}',
                subtitle: e['description'] as String?,
              ),
          ],
          dividerAfterFirst: true,
          onSelected: (v) => unawaited(
            _save(provider: provider, model: model, effort: v == '__default' ? null : v),
          ),
        ),
      ],
    );
  }

  Widget _chipMenu({
    required IconData icon,
    required String label,
    required String header,
    required List<({String key, String label, String? subtitle})> entries,
    required ValueChanged<String> onSelected,
    bool dividerAfterFirst = false,
    bool loading = false,
  }) {
    final c = context.appColors;
    return PopupMenuButton<String>(
      tooltip: header,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      enabled: !loading,
      onSelected: onSelected,
      itemBuilder: (ctx) => [
        PopupMenuItem<String>(
          enabled: false,
          height: 28,
          child: Text(header, style: TextStyle(color: c.mutedForeground, fontSize: 12)),
        ),
        for (var i = 0; i < entries.length; i++) ...[
          if (dividerAfterFirst && i == 1) const PopupMenuDivider(height: 8),
          PopupMenuItem<String>(
            value: entries[i].key,
            height: 36,
            child: entries[i].subtitle == null
                ? Text(entries[i].label, style: TextStyle(color: c.foreground, fontSize: 13))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entries[i].label, style: TextStyle(color: c.foreground, fontSize: 13)),
                      Text(
                        entries[i].subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: c.mutedForeground, fontSize: 11),
                      ),
                    ],
                  ),
          ),
        ],
      ],
      child: _MenuChip(icon: icon, label: label),
    );
  }
}

/// One board column — `rounded-xl border bg-muted/30 shadow-sm` with a
/// status-colored header and an optional dashed "+ Add card" slot.
class _BoardColumn extends StatelessWidget {
  const _BoardColumn({
    required this.column,
    required this.cards,
    required this.maxListHeight,
    required this.usersById,
    required this.onOpen,
    required this.onEdit,
    required this.onDetails,
    required this.onDelete,
    required this.onAbort,
    required this.onMove,
    required this.onAdd,
    required this.onDropped,
    this.width,
  });

  final KanbanColumnDef column;
  final List<KanbanCard> cards;
  final double maxListHeight;
  final Map<int, CollabUser> usersById;
  final ValueChanged<KanbanCard> onOpen;
  final ValueChanged<KanbanCard> onEdit;
  final ValueChanged<KanbanCard> onDetails;
  final ValueChanged<KanbanCard> onDelete;
  final ValueChanged<KanbanCard> onAbort;
  final void Function(KanbanCard card, String target) onMove;
  final VoidCallback onAdd;
  final void Function(KanbanCard card, String target) onDropped;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = dark
        ? column.headerBgDark.withValues(alpha: column.headerBgDarkAlpha)
        : column.headerBgLight;
    final headerFg = dark ? column.headerFgDark : column.headerFgLight;
    final droppable = _userMovableStatuses.contains(column.status);

    return DragTarget<KanbanCard>(
      onWillAcceptWithDetails: (_) => droppable,
      onAcceptWithDetails: (details) => onDropped(details.data, column.status),
      builder: (context, candidateData, _) {
        final isOver = candidateData.isNotEmpty;
        return Container(
          width: width,
          constraints: const BoxConstraints(minHeight: 220),
          decoration: BoxDecoration(
            color: isOver ? c.primary.withValues(alpha: 0.05) : c.muted.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isOver ? c.primary.withValues(alpha: 0.6) : c.border),
            boxShadow: const [
              BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // `rounded-t-xl px-3 py-2` status-colored header.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: headerBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: column.accent, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        column.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: headerFg,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: dark
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        '${cards.length}',
                        style: TextStyle(
                          color: headerFg,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // `space-y-2 p-2` card list; scrolls internally when tall.
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 120, maxHeight: maxListHeight),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      for (final card in cards)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _BoardCard(
                            key: ValueKey(card.cardId),
                            card: card,
                            assigneeName: card.assigneeId == null
                                ? null
                                : (usersById[card.assigneeId]?.displayName ??
                                      usersById[card.assigneeId]?.username ??
                                      '#${card.assigneeId}'),
                            onOpen: () => onOpen(card),
                            onEdit: () => onEdit(card),
                            onDetails: () => onDetails(card),
                            onDelete: () => onDelete(card),
                            onAbort: () => onAbort(card),
                            onMove: (target) => onMove(card, target),
                          ),
                        ),
                      if (cards.isEmpty) _AddCardButton(onTap: onAdd),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// `border-dashed` rounded-lg "+ Add card" slot for empty columns.
class _AddCardButton extends StatelessWidget {
  const _AddCardButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.borderLg,
      hoverColor: c.accent,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: c.border, borderRadius: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.plus, size: 14, color: c.mutedForeground),
              const SizedBox(width: 4),
              Text(t.tasks.board.addCard, style: TextStyle(color: c.mutedForeground, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card — `rounded-lg border border-border/70 bg-card p-3 shadow-sm`,
/// hover reveals the move/edit/delete affordances (desktop); compact
/// layouts always show them (no hover there).
class _BoardCard extends StatefulWidget {
  const _BoardCard({
    super.key,
    required this.card,
    required this.assigneeName,
    required this.onOpen,
    required this.onEdit,
    required this.onDetails,
    required this.onDelete,
    required this.onAbort,
    required this.onMove,
  });

  final KanbanCard card;
  final String? assigneeName;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDetails;
  final VoidCallback onDelete;
  final VoidCallback onAbort;
  final ValueChanged<String> onMove;

  @override
  State<_BoardCard> createState() => _BoardCardState();
}

class _BoardCardState extends State<_BoardCard> with SingleTickerProviderStateMixin {
  bool _hover = false;
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  @override
  void initState() {
    super.initState();
    _syncSpin();
  }

  @override
  void didUpdateWidget(_BoardCard old) {
    super.didUpdateWidget(old);
    _syncSpin();
  }

  /// The loader only renders while `isWorking` — keeping the ticker running
  /// for every card would burn frames and never let tests settle.
  void _syncSpin() {
    final working = widget.card.status == 'working';
    if (working && !_spin.isAnimating) {
      _spin.repeat();
    } else if (!working && _spin.isAnimating) {
      _spin.stop();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = widget.card;
    final needsDecision = card.status == 'needs_decision';
    final isWorking = card.status == 'working';
    final showActions = _hover || context.breakpoint.isCompact;

    final content = AnimatedContainer(
      duration: AppMotion.hover,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadii.borderLg,
        border: Border.all(
          color: needsDecision
              ? (dark
                    ? const Color(0xFFF59E0B).withValues(alpha: 0.5)
                    : const Color(0xFFFBBF24).withValues(alpha: 0.7))
              : c.border.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: _hover ? 0.12 : 0.06),
            blurRadius: _hover ? 4 : 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  card.title ?? t.kanban.card.untitled,
                  key: Key('card-title-${card.cardId}'),
                  style: TextStyle(
                    color: c.foreground,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (widget.assigneeName != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Tooltip(
                    message: widget.assigneeName!,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: c.primary.withValues(alpha: 0.15),
                      child: Text(
                        _initials(widget.assigneeName!),
                        style: TextStyle(
                          color: c.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              Text(
                _relTime(card.updatedAt),
                style: TextStyle(color: c.mutedForeground, fontSize: 11),
              ),
            ],
          ),
          if (card.statusMessage != null && card.statusMessage!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (needsDecision)
                  Padding(
                    padding: const EdgeInsets.only(top: 1, right: 4),
                    child: Icon(
                      LucideIcons.alertCircle,
                      size: 12,
                      color: dark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
                    ),
                  ),
                Expanded(
                  child: Text(
                    card.statusMessage!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: needsDecision
                          ? (dark ? const Color(0xFFFCD34D) : const Color(0xFFB45309))
                          : c.mutedForeground,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (card.branch != null || card.prUrl != null || card.sessionId != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                if (card.branch != null && card.branch!.isNotEmpty)
                  _metaItem(c, icon: LucideIcons.gitBranch, mono: true, label: card.branch!),
                if (card.prUrl != null && card.prUrl!.isNotEmpty)
                  _metaItem(
                    c,
                    icon: LucideIcons.gitPullRequest,
                    label: t.tasks.board.card.pullRequest,
                    onTap: () => unawaited(launchUrl(Uri.parse(card.prUrl!))),
                  ),
                if (card.sessionId != null && card.sessionId!.isNotEmpty)
                  _metaItem(
                    c,
                    icon: LucideIcons.messageSquare,
                    label: t.tasks.board.card.openSession,
                    color: c.primary.withValues(alpha: 0.8),
                    onTap: widget.onOpen,
                  ),
              ],
            ),
          ],
          if (isWorking) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                RotationTransition(
                  turns: _spin,
                  child: Icon(
                    LucideIcons.loaderCircle,
                    size: 12,
                    color: dark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  t.tasks.board.card.running,
                  style: TextStyle(
                    color: dark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                InkWell(
                  key: Key('abort-button-${card.cardId}'),
                  onTap: widget.onAbort,
                  borderRadius: AppRadii.borderMd,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      t.tasks.board.card.abort,
                      style: TextStyle(color: c.mutedForeground, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (showActions) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  tooltip: t.tasks.board.card.moveTo,
                  position: PopupMenuPosition.under,
                  iconSize: 12,
                  icon: Icon(LucideIcons.arrowRightLeft, size: 12, color: c.mutedForeground),
                  onSelected: widget.onMove,
                  itemBuilder: (ctx) => [
                    PopupMenuItem<String>(
                      enabled: false,
                      height: 28,
                      child: Text(
                        t.tasks.board.card.moveTo,
                        style: TextStyle(color: c.mutedForeground, fontSize: 12),
                      ),
                    ),
                    for (final s in _moveTargets[card.status] ?? const <String>[])
                      PopupMenuItem<String>(
                        value: s,
                        height: 32,
                        child: Text(
                          _columnTitle(t, s),
                          style: TextStyle(color: c.foreground, fontSize: 13),
                        ),
                      ),
                  ],
                ),
                InkWell(
                  onTap: widget.onEdit,
                  borderRadius: AppRadii.borderSm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.pencil, size: 12, color: c.mutedForeground),
                        const SizedBox(width: 2),
                        Text(
                          t.common.buttons.edit,
                          style: TextStyle(color: c.mutedForeground, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: widget.onDelete,
                  borderRadius: AppRadii.borderSm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      t.common.buttons.delete,
                      style: TextStyle(color: c.mutedForeground, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );

    return Draggable<KanbanCard>(
      data: card,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 240, child: Opacity(opacity: 0.9, child: content)),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: content),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: InkWell(
          onTap: widget.onOpen,
          onLongPress: widget.onDetails,
          borderRadius: AppRadii.borderLg,
          hoverColor: Colors.transparent,
          child: content,
        ),
      ),
    );
  }

  static String _columnTitle(Translations t, String status) =>
      kanbanColumns(t).where((col) => col.status == status).firstOrNull?.title ?? status;

  Widget _metaItem(
    AppColors c, {
    required IconData icon,
    required String label,
    bool mono = false,
    Color? color,
    VoidCallback? onTap,
  }) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color ?? c.mutedForeground),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color ?? c.mutedForeground,
              fontSize: 11,
              fontFamily: mono ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
    if (onTap == null) return child;
    return InkWell(onTap: onTap, child: child);
  }
}

/// Bottom collapsible feed — `ActivityFeed` parity: `border-t` bar that
/// expands into the project's `/api/activity` events.
class _ActivityFooter extends ConsumerStatefulWidget {
  const _ActivityFooter({required this.projectId, required this.users});

  final String projectId;
  final List<CollabUser> users;

  @override
  ConsumerState<_ActivityFooter> createState() => _ActivityFooterState();
}

class _ActivityFooterState extends ConsumerState<_ActivityFooter> {
  bool _expanded = false;

  String? _userName(Object? userId) {
    if (userId == null) return null;
    for (final u in widget.users) {
      if ('${u.id}' == '$userId') return u.displayName ?? u.username;
    }
    return '#$userId';
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final activity = ref.watch(collabActivityProvider(widget.projectId));

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.border.withValues(alpha: 0.6))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() => _expanded = !_expanded);
              if (_expanded) {
                ref.invalidate(collabActivityProvider(widget.projectId));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    _expanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                    size: 14,
                    color: c.mutedForeground,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    t.tasks.board.activity.title,
                    style: TextStyle(
                      color: c.mutedForeground,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 192),
              child: activity.when(
                data: (events) => events.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            t.tasks.board.activity.empty,
                            style: TextStyle(color: c.mutedForeground, fontSize: 12),
                          ),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                        children: [
                          for (final e in events)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    _relTime('${e['createdAt'] ?? ''}'),
                                    style: TextStyle(color: c.mutedForeground, fontSize: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          if (_userName(e['userId']) != null)
                                            TextSpan(
                                              text: '${_userName(e['userId'])}: ',
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                          TextSpan(text: '${e['summary'] ?? ''}'),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: c.foreground.withValues(alpha: 0.9),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('$e', style: TextStyle(color: c.destructive, fontSize: 12)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Dashed rounded-rect border painter for the "+ Add card" slot.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, this.borderRadius = 8});

  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    ).deflate(0.5);
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final len = (distance + 4 <= metric.length) ? 4.0 : metric.length - distance;
        canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        distance += 7; // 4px dash + 3px gap
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.borderRadius != borderRadius;
}

/// Create/edit card dialog — `KanbanCardDialog` parity (title, description,
/// assignee, and — when editing — the card's comments; status stays `backlog`
/// on create, edits patch via updateCard).
class _CreateCardDialog extends ConsumerStatefulWidget {
  const _CreateCardDialog({this.projectId, this.card});

  final String? projectId;
  final KanbanCard? card;

  @override
  ConsumerState<_CreateCardDialog> createState() => _CreateCardDialogState();
}

class _CreateCardDialogState extends ConsumerState<_CreateCardDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  int? _assigneeId;
  String? _error;
  bool _saving = false;
  bool _titleTouched = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.card?.title ?? '');
    _descController = TextEditingController(text: widget.card?.description ?? '');
    _assigneeId = widget.card?.assigneeId?.toInt();
    _titleController.addListener(_onTitleChanged);
    _descController.addListener(_clearError);
  }

  void _onTitleChanged() {
    if (_titleController.text.trim().isNotEmpty) _titleTouched = true;
    if (_error != null) setState(() => _error = null);
  }

  void _clearError() {
    if (_error != null) setState(() => _error = null);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final editing = widget.card != null;
    if (title.isEmpty || _saving) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    final notifier = ref.read(kanbanControllerProvider.notifier);
    final body = <String, dynamic>{
      'title': title,
      'description': _descController.text.trim(),
      // Create ignores the assignee (the controller patches it right after),
      // so it is only sent when one was picked; an edit always sends it so
      // clearing the select unassigns.
      if (editing || _assigneeId != null) 'assigneeUserId': _assigneeId,
      if (!editing) 'status': 'backlog',
    };
    final saved = editing
        ? await notifier.updateCard(widget.card!.cardId, body)
        : await notifier.createCard(body, projectId: widget.projectId);

    if (!mounted) return;
    if (saved == null) {
      setState(() {
        _saving = false;
        _error = ref.read(kanbanControllerProvider).error ?? t.kanban.saveFailed;
      });
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final editing = widget.card != null;
    final users = ref.watch(collabUsersProvider).value ?? const <CollabUser>[];
    // A card can name a user the roster no longer lists — DropdownButton
    // asserts that its value matches an item, so the id gets a fallback entry.
    final unknownAssignee = _assigneeId != null && !users.any((u) => u.id == _assigneeId);

    return AlertDialog(
      backgroundColor: c.popover,
      title: Text(editing ? t.tasks.board.dialog.editTitle : t.tasks.board.dialog.createTitle),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.tasks.board.dialog.titleLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppInput(
                key: const Key('card-title-input'),
                controller: _titleController,
                hint: t.tasks.board.dialog.titleLabel,
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _titleController,
                builder: (context, value, _) => _titleTouched && value.text.trim().isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Text(
                          t.tasks.taskDetail.titleRequired,
                          style: TextStyle(color: c.destructive, fontSize: 12),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                t.tasks.board.dialog.descriptionLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppInput(
                key: const Key('card-description-input'),
                controller: _descController,
                hint: t.tasks.board.dialog.descriptionLabel,
                maxLines: 3,
              ),
              if (users.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  t.tasks.board.assignee.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xs),
                DropdownButton<int?>(
                  key: const Key('card-assignee-select'),
                  value: _assigneeId,
                  isExpanded: true,
                  isDense: true,
                  underline: const SizedBox.shrink(),
                  onChanged: _saving ? null : (v) => setState(() => _assigneeId = v),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(t.tasks.board.assignee.unassigned),
                    ),
                    if (unknownAssignee)
                      DropdownMenuItem<int?>(value: _assigneeId, child: Text('#$_assigneeId')),
                    for (final u in users)
                      DropdownMenuItem<int?>(value: u.id, child: Text(u.displayName ?? u.username)),
                  ],
                ),
              ],
              if (editing) ...[
                const SizedBox(height: AppSpacing.md),
                _CardComments(cardId: widget.card!.cardId),
              ],
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(_error!, style: TextStyle(color: c.destructive, fontSize: 12)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(t.common.buttons.cancel),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _titleController,
          builder: (context, value, _) => AppButton(
            key: const Key('save-card-button'),
            onPressed: value.text.trim().isEmpty || _saving ? null : _save,
            child: Text(_saving ? t.kanban.dialog.saving : t.tasks.board.dialog.save),
          ),
        ),
      ],
    );
  }
}

/// Comments block shared by the edit and details dialogs — `CardComments`
/// parity: author-resolved list, add box, live via `kanban-comment-added`.
class _CardComments extends ConsumerStatefulWidget {
  const _CardComments({required this.cardId});

  final String cardId;

  @override
  ConsumerState<_CardComments> createState() => _CardCommentsState();
}

class _CardCommentsState extends ConsumerState<_CardComments> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        unawaited(ref.read(kanbanControllerProvider.notifier).loadComments(widget.cardId));
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _authorName(Translations t, List<CollabUser> users, int? userId) {
    if (userId == null) return t.tasks.board.comments.unknownAuthor;
    for (final u in users) {
      if (u.id == userId) return u.displayName ?? u.username;
    }
    return '#$userId';
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final state = ref.watch(kanbanControllerProvider);
    final users = ref.watch(collabUsersProvider).value ?? const <CollabUser>[];
    final comments = state.comments[widget.cardId] ?? const <KanbanComment>[];
    final c = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.tasks.board.comments.label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.xs),
        if (comments.isEmpty)
          Text(t.kanban.comments.empty, style: TextStyle(color: c.mutedForeground, fontSize: 13))
        else
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 128),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border.all(color: c.border.withValues(alpha: 0.6)),
              borderRadius: AppRadii.borderMd,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final cm in comments)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _authorName(t, users, cm.userId),
                            style: TextStyle(
                              color: c.foreground,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              cm.body ?? '',
                              style: TextStyle(color: c.mutedForeground, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: AppInput(
                key: const Key('comment-input'),
                controller: _commentController,
                hint: t.kanban.comments.add,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(
              key: const Key('add-comment-button'),
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
              onPressed: () async {
                final body = _commentController.text.trim();
                if (body.isEmpty) return;
                await ref.read(kanbanControllerProvider.notifier).addComment(widget.cardId, body);
                _commentController.clear();
              },
              child: Text(t.kanban.comments.add),
            ),
          ],
        ),
      ],
    );
  }
}

/// Card details dialog (comments) — reachable via long-press.
class _CardDetailsDialog extends ConsumerWidget {
  const _CardDetailsDialog({required this.card});

  final KanbanCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;

    return AlertDialog(
      backgroundColor: c.popover,
      title: Text(card.title ?? t.kanban.details.title),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.kanban.details.status(status: _BoardCardState._columnTitle(t, card.status ?? '')),
                style: TextStyle(color: c.mutedForeground, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.md),
              _CardComments(cardId: card.cardId),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.common.buttons.close),
        ),
      ],
    );
  }
}
