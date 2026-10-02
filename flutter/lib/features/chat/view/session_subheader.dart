import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart' hide UsageSummary;
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// `/api/quota` snapshot on the web's 5-minute badge poll
/// (QuotaBadge.tsx POLL_MS). Emits `null` on failure — the badge hides.
final quotaSnapshotProvider = StreamProvider<QuotaSnapshot?>((ref) {
  final repo = ref.watch(quotaRepositoryProvider);
  final ctrl = StreamController<QuotaSnapshot?>();
  Future<void> emit() async {
    try {
      final snap = QuotaSnapshot.fromJson(await repo.snapshot());
      if (!ctrl.isClosed) ctrl.add(snap);
    } on Object {
      if (!ctrl.isClosed) ctrl.add(null);
    }
  }

  unawaited(emit());
  final timer = Timer.periodic(const Duration(minutes: 5), (_) => emit());
  ref.onDispose(() {
    timer.cancel();
    unawaited(ctrl.close());
  });
  return ctrl.stream;
});

/// `.oc-banner` port (ChatInterface.tsx:616): provider logo + label, active
/// model, project path, the persistent context-window gauge and the
/// subscription [QuotaBadge] — the strip pinned above the transcript.
class SessionSubheader extends ConsumerWidget {
  const SessionSubheader({
    required this.sessionId,
    this.provider,
    this.projectId,
    this.projectPath,
    this.dense = false,
    this.showMenuButton = false,
    super.key,
  });

  final String sessionId;
  final String? provider;
  final String? projectId;
  final String? projectPath;

  /// `[data-split-rows="2"]` parity — slim transparent strip without the
  /// path. Also applied on compact (mobile) breakpoints.
  final bool dense;

  /// Compact only: render the drawer hamburger inline here (standalone
  /// `/chat/:id` has no other header; workspace panes already carry one in
  /// the screen toolbar).
  final bool showMenuButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = provider ?? '';
    final compact = dense || context.breakpoint.isCompact;
    // The model label shares the ChatComposer's provider instance, but that
    // instance is provider-keyed: watching it before the provider is resolved
    // would create a throwaway slot and run the composer's whole `_init` under
    // the guess, then again under the real provider. So only watch it once the
    // provider is known; until then the session row's `model` seeds the label.
    final composer = p.isEmpty
        ? null
        : ref.watch(
            composerProvider((
              sessionId: sessionId,
              projectId: projectId,
              provider: p,
              projectPath: projectPath,
            )),
          );
    // Live WS budget first, REST snapshot as the fallback (web parity).
    final usage = ref.watch(contextUsageProvider(sessionId));

    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final fontSize = compact ? 11.0 : 12.0;
    final muted = t.bodySmall?.copyWith(color: c.mutedForeground, fontSize: fontSize);

    // `ocModelLabel` parity — 'orchestrated' for Auto, else the catalog
    // label behind the active model id. The session row's `model` seeds the
    // label immediately, like the web's `selectedSession.model` (the
    // composer's resolved pick replaces it once its init lands).
    final sessionModel = ref
        .watch(sessionDetailsProvider(sessionId))
        .value
        ?.raw['model']
        ?.toString();
    final effectiveModel =
        composer?.activeModel ??
        (sessionModel != null && sessionModel.isNotEmpty ? sessionModel : null);
    String? modelLabel;
    if (p == 'orchestrator') {
      modelLabel = 'orchestrated';
    } else {
      modelLabel = effectiveModel;
      for (final m in composer?.models ?? const []) {
        if ('${m['id'] ?? m['value']}' == effectiveModel) {
          modelLabel = '${m['label'] ?? m['name'] ?? effectiveModel}';
          break;
        }
      }
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Container(
          margin: compact
              ? const EdgeInsets.fromLTRB(6, 4, 6, 6)
              : const EdgeInsets.fromLTRB(18, 12, 18, 10),
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 6, vertical: 1)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: compact ? Colors.transparent : c.card,
            border: Border.all(
              // --oc-border-subtle
              color: compact ? Colors.transparent : const Color(0xFF3C3C3C),
            ),
            borderRadius: AppRadii.borderSm,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final spacing = compact ? 6.0 : 8.0;
              // The left cluster takes whatever width the trailing gauge +
              // badge leave over, so the badge always sits flush against the
              // right content edge at any width or label length. The trailing
              // pair is capped at 60% of the strip and scales down past that,
              // so a wide badge can never overflow the row.
              final trailingCap = constraints.maxWidth.isFinite
                  ? constraints.maxWidth * 0.6
                  : double.infinity;
              return Row(
                spacing: spacing,
                children: [
                  if (showMenuButton) const AppNavMenuButton(),
                  Expanded(
                    child: Row(
                      spacing: spacing,
                      children: [
                        ProviderLogo(provider: p, size: 14),
                        Flexible(
                          child: Text(
                            providerLabel(p),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: muted?.copyWith(color: c.primary, fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (!compact) Text('·', style: muted),
                        if (modelLabel != null && modelLabel.isNotEmpty)
                          Flexible(
                            child: Text(
                              modelLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: muted,
                            ),
                          ),
                        if (!compact) ...[
                          Text('·', style: muted),
                          Flexible(
                            child: Text(
                              projectPath ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: trailingCap),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: spacing,
                        children: [
                          if (usage != null) _ContextGauge(usage: usage, compact: compact),
                          QuotaBadge(provider: p, model: effectiveModel),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// `.oc-banner-ctx` — persistent context-window gauge: pill bar + `42%` +
/// total-token count. Hidden while the usage endpoint has nothing to say
/// (React renders it only when `ocContextPercent !== null`).
class _ContextGauge extends StatelessWidget {
  const _ContextGauge({required this.usage, required this.compact});

  final UsageSummary usage;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final pct = usage.contextPercent;
    if (pct == null) return const SizedBox.shrink();
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    // is-low / is-mid / is-high from index.css.
    final fill = pct >= 85
        ? const Color(0xFFF87171)
        : pct >= 60
        ? const Color(0xFFFBBF24)
        : const Color(0xFF34D399);
    final tabular = t.bodySmall?.copyWith(
      fontSize: compact ? 11 : 12,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Tooltip(
      message:
          'Context: ${usage.used.round()} / ${usage.total.round()} tokens'
          ' · $pct% used',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: compact ? 40 : 56,
            height: compact ? 5 : 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: pct / 100,
                backgroundColor: c.secondary, // --oc-elem
                valueColor: AlwaysStoppedAnimation(fill),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$pct%',
            style: tabular?.copyWith(color: c.foreground, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Text(formatTokenCount(usage.total), style: tabular?.copyWith(color: c.mutedForeground)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QuotaBadge (port of QuotaBadge.tsx) — worst matching subscription window.
// ---------------------------------------------------------------------------

/// `sectionForModel` — which /api/quota account backs a provider/model id.
String? sectionForModel(String? model) {
  if (model == null || model.isEmpty) return null;
  final m = model.toLowerCase();
  if (m.startsWith('google/') || m.contains('antigravity')) return 'gemini';
  if (m.startsWith('commandcode/')) return 'commandcode';
  if (m.startsWith('opencode/') || m.startsWith('opencode-go/')) {
    return 'opencode';
  }
  if (m.startsWith('nvidia/')) return 'byok';
  return null;
}

/// `windowMatchesModel` — the devin section's model-group filter.
bool windowMatchesModel(String windowKey, String? model) {
  if (model == null) return true;
  final m = model.toLowerCase();
  final isGeminiModel = m.contains('gemini');
  final isClaudeOrGpt = m.contains('claude') || m.contains('gpt');
  if (windowKey.startsWith('Gemini Models')) return isGeminiModel;
  if (windowKey.startsWith('Claude and GPT')) return isClaudeOrGpt;
  return true;
}

String _percentText(double p) => p.toStringAsFixed(p % 1 == 0 ? 0 : 1);

/// Period windows in badge order; each rendered as its own pill.
const quotaPeriodKinds = ['session', 'daily', 'weekly', 'monthly'];

/// Short label per kind (5h/D/W/M) — parity with the web PERIOD_LETTER.
const quotaPeriodLetter = {'session': '5h', 'daily': 'D', 'weekly': 'W', 'monthly': 'M'};

/// `(kind, percent, resetsAt)` for every present period window, in
/// [quotaPeriodKinds] order — parity with the web `sectionPeriodWindows`.
/// Windows with an unrecognised kind are skipped; zero-percent windows kept.
List<(String, double, String?)> quotaPeriodSegments(QuotaAccount? account, String? model) => [
  for (final kind in quotaPeriodKinds)
    for (final w in account?.windows ?? const <QuotaWindow>[])
      if (w.kind == kind && windowMatchesModel(w.label, model)) (kind, w.percent, w.resetsAt),
];

/// Full length of each period window — used to measure remaining clock time.
const quotaPeriodDurationMs = <String, int>{
  'session': 5 * 60 * 60 * 1000,
  'daily': 24 * 60 * 60 * 1000,
  'weekly': 7 * 24 * 60 * 60 * 1000,
  'monthly': 30 * 24 * 60 * 60 * 1000,
};

/// Percent of the window's clock still left until its reset (100% = just
/// reset, 0% = about to reset). `null` when `resetsAt`/duration is unknown.
double? quotaTimeRemainingPercent(String kind, String? resetsAt, int nowMs) {
  final total = quotaPeriodDurationMs[kind];
  final resetMs = DateTime.tryParse(resetsAt ?? '')?.millisecondsSinceEpoch;
  if (total == null || resetMs == null) return null;
  final remaining = resetMs - nowMs;
  if (remaining <= 0) return 0;
  return (remaining / total * 100).clamp(0, 100).toDouble();
}

/// Pill colour by remaining clock time, not usage: ≤25% amber, ≤10% red.
String quotaTimeToneFor(double? remainingPercent) => remainingPercent == null
    ? 'ok'
    : remainingPercent <= 10
    ? 'critical'
    : remainingPercent <= 25
    ? 'warn'
    : 'ok';

/// `dd.MM hh:mm` — the web badge's `toLocaleString` reset timestamp.
String? _resetLabel(String? iso) {
  final at = DateTime.tryParse(iso ?? '')?.toLocal();
  if (at == null) return null;
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(at.day)}.${two(at.month)} ${two(at.hour)}:${two(at.minute)}';
}

class QuotaBadge extends ConsumerWidget {
  const QuotaBadge({super.key, this.provider, this.model});

  final String? provider;
  final String? model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snap = ref.watch(quotaSnapshotProvider).value;
    if (snap == null) return const SizedBox.shrink();

    // Section exclusively for the selected model; fallback by provider only
    // ('devin'/'claude' → devin, bare 'opencode' → opencode). No section =
    // no badge — never show % from another subscription.
    final sectionKey =
        sectionForModel(model) ??
        switch (provider) {
          'devin' || 'claude' => 'devin',
          'opencode' => 'opencode',
          'commandcode' => 'commandcode',
          'antigravity' => 'gemini',
          'codex' => 'codex',
          _ => null,
        };
    if (sectionKey == null) return const SizedBox.shrink();

    final account = snap.accounts.where((a) => a.provider == sectionKey).firstOrNull;
    final lines = <String>[];
    if (account != null && account.status != 'active') {
      lines.add('${account.plan}: ${account.syncError ?? 'no subscription'}');
    }
    QuotaWindow? worst;
    for (final w in account?.windows ?? const <QuotaWindow>[]) {
      if (!windowMatchesModel(w.label, model)) continue;
      final reset = _resetLabel(w.resetsAt);
      lines.add(
        reset == null
            ? '${w.label}: ${_percentText(w.percent)}%'
            : '${w.label}: ${_percentText(w.percent)}% · reset $reset',
      );
      if (worst == null || w.percent > worst.percent) worst = w;
    }

    final percent = worst?.percent;
    final watch = snap.overview.watchThreshold > 0 ? snap.overview.watchThreshold : 75.0;
    final danger = snap.overview.dangerThreshold > 0 ? snap.overview.dangerThreshold : 90.0;

    final c = context.appColors;
    const amber = Color(0xFFF59E0B);
    // Usage tone drives the outer badge; the pill colours come from the clock.
    String usageTone(double? p) => p == null
        ? 'ok'
        : p >= danger
        ? 'critical'
        : p >= watch
        ? 'warn'
        : 'ok';
    (Color, Color, Color) colorsForTone(String tone, {bool muted = false}) => switch (tone) {
      'warn' => (amber.withValues(alpha: 0.5), amber.withValues(alpha: 0.1), amber),
      'critical' => (
        c.destructive.withValues(alpha: 0.5),
        c.destructive.withValues(alpha: 0.1),
        c.destructive,
      ),
      _ => (
        c.border.withValues(alpha: 0.7),
        c.background.withValues(alpha: 0.7),
        muted ? c.mutedForeground : c.foreground,
      ),
    };

    final (border, bg, textColor) = colorsForTone(usageTone(percent), muted: percent == null);
    final iconColor = percent == null ? c.mutedForeground : c.primary;

    // Present period windows in session/daily/weekly/monthly order — all shown
    // even at 0%, each its own pill so segments never merge into one string.
    final segments = quotaPeriodSegments(account, model);

    final title = worst != null
        ? '${account?.plan ?? sectionKey} · ${lines.join('\n')}'
        : lines.join('\n').isEmpty
        ? 'No subscription data for this model'
        : lines.join('\n');

    return Tooltip(
      message: title,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: AppRadii.borderLg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(LucideIcons.gauge, size: 14, color: iconColor),
            if (segments.isEmpty)
              Text(
                percent == null ? '—' : '${_percentText(percent)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 3,
                children: [
                  for (final (kind, segPercent, resetsAt) in segments)
                    Builder(
                      builder: (context) {
                        // Pill colour = remaining clock time to the window
                        // reset (not usage): green → amber ≤25% → red ≤10%.
                        final remaining = quotaTimeRemainingPercent(
                          kind,
                          resetsAt,
                          DateTime.now().millisecondsSinceEpoch,
                        );
                        final seg = colorsForTone(quotaTimeToneFor(remaining));
                        return Tooltip(
                          message: remaining == null
                              ? '${_percentText(segPercent)}%'
                              : '${remaining.round()}% of the window left before reset',
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: seg.$2,
                              border: Border.all(color: seg.$1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${_percentText(segPercent)}%${quotaPeriodLetter[kind] ?? kind}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: seg.$3,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
