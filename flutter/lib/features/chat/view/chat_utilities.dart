import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// Token usage (T17.4) — port of TokenUsageSummary.tsx helpers.
// ---------------------------------------------------------------------------

double _num(dynamic v) {
  final p = v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
  return p.isFinite ? p : 0;
}

String formatTokenCount(double value) {
  if (!value.isFinite || value <= 0) return '0';
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(value >= 10000000 ? 0 : 1)}M';
  }
  if (value >= 10000) return '${(value / 1000).round()}K';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.round().toString();
}

class UsageSummary {
  const UsageSummary({
    required this.used,
    required this.input,
    required this.output,
    required this.cacheRead,
    required this.cacheCreation,
    required this.total,
    required this.unsupported,
    this.message,
  });
  final double used;
  final double input;
  final double output;
  final double cacheRead;
  final double cacheCreation;
  final double total;
  final bool unsupported;
  final String? message;

  int? get contextPercent => unsupported || total <= 0
      ? null
      : (used / total * 100).round().clamp(0, 100);
}

UsageSummary parseUsage(Map<String, dynamic>? usage) {
  final bd = usage?['breakdown'] is Map
      ? usage!['breakdown'] as Map<String, dynamic>
      : null;
  final output = _num(usage?['outputTokens'] ?? bd?['output']);
  final used = _num(usage?['used']);
  final cacheRead = _num(
    usage?['cacheReadTokens'] ??
        usage?['cache_read_input_tokens'] ??
        usage?['cacheReadInputTokens'] ??
        bd?['cacheRead'],
  );
  final cacheCreation = _num(
    usage?['cacheCreationTokens'] ??
        usage?['cache_creation_input_tokens'] ??
        usage?['cacheCreationInputTokens'] ??
        bd?['cacheCreation'],
  );
  final reportedInput = _num(usage?['inputTokens'] ?? bd?['input']);
  // When no breakdown exists, fold cache out of the reported input so a
  // cache-heavy session doesn't show as a huge fresh prompt.
  final input = bd != null
      ? reportedInput
      : (reportedInput - cacheRead - cacheCreation).clamp(0, double.infinity);
  return UsageSummary(
    used: used > 0 ? used : reportedInput + output,
    input: input.toDouble(),
    output: output,
    cacheRead: cacheRead,
    cacheCreation: cacheCreation,
    total: _num(usage?['total']),
    unsupported: usage?['unsupported'] == true,
    message: usage?['message']?.toString(),
  );
}

// ---------------------------------------------------------------------------
// Model pricing (T17.8) — port of modelPricing.ts (substring match, per-1M USD).
// ---------------------------------------------------------------------------

const _prices = <(String, ({double input, double output}))>[
  ('opus', (input: 15, output: 75)),
  ('sonnet', (input: 3, output: 15)),
  ('haiku', (input: 0.8, output: 4)),
  ('gpt-5', (input: 1.25, output: 10)),
  ('gpt-4o-mini', (input: 0.15, output: 0.6)),
  ('gpt-4o', (input: 2.5, output: 10)),
  ('o3', (input: 2, output: 8)),
  ('gemini-2.5-pro', (input: 1.25, output: 10)),
  ('gemini-2.5-flash', (input: 0.3, output: 2.5)),
  ('grok-4', (input: 3, output: 15)),
  ('deepseek', (input: 0.28, output: 0.42)),
];

double? estimateCostUsd({
  String? model,
  double input = 0,
  double output = 0,
  double cacheRead = 0,
  double cacheCreation = 0,
}) {
  final m = (model ?? '').toLowerCase();
  ({double input, double output})? price;
  for (final (match, p) in _prices) {
    if (m.contains(match)) {
      price = p;
      break;
    }
  }
  if (price == null) return null;
  if (input == 0 && output == 0 && cacheRead == 0 && cacheCreation == 0) {
    return null;
  }
  return (input * price.input +
          output * price.output +
          cacheRead * price.input * 0.1 +
          cacheCreation * price.input * 1.25) /
      1000000;
}

String formatCostUsd(double? v) => v == null || !v.isFinite
    ? '—'
    : v > 0 && v < 0.001
    ? '<\$0.001'
    : v >= 100
    ? '\$${v.toStringAsFixed(0)}'
    : '\$${v.toStringAsFixed(3)}';

// ---------------------------------------------------------------------------
// Token usage chip + detail (T17.4)
// ---------------------------------------------------------------------------

final tokenUsageProvider = FutureProvider.family<UsageSummary, String>((
  ref,
  sessionId,
) async {
  final raw = await ref.read(sessionsRepositoryProvider).tokenUsage(sessionId);
  return parseUsage(raw);
});

class TokenUsageChip extends ConsumerWidget {
  const TokenUsageChip({required this.sessionId, super.key});
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(tokenUsageProvider(sessionId)).value;
    if (usage == null) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    final pct = usage.contextPercent;
    final title = usage.unsupported
        ? (usage.message ?? 'Token usage not available')
        : [
            '${usage.used.round()} tokens used',
            if (pct != null) 'context $pct% of ${usage.total.round()}',
            'input ${usage.input.round()}',
            if (usage.cacheRead + usage.cacheCreation > 0)
              'cache read ${usage.cacheRead.round()} · write ${usage.cacheCreation.round()}',
            'output ${usage.output.round()}',
          ].join(' · ');
    return Tooltip(
      message: title,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _showUsageDialog(context, usage),
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: cs.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt, size: 14, color: cs.primary),
              const SizedBox(width: 4),
              Text(
                formatTokenCount(usage.used),
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              ),
              if (pct != null) ...[
                const SizedBox(width: 6),
                SizedBox(
                  width: 40,
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    minHeight: 4,
                    color: pct >= 85
                        ? cs.error
                        : pct >= 60
                        ? Colors.amber
                        : Colors.green,
                    backgroundColor: cs.surfaceContainerHighest,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showUsageDialog(BuildContext context, UsageSummary u) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Token usage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (label, value) in <(String, String)>[
              ('Used', u.used.round().toString()),
              ('Input', u.input.round().toString()),
              ('Output', u.output.round().toString()),
              ('Cache read', u.cacheRead.round().toString()),
              ('Cache write', u.cacheCreation.round().toString()),
              if (u.total > 0)
                ('Context', '${u.used.round()} / ${u.total.round()}'),
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label),
                    Text(
                      value,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Export transcript (T17.5/6) — markdown + html, clipboard-first.
// ---------------------------------------------------------------------------

String _rowText(SessionMessage m) {
  final content = m.content?.toString() ?? '';
  switch (m.kind) {
    case 'text':
      return content;
    case 'thinking':
      return '> _thinking:_ $content';
    case 'tool_use':
      return '```tool:${m.toolName ?? 'tool'}\n${m.toolInput ?? content}\n```';
    case 'tool_result':
      return '```tool_result\n${m.toolResult ?? content}\n```';
    default:
      return content;
  }
}

String transcriptToMarkdown(List<SessionMessage> messages, {String? title}) {
  final b = StringBuffer('# ${title ?? 'Chat transcript'}\n\n');
  for (final m in messages) {
    final text = _rowText(m).trim();
    if (text.isEmpty) continue;
    final speaker = m.role == 'user' ? '**You:** ' : '';
    b.writeln('$speaker$text\n');
  }
  return b.toString();
}

String _esc(String s) =>
    s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

String transcriptToHtml(List<SessionMessage> messages, {String? title}) {
  final b = StringBuffer(
    '<!doctype html><meta charset="utf-8"><title>${_esc(title ?? 'Chat transcript')}</title>'
    '<style>body{font-family:sans-serif;max-width:800px;margin:auto;padding:16px}'
    '.user{background:#eef;border-radius:8px;padding:8px;margin:8px 0}'
    'pre{background:#f5f5f5;padding:8px;overflow-x:auto}</style>',
  );
  b.write('<h1>${_esc(title ?? 'Chat transcript')}</h1>');
  for (final m in messages) {
    final text = _rowText(m).trim();
    if (text.isEmpty) continue;
    final cls = m.role == 'user' ? ' class="user"' : '';
    b.write('<div$cls><pre>${_esc(text)}</pre></div>');
  }
  return b.toString();
}

// ---------------------------------------------------------------------------
// Session compare (T17.8) — port of SessionComparePanel data path.
// ---------------------------------------------------------------------------

class SessionUsage {
  const SessionUsage({
    this.used,
    this.input,
    this.output,
    this.model,
    this.costUsd,
    this.unsupported = false,
  });
  final double? used;
  final double? input;
  final double? output;
  final String? model;
  final double? costUsd;
  final bool unsupported;
}

Future<SessionUsage> loadSessionUsage(
  SessionsRepository repo,
  String sessionId, {
  String? provider,
}) async {
  double? used;
  double? input;
  double? output;
  var unsupported = false;
  try {
    final raw = await repo.tokenUsage(sessionId);
    final bd = raw['breakdown'] is Map
        ? raw['breakdown'] as Map<String, dynamic>
        : null;
    unsupported = raw['unsupported'] == true;
    input = _num(bd?['input'] ?? raw['inputTokens']);
    output = _num(bd?['output'] ?? raw['outputTokens']);
    used = _num(raw['used']);
    if (used == 0 && (input > 0 || output > 0)) used = input + output;
  } on Object {
    // 404 for providers without file-backed usage — keep nulls.
  }
  String? model;
  if (provider != null) {
    try {
      final m = await repo.activeModel(provider, sessionId);
      final v = m['model']?.toString();
      if (v != null && v.trim().isNotEmpty) model = v.trim();
    } on Object {
      // Provider may not expose an active-model record — model stays null.
    }
  }
  return SessionUsage(
    used: used,
    input: input,
    output: output,
    model: model,
    unsupported: unsupported,
    costUsd: estimateCostUsd(
      model: model,
      input: input ?? 0,
      output: output ?? 0,
    ),
  );
}

/// Side-by-side usage/model/cost compare for two sessions (T17.8).
class SessionCompareDialog extends ConsumerWidget {
  const SessionCompareDialog({
    required this.left,
    required this.right,
    super.key,
  });

  /// (sessionId, provider, label) for each side.
  final (String, String?, String) left;
  final (String, String?, String) right;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(sessionsRepositoryProvider);
    return AlertDialog(
      title: const Text('Compare sessions'),
      content: FutureBuilder(
        future: Future.wait([
          loadSessionUsage(repo, left.$1, provider: left.$2),
          loadSessionUsage(repo, right.$1, provider: right.$2),
        ]),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final (lu, ru) = (snap.data![0], snap.data![1]);
          Widget col(String title, SessionUsage u) => Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                for (final (k, v) in <(String, String)>[
                  ('Model', u.model ?? '—'),
                  ('Used', u.used == null ? '—' : formatTokenCount(u.used!)),
                  ('Input', u.input?.round().toString() ?? '—'),
                  ('Output', u.output?.round().toString() ?? '—'),
                  ('Cost', formatCostUsd(u.costUsd)),
                  if (u.unsupported) ('', 'usage unsupported'),
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(k.isEmpty ? v : '$k: $v'),
                  ),
              ],
            ),
          );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              col(left.$3, lu),
              const SizedBox(width: 16),
              col(right.$3, ru),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Provider display name — port of `ocProviderLabel` in MessageComponent.tsx.
String providerLabel(String provider) => switch (provider) {
  'cursor' => 'Cursor',
  'codex' => 'Codex',
  'opencode' => 'OpenCode',
  'devin' => 'Devin',
  'orchestrator' => 'Auto',
  _ => 'Claude',
};

/// `HH:MM:SS` local clock — the old footer renders `toLocaleTimeString()`.
String clockTime(String iso) {
  final at = DateTime.tryParse(iso)?.toLocal();
  if (at == null) return '';
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(at.hour)}:${two(at.minute)}:${two(at.second)}';
}
