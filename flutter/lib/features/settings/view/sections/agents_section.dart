import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/core/widgets/app_badge.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_spinner.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/provider_accounts/state/provider_accounts_controller.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:ddagent_app/features/settings/state/agent_permissions_controller.dart';
import 'package:ddagent_app/features/settings/state/provider_auth_controller.dart';
import 'package:ddagent_app/features/terminal/view/provider_login_dialog.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Agents settings section — port of `AgentsSettingsTab.tsx`: a provider
/// pill selector (claude/cursor/codex/opencode/devin), category tabs
/// (account/permissions/mcp/skills — `VISIBLE_CATEGORIES`) and the per-agent
/// content below. MCP and Skills bodies ship in follow-up tasks; their
/// categories render a stub row here.
class AgentsSection extends ConsumerStatefulWidget {
  const AgentsSection({super.key});

  static const agents = ['claude', 'cursor', 'codex', 'opencode', 'devin'];
  static const categories = ['account', 'permissions', 'mcp', 'skills'];

  static const _names = {
    'claude': 'Claude',
    'cursor': 'Cursor',
    'codex': 'Codex',
    'opencode': 'OpenCode',
    'devin': 'Devin',
  };

  /// Auth-dot tint — `dotColor` map from `AgentSelectorSection.tsx`.
  static Color dotColor(String provider, AppColors c) => switch (provider) {
    'claude' => const Color(0xFF3B82F6),
    'cursor' => const Color(0xFFA855F7),
    'opencode' => const Color(0xFF71717A),
    _ => c.foreground.withValues(alpha: 0.6),
  };

  /// Accent used by the account status card + login button.
  static Color accent(String provider) => switch (provider) {
    'claude' => const Color(0xFF2563EB),
    'cursor' => const Color(0xFF9333EA),
    _ => const Color(0xFF52525B),
  };

  @override
  ConsumerState<AgentsSection> createState() => _AgentsSectionState();
}

class _AgentsSectionState extends ConsumerState<AgentsSection> {
  String _agent = AgentsSection.agents.first;
  String _category = AgentsSection.categories.first;

  String _categoryLabel(Translations t, String category) => switch (category) {
    'account' => t.settings.tabs.account,
    'permissions' => t.settings.tabs.permissions,
    'mcp' => t.settings.tabs.mcpServers,
    // The web shows "Shared Skills" for opencode/devin via a defaultValue —
    // the single `skills` key already localizes the concept.
    _ => t.settings.tabs.skills,
  };

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // AgentSelectorSection — pills with provider logo + auth dot.
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.border)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final agent in AgentsSection.agents)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _AgentPill(
                      agent: agent,
                      name: AgentsSection._names[agent] ?? agent,
                      selected: _agent == agent,
                      dotColor: AgentsSection.dotColor(agent, c),
                      onTap: () => setState(() => _agent = agent),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // AgentCategoryTabsSection — underline tabs.
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.border)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final category in AgentsSection.categories)
                  InkWell(
                    onTap: () => setState(() => _category = category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 2,
                            color: _category == category
                                ? c.primary
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Text(
                        _categoryLabel(t, category),
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: _category == category
                              ? c.primary
                              : c.mutedForeground,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // AgentCategoryContentSection — the scrollable per-agent body.
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              switch (_category) {
                'account' => _AccountContent(agent: _agent),
                'permissions' => _PermissionsContent(agent: _agent),
                // Tasks T52/T53 own the real MCP/Skills panes — stub per spec.
                _ => _StubRow(category: _category),
              },
            ],
          ),
        ),
      ],
    );
  }
}

/// One provider pill — port of `AgentListItem`/`Pill`: logo + name + auth dot.
class _AgentPill extends ConsumerWidget {
  const _AgentPill({
    required this.agent,
    required this.name,
    required this.selected,
    required this.dotColor,
    required this.onTap,
  });

  final String agent;
  final String name;
  final bool selected;
  final Color dotColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final status = ref.watch(providerAuthStatusProvider(agent));

    return InkWell(
      borderRadius: AppRadii.borderMd,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.base,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? c.background : Colors.transparent,
          borderRadius: AppRadii.borderMd,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProviderLogo(provider: agent, size: 16),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: selected ? c.foreground : c.mutedForeground,
                ),
              ),
            ),
            if (status.value?.authenticated == true) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ] else if (status.isLoading) ...[
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: c.mutedForeground.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Stub for the mcp/skills categories — T52/T53 replace this row.
class _StubRow extends StatelessWidget {
  const _StubRow({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Row(
        children: [
          Icon(
            category == 'mcp' ? LucideIcons.server : LucideIcons.sparkles,
            size: 16,
            color: c.mutedForeground,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Managed under MCP/Skills sections',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: c.mutedForeground),
            ),
          ),
        ],
      ),
    );
  }
}

/// AccountContent — provider header + tinted connection-status card +
/// login button + the named-accounts manager.
class _AccountContent extends ConsumerWidget {
  const _AccountContent({required this.agent});

  final String agent;

  String _description(Translations t) => switch (agent) {
    'claude' => t.settings.agents.account.claude.description,
    'cursor' => t.settings.agents.account.cursor.description,
    'codex' => t.settings.agents.account.codex.description,
    'opencode' => t.settings.agents.account.opencode.description,
    'devin' => t.settings.agents.account.devin.description,
    _ => '',
  };

  /// Same resolution the terminal header uses for the login shell.
  String _projectPath(WidgetRef ref) {
    final projects = ref.read(projectsProvider).projects;
    if (projects.isEmpty) return '/workspace';
    final first = projects.first;
    return (first.fullPath?.isNotEmpty ?? false) ? first.fullPath! : first.path;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AgentsSection.accent(agent);
    final statusAsync = ref.watch(providerAuthStatusProvider(agent));
    final status = statusAsync.value;
    final name = AgentsSection._names[agent] ?? agent;

    final loading = statusAsync.isLoading;
    final authenticated = status?.authenticated ?? false;
    final error =
        status?.error ??
        (statusAsync.hasError ? statusAsync.error.toString() : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProviderLogo(provider: agent, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: tt.titleMedium),
                  Text(
                    _description(t),
                    style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.14 : 0.06),
            border: Border.all(color: accent.withValues(alpha: 0.35)),
            borderRadius: AppRadii.borderLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.settings.agents.connectionStatus,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          loading
                              ? t.settings.agents.authStatus.checkingAuth
                              : authenticated
                              ? t.settings.agents.authStatus.loggedInAs(
                                  email:
                                      status?.email ??
                                      t
                                          .settings
                                          .agents
                                          .authStatus
                                          .authenticatedUser,
                                )
                              : t.settings.agents.authStatus.notConnected,
                          style: tt.bodySmall?.copyWith(
                            color: c.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppBadge(
                    label: loading
                        ? t.settings.agents.authStatus.checking
                        : authenticated
                        ? t.settings.agents.authStatus.connected
                        : t.settings.agents.authStatus.disconnected,
                  ),
                ],
              ),

              // env-var credentials (`method === 'api_key'`) hide the login row.
              if (status?.method != 'api_key') ...[
                Divider(height: AppSpacing.xl, color: c.border),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authenticated
                                ? t.settings.agents.login.reAuthenticate
                                : t.settings.agents.login.title,
                            style: tt.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            authenticated
                                ? t.settings.agents.login.reAuthDescription
                                : t.settings.agents.login.description(
                                    agent: name,
                                  ),
                            style: tt.bodySmall?.copyWith(
                              color: c.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppButton(
                      size: AppButtonSize.sm,
                      onPressed: () => _openLogin(context, ref),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.logIn, size: 14),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            authenticated
                                ? t.settings.agents.login.reLoginButton
                                : t.settings.agents.login.button,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              if (error != null) ...[
                Divider(height: AppSpacing.xl, color: c.border),
                Text(
                  t.settings.agents.error(error: error),
                  style: tt.bodySmall?.copyWith(color: c.destructive),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
        _ProviderAccountsCard(agent: agent),
      ],
    );
  }

  /// The web's `openLoginForProvider` + `handleLoginComplete` pair: the
  /// provider's login CLI runs in a terminal dialog; afterwards auth status
  /// re-checks and a toast reports the outcome (`saveStatus` parity).
  void _openLogin(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    unawaited(
      ProviderLoginDialog.show(
        context: context,
        provider: agent,
        projectPath: _projectPath(ref),
        onComplete: (exitCode) {
          ref.invalidate(providerAuthStatusProvider(agent));
          if (!context.mounted) return;
          AppToast.show(
            context,
            exitCode == 0
                ? t.settings.agents.authStatus.connected
                : t.settings.agents.authStatus.notConnected,
            isError: exitCode != 0,
          );
        },
      ),
    );
  }
}

/// ProviderAccountsSection — named accounts CRUD + per-account usage probe.
class _ProviderAccountsCard extends ConsumerStatefulWidget {
  const _ProviderAccountsCard({required this.agent});

  final String agent;

  @override
  ConsumerState<_ProviderAccountsCard> createState() =>
      _ProviderAccountsCardState();
}

class _ProviderAccountsCardState extends ConsumerState<_ProviderAccountsCard> {
  final _labelCtrl = TextEditingController();

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

  String _envLine(ProviderAccountEntry account) =>
      account.envOverrides.entries.map((e) => '${e.key}=${e.value}').join(' ');

  String _tokens(int value) {
    // toLocaleString parity — grouped thousands.
    final digits = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return buf.toString();
  }

  Future<void> _add() async {
    final label = _labelCtrl.text.trim();
    if (label.isEmpty) return;
    final error = await ref
        .read(providerAccountsProvider(widget.agent).notifier)
        .add(label);
    if (!mounted) return;
    if (error == null) {
      _labelCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final state = ref.watch(providerAccountsProvider(widget.agent));
    final ctrl = ref.read(providerAccountsProvider(widget.agent).notifier);
    final accountsT = t.settings.agents.accounts;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(color: c.border.withValues(alpha: 0.6)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            accountsT.title,
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            accountsT.description,
            style: tt.bodySmall?.copyWith(color: c.mutedForeground),
          ),

          if (state.error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              state.error!,
              style: tt.bodySmall?.copyWith(color: c.destructive),
            ),
          ],
          const SizedBox(height: AppSpacing.md),

          if (state.loading && state.accounts.isEmpty)
            Row(
              children: [
                const AppSpinner(size: 16),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  accountsT.loading,
                  style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                ),
              ],
            ),

          for (final account in state.accounts) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: c.muted.withValues(alpha: 0.3),
                border: Border.all(color: c.border.withValues(alpha: 0.4)),
                borderRadius: AppRadii.borderLg,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                account.label,
                                overflow: TextOverflow.ellipsis,
                                style: tt.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (account.isDefault) ...[
                              const SizedBox(width: AppSpacing.sm),
                              AppBadge(label: accountsT.kDefault),
                            ],
                          ],
                        ),
                        if (account.envOverrides.isNotEmpty)
                          Text(
                            _envLine(account),
                            overflow: TextOverflow.ellipsis,
                            style: monoStyle(c.mutedForeground, size: 11),
                          ),
                        if (state.usageById[account.id] case final usage?)
                          Text(
                            '${accountsT.usage(tokens: _tokens(usage.totalTokens))}'
                            '${usage.costUsd != null ? ' · \$${usage.costUsd!.toStringAsFixed(2)}' : ''}',
                            style: tt.labelSmall?.copyWith(
                              color: c.mutedForeground,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AppButton(
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.sm,
                    onPressed: () => unawaited(ctrl.loadUsage(account.id)),
                    child: Text(accountsT.usageButton),
                  ),
                  if (!account.isDefault)
                    IconButton(
                      icon: const Icon(LucideIcons.star, size: 16),
                      tooltip: accountsT.makeDefault,
                      onPressed: state.busy
                          ? null
                          : () => unawaited(ctrl.makeDefault(account.id)),
                      visualDensity: VisualDensity.compact,
                    )
                  else
                    Icon(
                      LucideIcons.check,
                      size: 16,
                      color: const Color(0xFF059669),
                    ),
                  IconButton(
                    icon: Icon(
                      LucideIcons.trash2,
                      size: 16,
                      color: c.destructive,
                    ),
                    tooltip: accountsT.remove,
                    onPressed: state.busy
                        ? null
                        : () => unawaited(ctrl.remove(account.id)),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          Row(
            children: [
              Expanded(
                child: AppInput(
                  controller: _labelCtrl,
                  hint: accountsT.newLabel,
                  onSubmitted: (_) => unawaited(_add()),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                size: AppButtonSize.sm,
                onPressed: state.busy ? null : () => unawaited(_add()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.plus, size: 14),
                    const SizedBox(width: AppSpacing.xs),
                    Text(accountsT.add),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// PermissionsContent — routes to the per-agent editor.
class _PermissionsContent extends StatelessWidget {
  const _PermissionsContent({required this.agent});

  final String agent;

  @override
  Widget build(BuildContext context) => switch (agent) {
    'claude' => const _ToolPermissions(
      provider: 'claude',
      quickAdd: _commonClaudeTools,
    ),
    'cursor' => const _ToolPermissions(
      provider: 'cursor',
      quickAdd: _commonCursorCommands,
    ),
    'codex' => const _CodexPermissions(),
    _ => _ProviderModePermissions(provider: agent),
  };
}

const _commonClaudeTools = [
  'Bash(git log:*)',
  'Bash(git diff:*)',
  'Bash(git status:*)',
  'Write',
  'Read',
  'Edit',
  'Glob',
  'Grep',
  'MultiEdit',
  'Task',
  'TodoWrite',
  'TodoRead',
  'WebFetch',
  'WebSearch',
];

const _commonCursorCommands = [
  'Shell(ls)',
  'Shell(mkdir)',
  'Shell(cd)',
  'Shell(cat)',
  'Shell(echo)',
  'Shell(git status)',
  'Shell(git diff)',
  'Shell(git log)',
  'Shell(npm install)',
  'Shell(npm run)',
  'Shell(python)',
  'Shell(node)',
];

/// Claude/Cursor permission editor — skip-permissions toggle plus the
/// allowed/blocked list editors and the pattern-examples card.
class _ToolPermissions extends ConsumerWidget {
  const _ToolPermissions({required this.provider, required this.quickAdd});

  /// `claude` (tools) or `cursor` (shell commands).
  final String provider;
  final List<String> quickAdd;

  bool get _isClaude => provider == 'claude';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final perms = ref.watch(agentPermissionsProvider(provider));
    final ctrl = ref.read(agentPermissionsProvider(provider).notifier);
    final p = t.settings.permissions;

    final skipDesc = _isClaude
        ? p.skipPermissions.claudeDescription
        : p.skipPermissions.cursorDescription;

    const warning = Color(0xFFEA580C);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Skip-permissions warning card.
        Row(
          children: [
            const Icon(LucideIcons.triangleAlert, size: 20, color: warning),
            const SizedBox(width: AppSpacing.md),
            Text(p.title, style: tt.titleMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: warning.withValues(alpha: isDark ? 0.15 : 0.06),
            border: Border.all(color: warning.withValues(alpha: 0.4)),
            borderRadius: AppRadii.borderLg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.skipPermissions.label,
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      skipDesc,
                      style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                    ),
                  ],
                ),
              ),
              Switch(
                value: perms.skipPermissions,
                onChanged: ctrl.setSkipPermissions,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        _ListEditor(provider: provider, isAllowed: true, quickAdd: quickAdd),
        const SizedBox(height: AppSpacing.xl),
        _ListEditor(provider: provider, isAllowed: false, quickAdd: const []),
        const SizedBox(height: AppSpacing.xl),

        _ExamplesCard(isClaude: _isClaude),
      ],
    );
  }
}

/// One allowed/blocked list editor — input + add button, quick-add chips
/// (allowed side only), removable rows, empty state.
class _ListEditor extends ConsumerStatefulWidget {
  const _ListEditor({
    required this.provider,
    required this.isAllowed,
    required this.quickAdd,
  });

  final String provider;
  final bool isAllowed;
  final List<String> quickAdd;

  @override
  ConsumerState<_ListEditor> createState() => _ListEditorState();
}

class _ListEditorState extends ConsumerState<_ListEditor> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _add(List<String> items, String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || items.contains(normalized)) return;
    final notifier = ref.read(
      agentPermissionsProvider(widget.provider).notifier,
    );
    if (widget.isAllowed) {
      notifier.setAllowed([...items, normalized]);
    } else {
      notifier.setDisallowed([...items, normalized]);
    }
    _ctrl.clear();
  }

  void _remove(List<String> items, String value) {
    final notifier = ref.read(
      agentPermissionsProvider(widget.provider).notifier,
    );
    final next = items.where((i) => i != value).toList();
    if (widget.isAllowed) {
      notifier.setAllowed(next);
    } else {
      notifier.setDisallowed(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final isCursor = widget.provider == 'cursor';
    final p = t.settings.permissions;
    final perms = ref.watch(agentPermissionsProvider(widget.provider));
    final items = widget.isAllowed ? perms.allowed : perms.disallowed;

    final title = widget.isAllowed
        ? (isCursor ? p.allowedCommands.title : p.allowedTools.title)
        : (isCursor ? p.blockedCommands.title : p.blockedTools.title);
    final description = widget.isAllowed
        ? (isCursor
              ? p.allowedCommands.description
              : p.allowedTools.description)
        : (isCursor
              ? p.blockedCommands.description
              : p.blockedTools.description);
    final placeholder = widget.isAllowed
        ? (isCursor
              ? p.allowedCommands.placeholder
              : p.allowedTools.placeholder)
        : (isCursor
              ? p.blockedCommands.placeholder
              : p.blockedTools.placeholder);
    final emptyLabel = widget.isAllowed
        ? (isCursor ? p.allowedCommands.empty : p.allowedTools.empty)
        : (isCursor ? p.blockedCommands.empty : p.blockedTools.empty);

    final tone = widget.isAllowed
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              widget.isAllowed ? LucideIcons.shield : LucideIcons.triangleAlert,
              size: 20,
              color: tone,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(title, style: tt.titleMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          description,
          style: tt.bodySmall?.copyWith(color: c.mutedForeground),
        ),
        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: AppInput(
                controller: _ctrl,
                hint: placeholder,
                onSubmitted: (v) => _add(items, v),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(
              size: AppButtonSize.sm,
              onPressed: () => _add(items, _ctrl.text),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.plus, size: 14),
                  const SizedBox(width: AppSpacing.xs),
                  Text(p.actions.add),
                ],
              ),
            ),
          ],
        ),

        if (widget.quickAdd.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            // Quick-add only exists on the allowed side (blocked editors
            // pass `quickAdd: const []`) — label picks tools vs commands.
            isCursor ? p.allowedCommands.quickAdd : p.allowedTools.quickAdd,
            style: tt.bodySmall?.copyWith(
              color: c.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final tool in widget.quickAdd)
                AppButton(
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.sm,
                  onPressed: items.contains(tool)
                      ? null
                      : () => _add(items, tool),
                  child: Text(tool, style: tt.labelSmall),
                ),
            ],
          ),
        ],

        const SizedBox(height: AppSpacing.md),
        for (final item in items) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: tone.withValues(alpha: isDark ? 0.15 : 0.06),
              border: Border.all(color: tone.withValues(alpha: 0.35)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Row(
              children: [
                Expanded(child: Text(item, style: monoStyle(tone, size: 12))),
                IconButton(
                  icon: Icon(LucideIcons.x, size: 16, color: tone),
                  onPressed: () => _remove(items, item),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text(
                emptyLabel,
                style: tt.bodySmall?.copyWith(color: c.mutedForeground),
              ),
            ),
          ),
      ],
    );
  }
}

/// Pattern-examples hint card (blue for claude tools, purple for cursor
/// commands).
class _ExamplesCard extends StatelessWidget {
  const _ExamplesCard({required this.isClaude});

  final bool isClaude;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tone = isClaude ? const Color(0xFF2563EB) : const Color(0xFF9333EA);
    final p = t.settings.permissions;

    final examples = isClaude
        ? [
            ('"Bash(git log:*)"', p.toolExamples.bashGitLog),
            ('"Bash(git diff:*)"', p.toolExamples.bashGitDiff),
            ('"Write"', p.toolExamples.write),
            ('"Bash(rm:*)"', p.toolExamples.bashRm),
          ]
        : [
            ('"Shell(ls)"', p.shellExamples.ls),
            ('"Shell(git status)"', p.shellExamples.gitStatus),
            ('"Shell(npm install)"', p.shellExamples.npmInstall),
            ('"Shell(rm -rf)"', p.shellExamples.rmRf),
          ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: isDark ? 0.15 : 0.06),
        border: Border.all(color: tone.withValues(alpha: 0.35)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isClaude ? p.toolExamples.title : p.shellExamples.title,
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final (code, desc) in examples)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$code ',
                      style: monoStyle(
                        tone,
                        size: 12,
                      ).copyWith(backgroundColor: tone.withValues(alpha: 0.12)),
                    ),
                    TextSpan(
                      text: desc,
                      style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Radio-card picker for one permission mode — the web's bordered card with
/// a leading radio input.
class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.tone,
    required this.onTap,
    this.showWarning = false,
  });

  final String title;
  final String description;
  final bool selected;

  /// Selected-state tint (green/orange/primary); null = neutral.
  final Color? tone;
  final VoidCallback onTap;
  final bool showWarning;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tone = this.tone;

    final border = selected && tone != null
        ? tone.withValues(alpha: 0.6)
        : c.border;
    final bg = selected
        ? (tone?.withValues(alpha: isDark ? 0.16 : 0.07) ?? c.accent)
        : c.card.withValues(alpha: 0.5);
    final titleColor = selected && tone != null ? tone : c.foreground;
    final descColor = selected && tone != null
        ? tone.withValues(alpha: 0.85)
        : c.mutedForeground;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: AppRadii.borderLg,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border),
            borderRadius: AppRadii.borderLg,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? (tone ?? c.primary) : c.input,
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tone ?? c.primary,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: tt.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: titleColor,
                            ),
                          ),
                        ),
                        if (showWarning) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            LucideIcons.triangleAlert,
                            size: 14,
                            color: titleColor,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      description,
                      style: tt.bodySmall?.copyWith(color: descColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Codex permission mode cards + the `<details>` technical block.
class _CodexPermissions extends ConsumerWidget {
  const _CodexPermissions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final p = t.settings.permissions.codex;
    final perms = ref.watch(agentPermissionsProvider('codex'));
    final ctrl = ref.read(agentPermissionsProvider('codex').notifier);

    (String, String, Color?, bool) modeData(String mode) => switch (mode) {
      'acceptEdits' => (
        p.modes.acceptEdits.title,
        p.modes.acceptEdits.description,
        const Color(0xFF16A34A),
        false,
      ),
      'bypassPermissions' => (
        p.modes.bypassPermissions.title,
        p.modes.bypassPermissions.description,
        const Color(0xFFEA580C),
        true,
      ),
      _ => (p.modes.kDefault.title, p.modes.kDefault.description, null, false),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.shield, size: 20, color: Color(0xFF16A34A)),
            const SizedBox(width: AppSpacing.md),
            Text(p.permissionMode, style: tt.titleMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          p.description,
          style: tt.bodySmall?.copyWith(color: c.mutedForeground),
        ),
        const SizedBox(height: AppSpacing.md),

        for (final mode in agentPermissionModes['codex']!)
          Builder(
            builder: (context) {
              final (title, desc, tone, warn) = modeData(mode);
              return _ModeCard(
                title: title,
                description: desc,
                selected: perms.permissionMode == mode,
                tone: tone,
                showWarning: warn,
                onTap: () => ctrl.setPermissionMode(mode),
              );
            },
          ),

        // `<details>` parity — collapsible technical info.
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(
              p.technicalDetails,
              style: tt.bodySmall?.copyWith(color: c.mutedForeground),
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: c.muted.withValues(alpha: 0.5),
                  borderRadius: AppRadii.borderLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (label, info) in [
                      (p.modes.kDefault.title, p.technicalInfo.kDefault),
                      (p.modes.acceptEdits.title, p.technicalInfo.acceptEdits),
                      (
                        p.modes.bypassPermissions.title,
                        p.technicalInfo.bypassPermissions,
                      ),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$label: ',
                                style: tt.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: info,
                                style: tt.labelSmall?.copyWith(
                                  color: c.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Text(
                      p.technicalInfo.overrideNote,
                      style: tt.labelSmall?.copyWith(
                        color: c.mutedForeground.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// opencode/devin permission mode cards — `ProviderPermissionModeSettings`.
class _ProviderModePermissions extends ConsumerWidget {
  const _ProviderModePermissions({required this.provider});

  final String provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final p = t.settings.permissions.permissionMode;
    final perms = ref.watch(agentPermissionsProvider(provider));
    final ctrl = ref.read(agentPermissionsProvider(provider).notifier);
    final name = AgentsSection._names[provider] ?? provider;

    (String, String, Color?, bool) modeData(String mode) => switch (mode) {
      'acceptEdits' => (
        p.modes.acceptEdits.title,
        p.modes.acceptEdits.description,
        const Color(0xFF16A34A),
        false,
      ),
      'bypassPermissions' => (
        p.modes.bypassPermissions.title,
        p.modes.bypassPermissions.description,
        const Color(0xFFEA580C),
        true,
      ),
      'plan' => (
        p.modes.plan.title,
        p.modes.plan.description,
        c.primary,
        false,
      ),
      _ => (p.modes.kDefault.title, p.modes.kDefault.description, null, false),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.shield, size: 20, color: Color(0xFF16A34A)),
            const SizedBox(width: AppSpacing.md),
            Text(p.title, style: tt.titleMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          p.description(provider: name),
          style: tt.bodySmall?.copyWith(color: c.mutedForeground),
        ),
        const SizedBox(height: AppSpacing.md),

        for (final mode in agentPermissionModes[provider] ?? const ['default'])
          Builder(
            builder: (context) {
              final (title, desc, tone, warn) = modeData(mode);
              return _ModeCard(
                title: title,
                description: desc,
                selected: perms.permissionMode == mode,
                tone: tone,
                showWarning: warn,
                onTap: () => ctrl.setPermissionMode(mode),
              );
            },
          ),
      ],
    );
  }
}
