import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/git/state/git_controller.dart';
import 'package:ddagent_app/features/git/view/git_confirm.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Branches tab (BranchesView.tsx): count + new-branch action, search field,
/// Local/Remote sections with switch + delete (force-delete alternate).
class GitBranchesView extends ConsumerStatefulWidget {
  const GitBranchesView({super.key});

  @override
  ConsumerState<GitBranchesView> createState() => _GitBranchesViewState();
}

class _GitBranchesViewState extends ConsumerState<GitBranchesView> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _newBranch() async {
    final i18n = Translations.of(context);
    var input = '';
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AppDialog(
        title: i18n.common.gitPanel.branches.kNew,
        content: AppInput(hint: 'branch-name', autofocus: true, onChanged: (v) => input = v),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(i18n.chat.orchestrator.summary.cancelTasks),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(input.trim()),
            child: Text(i18n.common.buttons.create),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || !mounted) return;
    final ctrl = ref.read(gitProvider.notifier);
    if (await ctrl.createBranch(name)) {
      await ctrl.checkout(name);
    }
  }

  Future<void> _switchBranch(String branch) async {
    final i18n = Translations.of(context);
    final res = await gitConfirm(
      context,
      type: GitConfirmType.commit, // web reuses the neutral type for switch
      message: i18n.common.gitPanel.branches.confirmSwitch(branch: branch),
    );
    if (res == false && mounted) {
      await ref.read(gitProvider.notifier).checkout(branch);
    }
  }

  Future<void> _deleteBranch(String branch) async {
    final i18n = Translations.of(context);
    final res = await gitConfirm(
      context,
      type: GitConfirmType.deleteBranch,
      message: i18n.common.gitPanel.branches.confirmDelete(branch: branch),
      alternate: GitAlternate(
        label: i18n.common.gitPanel.branches.forceDeleteLabel,
        description: i18n.common.gitPanel.branches.forceDeleteDesc,
        actionLabel: i18n.common.gitPanel.branches.forceDelete,
      ),
    );
    if (res != null && mounted) {
      await ref.read(gitProvider.notifier).deleteBranch(branch, force: res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gitProvider);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final compact = context.breakpoint.isCompact;
    final current = state.status?.branch ?? '';
    final remote = state.remoteStatus;

    final query = _search.text.trim().toLowerCase();
    final local = [
      for (final b in state.branches.local)
        if (query.isEmpty || b.toLowerCase().contains(query)) b,
    ];
    final remoteBranches = [
      for (final b in state.branches.remote)
        if (query.isEmpty || b.toLowerCase().contains(query)) b,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Count + New branch
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  state.branches.remote.isNotEmpty
                      ? i18n.common.gitPanel.branches.countBoth(
                          local: state.branches.local.length,
                          remote: state.branches.remote.length,
                        )
                      : i18n.common.gitPanel.branches.countLocal(
                          count: state.branches.local.length,
                        ),
                  style: t.bodySmall?.copyWith(color: c.mutedForeground),
                ),
              ),
              InkWell(
                onTap: _newBranch,
                borderRadius: AppRadii.borderMd,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadii.borderMd,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.plus, size: 14, color: c.primary),
                      const SizedBox(width: 6),
                      Text(
                        i18n.common.gitPanel.branches.kNew,
                        style: t.bodySmall?.copyWith(color: c.primary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Search
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.border)),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.search, size: 14, color: c.mutedForeground),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  style: t.bodySmall,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: i18n.common.gitPanel.searchBranches,
                    hintStyle: t.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
                ),
              ),
              if (_search.text.isNotEmpty)
                InkWell(
                  onTap: () => setState(_search.clear),
                  child: Icon(Icons.close, size: 14, color: c.mutedForeground),
                ),
            ],
          ),
        ),
        // Lists
        Expanded(
          child: local.isEmpty && remoteBranches.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      query.isNotEmpty
                          ? i18n.common.gitPanel.branches.noMatch
                          : i18n.common.gitPanel.branches.none,
                      style: t.bodySmall?.copyWith(color: c.mutedForeground),
                    ),
                  ),
                )
              : ListView(
                  children: [
                    if (local.isNotEmpty) ...[
                      _section('LOCAL', local.length),
                      for (final b in local)
                        _BranchRow(
                          name: b,
                          isCurrent: b == current,
                          isRemote: false,
                          compact: compact,
                          ahead: b == current ? remote.ahead : 0,
                          behind: b == current ? remote.behind : 0,
                          onSwitch: () => unawaited(_switchBranch(b)),
                          onDelete: () => unawaited(_deleteBranch(b)),
                        ),
                    ],
                    if (remoteBranches.isNotEmpty) ...[
                      _section('REMOTE', remoteBranches.length),
                      for (final b in remoteBranches)
                        _BranchRow(
                          name: b,
                          isCurrent: false,
                          isRemote: true,
                          compact: compact,
                          ahead: 0,
                          behind: 0,
                          onSwitch: () => unawaited(_switchBranch(b)),
                          onDelete: () => unawaited(_deleteBranch(b)),
                        ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _section(String label, int count) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    return Container(
      color: c.background.withValues(alpha: 0.95),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: Row(
        children: [
          Text(
            label,
            style: t.labelSmall?.copyWith(
              color: c.mutedForeground,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(color: c.muted, borderRadius: BorderRadius.circular(999)),
            child: Text('$count', style: t.labelSmall?.copyWith(color: c.mutedForeground)),
          ),
        ],
      ),
    );
  }
}

class _BranchRow extends StatelessWidget {
  const _BranchRow({
    required this.name,
    required this.isCurrent,
    required this.isRemote,
    required this.compact,
    required this.ahead,
    required this.behind,
    required this.onSwitch,
    required this.onDelete,
  });

  final String name;
  final bool isCurrent;
  final bool isRemote;
  final bool compact;
  final int ahead;
  final int behind;
  final VoidCallback onSwitch;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isCurrent ? c.primary.withValues(alpha: 0.05) : null,
        border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.4))),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: compact ? 10 : 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: isCurrent ? c.primary.withValues(alpha: 0.3) : c.border),
              borderRadius: AppRadii.borderMd,
              color: isCurrent
                  ? c.primary.withValues(alpha: 0.1)
                  : c.muted.withValues(alpha: isRemote ? 1 : 0.5),
            ),
            child: Icon(
              isRemote ? LucideIcons.globe : LucideIcons.gitBranch,
              size: 14,
              color: isCurrent ? c.primary : c.mutedForeground,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Icon(LucideIcons.check, size: 14, color: c.primary),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: c.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          i18n.common.gitPanel.branches.current,
                          style: t.labelSmall?.copyWith(
                            color: c.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    if (isRemote) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: c.muted,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          i18n.common.gitPanel.branches.remote,
                          style: t.labelSmall?.copyWith(color: c.mutedForeground),
                        ),
                      ),
                    ],
                  ],
                ),
                if (isCurrent && (ahead > 0 || behind > 0))
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        if (ahead > 0)
                          Text(
                            '↑${i18n.common.gitPanel.ahead(count: ahead)}',
                            style: t.labelSmall?.copyWith(color: const Color(0xFF2EA043)),
                          ),
                        if (ahead > 0 && behind > 0) const SizedBox(width: 8),
                        if (behind > 0)
                          Text(
                            '↓${i18n.common.gitPanel.behind(count: behind)}',
                            style: t.labelSmall?.copyWith(color: c.primary),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!isCurrent && !isRemote) ...[
            InkWell(
              onTap: onSwitch,
              borderRadius: AppRadii.borderMd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  i18n.common.gitPanel.branches.kSwitch,
                  style: t.labelSmall?.copyWith(color: c.mutedForeground),
                ),
              ),
            ),
            IconButton(
              tooltip: i18n.common.gitPanel.branches.deleteTitle(branch: name),
              onPressed: onDelete,
              icon: Icon(LucideIcons.trash2, size: 14, color: c.mutedForeground),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 26, height: 26),
            ),
          ],
        ],
      ),
    );
  }
}
