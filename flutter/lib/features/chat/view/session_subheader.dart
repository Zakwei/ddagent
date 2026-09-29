import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart'
    hide UsageSummary;
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
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
    super.key,
  });

  final String sessionId;
  final String? provider;
  final String? projectId;
  final String? projectPath;

  /// `[data-split-rows="2"]` parity — slim transparent strip without the
  /// path. Also applied on compact (mobile) breakpoints.
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = provider ?? 'claude';
    final compact = dense || context.breakpoint.isCompact;
    // Same ComposerArg as the ChatComposer below the transcript — the model
    // label shares its provider instance instead of refetching.
    final composer = ref.watch(
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
    final muted = t.bodySmall?.copyWith(
      color: c.mutedForeground,
      fontSize: fontSize,
    );

    // `ocModelLabel` parity — 'orchestrated' for Auto, else the catalog
    // label behind the active model id.
    String? modelLabel;
    if (p == 'orchestrator') {
      modelLabel = 'orchestrated';
    } else {
      modelLabel = composer.activeModel;
      for (final m in composer.models) {
        if ('${m['id'] ?? m['value']}' == composer.activeModel) {
          modelLabel = '${m['label'] ?? m['name'] ?? composer.activeModel}';
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
          child: Row(
            spacing: compact ? 6 : 8,
            children: [
              ProviderLogo(provider: p, size: 14),
              Text(
                providerLabel(p),
                style: muted?.copyWith(
                  color: c.primary,
                  fontWeight: FontWeight.w700,
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
              const Spacer(),
              if (usage != null) _ContextGauge(usage: usage, compact: compact),
              QuotaBadge(provider: p, model: composer.activeModel),
            ],
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
            style: tabular?.copyWith(
              color: c.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            formatTokenCount(usage.total),
            style: tabular?.copyWith(color: c.mutedForeground),
          ),
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
          _ => null,
        };
    if (sectionKey == null) return const SizedBox.shrink();

    final account = snap.accounts
        .where((a) => a.provider == sectionKey)
        .firstOrNull;
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
    final watch = snap.overview.watchThreshold > 0
        ? snap.overview.watchThreshold
        : 75.0;
    final danger = snap.overview.dangerThreshold > 0
        ? snap.overview.dangerThreshold
        : 90.0;
    final tone = percent == null
        ? 'ok'
        : percent >= danger
        ? 'critical'
        : percent >= watch
        ? 'warn'
        : 'ok';

    final c = context.appColors;
    const amber = Color(0xFFF59E0B);
    final (border, bg, iconColor, textColor) = switch (tone) {
      'warn' => (
        amber.withValues(alpha: 0.5),
        amber.withValues(alpha: 0.1),
        amber,
        amber,
      ),
      'critical' => (
        c.destructive.withValues(alpha: 0.5),
        c.destructive.withValues(alpha: 0.1),
        c.destructive,
        c.destructive,
      ),
      _ => (
        c.border.withValues(alpha: 0.7),
        c.background.withValues(alpha: 0.7),
        percent == null ? c.mutedForeground : c.primary,
        percent == null ? c.mutedForeground : c.foreground,
      ),
    };

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
            Text(
              percent == null ? '—' : '${_percentText(percent)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: textColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
