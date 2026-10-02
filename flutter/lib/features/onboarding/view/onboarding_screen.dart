import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:ddagent_app/features/settings/state/provider_auth_controller.dart';
import 'package:ddagent_app/features/terminal/view/provider_login_dialog.dart';
import 'package:ddagent_app/features/user/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

/// Two-step onboarding — port of Onboarding.tsx:
/// step 0: git identity (GET/POST /user/git-config, auto-populated),
/// step 1: agent connections placeholder → POST /user/complete-onboarding.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  int _step = 0;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGitConfig();
  }

  Future<void> _loadGitConfig() async {
    try {
      final cfg = await ref.read(userRepositoryProvider).gitConfig();
      if (!mounted) return;
      _name.text = cfg.gitName ?? '';
      _email.text = cfg.gitEmail ?? '';
    } on AppError {
      // Missing/failed git config must not block onboarding.
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  bool get _step0Valid =>
      _name.text.trim().isNotEmpty &&
      _email.text.trim().isNotEmpty &&
      _emailPattern.hasMatch(_email.text.trim());

  Future<void> _next() async {
    setState(() => _error = null);
    if (_step == 0) {
      if (!_step0Valid) {
        setState(
          () => _error = _email.text.trim().isEmpty || _name.text.trim().isEmpty
              ? 'Both git name and email are required.'
              : 'Please enter a valid email address.',
        );
        return;
      }
      setState(() => _busy = true);
      try {
        await ref
            .read(userRepositoryProvider)
            .updateGitConfig(gitName: _name.text.trim(), gitEmail: _email.text.trim());
      } on AppError catch (e) {
        setState(() {
          _busy = false;
          _error = e.message;
        });
        return;
      }
    }
    setState(() {
      _busy = false;
      _step++;
    });
  }

  Future<void> _finish() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).completeOnboarding();
    } on AppError catch (e) {
      setState(() {
        _busy = false;
        _error = e.message;
      });
      return;
    }
    if (mounted) context.go('/projects');
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 2; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.sm),
                        Icon(
                          i < _step
                              ? Icons.check_circle
                              : (i == _step ? Icons.radio_button_checked : Icons.circle_outlined),
                          size: 18,
                          color: i <= _step ? c.primary : c.mutedForeground,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_step == 0) ...[
                    Text('Git configuration', style: t.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Used for commits created by ddagent sessions.',
                      style: t.textTheme.bodyMedium?.copyWith(color: c.mutedForeground),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppInput(
                      controller: _name,
                      hint: 'Name',
                      autofocus: true,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _next(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppInput(
                      controller: _email,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _next(),
                    ),
                  ] else ...[
                    const _AgentConnectionsStep(),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(_error!, style: TextStyle(color: c.destructive)),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      AppButton(
                        variant: AppButtonVariant.ghost,
                        onPressed: _step == 0 || _busy ? null : () => setState(() => _step--),
                        child: const Text('Previous'),
                      ),
                      const Spacer(),
                      AppButton(
                        onPressed: _step == 0
                            ? (_step0Valid && !_busy ? _next : null)
                            : (_busy ? null : _finish),
                        loading: _busy,
                        child: Text(_step == 0 ? 'Next' : 'Complete Setup'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Step 1 — live provider auth cards + login launch (web
/// AgentConnectionsStep/AgentConnectionCard parity).
class _AgentConnectionsStep extends StatelessWidget {
  const _AgentConnectionsStep();

  static const _providers = [
    ('claude', 'Claude Code', Color(0xFF2563EB)),
    ('cursor', 'Cursor', Color(0xFF9333EA)),
    ('codex', 'OpenAI Codex', Color(0xFF1F2937)),
    ('opencode', 'OpenCode', Color(0xFF27272A)),
    ('commandcode', 'Command Code', Color(0xFF27272A)),
    ('antigravity', 'Antigravity', Color(0xFF27272A)),
    ('devin', 'Devin', Color(0xFF27272A)),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Connect Your AI Agents',
          style: t.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Login to one or more AI coding assistants. All are optional.',
          style: t.textTheme.bodyMedium?.copyWith(color: c.mutedForeground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final (id, title, accent) in _providers) ...[
                _AgentConnectionCard(provider: id, title: title, accent: accent),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'You can configure these later in Settings.',
          style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AgentConnectionCard extends ConsumerWidget {
  const _AgentConnectionCard({
    required this.provider,
    required this.title,
    required this.accent,
  });

  final String provider;
  final String title;
  final Color accent;

  /// Same project-path resolution the settings agents section uses.
  String _projectPath(WidgetRef ref) {
    final projects = ref.read(projectsProvider).projects;
    if (projects.isEmpty) return '/workspace';
    final first = projects.first;
    return (first.fullPath?.isNotEmpty ?? false) ? first.fullPath! : first.path;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final status = ref.watch(providerAuthStatusProvider(provider));
    final s = status.value;
    final loading = status.isLoading;
    final connected = s?.authenticated ?? false;
    final statusText = loading
        ? 'Checking...'
        : connected
        ? (s!.email ?? 'Connected')
        : (s?.error ?? 'Not connected');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: connected ? accent.withValues(alpha: 0.08) : c.card,
        border: Border.all(
          color: connected ? accent.withValues(alpha: 0.5) : c.border,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(child: ProviderLogo(provider: provider, size: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (connected) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.check,
                        size: 14,
                        color: Color(0xFF10B981), // emerald-500
                      ),
                    ],
                  ],
                ),
                Tooltip(
                  message: statusText,
                  child: Text(
                    statusText,
                    style: TextStyle(fontSize: 12, color: c.mutedForeground),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // The web hides Login for env-var (api_key) credentials.
          if (!connected && !loading && s?.method != 'api_key')
            FilledButton(
              onPressed: () => unawaited(
                ProviderLoginDialog.show(
                  context: context,
                  provider: provider,
                  projectPath: _projectPath(ref),
                  onComplete: (exitCode) {
                    ref.invalidate(providerAuthStatusProvider(provider));
                    if (!context.mounted) return;
                    AppToast.show(
                      context,
                      exitCode == 0 ? 'Connected' : 'Not connected',
                      isError: exitCode != 0,
                    );
                  },
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Login'),
            ),
        ],
      ),
    );
  }
}
