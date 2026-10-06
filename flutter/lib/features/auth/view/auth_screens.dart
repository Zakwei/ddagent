import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Centered card shell shared by login/setup (AuthScreenLayout parity).
class _AuthShell extends StatelessWidget {
  const _AuthShell({
    required this.title,
    this.description,
    required this.child,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = context.appColors;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: c.mutedForeground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    child,
                    TextButton(
                      onPressed: () => context.go('/connect'),
                      child: Text(
                        Translations.of(context).serverConnect.changeServer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Login form — POST /auth/login via [AuthController]; `?from=` is restored
/// after success (deep links that bounced off the auth guard).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = Translations.of(context);
    if (_username.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _error = t.auth.login.errors.requiredFields);
      return;
    }
    final error = await ref
        .read(authControllerProvider.notifier)
        .login(_username.text.trim(), _password.text);
    if (!mounted) return;
    if (error == null) {
      final from = GoRouterState.of(context).uri.queryParameters['from'];
      context.go(from != null && from.startsWith('/') ? from : '/projects');
    } else {
      setState(
        () => _error = error is AuthError
            ? t.auth.login.errors.invalidCredentials
            : error.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    // First-run servers have no owner — bounce to the setup form once the
    // status check resolves (web parity: ProtectedRoute → /setup).
    ref.listen(authControllerProvider, (_, next) {
      if (next.needsSetup) context.go('/setup');
    });
    final loading = ref.watch(authControllerProvider).isLoading;
    return _AuthShell(
      title: t.auth.login.title,
      description: t.auth.login.description,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInput(
            controller: _username,
            hint: t.auth.login.placeholders.username,
            autofocus: true,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppInput(
            controller: _password,
            hint: t.auth.login.placeholders.password,
            obscureText: true,
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _error!,
              style: TextStyle(color: context.appColors.destructive),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            onPressed: _submit,
            loading: loading,
            child: Text(loading ? t.auth.login.loading : t.auth.login.submit),
          ),
        ],
      ),
    );
  }
}

/// First-run owner registration (needsSetup). `?invite=<token>` pre-fills an
/// invite token for the collab registration path.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = Translations.of(context);
    // web SetupForm order: required → username ≥3 → password ≥6 → match.
    if (_username.text.trim().isEmpty ||
        _password.text.isEmpty ||
        _confirm.text.isEmpty) {
      setState(() => _error = t.auth.login.errors.requiredFields);
      return;
    }
    if (_username.text.trim().length < 3) {
      setState(() => _error = t.auth.register.errors.usernameTooShort);
      return;
    }
    if (_password.text.length < 6) {
      setState(() => _error = t.auth.register.errors.passwordTooShort);
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _error = t.auth.register.errors.passwordMismatch);
      return;
    }
    final invite = GoRouterState.of(context).uri.queryParameters['invite'];
    final error = await ref
        .read(authControllerProvider.notifier)
        .register(_username.text.trim(), _password.text, inviteToken: invite);
    if (!mounted) return;
    if (error == null) {
      context.go('/projects');
    } else {
      setState(() => _error = error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final loading = ref.watch(authControllerProvider).isLoading;
    return _AuthShell(
      title: t.auth.register.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInput(
            controller: _username,
            hint: t.auth.register.username,
            autofocus: true,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppInput(
            controller: _password,
            hint: t.auth.register.password,
            obscureText: true,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppInput(
            controller: _confirm,
            hint: t.auth.register.confirmPassword,
            obscureText: true,
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _error!,
              style: TextStyle(color: context.appColors.destructive),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            onPressed: _submit,
            loading: loading,
            child: Text(
              loading ? t.auth.register.loading : t.auth.register.submit,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sign-out with a confirm dialog — clears the JWT; the guard then routes
/// to /connect. Mounted in the settings page until T34 builds the real tab.
class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    return AppButton(
      variant: AppButtonVariant.ghost,
      onPressed: () async {
        final confirmed = await AppDialog.confirm(
          context,
          title: t.auth.logout.title,
          message: t.auth.logout.confirm,
          confirmLabel: t.auth.logout.button,
        );
        if (confirmed) await ref.read(authControllerProvider.notifier).logout();
      },
      child: Text(t.auth.logout.button),
    );
  }
}
