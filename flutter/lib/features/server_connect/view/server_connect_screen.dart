import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:ddagent_app/features/server_connect/data/local_server_status.dart';
import 'package:ddagent_app/features/server_connect/data/server_profiles.dart';
import 'package:ddagent_app/features/server_connect/state/local_server_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Server connect — URL entry + /auth/status probe + saved profiles
/// (multi-server parity with the RN client's server list).
class ServerConnectScreen extends ConsumerStatefulWidget {
  const ServerConnectScreen({super.key});

  @override
  ConsumerState<ServerConnectScreen> createState() => _ServerConnectScreenState();
}

class _ServerConnectScreenState extends ConsumerState<ServerConnectScreen> {
  final _url = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _connect([String? preset, bool isLocal = false]) async {
    final i18n = Translations.of(context);
    final url = preset ?? _url.text;
    if (url.trim().isEmpty) {
      setState(() => _error = i18n.serverConnect.enterUrl);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    // _busy gates the only retry affordance (the button is disabled while
    // loading), so it must always be cleared — otherwise any throw or stall
    // below leaves the screen spinning forever with no way back.
    var navigated = false;
    try {
      if (isLocal) {
        // Saved local profile: the server may be stopped — start it before
        // probing. ensureRunning is a no-op when it's already up.
        await ref.read(localServerProvider.notifier).ensureRunning();
        if (!mounted) return;
      }
      final probe = await probeServer(url);
      if (!mounted) return;
      if (!probe.ok) {
        setState(() => _error = i18n.serverConnect.connectionFailed(error: probe.error ?? ''));
        return;
      }
      // A different server won't accept the current JWT — drop it so the
      // login flow on the new server starts clean.
      if (normalizeServerUrl(url) != ref.read(serverProfilesProvider).activeUrl) {
        await ref.read(authTokenStoreProvider).clear();
      }
      await ref
          .read(serverProfilesProvider.notifier)
          .select(url, name: isLocal ? i18n.serverConnect.local.title : '', isLocal: isLocal);
      // Re-check status against the new server — may flip needsSetup → /setup.
      await ref.read(authControllerProvider.notifier).checkStatus();
      if (!mounted) return;
      final from = GoRouterState.of(context).uri.queryParameters['from'];
      context.go(from != null && from.startsWith('/') ? from : '/login');
      navigated = true;
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = i18n.serverConnect.connectionFailed(error: '$e'));
      }
    } finally {
      if (mounted && !navigated) setState(() => _busy = false);
    }
  }

  Future<void> _remove(String url) async {
    await ref.read(serverProfilesProvider.notifier).remove(url);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final i18n = Translations.of(context);
    final c = context.appColors;
    final profilesState = ref.watch(serverProfilesProvider);
    final profiles = profilesState.profiles;
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
                      i18n.sidebar.app.title,
                      style: t.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      i18n.serverConnect.subtitle,
                      style: t.textTheme.bodyMedium?.copyWith(color: c.mutedForeground),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (!kIsWeb &&
                        (defaultTargetPlatform == TargetPlatform.windows ||
                            defaultTargetPlatform == TargetPlatform.linux)) ...[
                      _LocalServerCard(onConnect: (url) => _connect(url, true)),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            child: Text(
                              i18n.serverConnect.local.or,
                              style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    if (profiles.isNotEmpty) ...[
                      for (final p in profiles)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          selected: p.url == profilesState.activeUrl,
                          leading: Icon(
                            p.isLocal ? Icons.dns_outlined : Icons.cloud_outlined,
                            size: 18,
                            color: c.mutedForeground,
                          ),
                          title: Text(p.label, overflow: TextOverflow.ellipsis),
                          subtitle: p.label == p.url
                              ? null
                              : Text(p.url, overflow: TextOverflow.ellipsis),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            tooltip: i18n.common.gitPanel.remove,
                            onPressed: () => _remove(p.url),
                          ),
                          onTap: _busy ? null : () => _connect(p.url, p.isLocal),
                        ),
                      const Divider(height: AppSpacing.lg),
                    ],
                    AppInput(
                      controller: _url,
                      hint: 'https://your-server:10087',
                      keyboardType: TextInputType.url,
                      autofocus: profiles.isEmpty,
                      onSubmitted: (_) => _connect(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(_error!, style: TextStyle(color: c.destructive)),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      onPressed: _connect,
                      loading: _busy,
                      child: Text(
                        _busy ? i18n.serverConnect.connecting : i18n.serverConnect.connect,
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

/// "This device" option — downloads/spawns the ddagent server locally and
/// connects to it over loopback. Rendered only on Linux/Windows desktop.
class _LocalServerCard extends ConsumerWidget {
  const _LocalServerCard({required this.onConnect});

  final void Function(String url) onConnect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final c = context.appColors;
    final local = Translations.of(context).serverConnect.local;
    final s = ref.watch(localServerProvider);
    final busy = switch (s.stage) {
      LocalServerStage.downloading ||
      LocalServerStage.installing ||
      LocalServerStage.starting ||
      LocalServerStage.checking => true,
      _ => false,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.dns_outlined, size: 20, color: c.mutedForeground),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(local.title, style: t.textTheme.titleSmall),
                    Text(
                      switch (s.stage) {
                        LocalServerStage.running => local.running(url: s.url ?? ''),
                        LocalServerStage.stopped =>
                          s.version != null ? local.installed(version: s.version!) : local.subtitle,
                        LocalServerStage.error => local.error(error: s.message ?? ''),
                        _ => local.subtitle,
                      },
                      style: t.textTheme.bodySmall?.copyWith(
                        color: s.stage == LocalServerStage.error
                            ? c.destructive
                            : c.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (s.stage == LocalServerStage.downloading) ...[
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: s.progress > 0 ? s.progress : null),
            const SizedBox(height: AppSpacing.xs),
            Text(
              local.downloading(percent: (s.progress * 100).round()),
              style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
            ),
          ] else if (s.stage == LocalServerStage.installing ||
              s.stage == LocalServerStage.starting ||
              s.stage == LocalServerStage.checking) ...[
            const SizedBox(height: AppSpacing.sm),
            const LinearProgressIndicator(),
            const SizedBox(height: AppSpacing.xs),
            Text(
              s.stage == LocalServerStage.installing ? local.installing : local.starting,
              style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            loading: busy,
            onPressed: () async {
              final ctrl = ref.read(localServerProvider.notifier);
              try {
                switch (s.stage) {
                  case LocalServerStage.running:
                    onConnect(s.url ?? kLocalServerUrl);
                  case LocalServerStage.stopped ||
                      LocalServerStage.notInstalled ||
                      LocalServerStage.error:
                    final url = await ctrl.installAndStart();
                    if (context.mounted) onConnect(url);
                  case LocalServerStage.unsupported ||
                      LocalServerStage.checking ||
                      LocalServerStage.downloading ||
                      LocalServerStage.installing ||
                      LocalServerStage.starting:
                    break;
                }
              } on Object catch (_) {
                // Error state + message live in the controller.
              }
            },
            child: Text(switch (s.stage) {
              LocalServerStage.running => local.connect,
              LocalServerStage.stopped => local.start,
              LocalServerStage.downloading => local.downloading(
                percent: (s.progress * 100).round(),
              ),
              LocalServerStage.installing => local.installing,
              LocalServerStage.starting || LocalServerStage.checking => local.starting,
              _ => local.install,
            }),
          ),
        ],
      ),
    );
  }
}
