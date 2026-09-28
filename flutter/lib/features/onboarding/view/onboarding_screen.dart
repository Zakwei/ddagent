import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
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
                    Text('Agent connections', style: t.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Provider accounts can be linked later in Settings.',
                      style: t.textTheme.bodyMedium?.copyWith(color: c.mutedForeground),
                    ),
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
