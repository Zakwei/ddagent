import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/state/quota_controller.dart';
import 'package:ddagent_app/features/quota/view/quota_charts.dart';
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Usage explorer (port of quota/UsagePanel.tsx): period + group-by pills,
/// KPI cards, the daily trend chart and a breakdown table.
class QuotaUsagePanel extends ConsumerWidget {
  const QuotaUsagePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usageChartProvider);
    final ctrl = ref.read(usageChartProvider.notifier);
    final summary = state.summary;
    final c = context.appColors;
    final t = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            _pills(usagePeriods, state.period, ctrl.setPeriod),
            _pills(usageGroupBys, state.groupBy, ctrl.setGroupBy),
            if (state.loading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              state.error!,
              style: t.bodySmall?.copyWith(color: c.destructive),
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            _metric('Tokens', formatTokens(summary?.totals.tokensTotal ?? 0)),
            _metric('Cost', formatCost(summary?.totals.costUsd ?? 0)),
            _metric('API calls', '${summary?.totals.apiCalls ?? 0}'),
            _metric('Sessions', '${summary?.totals.sessions ?? 0}'),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily trend', style: t.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                QuotaTrendChart(trend: summary?.trend ?? const []),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Breakdown by ${state.groupBy}', style: t.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                if (state.loading && summary == null)
                  const Center(child: CircularProgressIndicator())
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _breakdownTable(summary?.buckets ?? const []),
                  ),
                if (summary?.source == 'unavailable')
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      'Analytics store unavailable; showing no data.',
                      style: t.labelSmall?.copyWith(color: c.mutedForeground),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pills(
    List<String> values,
    String current,
    void Function(String) onTap,
  ) {
    return Builder(
      builder: (context) => Wrap(
        spacing: 4,
        children: [
          for (final v in values)
            ChoiceChip(
              label: Text(v),
              selected: v == current,
              onSelected: (_) => onTap(v),
              visualDensity: VisualDensity.compact,
              labelStyle: Theme.of(context).textTheme.labelSmall,
            ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Builder(
      builder: (context) => SizedBox(
        width: 150,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: context.appColors.mutedForeground),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _breakdownTable(List<UsageMetric> buckets) {
    return Builder(
      builder: (context) {
        final t = Theme.of(context).textTheme;
        final muted = t.bodySmall?.copyWith(
          color: context.appColors.mutedForeground,
        );
        Text right(Object v, {bool strong = false}) => Text(
          '$v',
          textAlign: TextAlign.right,
          style: strong
              ? t.bodySmall?.copyWith(fontWeight: FontWeight.w600)
              : t.bodySmall,
        );
        return DataTable(
          columnSpacing: 16,
          headingRowHeight: 32,
          dataRowMinHeight: 28,
          dataRowMaxHeight: 34,
          columns: [
            DataColumn(label: Text('Name', style: muted)),
            DataColumn(label: right('Input'), numeric: true),
            DataColumn(label: right('Output'), numeric: true),
            DataColumn(label: right('Cache read'), numeric: true),
            DataColumn(label: right('Tokens'), numeric: true),
            DataColumn(label: right('Calls'), numeric: true),
            DataColumn(label: right('Cost'), numeric: true),
          ],
          rows: [
            for (final b in buckets)
              DataRow(
                cells: [
                  DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Tooltip(
                        message: b.label,
                        child: Text(
                          b.label,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  DataCell(right(formatTokens(b.tokensInput))),
                  DataCell(right(formatTokens(b.tokensOutput))),
                  DataCell(right(formatTokens(b.tokensCacheRead))),
                  DataCell(right(formatTokens(b.tokensTotal), strong: true)),
                  DataCell(right('${b.apiCalls}')),
                  DataCell(right(formatCost(b.costUsd))),
                ],
              ),
          ],
        );
      },
    );
  }
}
