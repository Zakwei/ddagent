import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_badge.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/mcp/state/mcp_tokens_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// `McpServerTokens.tsx` — bearer tokens for ddagent's own MCP endpoint
/// (`POST /mcp`), how external tools like Claude Desktop or OpenClaw call the
/// ddagent tools. Plaintext shows exactly once, right after creation.
class McpTokensCard extends ConsumerStatefulWidget {
  const McpTokensCard({super.key});

  @override
  ConsumerState<McpTokensCard> createState() => _McpTokensCardState();
}

class _McpTokensCardState extends ConsumerState<McpTokensCard> {
  final _labelCtrl = TextEditingController();
  String _scope = 'read';

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final error = await ref.read(mcpTokensProvider.notifier).create(_labelCtrl.text, _scope);
    if (error == null && mounted) _labelCtrl.clear();
  }

  String _lastUsed(Translations t, String? lastUsedAt) {
    final parsed = lastUsedAt == null ? null : DateTime.tryParse(lastUsedAt);
    if (parsed == null) return t.settings.mcpTokens.neverUsed;
    final local = MaterialLocalizations.of(context);
    return t.settings.mcpTokens.lastUsed(time: local.formatShortDate(parsed.toLocal()));
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final tokensT = t.settings.mcpTokens;
    final state = ref.watch(mcpTokensProvider);

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xl), // web `mt-6`
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.keyRound, size: 16, color: c.mutedForeground),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  tokensT.title,
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(tokensT.description, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
          const SizedBox(height: AppSpacing.md),

          // One-shot plaintext banner (`freshToken`).
          if (state.freshToken != null)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.05),
                border: Border.all(color: c.primary.withValues(alpha: 0.4)),
                borderRadius: AppRadii.borderMd,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.freshToken!,
                      overflow: TextOverflow.ellipsis,
                      style: tt.bodySmall?.copyWith(fontFamily: 'monospace'),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        unawaited(Clipboard.setData(ClipboardData(text: state.freshToken!))),
                    icon: const Icon(LucideIcons.copy, size: 14),
                    visualDensity: VisualDensity.compact,
                  ),
                  AppButton(
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.sm,
                    onPressed: () => ref.read(mcpTokensProvider.notifier).dismissFreshToken(),
                    child: Text(tokensT.dismiss),
                  ),
                ],
              ),
            ),

          // Create row — label input + scope select + create button.
          Row(
            children: [
              Expanded(
                child: AppInput(
                  controller: _labelCtrl,
                  hint: tokensT.labelPlaceholder,
                  onSubmitted: (_) => unawaited(_create()),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              DropdownButton<String>(
                value: _scope,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(value: 'read', child: Text('read')),
                  DropdownMenuItem(value: 'write', child: Text('write')),
                ],
                onChanged: (v) => setState(() => _scope = v ?? 'read'),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                size: AppButtonSize.sm,
                loading: state.busy,
                onPressed: () => unawaited(_create()),
                child: Text(tokensT.create),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(state.error!, style: tt.bodySmall?.copyWith(color: c.destructive)),
            ),

          // Token list.
          if (state.tokens.isEmpty)
            Text(tokensT.empty, style: tt.bodySmall?.copyWith(color: c.mutedForeground))
          else
            for (final token in state.tokens)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        token.label,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodyMedium,
                      ),
                    ),
                    AppBadge(label: token.scope, variant: AppBadgeVariant.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      _lastUsed(t, token.lastUsedAt),
                      style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                    ),
                    IconButton(
                      onPressed: () =>
                          unawaited(ref.read(mcpTokensProvider.notifier).revoke(token.id)),
                      icon: const Icon(LucideIcons.trash2, size: 14),
                      tooltip: t.settings.mcpServers.actions.delete,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
