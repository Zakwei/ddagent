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
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:ddagent_app/features/quota/view/quota_usage_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum _Section { accounts, usage, fleet, config }

/// AI Control Center (port of ControlCenterPage.tsx): account quota cards,
/// the usage explorer, the agent-fleet snapshot and the poller config form.
/// Mounted at /quota.
class QuotaScreen extends ConsumerStatefulWidget {
  const QuotaScreen({super.key});

  @override
  ConsumerState<QuotaScreen> createState() => _QuotaScreenState();
}

class _QuotaScreenState extends ConsumerState<QuotaScreen> {
  _Section _section = _Section.accounts;

  static const _sections = [
    (_Section.accounts, LucideIcons.gauge, 'Accounts'),
    (_Section.usage, LucideIcons.barChart3, 'Usage'),
    (_Section.fleet, LucideIcons.users, 'Fleet'),
    (_Section.config, LucideIcons.slidersHorizontal, 'Config'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quotaProvider);
    final ctrl = ref.read(quotaProvider.notifier);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final compact = context.breakpoint.isCompact;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SubpageHeader(
              icon: LucideIcons.monitorCog,
              title: 'AI Control Center',
              trailing: [
                _RangePills(
                  periods: usagePeriods,
                  active: ref.watch(usageChartProvider).period,
                  onPick: ref.read(usageChartProvider.notifier).setPeriod,
                ),
                if (state.snapshot?.generatedAt != null && !compact)
                  Text(
                    'updated ${formatAgo(state.snapshot!.generatedAt)} ago',
                    style: t.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                AppButton(
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.sm,
                  loading: state.refreshing,
                  onPressed: () => unawaited(ctrl.refresh()),
                  child: const Text('Sync now'),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.settings, size: 16),
                  tooltip: 'Control Center settings',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _section = _Section.config),
                ),
              ],
            ),
            if (state.error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                color: c.destructive.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.error!,
                        style: t.bodySmall?.copyWith(color: c.destructive),
                      ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    for (final (s, icon, label) in _sections)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: ChoiceChip(
                          avatar: Icon(icon, size: 14),
                          label: Text(label),
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
                                right: BorderSide(
                                  color: c.border.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final (s, icon, label) in _sections)
                                  _navItem(s, icon, label),
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: active ? c.accent : null,
            borderRadius: AppRadii.borderLg,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: active ? c.foreground : c.mutedForeground,
              ),
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
    _Section.accounts => _AccountsPanel(state: state),
    _Section.usage => const QuotaUsagePanel(),
    _Section.fleet => _FleetPanel(fleet: state.fleet),
    _Section.config => _ConfigPanel(state: state),
  };
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
                label: const Text('All'),
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
                  'No accounts connected',
                  style: t.bodyMedium?.copyWith(color: c.mutedForeground),
                ),
                Text(
                  'Sign in to Claude, OpenAI, Gemini or another provider so '
                  'quota can be tracked here.',
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
                      width:
                          (constraints.maxWidth - (cols - 1) * AppSpacing.sm) /
                          cols,
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

  static const _statuses = [
    'running',
    'waiting',
    'queued',
    'failed',
    'finished',
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
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
              '${summary?.running ?? 0} running',
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
              label: const Text('All'),
              selected: _status == null,
              onSelected: (_) => setState(() => _status = null),
              visualDensity: VisualDensity.compact,
              labelStyle: t.labelSmall,
            ),
            for (final s in _statuses)
              ChoiceChip(
                label: Text(
                  '$s (${switch (s) {
                    'running' => summary?.running ?? 0,
                    'waiting' => summary?.waiting ?? 0,
                    'queued' => summary?.queued ?? 0,
                    'failed' => summary?.failed ?? 0,
                    _ => summary?.finished ?? 0,
                  }})',
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
                      'No agents match this filter.',
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
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }

  Widget _agentRow(AgentFleetEntry e) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final tone = quotaToneColor(toneForAgentStatus(e.status));
    final expanded = _expanded == e.agentId;
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = expanded ? null : e.agentId),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 6,
            ),
            child: Row(
              children: [
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
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
                        style: t.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (e.role.isNotEmpty)
                        Text(
                          e.role,
                          style: t.labelSmall?.copyWith(
                            fontSize: 10,
                            color: c.mutedForeground,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tone,
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 56,
                  child: Text(
                    e.status,
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
                _detail('Task', e.taskTitle ?? '—'),
                _detail('Session', e.sessionId ?? '—'),
                _detail('Model', e.model ?? '—'),
                _detail(
                  'Started',
                  e.startedAt == null
                      ? '—'
                      : (DateTime.tryParse(e.startedAt!)
                                ?.toLocal()
                                .toString()
                                .split('.')
                                .first ??
                            '—'),
                ),
                _detail(
                  'Retries',
                  e.retryCount == null ? 'not tracked' : '${e.retryCount}',
                ),
                _detail('Result', e.result ?? '—'),
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
          style: t.labelSmall?.copyWith(
            fontSize: 10,
            color: context.appColors.mutedForeground,
          ),
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
                Text('Poller & alerts', style: t.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Predicted limit alerts'),
                  subtitle: Text(
                    'Warn before a quota window runs out',
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
                        hint: 'Watch threshold (%)',
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: AppInput(
                        controller: _danger,
                        hint: 'Danger threshold (%)',
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Routing mode', style: t.labelMedium),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: 4,
                  children: [
                    for (final m in _routingModes)
                      ChoiceChip(
                        label: Text(m),
                        selected: _routing == m,
                        onSelected: (_) => setState(() => _routing = m),
                        visualDensity: VisualDensity.compact,
                        labelStyle: t.labelSmall,
                      ),
                  ],
                ),
                if (state.accounts.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text('Account routing', style: t.labelMedium),
                  for (final a in state.accounts)
                    SwitchListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        a.providerLabel.isEmpty ? a.id : a.providerLabel,
                        style: t.bodySmall,
                      ),
                      value: _accountRouting[a.id] ?? true,
                      onChanged: (v) =>
                          setState(() => _accountRouting[a.id] = v),
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
                    child: const Text('Save config'),
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
  const _RangePills({
    required this.periods,
    required this.active,
    required this.onPick,
  });

  final List<String> periods;
  final String active;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
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
                  border: p == active
                      ? Border.all(color: c.border.withValues(alpha: 0.5))
                      : null,
                ),
                child: Text(
                  p,
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
