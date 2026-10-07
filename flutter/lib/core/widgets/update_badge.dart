import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/app_quit.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/server_connect/data/server_profiles.dart';
import 'package:ddagent_app/features/server_connect/state/local_server_controller.dart';
import 'package:ddagent_app/features/system/data/app_update_channel.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Port of `UpdateBadge.tsx` — an emerald rail button (or drawer row) shown
/// when GitHub has a newer release. Two independent cases feed it:
///
/// * the connected server is behind — the dialog runs
///   `POST /api/system/update` and polls `/health` for the new version
///   (under systemd the server exits and the watchdog brings it back);
/// * this app is behind on Android — the dialog downloads the release APK and
///   hands it to the system installer, which is the only way a sideloaded
///   build can replace itself.
class UpdateBadge extends ConsumerWidget {
  const UpdateBadge({super.key, this.variant = UpdateBadgeVariant.icon});

  final UpdateBadgeVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The local server self-updates through the app's own bundle pipeline —
    // POST /api/system/update can't work on a release bundle, so a *server*
    // update on a local profile would only lead to a guaranteed failure. A
    // self-update of THIS app still applies everywhere.
    final profiles = ref.watch(serverProfilesProvider);
    final active = profiles.profiles.where((p) => p.url == profiles.activeUrl).firstOrNull;
    final serverUpdate = !(active?.isLocal ?? false) && ref.watch(updateAvailableProvider);
    // A `_Status.updateAvailable` (above) still drives the badge on server
    // updates; an app update only exists where the client can install itself.
    if (!serverUpdate && !ref.watch(appUpdateAvailableProvider)) {
      return const SizedBox.shrink();
    }
    final t = Translations.of(context);
    final version = normalizeVersion(ref.watch(latestReleaseProvider).value!.tagName);
    final label = t.common.update.available(version: version);

    if (variant == UpdateBadgeVariant.row) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
        child: Material(
          color: const Color(0xFF10B981).withValues(alpha: 0.10),
          borderRadius: AppRadii.borderLg,
          child: ListTile(
            dense: true,
            leading: const Icon(LucideIcons.circleArrowUp, size: 18, color: Color(0xFF10B981)),
            title: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF34D399),
              ),
            ),
            onTap: () => _open(context),
          ),
        ),
      );
    }

    return Tooltip(
      message: label,
      preferBelow: false,
      verticalOffset: 12,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: AppRadii.borderLg,
        child: const SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            children: [
              Center(child: Icon(LucideIcons.circleArrowUp, size: 16, color: Color(0xFF10B981))),
              Positioned(top: 6, right: 6, child: _PulseDot()),
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context) =>
      showDialog<void>(context: context, builder: (_) => const UpdateDialog());
}

enum UpdateBadgeVariant { icon, row }

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    lowerBound: 0.4,
    upperBound: 1,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _ctrl,
    child: Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
    ),
  );
}

/// Update flow dialog — states mirror `UpdateBadge.tsx`:
/// confirm → updating → restarting (poll /health) → done | manual-restart,
/// or failed with the server's error detail.
class UpdateDialog extends ConsumerStatefulWidget {
  const UpdateDialog({super.key});

  @override
  ConsumerState<UpdateDialog> createState() => _UpdateDialogState();
}

enum _Status { confirm, updating, restarting, done, manualRestart, failed, permission }

class _UpdateDialogState extends ConsumerState<UpdateDialog> {
  static const _pollInterval = Duration(seconds: 2);
  static const _restartDeadline = Duration(seconds: 90);

  _Status _status = _Status.confirm;
  String _error = '';
  double _progress = 0;
  Timer? _poller;

  @override
  void dispose() {
    _poller?.cancel();
    super.dispose();
  }

  Future<void> _runUpdate() async {
    // Desktop (Linux/Windows) stages the new build in the background and
    // installs it on quit — the button only re-checks or applies a staged one.
    if (isDesktopChannel(ref.read(appUpdateChannelProvider)) &&
        ref.read(appUpdateAvailableProvider)) {
      return _runDesktopUpdate();
    }
    // Android can install a newer APK of this app itself; every other case is
    // the connected server updating itself.
    final asset = ref.read(appUpdateAssetProvider);
    if (asset != null && ref.read(appUpdateAvailableProvider)) {
      return _runAppUpdate(asset);
    }
    final repo = ref.read(systemRepositoryProvider);
    setState(() {
      _status = _Status.updating;
      _error = '';
    });
    try {
      await repo.update();
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _status = _Status.failed;
          _error = e.toString();
        });
      }
      return;
    }
    if (!mounted) return;
    setState(() => _status = _Status.restarting);
    _pollForVersion(repo);
  }

  /// Downloads the release APK and hands it to the Android installer. Android
  /// refuses to install for an app lacking the "install unknown apps" grant, so
  /// that case routes the user to the system setting instead of failing.
  Future<void> _runAppUpdate(ReleaseAsset asset) async {
    final installer = ref.read(appUpdateInstallerProvider);
    final t = Translations.of(context);
    setState(() {
      _status = _Status.updating;
      _error = '';
      _progress = 0;
    });
    try {
      if (!await installer.canInstallPackages()) {
        await installer.openInstallPermissionSettings();
        if (mounted) {
          setState(() {
            _status = _Status.permission;
            _error = t.common.update.appPermission;
          });
        }
        return;
      }
      await installer.downloadAndInstall(
        asset,
        onProgress: (progress) {
          if (mounted) setState(() => _progress = progress);
        },
      );
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _status = _Status.failed;
          _error = e.toString();
        });
      }
      return;
    }
    // The system installer now owns the screen; nothing left to show here.
    if (mounted) Navigator.of(context).pop();
  }

  /// Desktop: install now when a build is already staged, otherwise re-check
  /// and let the background downloader stage it.
  Future<void> _runDesktopUpdate() async {
    if (ref.read(desktopUpdateProvider).stage == DesktopUpdateStage.ready) {
      return _applyDesktopNow();
    }
    ref.read(desktopUpdateProvider.notifier).recheck();
  }

  /// Hands the staged update to the detached installer and quits so it can
  /// replace the running binary. On web (no process to exit) the dialog just
  /// closes.
  Future<void> _applyDesktopNow() async {
    await ref.read(desktopUpdateProvider.notifier).applyOnExit();
    await ref.read(localServerProvider.notifier).stop();
    if (!quitApp() && mounted) Navigator.of(context).pop();
  }

  /// `/health` poll until the restarted process reports the new version —
  /// 90s deadline then 'manual-restart' (same as web).
  void _pollForVersion(SystemRepository repo) {
    final latest = normalizeVersion(ref.read(latestReleaseProvider).value!.tagName);
    final deadline = DateTime.now().add(_restartDeadline);
    _poller = Timer.periodic(_pollInterval, (timer) async {
      try {
        final health = await repo.health();
        if (health['version']?.toString() == latest) {
          timer.cancel();
          if (mounted) setState(() => _status = _Status.done);
          return;
        }
      } on Object {
        // Server down mid-restart — keep polling until the deadline.
      }
      if (DateTime.now().isAfter(deadline)) {
        timer.cancel();
        if (mounted) setState(() => _status = _Status.manualRestart);
      }
    });
  }

  void _close() {
    if (_status == _Status.updating || _status == _Status.restarting) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context);
    final release = ref.watch(latestReleaseProvider).value;
    final version = release != null ? normalizeVersion(release.tagName) : '?';

    // Desktop self-update stages in the background and installs on quit, so its
    // dialog is driven by [desktopUpdateProvider] rather than the poll-based
    // server flow below.
    if (isDesktopChannel(ref.watch(appUpdateChannelProvider)) &&
        ref.watch(appUpdateAvailableProvider)) {
      return _buildDesktop(context, t, c, release, version);
    }

    final busy = _status == _Status.updating || _status == _Status.restarting;

    final body = switch (_status) {
      _Status.confirm =>
        ref.watch(appUpdateAvailableProvider)
            ? t.common.update.appConfirm(version: version)
            : t.common.update.confirm(version: version),
      _Status.updating =>
        _progress > 0
            ? '${t.common.update.downloading} ${(_progress * 100).round()}%'
            : t.common.update.downloading,
      _Status.restarting => t.common.update.restarting,
      _Status.done => t.common.update.done(version: version),
      _Status.manualRestart => t.common.update.manualRestart,
      _Status.failed => _error.isNotEmpty ? _error : t.common.update.failed,
      _Status.permission => _error.isNotEmpty ? _error : t.common.update.failed,
    };

    return AlertDialog(
      backgroundColor: c.card,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: busy
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(LucideIcons.circleArrowUp, size: 16, color: Color(0xFF10B981)),
      ),
      title: Text(
        _status == _Status.failed
            ? t.common.update.failedTitle
            : t.common.update.available(version: version),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 288),
        child: SingleChildScrollView(
          child: Text(body, style: TextStyle(fontSize: 14, color: c.mutedForeground)),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        if (release?.htmlUrl != null)
          TextButton.icon(
            onPressed: () => launchUrl(Uri.parse(release!.htmlUrl!)),
            icon: const Icon(LucideIcons.externalLink, size: 12),
            label: Text(t.sidebar.version.releaseNotes, style: const TextStyle(fontSize: 12)),
          )
        else
          const SizedBox.shrink(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_status == _Status.confirm ||
                _status == _Status.failed ||
                _status == _Status.permission ||
                _status == _Status.manualRestart ||
                _status == _Status.done)
              AppButton(
                variant: AppButtonVariant.secondary,
                onPressed: _close,
                child: Text(t.chat.common.close),
              ),
            if (_status == _Status.confirm) ...[
              const SizedBox(width: 12),
              AppButton(onPressed: _runUpdate, child: Text(t.common.buttons.update)),
            ],
            if (_status == _Status.failed || _status == _Status.permission) ...[
              const SizedBox(width: 12),
              AppButton(onPressed: _runUpdate, child: Text(t.chat.session.messages.retry)),
            ],
          ],
        ),
      ],
    );
  }

  /// Desktop update dialog — reflects [desktopUpdateProvider]: the background
  /// downloader either is mid-download, has a build staged (offer to quit and
  /// install now), or failed (offer a retry).
  Widget _buildDesktop(
    BuildContext context,
    Translations t,
    AppColors c,
    Release? release,
    String version,
  ) {
    final stage = ref.watch(desktopUpdateProvider).stage;
    final progress = ref.watch(desktopUpdateProvider).progress;
    final error = ref.watch(desktopUpdateProvider).error;
    final busy = stage == DesktopUpdateStage.idle || stage == DesktopUpdateStage.downloading;

    final body = switch (stage) {
      DesktopUpdateStage.idle || DesktopUpdateStage.downloading =>
        progress > 0
            ? '${t.common.update.downloading} ${(progress * 100).round()}%'
            : t.common.update.downloading,
      DesktopUpdateStage.ready => t.settings.updates.downloaded(version: version),
      DesktopUpdateStage.failed => t.settings.updates.error(
        message: error ?? t.settings.updates.errorGeneric,
      ),
    };

    return AlertDialog(
      backgroundColor: c.card,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: busy
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(LucideIcons.circleArrowUp, size: 16, color: Color(0xFF10B981)),
      ),
      title: Text(
        stage == DesktopUpdateStage.failed
            ? t.common.update.failedTitle
            : t.common.update.available(version: version),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 288),
        child: SingleChildScrollView(
          child: Text(body, style: TextStyle(fontSize: 14, color: c.mutedForeground)),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        if (release?.htmlUrl != null)
          TextButton.icon(
            onPressed: () => launchUrl(Uri.parse(release!.htmlUrl!)),
            icon: const Icon(LucideIcons.externalLink, size: 12),
            label: Text(t.sidebar.version.releaseNotes, style: const TextStyle(fontSize: 12)),
          )
        else
          const SizedBox.shrink(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.chat.common.close),
            ),
            if (stage == DesktopUpdateStage.ready) ...[
              const SizedBox(width: 12),
              AppButton(onPressed: _applyDesktopNow, child: Text(t.common.buttons.update)),
            ],
            if (stage == DesktopUpdateStage.failed) ...[
              const SizedBox(width: 12),
              AppButton(
                onPressed: () => ref.read(desktopUpdateProvider.notifier).recheck(),
                child: Text(t.chat.session.messages.retry),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
