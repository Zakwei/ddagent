import 'dart:async';

import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/features/settings/state/locale_controller.dart';
import 'package:ddagent_app/features/settings/view/sections/general_section.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/system_providers.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

const _githubRepoUrl = 'https://github.com/Zakwei/ddagent';
const _discordUrl = 'https://discord.gg/buxwujPNRE';
const _docsUrl = 'https://github.com/Zakwei/ddagent/docs';
const _coffeeUrl = 'https://buymeacoffee.com/ddnet';
const _releasesUrl = '$_githubRepoUrl/releases';

/// About section — port of `AboutTab.tsx` + `UpdateCheckSection` +
/// `RestartSection` + `ChangelogSection`. `GeneralSectionContent` rides on
/// top — the web has no "general" tab, so the account card lives here.
class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const GeneralSectionContent(),
        const SizedBox(height: AppSpacing.xl),
        const _BrandHeader(),
        const SizedBox(height: AppSpacing.md),
        const _LinksBlock(),
        const SizedBox(height: AppSpacing.xl),
        const _UpdateCheckBlock(),
        Divider(height: AppSpacing.xl * 2, color: context.appColors.border),
        const _RestartBlock(),
        Divider(height: AppSpacing.xl * 2, color: context.appColors.border),
        const _ChangelogBlock(),
        Divider(height: AppSpacing.xl * 2, color: context.appColors.border),
        Text(
          '© 2026 ddagent — all rights reserved',
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: context.appColors.mutedForeground.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}

void _openUrl(String url) =>
    unawaited(launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication));

/// Logo + wordmark + server-version badge + "update available" chip —
/// the header row of `AboutTab`.
class _BrandHeader extends ConsumerWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final t = Translations.of(context);
    final health = ref.watch(serverHealthProvider).value;
    final release = ref.watch(latestReleaseProvider).value;
    final version = health?['version']?.toString() ?? '';
    final latest = release?.tagName.replaceFirst(RegExp('^v'), '') ?? '';
    final updateAvailable =
        version.isNotEmpty && latest.isNotEmpty && compareVersions(latest, version) > 0;

    return Row(
      spacing: AppSpacing.md,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: c.primary.withValues(alpha: 0.9),
            borderRadius: AppRadii.borderLg,
          ),
          child: Icon(LucideIcons.messageSquare, size: 20, color: c.primaryForeground),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: AppSpacing.sm,
                children: [
                  Flexible(
                    child: Text(
                      'ddagent',
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (version.isNotEmpty)
                    InkWell(
                      onTap: () => _openUrl(_releasesUrl),
                      borderRadius: AppRadii.borderMd,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                        decoration: BoxDecoration(color: c.muted, borderRadius: AppRadii.borderMd),
                        child: Text(
                          'v$version',
                          style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                        ),
                      ),
                    ),
                  if (updateAvailable)
                    Flexible(
                      child: InkWell(
                        onTap: () => _openUrl(_releasesUrl),
                        borderRadius: AppRadii.borderMd,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: AppRadii.borderMd,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 2,
                            children: [
                              Flexible(
                                child: Text(
                                  t.settings.apiKeys.version.updateAvailable(version: latest),
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.labelSmall?.copyWith(
                                    color: Colors.green.shade700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Icon(
                                LucideIcons.externalLink,
                                size: 10,
                                color: Colors.green.shade700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Open-source AI coding assistant interface',
                overflow: TextOverflow.ellipsis,
                style: tt.bodySmall?.copyWith(color: c.mutedForeground),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Star/coffee buttons, the link row, and the OSS-only "ddagent Hosted" CTA +
/// Pro placeholder cards (all gated on `!Env.embedded` — `!IS_PLATFORM`
/// parity).
class _LinksBlock extends StatelessWidget {
  const _LinksBlock();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings.about;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;

    Widget linkButton(String url, IconData icon, String label, {Color? tint}) => InkWell(
      onTap: () => _openUrl(url),
      borderRadius: AppRadii.borderMd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: tint?.withValues(alpha: 0.1) ?? c.background,
          border: Border.all(
            color: tint?.withValues(alpha: 0.3) ?? c.border.withValues(alpha: 0.6),
          ),
          borderRadius: AppRadii.borderMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            Icon(icon, size: 14, color: tint ?? c.mutedForeground),
            Text(
              label,
              style: tt.bodySmall?.copyWith(
                color: tint ?? c.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

    Widget textLink(String url, IconData icon, String label) => InkWell(
      onTap: () => _openUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            Icon(icon, size: 14, color: c.mutedForeground),
            Text(label, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            linkButton(_githubRepoUrl, LucideIcons.star, 'Star on GitHub'),
            linkButton(
              _coffeeUrl,
              LucideIcons.coffee,
              t.buyMeACoffee,
              tint: const Color(0xFFD97706),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            textLink(_githubRepoUrl, LucideIcons.gitBranch, 'GitHub'),
            textLink(_discordUrl, LucideIcons.messageSquare, 'Discord'),
            textLink(_coffeeUrl, LucideIcons.coffee, t.buyMeACoffee),
            textLink(_docsUrl, LucideIcons.externalLink, 'Docs'),
            textLink(_githubRepoUrl, LucideIcons.externalLink, 'ddagent'),
          ],
        ),
        if (!Env.embedded) ...[
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.05),
              border: Border.all(color: c.primary.withValues(alpha: 0.1)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.tryHosted, style: tt.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Team collaboration, shared MCP configs, settings sync '
                  'across environments, and managed infrastructure.',
                  style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                ),
                const SizedBox(height: AppSpacing.sm),
                InkWell(
                  onTap: () => _openUrl(_githubRepoUrl),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [
                      Text(t.learnMore, style: tt.labelSmall?.copyWith(color: c.primary)),
                      Icon(LucideIcons.externalLink, size: 12, color: c.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(t.proFeatures, style: tt.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          _ProCard(
            icon: LucideIcons.cloud,
            title: t.pro.syncSettings,
            description:
                'Keep your preferences, MCP configs, and theme in sync '
                'across all your environments.',
          ),
          const SizedBox(height: AppSpacing.sm),
          _ProCard(
            icon: LucideIcons.users,
            title: t.pro.teamManagement,
            description:
                'Multiple users, role-based access, and shared projects '
                'for your team.',
          ),
        ],
      ],
    );
  }
}

/// `PremiumFeatureCard.tsx` — dashed-border Pro placeholder card.
class _ProCard extends StatelessWidget {
  const _ProCard({required this.icon, required this.title, required this.description});

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.2),
        border: Border.all(color: c.border.withValues(alpha: 0.6)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.6),
              borderRadius: AppRadii.borderMd,
            ),
            child: Icon(icon, size: 18, color: c.mutedForeground),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: AppSpacing.xs,
                  children: [
                    Flexible(child: Text(title, style: tt.titleSmall)),
                    Icon(
                      LucideIcons.lock,
                      size: 12,
                      color: c.mutedForeground.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(description, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
                const SizedBox(height: AppSpacing.sm),
                InkWell(
                  onTap: () => _openUrl(_githubRepoUrl),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [
                      Flexible(
                        child: Text(
                          'Available with ddagent Pro',
                          style: tt.labelSmall?.copyWith(color: c.primary),
                        ),
                      ),
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

enum _CheckStatus { idle, checking, upToDate, updateAvailable, error }

/// "App updates" — the web's `UpdateCheckSection` talks to the Electron
/// bridge, which doesn't exist here; the equivalent for a remote client is
/// `GET /api/system/latest-release` (server-side GitHub check, same as
/// `useVersionCheck`) compared against the server's running version.
class _UpdateCheckBlock extends ConsumerStatefulWidget {
  const _UpdateCheckBlock();

  @override
  ConsumerState<_UpdateCheckBlock> createState() => _UpdateCheckBlockState();
}

class _UpdateCheckBlockState extends ConsumerState<_UpdateCheckBlock> {
  _CheckStatus _status = _CheckStatus.idle;
  String _detail = '';

  Future<void> _check() async {
    setState(() {
      _status = _CheckStatus.checking;
      _detail = '';
    });
    try {
      final repo = ref.read(systemRepositoryProvider);
      final results = await Future.wait<Object?>([repo.health(), repo.latestRelease()]);
      if (!mounted) return;
      final health = results[0] as Map<String, dynamic>;
      final release = results[1] as Release?;
      final current = health['version']?.toString() ?? '';
      final latest = release?.tagName.replaceFirst(RegExp('^v'), '') ?? '';
      setState(() {
        if (latest.isEmpty) {
          _status = _CheckStatus.upToDate;
        } else if (current.isNotEmpty && compareVersions(latest, current) > 0) {
          _status = _CheckStatus.updateAvailable;
          _detail = latest;
        } else {
          _status = _CheckStatus.upToDate;
          _detail = current;
        }
      });
      ref
        ..invalidate(serverHealthProvider)
        ..invalidate(latestReleaseProvider);
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _status = _CheckStatus.error;
          _detail = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;

    String? result;
    var good = false;
    switch (_status) {
      case _CheckStatus.upToDate:
        result = t.updates.upToDate(version: _detail);
        good = true;
      case _CheckStatus.updateAvailable:
        result = t.apiKeys.version.updateAvailable(version: _detail);
        good = true;
      case _CheckStatus.error:
        result = _detail.isEmpty ? t.updates.errorGeneric : t.updates.error(message: _detail);
      case _CheckStatus.idle || _CheckStatus.checking:
        result = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: AppSpacing.md,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: AppSpacing.sm,
                    children: [
                      Icon(LucideIcons.arrowDownToLine, size: 16, color: c.mutedForeground),
                      Text(t.updates.title, style: tt.titleSmall),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    t.updates.description,
                    style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ),
            ),
            AppButton(
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
              loading: _status == _CheckStatus.checking,
              onPressed: () => unawaited(_check()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.xs,
                children: [
                  const Icon(LucideIcons.refreshCw, size: 12),
                  Text(_status == _CheckStatus.checking ? t.updates.checking : t.updates.check),
                ],
              ),
            ),
          ],
        ),
        if (result != null) ...[
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: _status == _CheckStatus.updateAvailable ? () => _openUrl(_releasesUrl) : null,
            child: Text(
              result,
              style: tt.labelSmall?.copyWith(
                color: _status == _CheckStatus.error
                    ? c.destructive
                    : good
                    ? Colors.green.shade700
                    : c.mutedForeground,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

enum _RestartStatus { restarting, back, unsupported, failed }

/// "Server" — port of `RestartSection.tsx`: confirm → `POST
/// /api/system/restart` → poll `/health` until the process is back (the web
/// reloads the page; here we re-read the health provider so the version
/// badge refreshes).
class _RestartBlock extends ConsumerStatefulWidget {
  const _RestartBlock();

  @override
  ConsumerState<_RestartBlock> createState() => _RestartBlockState();
}

class _RestartBlockState extends ConsumerState<_RestartBlock> {
  static const _pollInterval = Duration(seconds: 1);
  static const _timeout = Duration(seconds: 60);

  Future<void> _confirmAndRestart() async {
    final t = Translations.of(context).settings.server;
    final confirmed = await AppDialog.confirm(
      context,
      title: t.restart,
      message: t.restartConfirm,
      confirmLabel: t.restart,
    );
    if (!confirmed || !mounted) return;

    var status = _RestartStatus.restarting;
    String? detail;

    try {
      final restarting = await ref.read(systemRepositoryProvider).restart();
      if (!restarting) status = _RestartStatus.unsupported;
    } on Object catch (e) {
      // The process exits right after responding — a transport error after a
      // successful hand-off is expected; only a fast failure is fatal.
      detail = e.toString();
    }

    if (!mounted) return;
    if (status == _RestartStatus.unsupported) {
      unawaited(_showResultDialog(_RestartStatus.unsupported, null));
      return;
    }

    // Poll /health until the watchdog brings the process back.
    final startedAt = DateTime.now();
    var back = false;
    while (DateTime.now().difference(startedAt) < _timeout) {
      await Future<void>.delayed(_pollInterval);
      try {
        await ref.read(systemRepositoryProvider).health();
        if (DateTime.now().difference(startedAt).inMilliseconds > 1500) {
          back = true;
          break;
        }
      } on Object {
        // Server down mid-restart — keep polling until the deadline.
      }
      if (!mounted) return;
    }
    if (!mounted) return;
    if (back) {
      ref.invalidate(serverHealthProvider);
      unawaited(_showResultDialog(_RestartStatus.back, null));
    } else {
      unawaited(_showResultDialog(_RestartStatus.failed, detail));
    }
  }

  Future<void> _showResultDialog(_RestartStatus status, String? detail) {
    final t = Translations.of(context).settings.server;
    return AppDialog.show<void>(
      context,
      title: switch (status) {
        _RestartStatus.back => t.restart,
        _RestartStatus.unsupported => t.restart,
        _ => t.restartFailed,
      },
      content: Text(switch (status) {
        _RestartStatus.back => 'Server is back — health check responded after the restart.',
        _RestartStatus.unsupported => t.unsupported,
        _ => detail ?? t.restartFailed,
      }),
      actions: [AppButton(onPressed: () => AppDialog.pop(context), child: Text(t.ok))],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings.server;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Row(
      spacing: AppSpacing.md,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: AppSpacing.sm,
                children: [
                  Icon(LucideIcons.server, size: 16, color: c.mutedForeground),
                  Text(t.title, style: tt.titleSmall),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(t.description, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
            ],
          ),
        ),
        AppButton(
          variant: AppButtonVariant.outline,
          size: AppButtonSize.sm,
          onPressed: () => unawaited(_confirmAndRestart()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xs,
            children: [const Icon(LucideIcons.rotateCw, size: 12), Text(t.restart)],
          ),
        ),
      ],
    );
  }
}

/// Changelog — port of `ChangelogSection.tsx`: `GET /api/system/releases`,
/// per-locale note extraction from `<!-- lang:xx -->` sections, current/new
/// badges vs the server's running version, markdown bodies.
class _ChangelogBlock extends ConsumerWidget {
  const _ChangelogBlock();

  static final _langPattern = RegExp('<!--\\s*lang:([a-zA-Z-]+)\\s*-->');

  /// `localizedNotes` port — split the body on lang markers; pick the active
  /// UI language, then its base tag, then `en`, then the raw body.
  static String _localizedNotes(String body, String language) {
    final matches = _langPattern.allMatches(body).toList();
    if (matches.isEmpty) return body.trim();
    final byLang = <String, String>{};
    for (var i = 0; i < matches.length; i++) {
      final start = matches[i].end;
      final end = i + 1 < matches.length ? matches[i + 1].start : body.length;
      byLang[matches[i].group(1)!.toLowerCase()] = body.substring(start, end).trim();
    }
    final lang = language.toLowerCase();
    return byLang[lang] ?? byLang[lang.split('-').first] ?? byLang['en'] ?? body.trim();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context).settings.changelog;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final langTag = ref.watch(localeProvider).languageTag;
    final currentVersion = ref.watch(serverHealthProvider).value?['version']?.toString() ?? '';
    final releases = ref.watch(releasesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: AppSpacing.sm,
          children: [
            Icon(LucideIcons.scrollText, size: 16, color: c.mutedForeground),
            Text(t.title, style: tt.titleSmall),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        releases.when(
          loading: () => Row(
            spacing: AppSpacing.sm,
            children: [
              const SizedBox.square(
                dimension: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              Text(t.loading, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
            ],
          ),
          error: (_, _) => Text(t.empty, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
          data: (list) => list.isEmpty
              ? Text(t.empty, style: tt.labelSmall?.copyWith(color: c.mutedForeground))
              : SizedBox(
                  // max-h-96 parity with the web scrollbox.
                  height: 384,
                  child: ListView(
                    children: [
                      for (final release in list)
                        _ReleaseCard(
                          release: release,
                          currentVersion: currentVersion,
                          language: langTag,
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _ReleaseCard extends StatelessWidget {
  const _ReleaseCard({required this.release, required this.currentVersion, required this.language});

  final Release release;
  final String currentVersion;
  final String language;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings.changelog;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final tag = release.tagName.replaceFirst(RegExp('^v'), '');
    final isCurrent = currentVersion.isNotEmpty && compareVersions(tag, currentVersion) == 0;
    final isNewer = currentVersion.isNotEmpty && compareVersions(tag, currentVersion) > 0;
    final published = DateTime.tryParse(release.publishedAt ?? '');

    Widget badge(String label, Color fg) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: fg.withValues(alpha: 0.1), borderRadius: AppRadii.borderMd),
      child: Text(label, style: tt.labelSmall?.copyWith(color: fg, fontSize: 10)),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: c.background.withValues(alpha: 0.6),
          border: Border.all(color: c.border.withValues(alpha: 0.6)),
          borderRadius: AppRadii.borderMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: AppSpacing.sm,
              children: [
                InkWell(
                  onTap: () => _openUrl('$_githubRepoUrl/releases/tag/${release.tagName}'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [
                      Text(
                        release.tagName,
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: c.primary,
                        ),
                      ),
                      Icon(LucideIcons.externalLink, size: 12, color: c.primary),
                    ],
                  ),
                ),
                if (isCurrent) badge(t.current, c.mutedForeground),
                if (isNewer) badge(t.kNew, Colors.green.shade700),
                if (published != null) ...[
                  const Spacer(),
                  Text(
                    MaterialLocalizations.of(context).formatShortDate(published.toLocal()),
                    style: tt.labelSmall?.copyWith(color: c.mutedForeground, fontSize: 11),
                  ),
                ],
              ],
            ),
            if ((release.body ?? '').isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              AppMarkdown(
                data: _ChangelogBlock._localizedNotes(release.body ?? '', language),
                selectable: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
