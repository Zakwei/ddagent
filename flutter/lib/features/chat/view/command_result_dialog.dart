import 'dart:async';
import 'dart:math' as math;

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/chat/view/composer_model_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Port of `CommandResultModal.tsx` — the builtin `/help` `/models` `/cost`
/// `/status` slash-command results render in a dialog over the chat pane
/// (`memory`/`config` are navigation actions handled by the composer itself).
///
/// Compact variant: the web's 5xl/48rem shell becomes a ~640px dialog, the
/// two-column help grid stacks, and the models grid becomes a single column.
Future<void> showCommandResultDialog(
  BuildContext context, {
  required CommandExecutionResult result,
  required ComposerArg arg,
}) {
  // showDialog resolves the Navigator's app theme — the composer lives under
  // the `.oc-chat` Theme, so re-wrap its ThemeData like composerPopoverEntry
  // does for the popover menus.
  final theme = Theme.of(context);
  return showDialog<void>(
    context: context,
    builder: (_) => Theme(
      data: theme,
      child: CommandResultDialog(result: result, arg: arg),
    ),
  );
}

class CommandResultDialog extends StatelessWidget {
  const CommandResultDialog({
    required this.result,
    required this.arg,
    super.key,
  });

  final CommandExecutionResult result;
  final ComposerArg arg;

  /// Web `modalMeta` — (icon, eyebrow, title, subtitle) per payload kind.
  static const _meta = <String, (IconData, String, String, String)>{
    'help': (
      LucideIcons.circleHelp,
      'Command center',
      'Help & Shortcuts',
      'Search built-ins, syntax patterns, and command usage.',
    ),
    'models': (
      LucideIcons.cpu,
      'Model selection',
      'Choose a Model',
      'Pick the model this provider should use.',
    ),
    'cost': (
      LucideIcons.coins,
      'Session telemetry',
      'Token Usage',
      'Input, output, and total token counts for this session.',
    ),
    'status': (
      LucideIcons.activity,
      'Runtime health',
      'System Status',
      'Version, provider, runtime, and environment details.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final action = result.action ?? '';
    final meta = _meta[action];
    final height = MediaQuery.sizeOf(context).height;
    return Dialog(
      backgroundColor: c.popover,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 640,
          maxHeight: math.min(height - 48, 560),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c.muted,
                      border: Border.all(color: c.border),
                      borderRadius: AppRadii.borderLg,
                    ),
                    child: Icon(
                      meta?.$1 ?? LucideIcons.sparkles,
                      size: 16,
                      color: c.foreground,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          (meta?.$2 ?? 'Command').toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: c.mutedForeground,
                          ),
                        ),
                        Text(
                          meta?.$3 ?? 'Command Result',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 24 / 16,
                            color: c.foreground,
                          ),
                        ),
                        if (meta != null)
                          Text(
                            meta.$4,
                            style: TextStyle(
                              fontSize: 12,
                              height: 16 / 12,
                              color: c.mutedForeground,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      LucideIcons.x,
                      size: 16,
                      color: c.mutedForeground,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: c.border),
            Flexible(
              child: switch (action) {
                'help' => _HelpContent(data: result.data),
                'models' => _ModelsContent(data: result.data, arg: arg),
                'cost' => _CostContent(data: result.data),
                'status' => _StatusContent(data: result.data),
                _ => _FallbackContent(data: result.data),
              },
            ),
            Divider(height: 1, thickness: 1, color: c.border),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.gauge, size: 12, color: c.mutedForeground),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Esc closes the modal.',
                      style: TextStyle(fontSize: 11, color: c.mutedForeground),
                    ),
                  ),
                  AppButton(
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.sm,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ── shared bits ── */

/// `providerLabel` plus the web's `getProviderLabel` fallback: an unknown
/// provider id renders as written instead of collapsing to Claude.
String _providerLabelOf(String? provider, [String fallback = 'Unknown']) {
  if (provider == null || provider.isEmpty) return fallback;
  const known = {
    'claude',
    'cursor',
    'codex',
    'opencode',
    'commandcode',
    'devin',
    'orchestrator',
  };
  return known.contains(provider) ? providerLabel(provider) : provider;
}

double _numOf(dynamic v) =>
    v is num ? v.toDouble() : (double.tryParse('$v') ?? 0);

/// `toLocaleString` grouping — 12,345.
String _fmtNum(double v) {
  if (!v.isFinite) return '0';
  final s = v.round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

/// `SearchField` — icon + borderless input row (composer popover style).
class _SearchField extends StatelessWidget {
  const _SearchField({required this.hint, required this.onChanged});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: c.background.withValues(alpha: 0.6),
        border: Border.all(color: c.border.withValues(alpha: 0.7)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        spacing: 8,
        children: [
          Icon(LucideIcons.search, size: 14, color: c.mutedForeground),
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 13, color: c.foreground),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: c.mutedForeground),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tiny uppercase chip (`Badge variant="secondary"`).
class _Chip extends StatelessWidget {
  const _Chip(this.label, {this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color?.withValues(alpha: 0.15) ?? c.muted,
        border: Border.all(color: color?.withValues(alpha: 0.3) ?? c.border),
        borderRadius: AppRadii.borderSm,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          height: 1,
          fontWeight: FontWeight.w500,
          color: color ?? c.mutedForeground,
        ),
      ),
    );
  }
}

/* ── help ── */

class _HelpContent extends StatefulWidget {
  const _HelpContent({required this.data});

  final Map<String, dynamic> data;

  @override
  State<_HelpContent> createState() => _HelpContentState();
}

class _HelpContentState extends State<_HelpContent> {
  String _query = '';

  /// `FALLBACK_COMMANDS` — used when the payload carries no command list.
  static const _fallback = [
    (
      name: '/models',
      description: 'Browse available models for the active provider.',
    ),
    (name: '/cost', description: 'Review token usage for the active session.'),
    (
      name: '/status',
      description:
          'Inspect runtime, version, provider, and environment status.',
    ),
    (name: '/memory', description: 'Open the project CLAUDE.md memory file.'),
    (name: '/config', description: 'Open settings and configuration.'),
    (name: '/help', description: 'Show command documentation and syntax.'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final raw = widget.data['commands'];
    final commands = raw is List && raw.isNotEmpty
        ? [
            for (final e in raw)
              if (e is Map)
                (
                  name: '${e['name'] ?? ''}',
                  description: '${e['description'] ?? ''}',
                  namespace: '${e['namespace'] ?? 'builtin'}',
                ),
          ]
        : [
            for (final e in _fallback)
              (name: e.name, description: e.description, namespace: 'builtin'),
          ];
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? commands
        : [
            for (final cmd in commands)
              if ('${cmd.name} ${cmd.description} ${cmd.namespace}'
                  .toLowerCase()
                  .contains(q))
                cmd,
          ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _SearchField(
            hint: 'Filter commands...',
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final cmd in filtered)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: c.background.withValues(alpha: 0.6),
                          border: Border.all(
                            color: c.border.withValues(alpha: 0.7),
                          ),
                          borderRadius: AppRadii.borderLg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: c.primary.withValues(alpha: 0.1),
                                    border: Border.all(
                                      color: c.primary.withValues(alpha: 0.2),
                                    ),
                                    borderRadius: AppRadii.borderMd,
                                  ),
                                  child: Text(
                                    cmd.name,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: c.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _Chip(cmd.namespace),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                cmd.description.isEmpty
                                    ? 'No description available.'
                                    : cmd.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 18 / 12,
                                  color: c.mutedForeground,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              if (filtered.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: c.border,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: AppRadii.borderLg,
                  ),
                  child: Center(
                    child: Text(
                      'No commands match that filter.',
                      style: TextStyle(fontSize: 13, color: c.mutedForeground),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              // The web's `Syntax` aside, flattened under the list.
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.muted.withValues(alpha: 0.2),
                  border: Border.all(color: c.border.withValues(alpha: 0.7)),
                  borderRadius: AppRadii.borderLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      spacing: 6,
                      children: [
                        Icon(
                          LucideIcons.squareTerminal,
                          size: 14,
                          color: c.primary,
                        ),
                        Text(
                          'Syntax',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: c.foreground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final line in const [
                      '/command arg1 arg2',
                      '\$ARGUMENTS passes all args; \$1, \$2 positional.',
                      '@file includes file contents.',
                      '!command runs bash.',
                    ])
                      Text(
                        line,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          height: 20 / 12,
                          color: c.mutedForeground,
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

/* ── models ── */

class _ModelsContent extends ConsumerStatefulWidget {
  const _ModelsContent({required this.data, required this.arg});

  final Map<String, dynamic> data;
  final ComposerArg arg;

  @override
  ConsumerState<_ModelsContent> createState() => _ModelsContentState();
}

class _ModelsContentState extends ConsumerState<_ModelsContent> {
  String _query = '';
  String _tier = 'all';
  String? _selecting;
  String? _notice;

  String _id(Map<String, dynamic> m) => '${m['id'] ?? m['value']}';

  String _label(Map<String, dynamic> m) =>
      '${m['label'] ?? m['name'] ?? _id(m)}';

  /// `availableOptions` — the web prefers the live catalog over the payload
  /// (`liveDefinition.OPTIONS`); here `state.models` is that catalog.
  List<Map<String, dynamic>> _options(ComposerState state) {
    if (state.models.isNotEmpty) return state.models;
    final raw = widget.data['availableOptions'];
    if (raw is List && raw.isNotEmpty) {
      return [
        for (final m in raw)
          if (m is Map) Map<String, dynamic>.from(m),
      ];
    }
    final names = widget.data['availableModels'];
    return [
      for (final m in (names is List ? names : const []))
        {'value': '$m', 'label': '$m'},
    ];
  }

  Future<void> _select(String id) async {
    setState(() => _selecting = id);
    try {
      await ref.read(composerProvider(widget.arg).notifier).selectModel(id);
      if (mounted) setState(() => _notice = 'Model set to $id.');
    } on Object catch (e) {
      if (mounted) setState(() => _notice = '$e');
    } finally {
      if (mounted) setState(() => _selecting = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final state = ref.watch(composerProvider(widget.arg));
    final current = widget.data['current'] is Map
        ? widget.data['current'] as Map
        : const <String, dynamic>{};
    final provider = '${current['provider'] ?? widget.arg.provider}';
    final pLabel = '${current['providerLabel'] ?? _providerLabelOf(provider)}';
    final currentModel =
        state.activeModel ?? '${current['model'] ?? 'Unknown'}';
    final options = _options(state);
    final q = _query.trim().toLowerCase();
    final searched = q.isEmpty
        ? options
        : [
            for (final m in options)
              if ('${_label(m)} ${_id(m)} ${m['description'] ?? ''}'
                  .toLowerCase()
                  .contains(q))
                m,
          ];
    final shown = _tier == 'all'
        ? searched
        : [
            for (final m in searched)
              if (modelTierOf(m) == _tier) m,
          ];

    return Column(
      children: [
        // Active-model header + the web's `Manage models` button.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.2),
              border: Border.all(color: c.border.withValues(alpha: 0.7)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ACTIVE MODEL · ${pLabel.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: c.mutedForeground,
                        ),
                      ),
                      Text(
                        currentModel,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: c.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
                // Custom-model CRUD moved to Settings → Models (web parity —
                // the web repoints this button to the models settings tab).
                AppButton(
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.sm,
                  onPressed: () {
                    final router = GoRouter.of(context);
                    Navigator.of(context).pop();
                    router.go('/settings/models');
                  },
                  child: const Text('Manage models'),
                ),
              ],
            ),
          ),
        ),
        if (options.length > 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _TierPills(
              tier: _tier,
              onSelect: (t) => setState(() => _tier = t),
            ),
          ),
        if (options.length > 6)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _SearchField(
              hint: 'Search $pLabel models...',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        Expanded(
          child: shown.isEmpty
              ? Center(
                  child: Text(
                    'No models match that filter.',
                    style: TextStyle(fontSize: 13, color: c.mutedForeground),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [for (final m in shown) _modelTile(c, state, m)],
                ),
        ),
        // The web's quiet guidance/feedback line.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _notice ??
                  (widget.arg.sessionId?.isNotEmpty ?? false
                      ? 'Your choice is saved for this session and becomes the default for new chats.'
                      : 'Your choice becomes the default model for new chats.'),
              style: TextStyle(
                fontSize: 11,
                height: 16 / 11,
                color: _notice != null ? c.foreground : c.mutedForeground,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _modelTile(AppColors c, ComposerState state, Map<String, dynamic> m) {
    final id = _id(m);
    final label = _label(m);
    final isCurrent = id == state.activeModel;
    final isCustom = m['isCustom'] == true;
    final isFree = modelTierOf(m) == 'free';
    final busy = _selecting == id;
    final description = m['description']?.toString();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _selecting != null ? null : () => unawaited(_select(id)),
          borderRadius: AppRadii.borderLg,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCurrent
                  ? c.primary.withValues(alpha: 0.1)
                  : c.background.withValues(alpha: 0.6),
              border: Border.all(
                color: isCurrent
                    ? c.primary.withValues(alpha: 0.45)
                    : c.border.withValues(alpha: 0.7),
              ),
              borderRadius: AppRadii.borderLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: c.foreground,
                        ),
                      ),
                    ),
                    if (isFree) ...[
                      const _Chip('Free', color: Color(0xFF10B981)),
                      const SizedBox(width: 6),
                    ],
                    if (isCustom) ...[
                      const _Chip('Custom'),
                      const SizedBox(width: 6),
                    ],
                    if (busy)
                      SizedBox.square(
                        dimension: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: c.primary,
                        ),
                      )
                    else if (isCurrent)
                      Icon(LucideIcons.badgeCheck, size: 14, color: c.primary),
                  ],
                ),
                if (label != id)
                  Text(
                    id,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: c.mutedForeground,
                    ),
                  ),
                if (!isFree && description != null && description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        height: 18 / 12,
                        color: c.mutedForeground,
                      ),
                    ),
                  ),
                if (isCurrent)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'CURRENT SELECTION',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                        color: c.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `PillBar` — All/Free/Paid segmented filter (compact port).
class _TierPills extends StatelessWidget {
  const _TierPills({required this.tier, required this.onSelect});

  final String tier;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    Widget pill(String t, String label) {
      final active = tier == t;
      return GestureDetector(
        onTap: () => onSelect(t),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: active ? c.background : Colors.transparent,
            borderRadius: AppRadii.borderMd,
            border: active
                ? Border.all(color: c.border.withValues(alpha: 0.5))
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: active ? c.foreground : c.mutedForeground,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: c.muted.withValues(alpha: 0.6),
          borderRadius: AppRadii.borderLg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [
            pill('all', 'All'),
            pill('free', 'Free'),
            pill('paid', 'Paid'),
          ],
        ),
      ),
    );
  }
}

/* ── cost ── */

class _CostContent extends StatelessWidget {
  const _CostContent({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final usage = data['tokenUsage'] is Map
        ? data['tokenUsage'] as Map
        : const <String, dynamic>{};
    final breakdown = data['tokenBreakdown'] is Map
        ? data['tokenBreakdown'] as Map
        : null;
    final used = _numOf(usage['used']);
    final total = _numOf(usage['total']);
    final hasBreakdown =
        breakdown?['input'] is num || breakdown?['output'] is num;
    final cacheRead = _numOf(breakdown?['cacheRead']);
    final cacheCreation = _numOf(breakdown?['cacheCreation']);
    // Prefer the provider-reported amount when available; otherwise estimate.
    final reportedCost = _numOf(data['costUsd']);
    final estimated = reportedCost > 0
        ? reportedCost
        : estimateCostUsd(
            model: data['model']?.toString(),
            input: _numOf(breakdown?['input']),
            output: _numOf(breakdown?['output']),
            cacheRead: cacheRead,
            cacheCreation: cacheCreation,
          );
    final unsupported = data['unsupported'] == true;

    final rows = <(String, String)>[
      ('Total tokens used', _fmtNum(used)),
      if (hasBreakdown) ...[
        ('Input tokens', _fmtNum(_numOf(breakdown?['input']))),
        if (cacheRead > 0) ('Cache read tokens', _fmtNum(cacheRead)),
        if (cacheCreation > 0) ('Cache write tokens', _fmtNum(cacheCreation)),
        ('Output tokens', _fmtNum(_numOf(breakdown?['output']))),
      ] else
        ('Breakdown', 'Unavailable'),
      if (total > 0) ('Context window', _fmtNum(total)),
      if (estimated != null)
        (
          reportedCost > 0 ? 'Cost' : 'Estimated cost',
          formatCostUsd(estimated),
        ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (unsupported && data['message'] != null)
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
              ),
              borderRadius: AppRadii.borderLg,
            ),
            child: Text(
              '${data['message']}',
              style: TextStyle(fontSize: 13, color: c.foreground),
            ),
          ),
        if (!unsupported)
          Container(
            decoration: BoxDecoration(
              color: c.background.withValues(alpha: 0.6),
              border: Border.all(color: c.border.withValues(alpha: 0.7)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < rows.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: i < rows.length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: c.border.withValues(alpha: 0.6),
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rows[i].$1,
                          style: TextStyle(fontSize: 13, color: c.foreground),
                        ),
                        Text(
                          rows[i].$2,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: c.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        // Provider/model footer card (web's `muted/20` grid).
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: c.muted.withValues(alpha: 0.2),
            border: Border.all(color: c.border.withValues(alpha: 0.7)),
            borderRadius: AppRadii.borderLg,
          ),
          child: Row(
            children: [
              for (final (label, value, mono) in [
                (
                  'PROVIDER',
                  _providerLabelOf(data['provider']?.toString()),
                  false,
                ),
                ('MODEL', '${data['model'] ?? 'Unknown'}', true),
              ])
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: c.mutedForeground,
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontFamily: mono ? 'monospace' : null,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: c.foreground,
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

/* ── status ── */

class _StatusContent extends StatelessWidget {
  const _StatusContent({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    const emerald = Color(0xFF10B981);
    final memory = data['memoryUsage'] is Map
        ? data['memoryUsage'] as Map
        : const <String, dynamic>{};
    final rssMb = memory['rssMb'];
    final rows = <(String, String, IconData)>[
      ('Package', '${data['packageName'] ?? 'ddagent'}', LucideIcons.package),
      ('Version', '${data['version'] ?? 'Unknown'}', LucideIcons.badgeCheck),
      ('Uptime', '${data['uptime'] ?? 'Unknown'}', LucideIcons.timer),
      (
        'Provider',
        _providerLabelOf(data['provider']?.toString()),
        LucideIcons.server,
      ),
      ('Model', '${data['model'] ?? 'Unknown'}', LucideIcons.cpu),
      (
        'Node.js',
        '${data['nodeVersion'] ?? 'Unknown'}',
        LucideIcons.squareTerminal,
      ),
      ('Platform', '${data['platform'] ?? 'Unknown'}', LucideIcons.activity),
      (
        'Memory',
        rssMb is num ? '${rssMb.round()} MB RSS' : 'Unknown',
        LucideIcons.gauge,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // `Runtime online` banner — emerald tint + Healthy chip.
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: emerald.withValues(alpha: 0.1),
            border: Border.all(color: emerald.withValues(alpha: 0.25)),
            borderRadius: AppRadii.borderLg,
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: emerald,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Runtime online',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: c.foreground,
                      ),
                    ),
                    Text(
                      'Process ${data['pid'] != null ? '#${data['pid']}' : 'status'} is responding.',
                      style: TextStyle(fontSize: 11, color: c.mutedForeground),
                    ),
                  ],
                ),
              ),
              const _Chip('Healthy', color: emerald),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (label, value, icon) in rows)
              SizedBox(
                width: 150,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.background.withValues(alpha: 0.6),
                    border: Border.all(color: c.border.withValues(alpha: 0.7)),
                    borderRadius: AppRadii.borderLg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: c.primary.withValues(alpha: 0.1),
                          border: Border.all(
                            color: c.primary.withValues(alpha: 0.35),
                          ),
                          borderRadius: AppRadii.borderMd,
                        ),
                        child: Icon(icon, size: 13, color: c.primary),
                      ),
                      Text(
                        label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: c.mutedForeground,
                        ),
                      ),
                      Text(
                        value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: c.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Unknown builtin actions — the payload may still carry a `message`.
class _FallbackContent extends StatelessWidget {
  const _FallbackContent({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        '${data['message'] ?? 'Command finished.'}',
        style: TextStyle(fontSize: 13, color: c.foreground),
      ),
    );
  }
}
