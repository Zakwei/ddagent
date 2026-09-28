import 'dart:convert';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/browser_use/data/browser_use_repository.dart';
import 'package:ddagent_app/features/browser_use/state/browser_use_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Headless agent-browser panel: runtime readiness (Playwright + Chromium),
/// an install button, and the live session list with screenshots and
/// stop/delete actions.
class BrowserUsePanel extends ConsumerWidget {
  const BrowserUsePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(browserUseProvider);
    final ctrl = ref.read(browserUseProvider.notifier);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final status = state.status;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Icon(
                status?.available == true
                    ? Icons.check_circle_outline
                    : Icons.warning_amber_outlined,
                size: 16,
                color: status?.available == true ? Colors.green : c.mutedForeground,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  status?.message ??
                      (state.loading ? 'Checking runtime…' : 'Browser runtime'),
                  style: t.bodySmall?.copyWith(color: c.mutedForeground),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (status?.available != true)
                AppButton(
                  key: const Key('browser-use-install'),
                  size: AppButtonSize.sm,
                  onPressed: state.busy
                      ? null
                      : () => ctrl.installRuntime(),
                  child: Text(
                    status?.installInProgress == true || state.busy
                        ? 'Installing…'
                        : 'Install',
                  ),
                ),
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: () => ctrl.refresh(),
              ),
            ],
          ),
        ),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              state.error!,
              style: t.bodySmall?.copyWith(color: c.destructive),
            ),
          ),
        const Divider(height: 1),
        Expanded(
          child: state.sessions.isEmpty
              ? Center(
                  child: Text(
                    'No agent browser sessions',
                    style: t.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  children: [
                    for (final s in state.sessions)
                      _SessionTile(key: ValueKey(s.id), session: s),
                  ],
                ),
        ),
      ],
    );
  }
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({super.key, required this.session});

  final BrowserUseSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(browserUseProvider.notifier);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: session.isRunning ? Colors.green : c.mutedForeground,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  session.title ?? session.url ?? session.id,
                  style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (session.isRunning)
                IconButton(
                  key: Key('browser-use-stop-${session.id}'),
                  tooltip: 'Stop',
                  icon: const Icon(Icons.stop_circle_outlined, size: 18),
                  onPressed: () => ctrl.stopSession(session.id),
                ),
              IconButton(
                key: Key('browser-use-delete-${session.id}'),
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: () => ctrl.deleteSession(session.id),
              ),
            ],
          ),
          if (session.url != null)
            Text(
              session.url!,
              style: t.bodySmall?.copyWith(color: c.mutedForeground),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (session.lastAction != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Last action: ${session.lastAction}',
                style: t.bodySmall?.copyWith(color: c.mutedForeground),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (session.screenshotDataUrl != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.sm),
                child: _Screenshot(dataUrl: session.screenshotDataUrl!),
              ),
            ),
        ],
      ),
    );
  }
}

class _Screenshot extends StatelessWidget {
  const _Screenshot({required this.dataUrl});

  final String dataUrl;

  @override
  Widget build(BuildContext context) {
    try {
      final comma = dataUrl.indexOf(',');
      final bytes = base64Decode(
        comma >= 0 ? dataUrl.substring(comma + 1) : dataUrl,
      );
      return Image.memory(
        bytes,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    } on Object {
      return const SizedBox.shrink();
    }
  }
}

/// Hosted dialog wrapper — "Browser" button entry point.
Future<void> showBrowserUseDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Agent Browser'),
      content: const SizedBox(
        width: 480,
        height: 480,
        child: BrowserUsePanel(),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
