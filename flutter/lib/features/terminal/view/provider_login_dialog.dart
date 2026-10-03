import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_view_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderLoginDialog extends ConsumerStatefulWidget {
  const ProviderLoginDialog({
    super.key,
    this.provider = 'claude',
    required this.projectPath,
    this.customCommand,
    this.onComplete,
  });

  final String provider;
  final String projectPath;
  final String? customCommand;
  final void Function(int exitCode)? onComplete;

  /// The provider's login shell command — exposed so per-account logins can
  /// wrap it in `env KEY=VALUE …` overrides (Settings → Agents → accounts).
  static String loginCommandFor(String provider) => providerLoginCommand(provider);

  static Future<void> show({
    required BuildContext context,
    String provider = 'claude',
    required String projectPath,
    String? customCommand,
    void Function(int exitCode)? onComplete,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProviderLoginDialog(
        provider: provider,
        projectPath: projectPath,
        customCommand: customCommand,
        onComplete: onComplete,
      ),
    );
  }

  @override
  ConsumerState<ProviderLoginDialog> createState() => _ProviderLoginDialogState();
}

class _ProviderLoginDialogState extends ConsumerState<ProviderLoginDialog> {
  late String _selectedProvider;
  late TerminalController _terminalController;
  TerminalTab? _tab;

  @override
  void initState() {
    super.initState();
    _selectedProvider = widget.provider;
    _terminalController = ref.read(terminalControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSession();
    });
  }

  @override
  void dispose() {
    if (_tab != null) {
      _terminalController.closeTab(_tab!.id);
    }
    super.dispose();
  }

  String _getCommand(String provider) {
    if (widget.customCommand != null && widget.customCommand!.isNotEmpty) {
      return widget.customCommand!;
    }
    return providerLoginCommand(provider);
  }

  String _getTitle(String provider) {
    return switch (provider) {
      'claude' => 'Claude CLI Login',
      'cursor' => 'Cursor CLI Login',
      'codex' => 'Codex CLI Login',
      'opencode' => 'OpenCode CLI Login',
      'commandcode' => 'Command Code CLI Login',
      'antigravity' => 'Antigravity CLI Login',
      'devin' => 'Devin CLI Login',
      _ => '$provider CLI Login',
    };
  }

  void _startSession() {
    if (_tab != null) {
      ref.read(terminalControllerProvider.notifier).closeTab(_tab!.id);
    }

    final cmd = _getCommand(_selectedProvider);
    final tab = ref
        .read(terminalControllerProvider.notifier)
        .runOneShotCommand(
          projectPath: widget.projectPath,
          command: cmd,
          title: _getTitle(_selectedProvider),
          onComplete: (exitCode) {
            if (mounted) {
              setState(() {});
              widget.onComplete?.call(exitCode);
            }
          },
        );

    setState(() {
      _tab = tab;
    });
  }

  Future<void> _openAuthUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final terminalState = ref.watch(terminalControllerProvider);

    final currentTab = _tab != null
        ? terminalState.tabs.firstWhere((t) => t.id == _tab!.id, orElse: () => _tab!)
        : null;

    final latestAuthUrl = currentTab?.authUrls.isNotEmpty == true
        ? currentTab!.authUrls.last
        : null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.card,
                border: Border(bottom: BorderSide(color: colors.border)),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _getTitle(_selectedProvider),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: colors.foreground,
                      ),
                    ),
                  ),
                  if (currentTab != null && currentTab.isCompleted) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: currentTab.exitCode == 0
                            ? const Color(0xFF22C55E).withValues(alpha: 0.15)
                            : colors.destructive.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                      child: Text(
                        currentTab.exitCode == 0 ? 'Completed' : 'Exited (${currentTab.exitCode})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: currentTab.exitCode == 0
                              ? const Color(0xFF22C55E)
                              : colors.destructive,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // Auth URL Banner
            if (latestAuthUrl != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: colors.primary.withValues(alpha: 0.12),
                child: Row(
                  children: [
                    Icon(Icons.link, size: 16, color: colors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Authentication link detected',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.primary,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _openAuthUrl(latestAuthUrl),
                      icon: const Icon(Icons.open_in_new, size: 14),
                      label: const Text('Open in browser'),
                      style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                    ),
                  ],
                ),
              ),

            // Terminal View
            Expanded(
              child: currentTab != null
                  ? TerminalViewWrapper(tab: currentTab)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
