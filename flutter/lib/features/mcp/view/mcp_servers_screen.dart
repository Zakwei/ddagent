import 'dart:async';

import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_badge.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/mcp/data/mcp_constants.dart';
import 'package:ddagent_app/features/mcp/data/mcp_formatting.dart';
import 'package:ddagent_app/features/mcp/data/mcp_models.dart';
import 'package:ddagent_app/features/mcp/state/mcp_servers_controller.dart';
import 'package:ddagent_app/features/mcp/view/mcp_server_form_dialog.dart';
import 'package:ddagent_app/features/mcp/view/mcp_tokens_card.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Standalone MCP servers screen — provider pills on top (Agents-section
/// selector parity), then [McpServersPane] + [McpTokensCard]. Exposed as a
/// public widget so a route (`/mcp`) or any caller can mount it.
class McpServersScreen extends ConsumerStatefulWidget {
  const McpServersScreen({super.key, this.initialProvider});

  /// Provider shown first — defaults to the first of [kMcpProviders].
  final String? initialProvider;

  @override
  ConsumerState<McpServersScreen> createState() => _McpServersScreenState();
}

class _McpServersScreenState extends ConsumerState<McpServersScreen> {
  late String _provider = widget.initialProvider ?? kMcpProviders.first;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SubpageHeader(icon: LucideIcons.server, title: t.settings.mcpServers.title),
            // Provider selector — same pill row the Agents settings tab uses.
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.border)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final provider in kMcpProviders)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: _ProviderPill(
                          provider: provider,
                          selected: _provider == provider,
                          onTap: () => setState(() => _provider = provider),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [McpServersPane(provider: _provider, includeTokens: true)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider pill — compact variant of the Agents-tab `_AgentPill`.
class _ProviderPill extends StatelessWidget {
  const _ProviderPill({required this.provider, required this.selected, required this.onTap});

  final String provider;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: AppRadii.borderMd,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.base,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? c.background : Colors.transparent,
          borderRadius: AppRadii.borderMd,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProviderLogo(provider: provider, size: 16),
            const SizedBox(width: AppSpacing.sm),
            Text(
              mcpProviderName(provider),
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: selected ? c.foreground : c.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Per-provider MCP server list — port of `McpServers.tsx`. Embeddable body
/// (no Scaffold): the settings Agents tab mounts it inside its category
/// `ListView`, the standalone screen wraps it itself.
class McpServersPane extends ConsumerWidget {
  const McpServersPane({super.key, required this.provider, this.includeTokens = false});

  /// Provider id — `claude`, `cursor`, `codex`, `opencode`, `commandcode`, `antigravity` or `devin`.
  final String provider;

  /// Appends [McpTokensCard] below the list — the web renders
  /// `<McpServers/><McpServerTokens/>` together in the mcp category tab.
  final bool includeTokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final state = ref.watch(mcpServersProvider(provider));
    final providerName = mcpProviderName(provider);
    final providerLabel = 'Add $providerName MCP Server';
    final error = state.deleteError ?? state.loadError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header — server icon + title/description + split add menu.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                LucideIcons.server,
                size: 20,
                color: Color(0xFFA855F7), // web `text-purple-500`
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.settings.mcpServers.title, style: tt.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _providerDescription(t, provider),
                    style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _AddServerMenu(
              providerName: providerName,
              onGlobal: () => unawaited(_openGlobalForm(context, ref)),
              onProvider: () => unawaited(_openForm(context, ref)),
            ),
          ],
        ),

        // Status line — project scopes still streaming in.
        SizedBox(
          height: AppSpacing.lg,
          child: state.isLoadingProjectScopes
              ? Text(
                  'Refreshing project scopes...',
                  style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                )
              : null,
        ),

        // Load/delete error box.
        if (error != null)
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: c.destructive.withValues(alpha: 0.08),
              border: Border.all(color: c.destructive.withValues(alpha: 0.4)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Text(error, style: tt.bodySmall?.copyWith(color: c.destructive)),
          ),

        // Server list.
        if (state.isLoading && state.servers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Center(
              child: Text(
                'Loading MCP servers...',
                style: tt.bodyMedium?.copyWith(color: c.mutedForeground),
              ),
            ),
          ),
        for (final server in state.servers)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _McpServerCard(
              server: server,
              onEdit: server.isManaged
                  ? null
                  : () => unawaited(_openForm(context, ref, editing: server)),
              onDelete: server.isManaged
                  ? null
                  : () => unawaited(_confirmDelete(context, ref, server)),
            ),
          ),
        if (!state.isLoading && !state.isLoadingProjectScopes && state.servers.isEmpty)
          _EmptyState(onAdd: () => unawaited(_openForm(context, ref)), label: providerLabel),

        // Codex help card (`selectedProvider === 'codex'` block).
        if (provider == 'codex')
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.5),
              border: Border.all(color: c.border),
              borderRadius: AppRadii.borderLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.settings.mcpServers.help.title,
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  t.settings.mcpServers.help.description,
                  style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                ),
              ],
            ),
          ),

        // Team upsell — claude only, and not on platform builds
        // (`!IS_PLATFORM`).
        if (provider == 'claude' && !Env.embedded) const _TeamMcpCard(),

        if (includeTokens) const McpTokensCard(),
      ],
    );
  }

  /// `t('mcpServers.description.<provider>')` with the web default fallback.
  static String _providerDescription(Translations t, String provider) => switch (provider) {
    'claude' => t.settings.mcpServers.description.claude,
    'cursor' => t.settings.mcpServers.description.cursor,
    'codex' => t.settings.mcpServers.description.codex,
    'opencode' => t.settings.mcpServers.description.opencode,
    'devin' => t.settings.mcpServers.description.devin,
    _ =>
      'Model Context Protocol servers provide additional tools and data '
          'sources to ${mcpProviderName(provider)}',
  };

  Future<void> _openForm(BuildContext context, WidgetRef ref, {McpServer? editing}) async {
    final providerName = mcpProviderName(provider);
    final label = 'Add $providerName MCP Server';
    final saved = await McpServerFormDialog.show(
      context,
      provider: provider,
      editing: editing,
      title: editing == null ? label : null,
      submitLabel: label,
      onSubmit: (payload) =>
          ref.read(mcpServersProvider(provider).notifier).submit(payload, editing: editing),
    );
    if (saved && context.mounted) {
      AppToast.show(context, Translations.of(context).settings.saveStatus.success);
    }
  }

  Future<void> _openGlobalForm(BuildContext context, WidgetRef ref) async {
    const label = 'Add Global MCP Server';
    final saved = await McpServerFormDialog.show(
      context,
      provider: provider,
      global: true,
      title: label,
      description:
          'Adds this MCP server to every provider: Claude, Cursor, Codex, '
          'OpenCode, and Devin. Only stdio and HTTP transports are supported '
          'because the same config must work across all providers.',
      submitLabel: label,
      supportedScopes: kMcpGlobalScopes,
      supportedTransports: kMcpGlobalTransports,
      onSubmit: (payload) => ref.read(mcpServersProvider(provider).notifier).submitGlobal(payload),
    );
    if (saved && context.mounted) {
      AppToast.show(context, Translations.of(context).settings.saveStatus.success);
    }
  }

  /// `pendingDeleteServer` dialog — deleting rewrites provider config files,
  /// so it requires confirmation (`AppDialog.confirm`-shaped, destructive).
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, McpServer server) async {
    final t = Translations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: t.settings.mcpServers.deleteConfirm.title,
        content: Text(t.settings.mcpServers.deleteConfirm.description(serverName: server.name)),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.settings.mcpForm.actions.cancel),
          ),
          AppButton(
            variant: AppButtonVariant.destructive,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.settings.mcpServers.actions.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(mcpServersProvider(provider).notifier).delete(server);
    if (!context.mounted) return;
    // Inline `saveStatus` line on the web → toast here (login-flow parity).
    if (ref.read(mcpServersProvider(provider)).deleteError == null) {
      AppToast.show(context, t.settings.saveStatus.success);
    }
  }
}

/// "Add MCP Server" split button — global vs provider-only
/// (`ActionMenu` with two described items in the web).
class _AddServerMenu extends StatelessWidget {
  const _AddServerMenu({required this.providerName, this.onGlobal, this.onProvider});

  final String providerName;
  final VoidCallback? onGlobal;
  final VoidCallback? onProvider;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return MenuAnchor(
      builder: (context, controller, _) => AppButton(
        size: AppButtonSize.sm,
        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.plus, size: 14),
            const SizedBox(width: AppSpacing.xs),
            Text(t.settings.mcpServers.addButton),
            const SizedBox(width: AppSpacing.xs),
            const Icon(LucideIcons.chevronDown, size: 14),
          ],
        ),
      ),
      menuChildren: [
        _menuEntry(
          context,
          icon: LucideIcons.globe,
          label: 'Add Global MCP Server',
          description:
              'Add Global MCP Server writes one common stdio or HTTP server '
              'to Claude, Cursor, Codex, OpenCode, and Devin.',
          onTap: onGlobal,
        ),
        _menuEntry(
          context,
          icon: LucideIcons.server,
          label: 'Add $providerName MCP Server',
          description: 'Add $providerName MCP Server only changes $providerName.',
          onTap: onProvider,
        ),
      ],
    );
  }

  static MenuItemButton _menuEntry(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    VoidCallback? onTap,
  }) {
    final tt = Theme.of(context).textTheme;
    final c = context.appColors;
    return MenuItemButton(
      onPressed: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14),
                const SizedBox(width: AppSpacing.sm),
                Flexible(child: Text(label, style: tt.bodyMedium)),
              ],
            ),
            const SizedBox(height: 2),
            Text(description, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
          ],
        ),
      ),
    );
  }
}

/// One server row — transport icon, name, scope/transport/project badges,
/// config lines (masked env), edit/delete actions. `ddagent-*` managed rows
/// are read-only.
class _McpServerCard extends StatelessWidget {
  const _McpServerCard({required this.server, this.onEdit, this.onDelete});

  final McpServer server;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  static IconData _transportIcon(McpTransport transport) => switch (transport) {
    McpTransport.stdio => LucideIcons.terminal,
    McpTransport.sse => LucideIcons.zap,
    McpTransport.http => LucideIcons.globe,
  };

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final managed = server.isManaged;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.5),
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (!managed)
                      Icon(_transportIcon(server.transport), size: 16, color: c.mutedForeground),
                    Text(server.name, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    if (!managed) ...[
                      AppBadge(label: server.transport.wire),
                      AppBadge(label: server.scope.wire),
                      if (server.projectDisplayName != null)
                        AppBadge(label: server.projectDisplayName!),
                    ] else
                      // Lock-glyph badge — `AppBadge` has no icon slot, so
                      // this is a small custom chip on the same colors.
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                        decoration: BoxDecoration(color: c.muted, borderRadius: AppRadii.borderSm),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.lock, size: 12, color: c.mutedForeground),
                            const SizedBox(width: 4),
                            Text(
                              t.settings.mcpServers.managed.badge,
                              style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (!managed) ...[
                  _ConfigLine(label: t.settings.mcpServers.config.command, value: server.command),
                  _ConfigLine(label: t.settings.mcpServers.config.url, value: server.url),
                  _ConfigLine(
                    label: t.settings.mcpServers.config.args,
                    value: server.args.join(' '),
                  ),
                  _ConfigLine(label: 'Cwd', value: server.cwd),
                  if (server.env.isNotEmpty)
                    _ConfigLine(
                      label: t.settings.mcpServers.config.environment,
                      value: server.env.entries
                          .map((e) => '${e.key}=${maskSecret(e.value)}')
                          .join(', '),
                    ),
                  if (server.envVars.isNotEmpty)
                    _ConfigLine(label: 'Env Vars', value: server.envVars.join(', ')),
                ] else
                  Text(
                    t.settings.mcpServers.managed.hint,
                    style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
              ],
            ),
          ),
          if (!managed) ...[
            const SizedBox(width: AppSpacing.lg),
            IconButton(
              onPressed: onEdit,
              tooltip: t.settings.mcpServers.actions.edit,
              icon: const Icon(LucideIcons.edit3, size: 16),
              visualDensity: VisualDensity.compact,
              color: c.mutedForeground,
            ),
            IconButton(
              onPressed: onDelete,
              tooltip: t.settings.mcpServers.actions.delete,
              icon: Icon(LucideIcons.trash2, size: 16, color: c.destructive),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }
}

/// `ConfigLine` — `Label: <code>value</code>` muted row, hidden when empty.
class _ConfigLine extends StatelessWidget {
  const _ConfigLine({required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('$label:', style: tt.bodySmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(color: c.muted, borderRadius: AppRadii.borderSm),
            child: Text(value!, style: tt.bodySmall?.copyWith(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }
}

/// Empty state — icon + `mcpServers.empty` + add button.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd, required this.label});

  final VoidCallback onAdd;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          Icon(LucideIcons.server, size: 28, color: c.mutedForeground),
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.settings.mcpServers.empty,
            style: tt.bodyMedium?.copyWith(color: c.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            size: AppButtonSize.sm,
            variant: AppButtonVariant.outline,
            onPressed: onAdd,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.plus, size: 14),
                const SizedBox(width: AppSpacing.xs),
                Text(label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `TeamMcpFeatureCard` — ddagent Pro upsell shown under the claude tab.
class _TeamMcpCard extends StatelessWidget {
  const _TeamMcpCard();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg + 4),
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.2),
        border: Border.all(color: c.border.withValues(alpha: 0.6), style: BorderStyle.solid),
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.6),
              borderRadius: AppRadii.borderLg,
            ),
            child: Icon(LucideIcons.users, size: 20, color: c.mutedForeground),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Team MCP Configs',
                        style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      LucideIcons.lock,
                      size: 12,
                      color: c.mutedForeground.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Share MCP server configurations across your team. '
                  'Everyone stays in sync automatically.',
                  style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                ),
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: () => unawaited(launchUrl(Uri.parse('https://github.com/Zakwei/ddagent'))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Available with ddagent Pro',
                        style: tt.bodySmall?.copyWith(
                          color: c.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Icon(LucideIcons.externalLink, size: 12, color: c.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
