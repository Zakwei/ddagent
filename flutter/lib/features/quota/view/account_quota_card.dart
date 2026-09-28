import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/state/quota_controller.dart';
import 'package:ddagent_app/features/quota/view/quota_charts.dart';
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Per-account quota card (port of AccountQuotaCard.tsx): window progress
/// bars with reset timers and pace projection, routed-agent chips, a
/// collapsible history sparkline and the sync age footer.
class AccountQuotaCard extends ConsumerStatefulWidget {
  const AccountQuotaCard({super.key, required this.account});

  final QuotaAccount account;

  @override
  ConsumerState<AccountQuotaCard> createState() => _AccountQuotaCardState();
}

class _AccountQuotaCardState extends ConsumerState<AccountQuotaCard> {
  bool _historyOpen = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final account = widget.account;
    final state = ref.watch(quotaProvider);
    final config = state.config;
    final history = state.histories[account.id];

    final watch = config?.watchThreshold ?? 75;
    final danger = config?.dangerThreshold ?? 90;
    final alertsEnabled = config?.alertsEnabled ?? true;
    final worst = account.windows.fold<double>(
      0,
      (m, w) => w.percent > m ? w.percent : m,
    );
    final errored = account.status == 'error';
    final inactive = account.status == 'inactive';
    final tone = errored
        ? QuotaTone.neutral
        : toneForPercent(worst, watch, danger);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: _dot(tone),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.providerLabel +
                            (account.accountLabel.isEmpty
                                ? ''
                                : ' / ${account.accountLabel}'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (account.plan.isNotEmpty)
                        Text(
                          account.plan,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodySmall?.copyWith(
                            color: c.mutedForeground,
                          ),
                        ),
                    ],
                  ),
                ),
                _qualityBadge(account, inactive),
                if (state.refreshing)
                  const Padding(
                    padding: EdgeInsets.all(6),
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (errored)
              Text(
                account.syncError ?? 'Synchronization failed',
                style: t.bodySmall?.copyWith(color: c.destructive),
              )
            else if (inactive)
              Text(
                'The provider reports no active plan for this account.',
                style: t.bodySmall?.copyWith(color: c.mutedForeground),
              )
            else
              Column(
                children: [
                  for (final w in account.windows)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _windowRow(
                        w,
                        watch,
                        danger,
                        alertsEnabled,
                        errored,
                      ),
                    ),
                ],
              ),
            // Routed agents.
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (account.assignedAgents.isEmpty)
                  _chip(
                    icon: Icons.group_outlined,
                    label: 'No agents assigned',
                    dashed: true,
                  )
                else
                  for (final a in account.assignedAgents)
                    _chip(
                      icon: Icons.group,
                      label: '${a.agentId}${a.role.isEmpty ? '' : ' · ${a.role}'}',
                    ),
              ],
            ),
            // Collapsible history.
            InkWell(
              onTap: () {
                setState(() => _historyOpen = !_historyOpen);
                if (_historyOpen && history == null) {
                  unawaited(
                    ref.read(quotaProvider.notifier).loadHistory(account.id),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 14, color: c.mutedForeground),
                    const SizedBox(width: 4),
                    Text(
                      'History',
                      style: t.labelSmall?.copyWith(color: c.mutedForeground),
                    ),
                    Icon(
                      _historyOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 14,
                      color: c.mutedForeground,
                    ),
                  ],
                ),
              ),
            ),
            if (_historyOpen) ...[
              QuotaSparkline(
                points: [
                  for (final p in history?.points ?? const <QuotaHistoryPoint>[])
                    p.percent,
                ],
                tone: tone,
              ),
              Text(
                history == null || history.points.isEmpty
                    ? 'No history recorded yet'
                    : '${history.points.length} readings recorded',
                style: t.labelSmall?.copyWith(
                  fontSize: 10,
                  color: c.mutedForeground,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  account.provider.toUpperCase(),
                  style: t.labelSmall?.copyWith(
                    fontSize: 10,
                    color: quotaToneColor(toneForQuality(account.quality)),
                  ),
                ),
                if (account.lastSyncedAt != null)
                  Text(
                    'synced ${formatAgo(account.lastSyncedAt)} ago',
                    style: t.labelSmall?.copyWith(
                      fontSize: 10,
                      color: c.mutedForeground,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(QuotaTone tone) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: quotaToneColor(tone),
    ),
  );

  Widget _qualityBadge(QuotaAccount a, bool inactive) {
    final quality = inactive ? 'No subscription' : a.quality;
    final tone = inactive ? QuotaTone.neutral : toneForQuality(a.quality);
    final color = quotaToneColor(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: AppRadii.borderSm,
      ),
      child: Text(
        quality.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(fontSize: 9, color: color),
      ),
    );
  }

  Widget _chip({IconData? icon, required String label, bool dashed = false}) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: c.mutedForeground),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: t.labelSmall?.copyWith(
              fontSize: 10,
              color: c.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _windowRow(
    QuotaWindow w,
    num watch,
    num danger,
    bool alertsEnabled,
    bool accountErrored,
  ) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final tone = accountErrored
        ? QuotaTone.neutral
        : toneForPercent(w.percent, watch, danger);
    final color = quotaToneColor(tone);
    final reset = formatRelativeTo(w.resetsAt);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              w.label,
              style: t.bodySmall?.copyWith(color: c.mutedForeground),
            ),
            Text(
              '${w.percent.toStringAsFixed(w.percent % 1 == 0 ? 0 : 1)}%',
              style: t.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: (w.percent / 100).clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: c.muted,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${w.remainingPercent.toStringAsFixed(0)}% left',
              style: t.labelSmall?.copyWith(
                fontSize: 10,
                color: c.mutedForeground,
              ),
            ),
            if (reset != '—')
              Tooltip(
                message: w.resetsAt ?? '',
                child: Text(
                  'reset in $reset',
                  style: t.labelSmall?.copyWith(
                    fontSize: 10,
                    color: c.mutedForeground,
                  ),
                ),
              ),
          ],
        ),
        if (alertsEnabled && w.etaSeconds != null && !accountErrored)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'at the current pace this limit runs out in '
              '${formatDuration(w.etaSeconds)}',
              style: t.labelSmall?.copyWith(fontSize: 10, color: color),
            ),
          ),
      ],
    );
  }
}
