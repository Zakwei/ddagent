import 'dart:async';
import 'dart:math' as math;

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/chat/view/composer_model_menu.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
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
  const CommandResultDialog({required this.result, required this.arg, super.key});

  final CommandExecutionResult result;
  final ComposerArg arg;

  /// Web `modalMeta` — (icon, eyebrow, title, subtitle) per payload kind.
  static (IconData, String, String, String)? _metaFor(Translations t, String action) {
    final d = t.chat.commandDialog;
    return switch (action) {
      'help' => (LucideIcons.circleHelp, d.help.eyebrow, d.help.title, d.help.subtitle),
      'models' => (LucideIcons.cpu, d.models.eyebrow, d.models.title, d.models.subtitle),
      'cost' => (LucideIcons.coins, d.cost.eyebrow, d.cost.title, d.cost.subtitle),
      'status' => (LucideIcons.activity, d.status.eyebrow, d.status.title, d.status.subtitle),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context);
    final action = result.action ?? '';
    final meta = _metaFor(t, action);
    final height = MediaQuery.sizeOf(context).height;
    return Dialog(
      backgroundColor: c.popover,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 640, maxHeight: math.min(height - 48, 560)),
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
                    child: Icon(meta?.$1 ?? LucideIcons.sparkles, size: 16, color: c.foreground),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          (meta?.$2 ?? t.chat.commandDialog.defaultEyebrow).toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: c.mutedForeground,
                          ),
                        ),
                        Text(
                          meta?.$3 ?? t.chat.commandDialog.defaultTitle,
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
                    tooltip: t.chat.common.close,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(LucideIcons.x, size: 16, color: c.mutedForeground),
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
                      t.chat.commandDialog.escHint,
                      style: TextStyle(fontSize: 11, color: c.mutedForeground),
                    ),
                  ),
                  AppButton(
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.sm,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(t.chat.common.close),
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
String _providerLabelOf(String? provider, [String? fallback]) {
  if (provider == null || provider.isEmpty) return fallback ?? t.chat.commandDialog.unknown;
  const known = {
    'claude',
    'cursor',
    'codex',
    'opencode',
    'commandcode',
    'antigravity',
    'devin',
    'orchestrator',
    'mini-orchestrator',
  };
  return known.contains(provider) ? providerLabel(provider) : provider;
}

double _numOf(dynamic v) => v is num ? v.toDouble() : (double.tryParse('$v') ?? 0);

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
  /// Built from the global translations accessor: this is static data with no
  /// `BuildContext` to resolve — the entries are rendered by `build` below.
  static List<({String name, String description})> get _fallback => [
    (name: '/models', description: t.chat.commandResult.fallback.models),
    (name: '/cost', description: t.chat.commandResult.fallback.cost),
    (name: '/status', description: t.chat.commandResult.fallback.status),
    (name: '/memory', description: t.chat.commandResult.fallback.memory),
    (name: '/config', description: t.chat.commandResult.fallback.config),
    (name: '/help', description: t.chat.commandResult.fallback.help),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
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
              if ('${cmd.name} ${cmd.description} ${cmd.namespace}'.toLowerCase().contains(q)) cmd,
          ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _SearchField(
            hint: t.chat.commandResult.filterCommands,
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
                          border: Border.all(color: c.border.withValues(alpha: 0.7)),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: c.primary.withValues(alpha: 0.1),
                                    border: Border.all(color: c.primary.withValues(alpha: 0.2)),
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
                                    ? t.chat.commandDialog.noDescription
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
                    border: Border.all(color: c.border, style: BorderStyle.solid),
                    borderRadius: AppRadii.borderLg,
                  ),
                  child: Center(
                    child: Text(
                      t.chat.commandDialog.noCommandsMatch,
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
                        Icon(LucideIcons.squareTerminal, size: 14, color: c.primary),
                        Text(
                          t.chat.commandDialog.syntax.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: c.foreground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final line in [
                      '/command arg1 arg2',
                      t.chat.commandDialog.syntax.arguments(
                        arguments: '\$ARGUMENTS',
                        first: '\$1',
                        second: '\$2',
                      ),
                      t.chat.commandDialog.syntax.file(token: '@file'),
                      t.chat.commandDialog.syntax.bash(token: '!command'),
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

  String _label(Map<String, dynamic> m) => '${m['label'] ?? m['name'] ?? _id(m)}';

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
      for (final m in (names is List ? names : const [])) {'value': '$m', 'label': '$m'},
    ];
  }

  Future<void> _select(String id) async {
    final t = Translations.of(context);
    setState(() => _selecting = id);
    try {
      await ref.read(composerProvider(widget.arg).notifier).selectModel(id);
      if (mounted) setState(() => _notice = t.chat.commandDialog.models.modelSetTo(model: id));
    } on Object catch (e) {
      if (mounted) setState(() => _notice = '$e');
    } finally {
      if (mounted) setState(() => _selecting = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context);
    final state = ref.watch(composerProvider(widget.arg));
    final current = widget.data['current'] is Map
        ? widget.data['current'] as Map
        : const <String, dynamic>{};
    final provider = '${current['provider'] ?? widget.arg.provider}';
    final pLabel = '${current['providerLabel'] ?? _providerLabelOf(provider)}';
    final currentModel = state.activeModel ?? '${current['model'] ?? t.chat.commandDialog.unknown}';
    final options = _options(state);
    final q = _query.trim().toLowerCase();
    final searched = q.isEmpty
        ? options
        : [
            for (final m in options)
              if ('${_label(m)} ${_id(m)} ${m['description'] ?? ''}'.toLowerCase().contains(q)) m,
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
                        '${t.chat.commandDialog.models.activeModel.toUpperCase()} · ${pLabel.toUpperCase()}',
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
                // Custom-model CRUD lives in Agents → Models, scoped to the
                // active provider (the web repoints this button to the models
                // settings tab).
                AppButton(
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.sm,
                  onPressed: () {
                    final router = GoRouter.of(context);
                    Navigator.of(context).pop();
                    router.go('/settings/agents?agent=$provider&category=models');
                  },
                  child: Text(t.chat.providerSelection.manageModels),
                ),
              ],
            ),
          ),
        ),
        if (options.length > 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _TierPills(tier: _tier, onSelect: (t) => setState(() => _tier = t)),
          ),
        if (options.length > 6)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _SearchField(
              hint: t.chat.commandResult.searchModels(provider: pLabel),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        Expanded(
          child: shown.isEmpty
              ? Center(
                  child: Text(
                    t.chat.commandDialog.models.noModelsMatch,
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
                      ? t.chat.commandDialog.models.choiceSavedForSession
                      : t.chat.commandDialog.models.choiceDefault),
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
    final t = Translations.of(context);
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
                      _Chip(t.chat.providerSelection.free, color: const Color(0xFF10B981)),
                      const SizedBox(width: 6),
                    ],
                    if (isCustom) ...[
                      _Chip(t.chat.commandDialog.models.custom),
                      const SizedBox(width: 6),
                    ],
                    if (busy)
                      SizedBox.square(
                        dimension: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: c.primary),
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
                      style: TextStyle(fontSize: 12, height: 18 / 12, color: c.mutedForeground),
                    ),
                  ),
                if (isCurrent)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      t.chat.commandDialog.models.currentSelection.toUpperCase(),
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
    final i18n = Translations.of(context).chat.providerSelection;
    Widget pill(String t, String label) {
      final active = tier == t;
      return GestureDetector(
        onTap: () => onSelect(t),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: active ? c.background : Colors.transparent,
            borderRadius: AppRadii.borderMd,
            border: active ? Border.all(color: c.border.withValues(alpha: 0.5)) : null,
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
          children: [pill('all', i18n.all), pill('free', i18n.free), pill('paid', i18n.paid)],
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
    final t = Translations.of(context);
    final d = t.chat.commandDialog;
    final usage = data['tokenUsage'] is Map ? data['tokenUsage'] as Map : const <String, dynamic>{};
    final breakdown = data['tokenBreakdown'] is Map ? data['tokenBreakdown'] as Map : null;
    final used = _numOf(usage['used']);
    final total = _numOf(usage['total']);
    final hasBreakdown = breakdown?['input'] is num || breakdown?['output'] is num;
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
      (d.cost.totalTokensUsed, _fmtNum(used)),
      if (hasBreakdown) ...[
        (d.cost.inputTokens, _fmtNum(_numOf(breakdown?['input']))),
        if (cacheRead > 0) (d.cost.cacheReadTokens, _fmtNum(cacheRead)),
        if (cacheCreation > 0) (d.cost.cacheWriteTokens, _fmtNum(cacheCreation)),
        (d.cost.outputTokens, _fmtNum(_numOf(breakdown?['output']))),
      ] else
        (d.cost.breakdown, d.cost.unavailable),
      if (total > 0) (d.cost.contextWindow, _fmtNum(total)),
      if (estimated != null)
        (
          reportedCost > 0 ? t.common.quota.metric.cost : d.cost.estimatedCost,
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
              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Text('${data['message']}', style: TextStyle(fontSize: 13, color: c.foreground)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: i < rows.length - 1
                          ? Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.6)))
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rows[i].$1, style: TextStyle(fontSize: 13, color: c.foreground)),
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
                  t.common.commandPalette.compare.provider.toUpperCase(),
                  _providerLabelOf(data['provider']?.toString(), d.unknown),
                  false,
                ),
                (
                  t.common.commandPalette.compare.model.toUpperCase(),
                  '${data['model'] ?? d.unknown}',
                  true,
                ),
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
    final t = Translations.of(context);
    final d = t.chat.commandDialog;
    final unknown = d.unknown;
    const emerald = Color(0xFF10B981);
    final memory = data['memoryUsage'] is Map
        ? data['memoryUsage'] as Map
        : const <String, dynamic>{};
    final rssMb = memory['rssMb'];
    final rows = <(String, String, IconData)>[
      (d.status.package, '${data['packageName'] ?? 'ddagent'}', LucideIcons.package),
      (t.common.common.version, '${data['version'] ?? unknown}', LucideIcons.badgeCheck),
      (d.status.uptime, '${data['uptime'] ?? unknown}', LucideIcons.timer),
      (
        t.common.commandPalette.compare.provider,
        _providerLabelOf(data['provider']?.toString(), unknown),
        LucideIcons.server,
      ),
      (t.common.commandPalette.compare.model, '${data['model'] ?? unknown}', LucideIcons.cpu),
      ('Node.js', '${data['nodeVersion'] ?? unknown}', LucideIcons.squareTerminal),
      (d.status.platform, '${data['platform'] ?? unknown}', LucideIcons.activity),
      (
        d.status.memory,
        rssMb is num ? d.status.memoryRss(mb: rssMb.round()) : unknown,
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
                decoration: const BoxDecoration(color: emerald, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      d.status.runtimeOnline,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: c.foreground,
                      ),
                    ),
                    Text(
                      data['pid'] != null
                          ? d.status.processResponding(pid: '${data['pid']}')
                          : d.status.processStatusResponding,
                      style: TextStyle(fontSize: 11, color: c.mutedForeground),
                    ),
                  ],
                ),
              ),
              _Chip(d.status.healthy, color: emerald),
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
                          border: Border.all(color: c.primary.withValues(alpha: 0.35)),
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
        '${data['message'] ?? Translations.of(context).chat.commandDialog.commandFinished}',
        style: TextStyle(fontSize: 13, color: c.foreground),
      ),
    );
  }
}
