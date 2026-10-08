import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_view_wrapper.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderLoginDialog extends ConsumerStatefulWidget {
  const ProviderLoginDialog({
    super.key,
    this.provider = 'claude',
    required this.projectPath,
    this.customCommand,
    this.title,
    this.onComplete,
  });

  final String provider;
  final String projectPath;
  final String? customCommand;

  /// Header/tab title override — the install flow reuses this dialog to run a
  /// provider's install command, so "… Login" would be wrong there.
  final String? title;
  final void Function(int exitCode)? onComplete;

  /// The provider's login shell command — exposed so per-account logins can
  /// wrap it in `env KEY=VALUE …` overrides (Settings → Agents → accounts).
  static String loginCommandFor(String provider) => providerLoginCommand(provider);

  static Future<void> show({
    required BuildContext context,
    String provider = 'claude',
    required String projectPath,
    String? customCommand,
    String? title,
    void Function(int exitCode)? onComplete,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProviderLoginDialog(
        provider: provider,
        projectPath: projectPath,
        customCommand: customCommand,
        title: title,
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
    final override = widget.title;
    if (override != null && override.isNotEmpty) return override;
    final name = switch (provider) {
      'claude' => 'Claude',
      'cursor' => 'Cursor',
      'codex' => 'Codex',
      'opencode' => 'OpenCode',
      'commandcode' => 'Command Code',
      'antigravity' => 'Antigravity',
      'devin' => 'Devin',
      _ => provider,
    };
    return Translations.of(context).terminal.loginDialog.title(provider: name);
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
    final t = Translations.of(context);
    final terminalState = ref.watch(terminalControllerProvider);

    final currentTab = _tab != null
        ? terminalState.tabs.firstWhere((t) => t.id == _tab!.id, orElse: () => _tab!)
        : null;

    final latestAuthUrl = currentTab == null ? null : bestAuthUrl(currentTab.authUrls);

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
                        currentTab.exitCode == 0
                            ? t.common.status.completed
                            : t.terminal.loginDialog.exited(code: currentTab.exitCode ?? ''),
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
                    tooltip: t.chat.common.close,
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
                        t.terminal.loginDialog.authLinkDetected,
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
                      label: Text(t.terminal.authUrl.openInBrowser),
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
