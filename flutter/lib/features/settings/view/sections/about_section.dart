import 'dart:async';

import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/app_reload.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/core/widgets/update_badge.dart'
    show showUpdateDialog, updateTargetAction;
import 'package:ddagent_app/features/server_connect/data/server_profiles.dart';
import 'package:ddagent_app/features/settings/state/locale_controller.dart';
import 'package:ddagent_app/features/settings/view/sections/general_section.dart';
import 'package:ddagent_app/features/system/data/app_update_channel.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/system_providers.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart'
    show
        DesktopUpdateStage,
        UpdateTarget,
        activeServerIsLocalProvider,
        appUpdateChannelProvider,
        appVersionProvider,
        availableUpdatesProvider,
        desktopUpdateProvider,
        normalizeVersion;
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
        const _VersionInfoBlock(),
        const SizedBox(height: AppSpacing.xl),
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

/// Running client build's version/build number. Null on platforms/tests where
/// `PackageInfo` is unavailable, so the block renders a placeholder instead.
final _packageInfoProvider = FutureProvider<PackageInfo?>((ref) async {
  try {
    return await PackageInfo.fromPlatform();
  } on Object {
    return null;
  }
});

enum _ClientKind { mobile, desktop, web }

/// Whether the running build is a mobile, desktop or web client.
_ClientKind _currentClientKind() {
  if (kIsWeb) return _ClientKind.web;
  return switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS => _ClientKind.mobile,
    _ => _ClientKind.desktop,
  };
}

/// Human-readable name of the platform the client runs on.
String _currentPlatformName() {
  if (kIsWeb) return 'Web';
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => 'Android',
    TargetPlatform.iOS => 'iOS',
    TargetPlatform.macOS => 'macOS',
    TargetPlatform.windows => 'Windows',
    TargetPlatform.linux => 'Linux',
    TargetPlatform.fuchsia => 'Fuchsia',
  };
}

/// `host[:port]` of a configured server URL, or null when unset/malformed.
String? _serverHost(String? url) {
  final trimmed = url?.trim() ?? '';
  if (trimmed.isEmpty) return null;
  final uri = Uri.tryParse(trimmed);
  if (uri == null || uri.host.isEmpty) return trimmed;
  return uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
}

/// Version markers — which client build (mobile/desktop/web + platform + app
/// version) is talking to which server version and host. Mobile and desktop
/// builds are indistinguishable otherwise.
class _VersionInfoBlock extends ConsumerWidget {
  const _VersionInfoBlock();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context).settings.about;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;

    final info = ref.watch(_packageInfoProvider).value;
    final health = ref.watch(serverHealthProvider).value;
    final serverVersion = health?['version']?.toString() ?? '';
    final serverHost = _serverHost(ref.watch(serverProfilesProvider).activeUrl);

    final kind = _currentClientKind();
    final kindLabel = switch (kind) {
      _ClientKind.mobile => t.platformMobile,
      _ClientKind.desktop => t.platformDesktop,
      _ClientKind.web => t.platformWeb,
    };
    final clientIcon = switch (kind) {
      _ClientKind.mobile => LucideIcons.smartphone,
      _ClientKind.desktop => LucideIcons.monitor,
      _ClientKind.web => LucideIcons.globe,
    };
    final clientVersion = info == null
        ? '…'
        : 'v${info.version}${info.buildNumber.isEmpty ? '' : ' (${info.buildNumber})'}';

    Widget row(IconData icon, String label, String value, String? secondary) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 16, color: c.mutedForeground),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
              Text(value, style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              if (secondary != null && secondary.isNotEmpty)
                Text(secondary, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
            ],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: AppSpacing.sm,
          children: [
            Icon(LucideIcons.info, size: 16, color: c.mutedForeground),
            Text(t.versionInfo, style: tt.titleSmall),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: c.border.withValues(alpha: 0.6)),
            borderRadius: AppRadii.borderLg,
          ),
          child: Column(
            children: [
              row(clientIcon, t.client, '$kindLabel · ${_currentPlatformName()}', clientVersion),
              Divider(height: AppSpacing.lg, color: c.border.withValues(alpha: 0.4)),
              row(
                LucideIcons.server,
                t.server,
                serverVersion.isEmpty ? t.unknown : 'v$serverVersion',
                serverHost,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
            textLink(_githubRepoUrl, LucideIcons.externalLink, 'DDAgent'),
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

/// "Updates" — one row per thing this client can update, each with its own
/// button ([UpdateDialog] does the work):
///
/// * this app (Android APK, desktop build — staged in the background and
///   installed on quit), or on the web the web interface, which the server
///   replaces when it hosts it;
/// * the connected server — over the API, or for the desktop app's own local
///   server by re-installing it.
///
/// Versions come from the shared update providers, so this agrees with the
/// rail badge; Check re-reads all of them.
class _UpdateCheckBlock extends ConsumerStatefulWidget {
  const _UpdateCheckBlock();

  @override
  ConsumerState<_UpdateCheckBlock> createState() => _UpdateCheckBlockState();
}

class _UpdateCheckBlockState extends ConsumerState<_UpdateCheckBlock> {
  bool _checking = false;
  bool _failed = false;

  Future<void> _check() async {
    if (isDesktopChannel(ref.read(appUpdateChannelProvider))) {
      ref.read(desktopUpdateProvider.notifier).recheck();
    }
    setState(() {
      _checking = true;
      _failed = false;
    });
    ref
      ..invalidate(latestReleaseProvider)
      ..invalidate(appVersionProvider)
      ..invalidate(serverHealthProvider)
      ..invalidate(serverUpdateInfoProvider);
    Release? release;
    try {
      final results = await Future.wait<Object?>([
        ref.read(latestReleaseProvider.future),
        ref.read(appVersionProvider.future),
        ref.read(serverHealthProvider.future),
        ref.read(serverUpdateInfoProvider.future),
      ]);
      release = results.first as Release?;
    } on Object {
      release = null;
    }
    if (mounted) {
      setState(() {
        _checking = false;
        _failed = release == null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final u = t.settings.updates;

    final channel = ref.watch(appUpdateChannelProvider);
    final latest = normalizeVersion(ref.watch(latestReleaseProvider).value?.tagName ?? '');
    final appVersion = ref.watch(appVersionProvider).value ?? '';
    final serverVersion = ref.watch(serverHealthProvider).value?['version']?.toString() ?? '';
    final updateInfo = ref.watch(serverUpdateInfoProvider).value;
    final targets = ref.watch(availableUpdatesProvider);
    final desktop = ref.watch(desktopUpdateProvider);

    String versionLine(String installed) {
      if (installed.isEmpty) return '';
      return latest.isNotEmpty && compareVersions(latest, installed) > 0
          ? u.versionLine(installed: installed, latest: latest)
          : u.current(version: installed);
    }

    final rows = <Widget>[];

    // This app / the web interface.
    if (kIsWeb) {
      final webHosted = (updateInfo?['web'] as Map?)?['hosted'] == true;
      final behind = targets.contains(UpdateTarget.web);
      rows.add(
        _UpdateRow(
          label: t.common.update.targetWeb,
          status: versionLine(appVersion),
          hint: behind && !webHosted ? u.webNotHosted(version: latest) : null,
          target: behind && webHosted ? UpdateTarget.web : null,
        ),
      );
    } else if (channel == AppUpdateChannel.unsupported) {
      rows.add(_UpdateRow(label: t.common.update.targetApp, status: u.unavailable));
    } else {
      final behind = targets.contains(UpdateTarget.app);
      final status = !isDesktopChannel(channel)
          ? (behind ? u.appAvailable(version: latest) : versionLine(appVersion))
          : switch (desktop.stage) {
              DesktopUpdateStage.ready => u.downloaded(version: desktop.version),
              DesktopUpdateStage.downloading => u.available(version: desktop.version),
              DesktopUpdateStage.failed => u.error(message: desktop.error ?? u.errorGeneric),
              DesktopUpdateStage.idle => versionLine(appVersion),
            };
      rows.add(
        _UpdateRow(
          label: t.common.update.targetApp,
          status: status,
          error: isDesktopChannel(channel) && desktop.stage == DesktopUpdateStage.failed,
          target: behind ? UpdateTarget.app : null,
        ),
      );
    }

    // The connected server.
    final serverBehind = targets.contains(UpdateTarget.server);
    final serverInfo = updateInfo?['server'] as Map?;
    // Servers before 0.8.13 don't report update-info — offer the update and
    // let the server answer for itself.
    final serverCanUpdate =
        ref.watch(activeServerIsLocalProvider) ||
        serverInfo == null ||
        serverInfo['canUpdate'] == true;
    rows.add(
      _UpdateRow(
        label: t.common.update.targetServer,
        status: versionLine(serverVersion),
        hint: serverBehind && !serverCanUpdate ? u.serverCannotUpdate : null,
        target: serverBehind && serverCanUpdate ? UpdateTarget.server : null,
      ),
    );

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
                      Text(u.title, style: tt.titleSmall),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(switch (channel) {
                    AppUpdateChannel.android => u.descriptionMobile,
                    // Web and other builds that can't install themselves —
                    // what's left to update is the connected server.
                    AppUpdateChannel.unsupported => u.descriptionServer,
                    _ => u.description,
                  }, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
                ],
              ),
            ),
            AppButton(
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
              loading: _checking,
              onPressed: () => unawaited(_check()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.xs,
                children: [
                  const Icon(LucideIcons.refreshCw, size: 12),
                  Text(_checking ? u.checking : u.check),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...rows,
        if (_failed) Text(u.errorGeneric, style: tt.labelSmall?.copyWith(color: c.destructive)),
      ],
    );
  }
}

/// One updatable thing: its name, version status, an optional hint when it
/// can't be updated from here, and the button that opens its [UpdateDialog].
class _UpdateRow extends StatelessWidget {
  const _UpdateRow({
    required this.label,
    required this.status,
    this.hint,
    this.target,
    this.error = false,
  });

  final String label;
  final String status;
  final String? hint;
  final UpdateTarget? target;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final target = this.target;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: tt.labelMedium),
                if (status.isNotEmpty)
                  Text(
                    status,
                    style: tt.labelSmall?.copyWith(
                      color: error
                          ? c.destructive
                          : target != null
                          ? Colors.green.shade700
                          : c.mutedForeground,
                    ),
                  ),
                if (hint != null)
                  InkWell(
                    onTap: () => _openUrl(_releasesUrl),
                    child: Text(hint!, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
                  ),
              ],
            ),
          ),
          if (target != null)
            AppButton(
              size: AppButtonSize.sm,
              onPressed: () => unawaited(showUpdateDialog(context, target)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.xs,
                children: [
                  const Icon(LucideIcons.circleArrowUp, size: 12),
                  Text(updateTargetAction(t, target)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// "Server" — port of `RestartSection.tsx`: confirm, then a blocking progress
/// dialog ([_RestartProgressDialog]) asks the server to restart and waits
/// until a new process answers `/health`.
class _RestartBlock extends ConsumerStatefulWidget {
  const _RestartBlock();

  @override
  ConsumerState<_RestartBlock> createState() => _RestartBlockState();
}

class _RestartBlockState extends ConsumerState<_RestartBlock> {
  Future<void> _confirmAndRestart() async {
    final t = Translations.of(context).settings.server;
    final confirmed = await AppDialog.confirm(
      context,
      title: t.restart,
      message: t.restartConfirm,
      confirmLabel: t.restart,
    );
    if (!confirmed || !mounted) return;
    final back = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _RestartProgressDialog(),
    );
    // Desktop and mobile have no page to reload — refresh the version badge.
    if (back == true && mounted) ref.invalidate(serverHealthProvider);
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

enum _RestartPhase { requesting, waiting, back, unsupported, timedOut }

/// Restart progress, from the request until a new server process answers.
///
/// "Back" means `/health` reports a different `startedAt` than before the
/// restart — the old process can still answer for a moment after accepting
/// the request. Servers without `startedAt` count as back once they were
/// seen down and answer again. Pops `true` when the server came back.
class _RestartProgressDialog extends ConsumerStatefulWidget {
  const _RestartProgressDialog();

  @override
  ConsumerState<_RestartProgressDialog> createState() => _RestartProgressDialogState();
}

class _RestartProgressDialogState extends ConsumerState<_RestartProgressDialog> {
  static const _pollInterval = Duration(seconds: 1);
  // The watchdog waits 5 s before relaunching, then the server boots.
  static const _timeout = Duration(seconds: 120);
  // Long enough to read the result before the web tab reloads.
  static const _reloadDelay = Duration(milliseconds: 1500);

  var _phase = _RestartPhase.requesting;
  var _elapsed = 0;
  String? _version;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _run() async {
    final repo = ref.read(systemRepositoryProvider);
    String? before;
    try {
      before = (await repo.health())['startedAt']?.toString();
    } on Object {
      // Unknown start time — fall back to "seen down, then up".
    }
    try {
      if (!await repo.restart()) {
        _set(_RestartPhase.unsupported);
        return;
      }
    } on Object {
      // The process exits right after answering; a dropped connection here
      // usually means the restart is already under way. The wait decides.
    }
    if (!mounted) return;
    _set(_RestartPhase.waiting);
    final startedAt = DateTime.now();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed = DateTime.now().difference(startedAt).inSeconds);
    });

    var seenDown = false;
    while (DateTime.now().difference(startedAt) < _timeout) {
      await Future<void>.delayed(_pollInterval);
      if (!mounted) return;
      try {
        final health = await repo.health();
        final now = health['startedAt']?.toString();
        final isNewProcess = now != null && before != null ? now != before : seenDown;
        if (isNewProcess) {
          _version = health['version']?.toString();
          _ticker?.cancel();
          _set(_RestartPhase.back);
          await Future<void>.delayed(_reloadDelay);
          if (!mounted) return;
          // The web tab re-bootstraps against the new process; native clients
          // close the dialog and refresh their health state.
          if (!reloadClient()) Navigator.of(context).pop(true);
          return;
        }
      } on Object {
        seenDown = true;
      }
    }
    _ticker?.cancel();
    _set(_RestartPhase.timedOut);
  }

  void _set(_RestartPhase phase) {
    if (mounted) setState(() => _phase = phase);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings.server;
    final c = context.appColors;
    final done = switch (_phase) {
      _RestartPhase.unsupported || _RestartPhase.timedOut => true,
      _ => false,
    };
    final message = switch (_phase) {
      _RestartPhase.requesting => t.restartRequesting,
      _RestartPhase.waiting => t.restartWaiting(seconds: _elapsed),
      _RestartPhase.back =>
        '${t.restartBack(version: _version ?? '?')}${kIsWeb ? '\n${t.restartReloading}' : ''}',
      _RestartPhase.unsupported => t.unsupported,
      _RestartPhase.timedOut => t.restartTimeout(seconds: _timeout.inSeconds),
    };
    return PopScope(
      canPop: done,
      child: AppDialog(
        title: done && _phase == _RestartPhase.timedOut ? t.restartFailed : t.restartTitle,
        content: Row(
          spacing: AppSpacing.md,
          children: [
            switch (_phase) {
              _RestartPhase.back => const Icon(LucideIcons.circleCheck, color: Colors.green),
              _RestartPhase.unsupported ||
              _RestartPhase.timedOut => Icon(LucideIcons.circleAlert, color: c.destructive),
              _ => const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            },
            Expanded(child: Text(message)),
          ],
        ),
        actions: [
          if (done) AppButton(onPressed: () => Navigator.of(context).pop(false), child: Text(t.ok)),
        ],
      ),
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
