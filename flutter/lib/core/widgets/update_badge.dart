import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/server_connect/data/server_profiles.dart';
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
    // POST /api/system/update can't work on a release bundle, so the badge
    // would only lead to a guaranteed failure. Remote servers keep it.
    final profiles = ref.watch(serverProfilesProvider);
    final active = profiles.profiles.where((p) => p.url == profiles.activeUrl).firstOrNull;
    if (active?.isLocal ?? false) return const SizedBox.shrink();
    // The server falling behind applies everywhere; an app update only exists
    // where the client can install its own APK (Android).
    if (!ref.watch(updateAvailableProvider) && !ref.watch(appUpdateAvailableProvider)) {
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
}
