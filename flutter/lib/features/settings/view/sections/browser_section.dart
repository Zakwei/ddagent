import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/features/browser_use/data/browser_use_repository.dart';
import 'package:ddagent_app/features/browser_use/state/browser_use_controller.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Browser block — port of `browser-use-settings/BrowserUseSettingsTab.tsx`:
/// enable/disable toggle (`PUT /api/browser-use/settings`), runtime status
/// badges (Playwright/Chromium/Status) and the "Install Runtime" button when
/// binaries are missing. Local state mirrors the web tab's useState trio;
/// `browserUseProvider` stays untouched (it owns the sessions panel). Rendered
/// inside the merged "Tools" settings page.
class BrowserSettingsBlock extends ConsumerStatefulWidget {
  const BrowserSettingsBlock({super.key});

  @override
  ConsumerState<BrowserSettingsBlock> createState() => _BrowserSettingsBlockState();
}

class _BrowserSettingsBlockState extends ConsumerState<BrowserSettingsBlock> {
  bool? _enabled;
  BrowserUseStatus? _status;
  bool _settingsLoading = true;
  bool _statusLoading = true;
  bool _saving = false;
  bool _installing = false;
  String? _error;

  BrowserUseRepository get _repo => ref.read(browserUseRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  void _loadAll() {
    unawaited(
      _repo
          .settings()
          .then((res) {
            if (!mounted) return;
            final settings = res['settings'] as Map? ?? const {};
            setState(() {
              _enabled = settings['enabled'] == true;
              _settingsLoading = false;
            });
          })
          .catchError((Object e) {
            if (!mounted) return;
            setState(() {
              _error = e.toString();
              _settingsLoading = false;
            });
          }),
    );
    unawaited(
      _loadStatus().catchError((Object e) {
        if (!mounted) return;
        setState(() => _error = e.toString());
      }),
    );
  }

  Future<void> _loadStatus() async {
    final status = await _repo.status();
    if (!mounted) return;
    setState(() {
      _status = status;
      _statusLoading = false;
    });
  }

  Future<void> _setEnabled(bool value) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final res = await _repo.saveSettings({'enabled': value});
      if (!mounted) return;
      final settings = res['settings'] as Map? ?? const {};
      setState(() => _enabled = settings['enabled'] == true);
      // The nav rail/drawer gate (`shouldShowBrowserTab` parity) reads this.
      ref.invalidate(browserUseEnabledProvider);
      _statusLoading = true;
      await _loadStatus();
    } on Object catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _statusLoading = false;
        });
      }
    }
  }

  Future<void> _installRuntime() async {
    setState(() {
      _installing = true;
      _error = null;
    });
    try {
      await _repo.installRuntime();
      _statusLoading = true;
      await _loadStatus();
    } on Object catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _installing = false;
          _statusLoading = false;
        });
      }
    }
  }

  String _runtimeLabel(bool? installed, {required Translations t}) {
    final browser = t.settings.browser;
    if (_statusLoading && _status == null) return browser.checking;
    return installed == true ? browser.installed : browser.missing;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final browser = t.settings.browser;

    final enabled = _enabled == true;
    final needsBinaries =
        enabled &&
        _status != null &&
        (!_status!.playwrightInstalled || !_status!.chromiumInstalled);
    final statusLabel = _statusLoading && _status == null
        ? browser.checking
        : _status?.available == true
        ? browser.statusReady
        : enabled
        ? browser.statusSetupRequired
        : browser.statusDisabled;

    Widget badge(String label) => Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderMd,
      ),
      child: Text(label, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
    );

    return SettingsSectionBlock(
      title: browser.title,
      icon: LucideIcons.monitorPlay,
      description: browser.description,
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          child: Column(
            children: [
              SettingsRow(
                label: browser.enableLabel,
                description: browser.enableDescription,
                child: _settingsLoading && _enabled == null
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Switch(
                        value: enabled,
                        onChanged: _saving ? null : (v) => unawaited(_setEnabled(v)),
                      ),
              ),
              Divider(height: 1, color: c.border),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        badge('Playwright: ${_runtimeLabel(_status?.playwrightInstalled, t: t)}'),
                        badge('Chromium: ${_runtimeLabel(_status?.chromiumInstalled, t: t)}'),
                        badge('${browser.statusLabel}: $statusLabel'),
                      ],
                    ),
                    if (needsBinaries) ...[
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.md,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  browser.runtimeRequired,
                                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _status?.message ?? browser.installHint,
                                  style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                                ),
                              ],
                            ),
                          ),
                          AppButton(
                            size: AppButtonSize.sm,
                            loading: _installing || _status?.installInProgress == true,
                            onPressed: () => unawaited(_installRuntime()),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: AppSpacing.xs,
                              children: [
                                const Icon(LucideIcons.download, size: 14),
                                Text(
                                  _installing || _status?.installInProgress == true
                                      ? browser.installing
                                      : browser.installRuntime,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: c.destructive.withValues(alpha: 0.08),
                          border: Border.all(color: c.destructive.withValues(alpha: 0.3)),
                          borderRadius: AppRadii.borderMd,
                        ),
                        child: Text(_error!, style: tt.bodySmall?.copyWith(color: c.destructive)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
