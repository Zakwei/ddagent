import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_spinner.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/settings/data/api_credentials_repository.dart';
import 'package:ddagent_app/features/settings/state/api_credentials_controller.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/features/voice/state/stt_controller.dart';
import 'package:ddagent_app/features/voice/view/stt_config_dialog.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// API & Tokens section — port of `CredentialsSettingsTab.tsx`: API key CRUD
/// (+ one-time new-key alert), GitHub token CRUD, STT config entry point.
class ApiSection extends ConsumerStatefulWidget {
  const ApiSection({super.key});

  @override
  ConsumerState<ApiSection> createState() => _ApiSectionState();
}

class _ApiSectionState extends ConsumerState<ApiSection> {
  bool _showKeyForm = false;
  final _keyName = TextEditingController();
  bool _showGithubForm = false;
  bool _showToken = false;
  final _ghName = TextEditingController();
  final _ghToken = TextEditingController();
  final _ghDescription = TextEditingController();

  @override
  void dispose() {
    _keyName.dispose();
    _ghName.dispose();
    _ghToken.dispose();
    _ghDescription.dispose();
    super.dispose();
  }

  ApiCredentialsController get _ctrl => ref.read(apiCredentialsProvider.notifier);

  void _report(String? error) {
    if (error != null && error != 'empty' && mounted) {
      AppToast.error(context, error);
    }
  }

  Future<void> _createApiKey() async {
    final error = await _ctrl.createApiKey(_keyName.text);
    if (error != null) return _report(error);
    setState(() {
      _keyName.clear();
      _showKeyForm = false;
    });
  }

  Future<void> _deleteApiKey(ApiKeyEntry key) async {
    final t = Translations.of(context);
    final confirmed = await AppDialog.confirm(
      context,
      title: t.settings.apiKeys.title,
      message: t.settings.apiKeys.confirmDelete,
      confirmLabel: 'Delete',
    );
    if (confirmed) _report(await _ctrl.deleteApiKey(key.id));
  }

  Future<void> _createGithubCredential() async {
    final error = await _ctrl.createGithubCredential(
      name: _ghName.text,
      token: _ghToken.text,
      description: _ghDescription.text,
    );
    if (error != null) return _report(error);
    setState(() {
      _ghName.clear();
      _ghToken.clear();
      _ghDescription.clear();
      _showToken = false;
      _showGithubForm = false;
    });
  }

  Future<void> _deleteGithubCredential(GithubCredentialEntry credential) async {
    final t = Translations.of(context);
    final confirmed = await AppDialog.confirm(
      context,
      title: t.settings.apiKeys.github.title,
      message: t.settings.apiKeys.github.confirmDelete,
      confirmLabel: 'Delete',
    );
    if (confirmed) {
      _report(await _ctrl.deleteGithubCredential(credential.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final state = ref.watch(apiCredentialsProvider);
    final apiT = t.settings.apiKeys;

    if (state.loading && state.apiKeys.isEmpty && state.githubCredentials.isEmpty) {
      return const Center(child: AppSpinner());
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (state.newlyCreatedKey != null) ...[
          _NewApiKeyCard(apiKey: state.newlyCreatedKey!, onDismiss: _ctrl.dismissNewlyCreatedKey),
          const SizedBox(height: AppSpacing.xl),
        ],
        SettingsSectionBlock(
          title: apiT.title,
          icon: LucideIcons.key,
          description: apiT.description,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton(
                size: AppButtonSize.sm,
                onPressed: () => setState(() => _showKeyForm = !_showKeyForm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xs,
                  children: [const Icon(LucideIcons.plus, size: 14), Text(apiT.newButton)],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const _ApiDocsLink(),
            if (_showKeyForm) ...[
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    AppInput(controller: _keyName, hint: apiT.form.placeholder),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      spacing: AppSpacing.sm,
                      children: [
                        AppButton(
                          size: AppButtonSize.sm,
                          onPressed: _createApiKey,
                          child: Text(apiT.form.createButton),
                        ),
                        AppButton(
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.sm,
                          onPressed: () => setState(() {
                            _showKeyForm = false;
                            _keyName.clear();
                          }),
                          child: Text(apiT.form.cancelButton),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            if (state.apiKeys.isEmpty)
              _EmptyState(icon: LucideIcons.keyRound, title: apiT.empty)
            else
              for (final entry in state.apiKeys)
                _ApiKeyRow(
                  key: ValueKey(entry.id),
                  entry: entry,
                  onToggle: () async => _report(await _ctrl.toggleApiKey(entry)),
                  onDelete: () => _deleteApiKey(entry),
                ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SettingsSectionBlock(
          title: apiT.github.title,
          icon: LucideIcons.gitBranch,
          description: apiT.github.descriptionAlt,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton(
                size: AppButtonSize.sm,
                onPressed: () => setState(() => _showGithubForm = !_showGithubForm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xs,
                  children: [const Icon(LucideIcons.plus, size: 14), Text(apiT.github.addButton)],
                ),
              ),
            ),
            if (_showGithubForm) ...[
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    AppInput(controller: _ghName, hint: apiT.github.form.namePlaceholder),
                    const SizedBox(height: AppSpacing.sm),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        AppInput(
                          controller: _ghToken,
                          hint: apiT.github.form.tokenPlaceholder,
                          obscureText: !_showToken,
                        ),
                        IconButton(
                          tooltip: _showToken ? 'Hide token' : 'Show token',
                          icon: Icon(
                            _showToken ? LucideIcons.eyeOff : LucideIcons.eye,
                            size: 16,
                            color: c.mutedForeground,
                          ),
                          onPressed: () => setState(() => _showToken = !_showToken),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppInput(
                      controller: _ghDescription,
                      hint: apiT.github.form.descriptionPlaceholder,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      spacing: AppSpacing.sm,
                      children: [
                        AppButton(
                          size: AppButtonSize.sm,
                          onPressed: _createGithubCredential,
                          child: Text(apiT.github.form.addButton),
                        ),
                        AppButton(
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.sm,
                          onPressed: () => setState(() {
                            _showGithubForm = false;
                            _ghName.clear();
                            _ghToken.clear();
                            _ghDescription.clear();
                            _showToken = false;
                          }),
                          child: Text(apiT.github.form.cancelButton),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => unawaited(
                          launchUrl(
                            Uri.parse('https://github.com/settings/tokens'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                        child: Text(
                          apiT.github.form.howToCreate,
                          style: tt.bodySmall?.copyWith(color: c.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            if (state.githubCredentials.isEmpty)
              _EmptyState(icon: LucideIcons.gitBranch, title: apiT.github.empty)
            else
              for (final credential in state.githubCredentials)
                _GithubCredentialRow(
                  credential: credential,
                  onToggle: () async => _report(await _ctrl.toggleGithubCredential(credential)),
                  onDelete: () => _deleteGithubCredential(credential),
                ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        const _SttSection(),
      ],
    );
  }
}

/// Yellow "save it now" card — port of `NewApiKeyAlert.tsx`: full key + copy
/// button + dismiss; visible only until "I've saved it".
class _NewApiKeyCard extends StatefulWidget {
  const _NewApiKeyCard({required this.apiKey, required this.onDismiss});

  final CreatedApiKey apiKey;
  final VoidCallback onDismiss;

  @override
  State<_NewApiKeyCard> createState() => _NewApiKeyCardState();
}

class _NewApiKeyCardState extends State<_NewApiKeyCard> {
  bool _copied = false;
  Timer? _copiedTimer;

  @override
  void dispose() {
    _copiedTimer?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.apiKey.key));
    _copiedTimer?.cancel();
    _copiedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
    setState(() => _copied = true);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    const amber = Color(0xFFEAB308);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: amber.withValues(alpha: 0.1),
        border: Border.all(color: amber.withValues(alpha: 0.2)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.settings.apiKeys.newKey.alertTitle, style: tt.titleSmall?.copyWith(color: amber)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.settings.apiKeys.newKey.alertMessage,
            style: tt.bodySmall?.copyWith(color: c.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: c.background.withValues(alpha: 0.5),
                    borderRadius: AppRadii.borderSm,
                  ),
                  child: Text(
                    widget.apiKey.key,
                    style: tt.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Tooltip(
                message: _copied ? 'Copied' : 'Copy',
                child: AppButton(
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.sm,
                  onPressed: _copy,
                  child: Icon(_copied ? LucideIcons.check : LucideIcons.copy, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.sm,
            onPressed: widget.onDismiss,
            child: Text(t.settings.apiKeys.newKey.iveSavedIt),
          ),
        ],
      ),
    );
  }
}

class _ApiDocsLink extends ConsumerWidget {
  const _ApiDocsLink();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final baseUrl = ref.watch(serverBaseUrlProvider);
    return InkWell(
      onTap: baseUrl.isEmpty
          ? null
          : () => unawaited(
              launchUrl(Uri.parse('$baseUrl/api-docs.html'), mode: LaunchMode.externalApplication),
            ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.xs,
        children: [
          Text(t.settings.apiKeys.apiDocsLink, style: tt.bodySmall?.copyWith(color: c.primary)),
          Icon(LucideIcons.externalLink, size: 12, color: c.primary),
        ],
      ),
    );
  }
}

class _ApiKeyRow extends StatelessWidget {
  const _ApiKeyRow({
    super.key,
    required this.entry,
    required this.onToggle,
    required this.onDelete,
  });

  final ApiKeyEntry entry;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name, style: tt.bodyMedium),
                  Text(
                    entry.maskedKey,
                    style: tt.bodySmall?.copyWith(
                      color: c.mutedForeground,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _keySubtitle(context, entry, t),
                    style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ),
            ),
            AppButton(
              variant: entry.isActive ? AppButtonVariant.outline : AppButtonVariant.secondary,
              size: AppButtonSize.sm,
              onPressed: onToggle,
              child: Text(
                entry.isActive
                    ? t.settings.apiKeys.status.active
                    : t.settings.apiKeys.status.inactive,
              ),
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(LucideIcons.trash2, size: 16),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _GithubCredentialRow extends StatelessWidget {
  const _GithubCredentialRow({
    required this.credential,
    required this.onToggle,
    required this.onDelete,
  });

  final GithubCredentialEntry credential;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(credential.name, style: tt.bodyMedium),
                  if (credential.description != null && credential.description!.isNotEmpty)
                    Text(
                      credential.description!,
                      style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${t.settings.apiKeys.github.added} ${_formatDate(context, credential.createdAt)}',
                    style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ),
            ),
            AppButton(
              variant: credential.isActive ? AppButtonVariant.outline : AppButtonVariant.secondary,
              size: AppButtonSize.sm,
              onPressed: onToggle,
              child: Text(
                credential.isActive
                    ? t.settings.apiKeys.status.active
                    : t.settings.apiKeys.status.inactive,
              ),
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(LucideIcons.trash2, size: 16),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Voice input card — port of `SttConfigSection.tsx`; the form itself lives in
/// the existing [SttConfigDialog] (same fields, same provider).
class _SttSection extends ConsumerWidget {
  const _SttSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final config = ref.watch(sttConfigProvider);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.mic, size: 16, color: c.foreground),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(t.settings.stt.title, style: tt.titleSmall)),
              if (config.configured)
                Text(
                  t.settings.stt.configured,
                  style: tt.labelSmall?.copyWith(color: Colors.green),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(t.settings.stt.description, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
              onPressed: () => SttConfigDialog.show(context),
              child: const Text('Configure'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Icon(icon, size: 24, color: c.mutedForeground),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
        ],
      ),
    );
  }
}

String _keySubtitle(BuildContext context, ApiKeyEntry entry, Translations t) {
  final created = _formatDate(context, entry.createdAt);
  final lastUsed = _formatDate(context, entry.lastUsed);
  var text = '${t.settings.apiKeys.list.created} $created';
  if (lastUsed.isNotEmpty) {
    text += ' - ${t.settings.apiKeys.list.lastUsed} $lastUsed';
  }
  return text;
}

String _formatDate(BuildContext context, String? raw) {
  final parsed = raw == null ? null : DateTime.tryParse(raw);
  if (parsed == null) return '';
  return MaterialLocalizations.of(context).formatShortDate(parsed.toLocal());
}
