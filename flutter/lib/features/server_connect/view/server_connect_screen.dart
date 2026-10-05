import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:ddagent_app/features/server_connect/data/server_profiles.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
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

  Future<void> _connect([String? preset]) async {
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
    final probe = await probeServer(url);
    if (!mounted) return;
    if (!probe.ok) {
      setState(() {
        _busy = false;
        _error = i18n.serverConnect.connectionFailed(error: probe.error ?? '');
      });
      return;
    }
    await ref.read(serverProfilesProvider.notifier).select(url);
    // Re-check status against the new server — may flip needsSetup → /setup.
    await ref.read(authControllerProvider.notifier).checkStatus();
    if (!mounted) return;
    final from = GoRouterState.of(context).uri.queryParameters['from'];
    context.go(from != null && from.startsWith('/') ? from : '/login');
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
    final profiles = ref.watch(serverProfilesProvider).profiles;
    return Scaffold(
      body: Center(
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
                  if (profiles.isNotEmpty) ...[
                    for (final p in profiles)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(p.label, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          tooltip: i18n.common.gitPanel.remove,
                          onPressed: () => _remove(p.url),
                        ),
                        onTap: _busy ? null : () => _connect(p.url),
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
                    child: Text(_busy ? i18n.serverConnect.connecting : i18n.serverConnect.connect),
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
