import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/mcp/data/mcp_constants.dart';
import 'package:ddagent_app/features/mcp/data/mcp_models.dart';
import 'package:ddagent_app/features/mcp/data/mcp_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// "Install ddagent MCP server" card — lets the user install ddagent's MCP
/// endpoint (pointing at `/mcp` with a bearer token) into one, several or all
/// agent CLIs, so their tools gain the `knowledge_*` group.
///
/// Used on the standalone MCP screen (no [defaultProviders] = every agent) and
/// inside Settings → Agents → MCP (pre-selects the current agent).
class DdagentMcpInstallCard extends ConsumerStatefulWidget {
  const DdagentMcpInstallCard({super.key, this.defaultProviders});

  /// Providers pre-selected when the dialog opens; null/empty = every agent.
  final List<String>? defaultProviders;

  @override
  ConsumerState<DdagentMcpInstallCard> createState() => _DdagentMcpInstallCardState();
}

class _DdagentMcpInstallCardState extends ConsumerState<DdagentMcpInstallCard> {
  Future<void> _openDialog() async {
    final preset = widget.defaultProviders?.where((p) => kMcpProviders.contains(p)).toList();
    final selected = <String>{...(preset?.isNotEmpty == true ? preset! : kMcpProviders)};
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Install ddagent MCP server'),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lets the selected agents use the ddagent knowledge base and tools over MCP.',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final provider in kMcpProviders)
                      FilterChip(
                        label: Text(mcpProviderName(provider)),
                        selected: selected.contains(provider),
                        onSelected: (value) => setState(() {
                          if (value) {
                            selected.add(provider);
                          } else {
                            selected.remove(provider);
                          }
                        }),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () => _install(ctx, providers: selected.toList()),
              child: const Text('Install selected'),
            ),
            FilledButton(
              onPressed: () => _install(ctx, providers: null),
              child: const Text('Install for all'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _install(BuildContext dialogContext, {required List<String>? providers}) async {
    var results = const <GlobalMcpResult>[];
    Object? failure;
    try {
      results = await ref.read(mcpRepositoryProvider).installDdagent(providers: providers);
    } on Object catch (error) {
      failure = error;
    }
    if (dialogContext.mounted) Navigator.of(dialogContext).pop();
    if (!mounted) return;
    if (failure != null) {
      AppToast.show(context, 'Install failed: $failure', isError: true);
      return;
    }
    final ok = results.where((result) => result.created).length;
    final failed = results.where((result) => !result.created).toList();
    AppToast.show(
      context,
      failed.isEmpty
          ? 'Installed on $ok agent(s).'
          : 'Installed on $ok; failed: '
                '${failed.map((f) => '${mcpProviderName(f.provider)} (${f.error ?? 'error'})').join(', ')}',
      isError: failed.isNotEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(LucideIcons.plug),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Install ddagent MCP server', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    'Give your agents the knowledge base and ddagent tools over MCP — '
                    'pick agents or install for all.',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppButton(onPressed: _openDialog, child: const Text('Install')),
          ],
        ),
      ),
    );
  }
}
