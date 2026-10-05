import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_interactive.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/state/quota_controller.dart';
import 'package:ddagent_app/features/quota/view/account_quota_card.dart';
import 'package:ddagent_app/features/quota/view/quota_charts.dart';
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:ddagent_app/features/quota/view/quota_usage_panel.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum _Section { overview, accounts, usage, fleet, config }

/// AI Control Center (port of ControlCenterPage.tsx): account quota cards,
/// the usage explorer, the agent-fleet snapshot and the poller config form.
/// Mounted at /quota.
class QuotaScreen extends ConsumerStatefulWidget {
  const QuotaScreen({super.key});

  @override
  ConsumerState<QuotaScreen> createState() => _QuotaScreenState();
}

class _QuotaScreenState extends ConsumerState<QuotaScreen> {
  _Section _section = _Section.overview;

  static const _sections = [
    _Section.overview,
    _Section.accounts,
    _Section.usage,
    _Section.fleet,
    _Section.config,
  ];

  static IconData _sectionIcon(_Section section) => switch (section) {
    _Section.overview => LucideIcons.layoutDashboard,
    _Section.accounts => LucideIcons.gauge,
    _Section.usage => LucideIcons.barChart3,
    _Section.fleet => LucideIcons.users,
    _Section.config => LucideIcons.slidersHorizontal,
  };

  static String _sectionLabel(Translations i18n, _Section section) => switch (section) {
    _Section.overview => i18n.common.quota.section.overview,
    _Section.accounts => i18n.common.quota.section.quotas,
    _Section.usage => i18n.common.quota.section.usage,
    _Section.fleet => i18n.common.quota.section.agents,
    _Section.config => i18n.quota.section.config,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quotaProvider);
    final ctrl = ref.read(quotaProvider.notifier);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final compact = context.breakpoint.isCompact;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SubpageHeader(
              icon: LucideIcons.monitorCog,
              title: i18n.common.quota.controlCenter,
              trailing: [
                _RangePills(
                  // ControlCenterPage.tsx RANGES — the explorer keeps the
                  // extra `all` option, the header matches the old set.
                  periods: const ['24h', '7d', '30d'],
                  active: ref.watch(usageChartProvider).period,
                  onPick: ref.read(usageChartProvider.notifier).setPeriod,
                ),
                if (state.snapshot?.generatedAt != null && !compact)
                  Text(
                    i18n.common.quota.generatedAt(value: formatClock(state.snapshot!.generatedAt)),
                    style: t.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                AppButton(
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.sm,
                  loading: state.refreshing,
                  onPressed: () => unawaited(ctrl.refresh()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [
                      const Icon(LucideIcons.refreshCw, size: 14),
                      Text(i18n.common.quota.syncNow),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.settings, size: 16),
                  tooltip: i18n.common.quota.settings.tab,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _section = _Section.config),
                ),
              ],
            ),
            if (state.error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                color: c.destructive.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(state.error!, style: t.bodySmall?.copyWith(color: c.destructive)),
                    ),
                    InkWell(
                      onTap: ctrl.clearError,
                      child: Icon(Icons.close, size: 14, color: c.destructive),
                    ),
                  ],
                ),
              ),
            // Section nav — top bar on compact, side rail otherwise.
            if (compact)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                child: Row(
                  children: [
                    for (final s in _sections)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: ChoiceChip(
                          avatar: Icon(_sectionIcon(s), size: 14),
                          label: Text(_sectionLabel(i18n, s)),
                          selected: _section == s,
                          onSelected: (_) => setState(() => _section = s),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: state.loading && state.snapshot == null
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!compact)
                          Container(
                            width: 224,
                            decoration: BoxDecoration(
                              color: c.muted.withValues(alpha: 0.3),
                              border: Border(
                                right: BorderSide(color: c.border.withValues(alpha: 0.6)),
                              ),
                            ),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final s in _sections)
                                  _navItem(s, _sectionIcon(s), _sectionLabel(i18n, s)),
                              ],
                            ),
                          ),
                        Expanded(child: _body(state)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(_Section s, IconData icon, String label) {
    final c = context.appColors;
    final active = _section == s;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: InkWell(
        borderRadius: AppRadii.borderMd,
        onTap: () => setState(() => _section = s),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
          decoration: BoxDecoration(
            color: active ? c.accent : null,
            borderRadius: AppRadii.borderLg,
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: active ? c.foreground : c.mutedForeground),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: active ? FontWeight.w600 : null,
                  color: active ? c.foreground : c.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(QuotaState state) => switch (_section) {
    _Section.overview => _OverviewPanel(
      state: state,
      onOpenQuotas: () => setState(() => _section = _Section.accounts),
      onOpenAgents: () => setState(() => _section = _Section.fleet),
    ),
    _Section.accounts => _AccountsPanel(state: state),
    _Section.usage => const QuotaUsagePanel(),
    _Section.fleet => _FleetPanel(fleet: state.fleet),
    _Section.config => _ConfigPanel(state: state),
  };
}

// ─── Overview ───────────────────────────────────────────────────────────────

/// Port of OverviewPanel.tsx — 4 KPIs, usage/limits + active tasks cards,
/// trend chart, alerts list.
class _OverviewPanel extends ConsumerWidget {
  const _OverviewPanel({
    required this.state,
    required this.onOpenQuotas,
    required this.onOpenAgents,
  });

  final QuotaState state;
  final VoidCallback onOpenQuotas;
  final VoidCallback onOpenAgents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final compact = context.breakpoint.isCompact;
    final cfg = state.config;
    final i18n = Translations.of(context);
    final summary = ref.watch(usageChartProvider).summary;
    final snapshot = state.snapshot;
    final fleet = state.fleet;
    final accounts = snapshot?.accounts ?? const <QuotaAccount>[];

    // Server always sends these; 0 means "not configured" — the web page's
    // `?? 75`/`?? 90` covers the same gap.
    final watch = (cfg == null || cfg.watchThreshold <= 0) ? 75.0 : cfg.watchThreshold;
    final danger = (cfg == null || cfg.dangerThreshold <= 0) ? 90.0 : cfg.dangerThreshold;
    final alertsEnabled = cfg?.alertsEnabled ?? true;

    QuotaWindow? worstWindow(QuotaAccount a) {
      QuotaWindow? worst;
      for (final w in a.windows) {
        if (worst == null || w.percent > worst.percent) worst = w;
      }
      return worst;
    }

    final paceAlerts = <(QuotaAccount, QuotaWindow)>[];
    final riskyWindows = <(QuotaAccount, QuotaWindow)>[];
    if (alertsEnabled) {
      for (final a in accounts) {
        for (final w in a.windows) {
          if (w.etaSeconds != null) {
            paceAlerts.add((a, w));
          } else if (w.percent >= watch) {
            riskyWindows.add((a, w));
          }
        }
      }
    }

    final activeAgents = [
      for (final e in fleet?.entries ?? const <AgentFleetEntry>[])
        if (e.status == 'running' || e.status == 'waiting' || e.status == 'queued') e,
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth > 900
                ? 4
                : constraints.maxWidth > 460
                ? 2
                : 1;
            final w = (constraints.maxWidth - (cols - 1) * 12) / cols;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: w,
                  child: _Kpi(
                    icon: LucideIcons.triangleAlert,
                    label: i18n.common.quota.kpi.atRisk,
                    value: '${snapshot?.overview.accountsAtRisk ?? 0}',
                    hint: i18n.common.quota.kpi.atRiskHint(value: watch.toStringAsFixed(0)),
                    tone: (snapshot?.overview.accountsAtRisk ?? 0) > 0
                        ? QuotaTone.watch
                        : QuotaTone.safe,
                    onTap: onOpenQuotas,
                  ),
                ),
                SizedBox(
                  width: w,
                  child: _Kpi(
                    icon: LucideIcons.users,
                    label: i18n.common.quota.kpi.activeAgents,
                    value: '${fleet?.summary.running ?? 0}',
                    hint: i18n.common.quota.kpi.agentsHint(
                      waiting: fleet?.summary.waiting ?? 0,
                      queued: fleet?.summary.queued ?? 0,
                    ),
                    tone: QuotaTone.neutral,
                    onTap: onOpenAgents,
                  ),
                ),
                SizedBox(
                  width: w,
                  child: _Kpi(
                    icon: LucideIcons.hash,
                    label: i18n.common.quota.metric.tokens,
                    value: formatTokens(summary?.totals.tokensTotal ?? 0),
                    hint: i18n.common.quota.kpi.sessionsHint(value: summary?.totals.sessions ?? 0),
                    tone: QuotaTone.neutral,
                  ),
                ),
                SizedBox(
                  width: w,
                  child: _Kpi(
                    icon: LucideIcons.coins,
                    label: i18n.common.quota.kpi.cost,
                    value: formatCost(summary?.totals.costUsd ?? 0),
                    hint: i18n.common.quota.kpi.costHint(
                      value: formatCost(summary?.subscriptionValueUsd ?? 0),
                    ),
                    tone: QuotaTone.neutral,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Flex(
          direction: compact ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: compact ? 0 : 1,
              child: _OverviewCard(
                icon: LucideIcons.gauge,
                title: i18n.common.quota.overview.limitsTitle,
                action: i18n.common.quota.overview.viewAccounts,
                onAction: onOpenQuotas,
                child: accounts.isEmpty
                    ? _EmptyLine(text: i18n.common.quota.empty.title)
                    : Column(
                        children: [
                          for (final a in accounts) ...[
                            _AccountLimitRow(
                              account: a,
                              window: worstWindow(a),
                              watch: watch,
                              danger: danger,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
              ),
            ),
            SizedBox(width: compact ? 0 : 12, height: compact ? 12 : 0),
            Expanded(
              flex: compact ? 0 : 1,
              child: _OverviewCard(
                icon: LucideIcons.activity,
                title: i18n.common.quota.overview.activeTasks,
                action: i18n.common.quota.overview.viewAgents,
                onAction: onOpenAgents,
                child: activeAgents.isEmpty
                    ? _EmptyLine(text: i18n.common.quota.overview.noTasks)
                    : Column(
                        children: [
                          for (final e in activeAgents.take(6)) ...[
                            _ActiveAgentRow(entry: e),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _OverviewCard(
          icon: LucideIcons.trendingUp,
          title: i18n.quota.overview.tokensAndCost,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (summary != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${formatTokens(summary.totals.tokensTotal)} · ${formatCost(summary.totals.costUsd)}',
                    style: t.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
                ),
              QuotaTrendChart(trend: summary?.trend ?? const []),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _OverviewCard(
          icon: null,
          title: i18n.common.quota.overview.alertsTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (paceAlerts.isEmpty && riskyWindows.isEmpty)
                _EmptyLine(text: i18n.common.quota.overview.noAlerts),
              for (final (a, w) in paceAlerts)
                _AlertLine(
                  color: quotaToneColor(QuotaTone.watch),
                  text: i18n.common.quota.alert.pace(
                    account: a.providerLabel,
                    window: w.label,
                    value: formatRelativeTo(w.projectedExhaustionAt),
                  ),
                ),
              for (final (a, w) in riskyWindows)
                _AlertLine(
                  color: w.percent >= danger
                      ? quotaToneColor(QuotaTone.danger)
                      : quotaToneColor(QuotaTone.watch),
                  text: i18n.common.quota.alert.threshold(
                    account: a.providerLabel,
                    window: w.label,
                    value: w.percent.toStringAsFixed(0),
                    watch: watch.toStringAsFixed(0),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Compact KPI card — `Kpi` in OverviewPanel.tsx.
class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
    this.hint,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final QuotaTone tone;
  final String? hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final color = quotaToneColor(tone);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: c.muted, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: t.bodySmall?.copyWith(color: c.mutedForeground)),
                    Text(
                      value,
                      style: t.titleLarge?.copyWith(
                        color: color,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    if (hint != null)
                      Text(
                        hint!,
                        style: t.labelSmall?.copyWith(
                          color: c.mutedForeground,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                        overflow: TextOverflow.ellipsis,
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

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.child,
    this.icon,
    this.action,
    this.onAction,
  });

  final String title;
  final Widget child;
  final IconData? icon;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 15, color: c.mutedForeground),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(title, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                ),
                if (action != null)
                  InkWell(
                    onTap: onAction,
                    child: Text(action!, style: t.bodySmall?.copyWith(color: c.mutedForeground)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// One account row in "Usage and limits" — provider · account label, worst
/// window percent + reset, tone bar.
class _AccountLimitRow extends StatelessWidget {
  const _AccountLimitRow({
    required this.account,
    required this.window,
    required this.watch,
    required this.danger,
  });

  final QuotaAccount account;
  final QuotaWindow? window;
  final double watch;
  final double danger;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final w = window;
    final tone = account.status == 'error'
        ? QuotaTone.danger
        : w != null
        ? toneForPercent(w.percent, watch, danger)
        : QuotaTone.neutral;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: account.providerLabel,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (account.accountLabel.isNotEmpty)
                      TextSpan(
                        text: ' · ${account.accountLabel}',
                        style: TextStyle(color: c.mutedForeground),
                      ),
                  ],
                ),
                style: t.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (account.status == 'error')
              Text(
                i18n.common.quota.quality.error,
                style: t.bodySmall?.copyWith(
                  color: quotaToneColor(QuotaTone.danger),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              )
            else if (account.status == 'inactive')
              Text(
                i18n.common.quota.noSubscription,
                style: t.bodySmall?.copyWith(color: c.mutedForeground),
              )
            else if (w != null)
              Text(
                '${w.percent.toStringAsFixed(0)}% · ${formatRelativeTo(w.resetsAt)}',
                style: t.bodySmall?.copyWith(
                  color: quotaToneColor(tone),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: account.status == 'error' || w == null ? 0 : (w.percent / 100).clamp(0.0, 1.0),
              color: quotaToneColor(tone),
              backgroundColor: c.muted,
            ),
          ),
        ),
      ],
    );
  }
}

/// One agent row in "Active tasks" — status dot, task/role, elapsed time.
class _ActiveAgentRow extends StatelessWidget {
  const _ActiveAgentRow({required this.entry});

  final AgentFleetEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final tone = switch (entry.status) {
      'running' => QuotaTone.info,
      'waiting' => QuotaTone.watch,
      _ => QuotaTone.neutral,
    };
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: quotaToneColor(tone), shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            entry.taskTitle ?? entry.role,
            style: t.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          formatDuration(entry.elapsedSeconds),
          style: t.bodySmall?.copyWith(
            color: c.mutedForeground,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _AlertLine extends StatelessWidget {
  const _AlertLine({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall
          ?.copyWith(color: context.appColors.mutedForeground),
    );
  }
}

// ─── Accounts ───────────────────────────────────────────────────────────────

class _AccountsPanel extends StatefulWidget {
  const _AccountsPanel({required this.state});
  final QuotaState state;

  @override
  State<_AccountsPanel> createState() => _AccountsPanelState();
}

class _AccountsPanelState extends State<_AccountsPanel> {
  String? _provider;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final accounts = widget.state.accounts;
    final providers = {for (final a in accounts) a.provider};
    final filtered = _provider == null
        ? accounts
        : [
            for (final a in accounts)
              if (a.provider == _provider) a,
          ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        if (providers.length > 1)
          Wrap(
            spacing: 4,
            children: [
              ChoiceChip(
                label: Text(i18n.chat.providerSelection.all),
                selected: _provider == null,
                onSelected: (_) => setState(() => _provider = null),
                visualDensity: VisualDensity.compact,
                labelStyle: t.labelSmall,
              ),
              for (final p in providers)
                ChoiceChip(
                  label: Text(p),
                  selected: _provider == p,
                  onSelected: (_) => setState(() => _provider = p),
                  visualDensity: VisualDensity.compact,
                  labelStyle: t.labelSmall,
                ),
            ],
          ),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Icon(Icons.speed, size: 32, color: c.mutedForeground),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  i18n.common.quota.empty.title,
                  style: t.bodyMedium?.copyWith(color: c.mutedForeground),
                ),
                Text(
                  i18n.common.quota.empty.description,
                  textAlign: TextAlign.center,
                  style: t.bodySmall?.copyWith(color: c.mutedForeground),
                ),
              ],
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 1200
                  ? 3
                  : constraints.maxWidth > 700
                  ? 2
                  : 1;
              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final a in filtered)
                    SizedBox(
                      width: (constraints.maxWidth - (cols - 1) * AppSpacing.sm) / cols,
                      child: AccountQuotaCard(account: a),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

// ─── Fleet ─────────────────────────────────────────────────────────────────

class _FleetPanel extends StatefulWidget {
  const _FleetPanel({required this.fleet});
  final FleetSnapshot? fleet;

  @override
  State<_FleetPanel> createState() => _FleetPanelState();
}

class _FleetPanelState extends State<_FleetPanel> {
  String? _status;
  String? _expanded;

  static const _statuses = ['running', 'waiting', 'queued', 'failed', 'finished'];

  static String _statusLabel(Translations i18n, String status) => switch (status) {
    'running' => i18n.common.quota.agentStatus.running,
    'waiting' => i18n.common.quota.agentStatus.waiting,
    'queued' => i18n.common.quota.agentStatus.queued,
    'failed' => i18n.common.quota.agentStatus.failed,
    'finished' => i18n.common.quota.agentStatus.finished,
    _ => status,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final fleet = widget.fleet;
    final summary = fleet?.summary;
    final entries = (fleet?.entries ?? const <AgentFleetEntry>[])
        .where((e) => _status == null || e.status == _status)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _summaryBadge(
              context,
              i18n.common.quota.agents.runningCount(value: summary?.running ?? 0),
              QuotaTone.info,
            ),
            _summaryBadge(
              context,
              '${formatTokens(summary?.totalTokens ?? 0)} · '
              '${formatCost(summary?.totalCostUsd ?? 0)}',
              QuotaTone.neutral,
            ),
            const SizedBox(width: AppSpacing.sm),
            ChoiceChip(
              label: Text(i18n.chat.providerSelection.all),
              selected: _status == null,
              onSelected: (_) => setState(() => _status = null),
              visualDensity: VisualDensity.compact,
              labelStyle: t.labelSmall,
            ),
            for (final s in _statuses)
              ChoiceChip(
                label: Text(
                  i18n.quota.agents.statusCount(
                    status: _statusLabel(i18n, s),
                    count: switch (s) {
                      'running' => summary?.running ?? 0,
                      'waiting' => summary?.waiting ?? 0,
                      'queued' => summary?.queued ?? 0,
                      'failed' => summary?.failed ?? 0,
                      _ => summary?.finished ?? 0,
                    },
                  ),
                ),
                selected: _status == s,
                onSelected: (_) => setState(() => _status = s),
                visualDensity: VisualDensity.compact,
                labelStyle: t.labelSmall,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          clipBehavior: Clip.antiAlias,
          child: entries.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text(
                      i18n.common.quota.agents.empty,
                      style: t.bodySmall?.copyWith(color: c.mutedForeground),
                    ),
                  ),
                )
              : Column(children: [for (final e in entries) _agentRow(e)]),
        ),
      ],
    );
  }

  Widget _summaryBadge(BuildContext context, String label, QuotaTone tone) {
    final color = quotaToneColor(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: AppRadii.borderMd,
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
    );
  }

  Widget _agentRow(AgentFleetEntry e) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final tone = quotaToneColor(toneForAgentStatus(e.status));
    final expanded = _expanded == e.agentId;
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = expanded ? null : e.agentId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
            child: Row(
              children: [
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 14,
                  color: c.mutedForeground,
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.agentId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (e.role.isNotEmpty)
                        Text(
                          e.role,
                          style: t.labelSmall?.copyWith(fontSize: 10, color: c.mutedForeground),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: tone),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 56,
                  child: Text(
                    _statusLabel(i18n, e.status),
                    style: t.labelSmall?.copyWith(color: tone),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    e.provider ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                ),
                SizedBox(
                  width: 52,
                  child: Text(
                    formatTokens(e.tokensTotal),
                    textAlign: TextAlign.right,
                    style: t.labelSmall,
                  ),
                ),
                SizedBox(
                  width: 44,
                  child: Text(
                    formatCost(e.costUsd),
                    textAlign: TextAlign.right,
                    style: t.labelSmall,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    formatDuration(e.elapsedSeconds),
                    textAlign: TextAlign.right,
                    style: t.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Container(
            width: double.infinity,
            color: c.muted.withValues(alpha: 0.2),
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.xs,
              children: [
                _detail(i18n.common.quota.agents.colTask, e.taskTitle ?? '—'),
                _detail(i18n.common.quota.agents.detailSession, e.sessionId ?? '—'),
                _detail(i18n.common.quota.group.model, e.model ?? '—'),
                _detail(
                  i18n.common.quota.agents.detailStarted,
                  e.startedAt == null
                      ? '—'
                      : (DateTime.tryParse(e.startedAt!)?.toLocal().toString().split('.').first ??
                            '—'),
                ),
                _detail(
                  i18n.common.quota.agents.detailRetries,
                  e.retryCount == null ? i18n.common.quota.agents.notTracked : '${e.retryCount}',
                ),
                _detail(i18n.common.quota.agents.detailResult, e.result ?? '—'),
              ],
            ),
          ),
        Divider(height: 1, color: c.border),
      ],
    );
  }

  Widget _detail(String label, String value) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: t.labelSmall?.copyWith(fontSize: 10, color: context.appColors.mutedForeground),
        ),
        Text(value, style: t.bodySmall),
      ],
    );
  }
}

// ─── Config ────────────────────────────────────────────────────────────────

class _ConfigPanel extends ConsumerStatefulWidget {
  const _ConfigPanel({required this.state});
  final QuotaState state;

  @override
  ConsumerState<_ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends ConsumerState<_ConfigPanel> {
  late final TextEditingController _watch;
  late final TextEditingController _danger;
  bool _alerts = true;
  String _routing = 'manual';
  final Map<String, bool> _accountRouting = {};
  bool _loaded = false;

  static const _routingModes = ['manual', 'ask', 'auto-low-risk'];

  static String _routingLabel(Translations i18n, String mode) => switch (mode) {
    'manual' => i18n.common.quota.settings.routing.manual,
    'ask' => i18n.common.quota.settings.routing.ask,
    'auto-low-risk' => i18n.common.quota.settings.routing.autoLowRisk,
    _ => mode,
  };

  void _load(QuotaConfig cfg) {
    if (_loaded) return;
    _loaded = true;
    _watch.text = cfg.watchThreshold.toStringAsFixed(0);
    _danger.text = cfg.dangerThreshold.toStringAsFixed(0);
    _alerts = cfg.alertsEnabled;
    _routing = cfg.routingMode;
    for (final a in cfg.accounts) {
      _accountRouting[a.accountId] = a.routingEnabled;
    }
  }

  @override
  void initState() {
    super.initState();
    _watch = TextEditingController();
    _danger = TextEditingController();
  }

  @override
  void dispose() {
    _watch.dispose();
    _danger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final state = widget.state;
    final cfg = state.config;
    if (cfg == null) {
      return const Center(child: CircularProgressIndicator());
    }
    _load(cfg);

    final watchV = num.tryParse(_watch.text) ?? cfg.watchThreshold;
    final dangerV = num.tryParse(_danger.text) ?? cfg.dangerThreshold;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(i18n.quota.config.pollerTitle, style: t.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(i18n.settings.quota.settings.alertsEnabled),
                  subtitle: Text(
                    i18n.common.quota.settings.alertsEnabledHint,
                    style: t.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                  value: _alerts,
                  onChanged: (v) => setState(() => _alerts = v),
                ),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    SizedBox(
                      width: 200,
                      child: AppInput(
                        controller: _watch,
                        hint: i18n.common.quota.settings.watchThreshold,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: AppInput(
                        controller: _danger,
                        hint: i18n.common.quota.settings.dangerThreshold,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(i18n.common.quota.settings.routingMode, style: t.labelMedium),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: 4,
                  children: [
                    for (final m in _routingModes)
                      ChoiceChip(
                        label: Text(_routingLabel(i18n, m)),
                        selected: _routing == m,
                        onSelected: (_) => setState(() => _routing = m),
                        visualDensity: VisualDensity.compact,
                        labelStyle: t.labelSmall,
                      ),
                  ],
                ),
                if (state.accounts.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(i18n.quota.config.accountRouting, style: t.labelMedium),
                  for (final a in state.accounts)
                    SwitchListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        a.providerLabel.isEmpty ? a.id : a.providerLabel,
                        style: t.bodySmall,
                      ),
                      value: _accountRouting[a.id] ?? true,
                      onChanged: (v) => setState(() => _accountRouting[a.id] = v),
                    ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppButton(
                    loading: state.savingConfig,
                    onPressed: () async {
                      final next = QuotaConfig(
                        routingMode: _routing,
                        alertsEnabled: _alerts,
                        watchThreshold: watchV.toDouble(),
                        dangerThreshold: dangerV.toDouble(),
                        accounts: [
                          for (final a in state.accounts)
                            QuotaAccountConfig(
                              accountId: a.id,
                              watchThreshold:
                                  cfg.accounts
                                      .where((x) => x.accountId == a.id)
                                      .firstOrNull
                                      ?.watchThreshold ??
                                  watchV.toDouble(),
                              dangerThreshold:
                                  cfg.accounts
                                      .where((x) => x.accountId == a.id)
                                      .firstOrNull
                                      ?.dangerThreshold ??
                                  dangerV.toDouble(),
                              routingEnabled: _accountRouting[a.id] ?? true,
                            ),
                        ],
                      );
                      await ref.read(quotaProvider.notifier).saveConfig(next);
                    },
                    child: Text(i18n.quota.config.save),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// PillBar port (ui/PillBar.tsx): rounded-lg muted/60 track with 3px padding,
/// pill = rounded-md px-3 py-2 text-sm; active gets bg-background + ring.
class _RangePills extends StatelessWidget {
  const _RangePills({required this.periods, required this.active, required this.onPick});

  final List<String> periods;
  final String active;
  final ValueChanged<String> onPick;

  static String _periodLabel(Translations i18n, String period) => switch (period) {
    '24h' => i18n.common.quota.range.k24h,
    '7d' => i18n.common.quota.range.k7d,
    '30d' => i18n.common.quota.range.k30d,
    _ => period,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.6),
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          for (final p in periods)
            AppInteractive(
              onTap: () => onPick(p),
              borderRadius: AppRadii.borderMd,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: p == active ? c.background : null,
                  borderRadius: AppRadii.borderMd,
                  border: p == active ? Border.all(color: c.border.withValues(alpha: 0.5)) : null,
                ),
                child: Text(
                  _periodLabel(i18n, p),
                  style: t.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: p == active ? c.foreground : c.mutedForeground,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
