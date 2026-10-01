import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/provider_login_dialog.dart';
import 'package:ddagent_app/features/terminal/view/terminal_shortcuts_bar.dart';
import 'package:ddagent_app/features/terminal/view/terminal_view_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class TerminalScreen extends ConsumerStatefulWidget {
  const TerminalScreen({
    super.key,
    this.projectPath,
    this.projectId,
    this.sessionId,
    this.onFileOpen,
  });

  final String? projectPath;
  final String? projectId;
  final String? sessionId;
  final void Function(String filePath, int? line)? onFileOpen;

  @override
  ConsumerState<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends ConsumerState<TerminalScreen> {
  /// "Copied!" flash on the copy-output button (web 2s timer).
  bool _copied = false;
  Timer? _copyTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureInitialTab();
    });
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  String _resolveProjectPath() {
    if (widget.projectPath != null && widget.projectPath!.isNotEmpty) {
      return widget.projectPath!;
    }
    final projectsState = ref.read(projectsProvider);
    if (widget.projectId != null) {
      final match = projectsState.projects
          .where((p) => p.projectId == widget.projectId)
          .firstOrNull;
      if (match != null) {
        return (match.fullPath?.isNotEmpty ?? false)
            ? match.fullPath!
            : match.path;
      }
    }
    final first = projectsState.projects.firstOrNull;
    if (first != null) {
      return (first.fullPath?.isNotEmpty ?? false)
          ? first.fullPath!
          : first.path;
    }
    return '/workspace';
  }

  void _ensureInitialTab() {
    final terminalState = ref.read(terminalControllerProvider);
    if (terminalState.tabs.isEmpty) {
      final path = _resolveProjectPath();
      ref
          .read(terminalControllerProvider.notifier)
          .createTab(
            title: widget.sessionId != null
                ? 'Session ${widget.sessionId}'
                : 'Shell 1',
            projectPath: path,
            sessionId: widget.sessionId,
            isPlainShell: widget.sessionId == null,
          );
    }
  }

  void _handleOpenFile(String filePath, int? line) {
    if (widget.onFileOpen != null) {
      widget.onFileOpen!(filePath, line);
    } else {
      final queryParams = <String, String>{'file': filePath};
      if (line != null) queryParams['line'] = line.toString();
      if (widget.projectId != null) {
        queryParams['projectId'] = widget.projectId!;
      }

      context.push(
        Uri(path: '/editor', queryParameters: queryParams).toString(),
      );
    }
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
    final activeTab = terminalState.activeTab;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          // Top bar / Tab Strip
          _buildTabStrip(context, terminalState, activeTab),

          // Active tab Auth URL banner (if any)
          if (activeTab != null && activeTab.authUrls.isNotEmpty)
            _buildAuthUrlBanner(activeTab.authUrls.last),

          // Main terminal view or empty state
          Expanded(
            child: activeTab != null
                ? _terminalArea(activeTab)
                : _buildEmptyState(),
          ),

          // Touch / Mobile Shortcuts Bar
          if (terminalState.showShortcutsBar && activeTab != null)
            TerminalShortcutsBar(
              onSendInput: (input) {
                ref
                    .read(terminalControllerProvider.notifier)
                    .sendInput(activeTab.id, input);
              },
              onClear: () {
                ref
                    .read(terminalControllerProvider.notifier)
                    .clearTab(activeTab.id);
              },
              onClose: () {
                ref
                    .read(terminalControllerProvider.notifier)
                    .toggleShortcutsBar();
              },
            ),
        ],
      ),
    );
  }

  /// Terminal + overlays (web `relative flex-1`): connection overlay with the
  /// explicit Connect CTA, and the CLI-prompt option chips strip.
  Widget _terminalArea(TerminalTab activeTab) {
    final notifier = ref.read(terminalControllerProvider.notifier);
    final connected = activeTab.status == TerminalTabStatus.connected;
    // `md:hidden short:!block` — the chips exist for touch/small screens.
    final showChips =
        activeTab.promptOptions != null &&
        connected &&
        (MediaQuery.sizeOf(context).width < 768 ||
            MediaQuery.sizeOf(context).height < 450);

    return Stack(
      children: [
        Positioned.fill(
          child: TerminalViewWrapper(
            key: ValueKey(activeTab.id),
            tab: activeTab,
            onFileOpen: _handleOpenFile,
          ),
        ),
        if (showChips)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _PromptChipsBar(
              options: activeTab.promptOptions!,
              onAnswer: (input) => notifier.answerPrompt(activeTab.id, input),
            ),
          ),
        if (activeTab.status != TerminalTabStatus.connected)
          _ConnectionOverlay(
            tab: activeTab,
            onConnect: () => notifier.restartTab(activeTab.id),
          ),
      ],
    );
  }

  Future<void> _copyOutput(TerminalTab tab) async {
    final text = ref
        .read(terminalControllerProvider.notifier)
        .copyOutputText(tab.id);
    if (text == null || text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    setState(() => _copied = true);
    _copyTimer?.cancel();
    _copyTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Widget _buildTabStrip(
    BuildContext context,
    TerminalState state,
    TerminalTab? activeTab,
  ) {
    final colors = context.appColors;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          // Scrollable tab items
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.tabs.length,
              itemBuilder: (context, index) {
                final tab = state.tabs[index];
                final isActive = tab.id == state.activeTabId;

                return _buildTabItem(context, tab, isActive);
              },
            ),
          ),

          // Action cluster — ShellHeader port: zoom, copy, kill, restart,
          // disconnect (+ Flutter extras: provider login, clear, shortcuts).
          // Horizontally scrollable so narrow panes keep the tabs visible.
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Font zoom (9–24px, disabled at the bounds).
                  if (activeTab != null) ...[
                    IconButton(
                      tooltip: 'Zoom out',
                      icon: const Icon(LucideIcons.zoomOut, size: 16),
                      onPressed: activeTab.fontSize > terminalFontSizeMin
                          ? () => ref
                                .read(terminalControllerProvider.notifier)
                                .zoomOut(activeTab.id)
                          : null,
                    ),
                    IconButton(
                      tooltip: 'Zoom in',
                      icon: const Icon(LucideIcons.zoomIn, size: 16),
                      onPressed: activeTab.fontSize < terminalFontSizeMax
                          ? () => ref
                                .read(terminalControllerProvider.notifier)
                                .zoomIn(activeTab.id)
                          : null,
                    ),
                    // Copy output → 2s "copied" check.
                    IconButton(
                      tooltip: _copied ? 'Copied!' : 'Copy terminal output',
                      icon: Icon(
                        _copied ? Icons.check : LucideIcons.copy,
                        size: 16,
                        color: _copied
                            ? const Color(0xFF22C55E)
                            : colors.foreground,
                      ),
                      onPressed: () => _copyOutput(activeTab),
                    ),
                  ],

                  // New tab popup button
                  PopupMenuButton<String>(
                    tooltip: 'New Terminal Tab',
                    icon: const Icon(Icons.add, size: 20),
                    onSelected: (choice) {
                      final path = _resolveProjectPath();
                      final notifier = ref.read(
                        terminalControllerProvider.notifier,
                      );
                      if (choice == 'plain') {
                        notifier.createTab(
                          projectPath: path,
                          isPlainShell: true,
                        );
                      } else {
                        notifier.createTab(
                          projectPath: path,
                          provider: choice,
                          isPlainShell: false,
                          title: '$choice CLI',
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'plain',
                        child: Row(
                          children: [
                            Icon(Icons.terminal, size: 16),
                            SizedBox(width: 8),
                            Text('Plain Shell'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'claude',
                        child: Row(
                          children: [
                            Icon(Icons.smart_toy_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Claude CLI'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'opencode',
                        child: Row(
                          children: [
                            Icon(Icons.code, size: 16),
                            SizedBox(width: 8),
                            Text('OpenCode CLI'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'cursor',
                        child: Row(
                          children: [
                            Icon(Icons.computer, size: 16),
                            SizedBox(width: 8),
                            Text('Cursor CLI'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'devin',
                        child: Row(
                          children: [
                            Icon(Icons.psychology, size: 16),
                            SizedBox(width: 8),
                            Text('Devin CLI'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Provider Login action
                  IconButton(
                    tooltip: 'Provider Login',
                    icon: const Icon(Icons.vpn_key_outlined, size: 18),
                    onPressed: () {
                      ProviderLoginDialog.show(
                        context: context,
                        projectPath: _resolveProjectPath(),
                      );
                    },
                  ),

                  // Kill running process (SIGINT) — connected only.
                  if (activeTab != null &&
                      activeTab.status == TerminalTabStatus.connected)
                    IconButton(
                      tooltip: 'Kill running process (Ctrl+C)',
                      icon: Icon(
                        LucideIcons.square,
                        size: 14,
                        color: colors.destructive,
                      ),
                      onPressed: () {
                        ref
                            .read(terminalControllerProvider.notifier)
                            .sendInput(activeTab.id, '\x03');
                      },
                    ),

                  // Restart current session
                  if (activeTab != null)
                    IconButton(
                      tooltip: 'Restart Session',
                      icon: const Icon(Icons.refresh, size: 18),
                      onPressed: () {
                        ref
                            .read(terminalControllerProvider.notifier)
                            .restartTab(activeTab.id);
                      },
                    ),

                  // Disconnect — connected only; overlay's Connect resumes.
                  if (activeTab != null &&
                      activeTab.status == TerminalTabStatus.connected)
                    IconButton(
                      tooltip: 'Disconnect',
                      icon: Icon(
                        LucideIcons.x,
                        size: 18,
                        color: colors.destructive,
                      ),
                      onPressed: () {
                        ref
                            .read(terminalControllerProvider.notifier)
                            .disconnectTab(activeTab.id);
                      },
                    ),

                  // Clear terminal buffer
                  if (activeTab != null)
                    IconButton(
                      tooltip: 'Clear Output',
                      icon: const Icon(Icons.clear_all, size: 18),
                      onPressed: () {
                        ref
                            .read(terminalControllerProvider.notifier)
                            .clearTab(activeTab.id);
                      },
                    ),

                  // Toggle touch shortcuts bar
                  IconButton(
                    tooltip: state.showShortcutsBar
                        ? 'Hide Shortcuts'
                        : 'Show Shortcuts',
                    icon: Icon(
                      Icons.keyboard,
                      size: 18,
                      color: state.showShortcutsBar
                          ? colors.primary
                          : colors.mutedForeground,
                    ),
                    onPressed: () {
                      ref
                          .read(terminalControllerProvider.notifier)
                          .toggleShortcutsBar();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, TerminalTab tab, bool isActive) {
    final colors = context.appColors;
    final statusColor = switch (tab.status) {
      TerminalTabStatus.connecting => const Color(0xFFF59E0B),
      TerminalTabStatus.connected => const Color(0xFF22C55E),
      TerminalTabStatus.disconnected => colors.mutedForeground,
      TerminalTabStatus.exited =>
        tab.exitCode == 0 ? const Color(0xFF22C55E) : colors.destructive,
    };

    return Material(
      color: isActive ? colors.background : colors.card,
      child: InkWell(
        onTap: () {
          ref.read(terminalControllerProvider.notifier).selectTab(tab.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: colors.border),
              bottom: BorderSide(
                color: isActive ? colors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                tab.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? colors.foreground : colors.mutedForeground,
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  ref
                      .read(terminalControllerProvider.notifier)
                      .closeTab(tab.id);
                },
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(Icons.close, size: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthUrlBanner(String authUrl) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: colors.primary.withValues(alpha: 0.12),
      child: Row(
        children: [
          Icon(Icons.link, size: 16, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Auth link: $authUrl',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontFamilyFallback: AppFonts.mono,
                color: colors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => _openAuthUrl(authUrl),
            icon: const Icon(Icons.open_in_new, size: 14),
            label: const Text('Open'),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final colors = context.appColors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.terminal, size: 48, color: colors.mutedForeground),
          const SizedBox(height: 12),
          Text(
            'No Active Terminal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new tab to begin',
            style: TextStyle(fontSize: 13, color: colors.mutedForeground),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              final path = _resolveProjectPath();
              ref
                  .read(terminalControllerProvider.notifier)
                  .createTab(
                    title: 'Shell 1',
                    projectPath: path,
                    isPlainShell: true,
                  );
            },
            icon: const Icon(Icons.add),
            label: const Text('New Shell'),
          ),
        ],
      ),
    );
  }
}

/// `ShellConnectionOverlay` port — `bg-gray-950/90` full-cover layer:
/// spinner + "Connecting…" while connecting; an explicit Connect CTA
/// (description underneath) once disconnected/exited.
class _ConnectionOverlay extends StatelessWidget {
  const _ConnectionOverlay({required this.tab, required this.onConnect});

  final TerminalTab tab;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final connecting = tab.status == TerminalTabStatus.connecting;
    final description = switch (tab.status) {
      TerminalTabStatus.exited =>
        'Process exited${tab.exitCode != null ? ' (code ${tab.exitCode})' : ''} — connect to start it again',
      _ =>
        tab.sessionId != null
            ? 'Resume session ${tab.title}'
            : 'Start a new session in ${tab.projectPath}',
    };
    return Container(
      color: const Color(0xE6030713), // gray-950/90
      child: Center(
        child: connecting
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFFDE047), // yellow-300
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Connecting…',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFDE047),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFD1D5DB), // gray-300
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton.icon(
                    onPressed: onConnect,
                    icon: const Icon(LucideIcons.rotateCcw, size: 16),
                    label: const Text('Connect'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF059669), // emerald-600
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Color(0xFFD1D5DB),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// CLI prompt option chips (web `cliPromptOptions` strip) — `N. label`
/// buttons send the digit; the Esc chip sends `\x1b`.
class _PromptChipsBar extends StatelessWidget {
  const _PromptChipsBar({required this.options, required this.onAnswer});

  final List<CliPromptOption> options;
  final void Function(String input) onAnswer;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.card.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: colors.border.withValues(alpha: 0.8)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          for (final opt in options)
            Tooltip(
              message: '${opt.number}. ${opt.label}',
              child: Material(
                color: const Color(0xFF2563EB), // blue-600
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  onTap: () => onAnswer(opt.number),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      '${opt.number}. ${opt.label}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Material(
            color: colors.muted,
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              onTap: () => onAnswer('\x1b'),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(
                  'Esc',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.foreground,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
