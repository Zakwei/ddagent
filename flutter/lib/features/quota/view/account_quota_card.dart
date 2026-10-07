import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/state/quota_controller.dart';
import 'package:ddagent_app/features/quota/view/quota_charts.dart';
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
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
    final i18n = Translations.of(context);
    final account = widget.account;
    final state = ref.watch(quotaProvider);
    final config = state.config;
    final history = state.histories[account.id];

    final watch = config?.watchThreshold ?? 75;
    final danger = config?.dangerThreshold ?? 90;
    final alertsEnabled = config?.alertsEnabled ?? true;
    final worst = account.windows.fold<double>(0, (m, w) => w.percent > m ? w.percent : m);
    final errored = account.status == 'error';
    final inactive = account.status == 'inactive';
    final tone = errored ? QuotaTone.neutral : toneForPercent(worst, watch, danger);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(top: 6), child: _dot(tone)),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.providerLabel +
                            (account.accountLabel.isEmpty ? '' : ' / ${account.accountLabel}'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (account.plan.isNotEmpty)
                        Text(
                          account.plan,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodySmall?.copyWith(color: c.mutedForeground),
                        ),
                      // A renamed provider_accounts row still shows which login it uses.
                      if (account.accountEmail.isNotEmpty &&
                          account.accountEmail != account.accountLabel)
                        Text(
                          account.accountEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodySmall?.copyWith(color: c.mutedForeground),
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
                account.syncError ?? i18n.common.quota.syncFailed,
                style: t.bodySmall?.copyWith(color: c.destructive),
              )
            else if (inactive)
              Text(
                i18n.common.quota.noSubscriptionHint,
                style: t.bodySmall?.copyWith(color: c.mutedForeground),
              )
            else
              Column(
                children: [
                  for (final w in account.windows)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _windowRow(w, watch, danger, alertsEnabled, errored),
                    ),
                ],
              ),
            // Routed agents.
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (account.assignedAgents.isEmpty)
                  _chip(icon: Icons.group_outlined, label: i18n.common.quota.noAgents, dashed: true)
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
                  unawaited(ref.read(quotaProvider.notifier).loadHistory(account.id));
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
                      i18n.common.quota.history,
                      style: t.labelSmall?.copyWith(color: c.mutedForeground),
                    ),
                    Icon(
                      _historyOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 14,
                      color: c.mutedForeground,
                    ),
                  ],
                ),
              ),
            ),
            if (_historyOpen) ...[
              QuotaSparkline(
                points: [for (final p in history?.points ?? const <QuotaHistoryPoint>[]) p.percent],
                tone: tone,
              ),
              Text(
                history == null || history.points.isEmpty
                    ? i18n.common.quota.historyEmpty
                    : i18n.common.quota.historyPoints(value: history.points.length),
                style: t.labelSmall?.copyWith(fontSize: 10, color: c.mutedForeground),
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
                    i18n.common.quota.syncedAgo(value: formatAgo(account.lastSyncedAt)),
                    style: t.labelSmall?.copyWith(fontSize: 10, color: c.mutedForeground),
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
    decoration: BoxDecoration(shape: BoxShape.circle, color: quotaToneColor(tone)),
  );

  static String _qualityLabel(Translations i18n, String quality) => switch (quality) {
    'live' => i18n.common.quota.quality.live,
    'cached' => i18n.common.quota.quality.cached,
    'estimate' => i18n.common.quota.quality.estimate,
    'error' => i18n.common.quota.quality.error,
    _ => i18n.common.quota.quality.unknown,
  };

  Widget _qualityBadge(QuotaAccount a, bool inactive) {
    final i18n = Translations.of(context);
    final quality = inactive ? i18n.common.quota.noSubscription : _qualityLabel(i18n, a.quality);
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
        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9, color: color),
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
          Text(label, style: t.labelSmall?.copyWith(fontSize: 10, color: c.mutedForeground)),
        ],
      ),
    );
  }

  Widget _windowRow(QuotaWindow w, num watch, num danger, bool alertsEnabled, bool accountErrored) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final tone = accountErrored ? QuotaTone.neutral : toneForPercent(w.percent, watch, danger);
    final color = quotaToneColor(tone);
    final reset = formatRelativeTo(w.resetsAt);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(w.label, style: t.bodySmall?.copyWith(color: c.mutedForeground)),
            Text(
              '${w.percent.toStringAsFixed(w.percent % 1 == 0 ? 0 : 1)}%',
              style: t.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: color),
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
              i18n.common.quota.remaining(value: w.remainingPercent.toStringAsFixed(0)),
              style: t.labelSmall?.copyWith(fontSize: 10, color: c.mutedForeground),
            ),
            if (reset != '—')
              Tooltip(
                message: w.resetsAt ?? '',
                child: Text(
                  i18n.common.quota.resetsIn(value: reset),
                  style: t.labelSmall?.copyWith(fontSize: 10, color: c.mutedForeground),
                ),
              ),
          ],
        ),
        if (alertsEnabled && w.etaSeconds != null && !accountErrored)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              i18n.common.quota.projected(value: formatDuration(w.etaSeconds)),
              style: t.labelSmall?.copyWith(fontSize: 10, color: color),
            ),
          ),
      ],
    );
  }
}
