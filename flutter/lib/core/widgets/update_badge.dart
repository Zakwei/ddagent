import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/app_quit.dart';
import 'package:ddagent_app/core/utils/app_reload.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/server_connect/state/local_server_controller.dart';
import 'package:ddagent_app/features/system/data/app_update_channel.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Port of `UpdateBadge.tsx` — an emerald rail button (or drawer row) shown
/// when GitHub has a newer release of something this client can update
/// ([availableUpdatesProvider]): this app, the web interface, or the
/// connected server. One update opens its dialog directly; several open a
/// chooser with a button for each.
class UpdateBadge extends ConsumerWidget {
  const UpdateBadge({super.key, this.variant = UpdateBadgeVariant.icon});

  final UpdateBadgeVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targets = ref.watch(availableUpdatesProvider);
    final release = ref.watch(latestReleaseProvider).value;
    if (targets.isEmpty || release == null) return const SizedBox.shrink();
    final t = Translations.of(context);
    final version = normalizeVersion(release.tagName);
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
            onTap: () => openUpdates(context, targets),
          ),
        ),
      );
    }

    return Tooltip(
      message: label,
      preferBelow: false,
      verticalOffset: 12,
      child: InkWell(
        onTap: () => openUpdates(context, targets),
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
}

/// Opens the update flow for [targets]: the dialog of the only one, or a
/// chooser listing each with its own button.
void openUpdates(BuildContext context, List<UpdateTarget> targets) {
  if (targets.length == 1) {
    unawaited(showUpdateDialog(context, targets.single));
    return;
  }
  unawaited(
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final t = Translations.of(dialogContext);
        return AlertDialog(
          title: Text(t.common.update.chooseTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              for (final target in targets)
                AppButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    unawaited(showUpdateDialog(context, target));
                  },
                  child: Text(updateTargetAction(t, target)),
                ),
            ],
          ),
          actions: [
            AppButton(
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(t.chat.common.close),
            ),
          ],
        );
      },
    ),
  );
}

/// Opens the update dialog for one [target].
Future<void> showUpdateDialog(BuildContext context, UpdateTarget target) => showDialog<void>(
  context: context,
  builder: (_) => UpdateDialog(target: target),
);

/// Button label for updating [target] ("Update app", "Update server", …).
String updateTargetAction(Translations t, UpdateTarget target) => switch (target) {
  UpdateTarget.app => t.common.update.updateApp,
  UpdateTarget.web => t.common.update.updateWeb,
  UpdateTarget.server => t.common.update.updateServer,
};

/// Short name of [target] ("This app", "Web interface", "Server").
String updateTargetName(Translations t, UpdateTarget target) => switch (target) {
  UpdateTarget.app => t.common.update.targetApp,
  UpdateTarget.web => t.common.update.targetWeb,
  UpdateTarget.server => t.common.update.targetServer,
};

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

/// Update flow for one [target] — confirm → updating → (restarting, polling
/// `/health`) → done | manual restart | failed:
///
/// * [UpdateTarget.app] — Android hands a downloaded APK to the system
///   installer; desktop stages the build in the background and installs it
///   on quit ([_buildDesktop]);
/// * [UpdateTarget.web] — the server replaces the web client it hosts, then
///   the page reloads;
/// * [UpdateTarget.server] — `POST /api/system/update` on a remote server
///   (its launcher restarts it, or it asks for a manual restart); the desktop
///   app's own local server is re-installed through [localServerProvider].
class UpdateDialog extends ConsumerStatefulWidget {
  const UpdateDialog({super.key, required this.target});

  final UpdateTarget target;

  @override
  ConsumerState<UpdateDialog> createState() => _UpdateDialogState();
}

enum _Status { confirm, updating, restarting, done, manualRestart, failed, permission }

class _UpdateDialogState extends ConsumerState<UpdateDialog> {
  static const _pollInterval = Duration(seconds: 2);
  static const _restartDeadline = Duration(seconds: 120);
  // Long enough to read the result before the web tab reloads.
  static const _reloadDelay = Duration(milliseconds: 1500);

  _Status _status = _Status.confirm;
  String _error = '';
  // Result line shown in the done / manual-restart states.
  String? _note;
  double _progress = 0;
  Timer? _poller;

  @override
  void dispose() {
    _poller?.cancel();
    super.dispose();
  }

  Future<void> _runUpdate() async {
    switch (widget.target) {
      case UpdateTarget.app:
        if (isDesktopChannel(ref.read(appUpdateChannelProvider))) return _runDesktopUpdate();
        final asset = ref.read(appUpdateAssetProvider);
        if (asset != null) return _runAppUpdate(asset);
        _fail(Translations.of(context).common.update.failed);
      case UpdateTarget.web:
        return _runWebUpdate();
      case UpdateTarget.server:
        if (ref.read(activeServerIsLocalProvider)) return _runLocalServerUpdate();
        return _runServerUpdate();
    }
  }

  void _fail(String error) {
    if (!mounted) return;
    setState(() {
      _status = _Status.failed;
      _error = error;
    });
  }

  void _startUpdating() => setState(() {
    _status = _Status.updating;
    _error = '';
    _note = null;
    _progress = 0;
  });

  /// Remote server: it updates itself and — when a launcher supervises it —
  /// exits so the new version comes up; otherwise it asks for a restart.
  Future<void> _runServerUpdate() async {
    final t = Translations.of(context).common.update;
    final repo = ref.read(systemRepositoryProvider);
    final version = _latestVersion;
    _startUpdating();
    final Map<String, dynamic> result;
    try {
      result = await repo.update();
    } on Object catch (e) {
      return _fail(e.toString());
    }
    if (!mounted) return;
    final webError = result['webError']?.toString();
    if (result['upToDate'] == true) {
      setState(() {
        _status = _Status.done;
        _note = t.upToDate;
      });
      return;
    }
    if (result['restarting'] != true) {
      setState(() {
        _status = _Status.manualRestart;
        _note = [
          result['staged'] == true ? t.staged(version: version) : t.manualRestart,
          if (webError != null) t.webHostFailed(message: webError),
        ].join('\n\n');
      });
      return;
    }
    setState(() {
      _status = _Status.restarting;
      _note = webError == null ? null : t.webHostFailed(message: webError);
    });
    _pollForVersion(repo, reloadWeb: kIsWeb && webError == null);
  }

  /// The web client the server hosts — replaced on the server, then reloaded.
  Future<void> _runWebUpdate() async {
    _startUpdating();
    final Map<String, dynamic> result;
    try {
      result = await ref.read(systemRepositoryProvider).updateWeb();
    } on Object catch (e) {
      return _fail(e.toString());
    }
    if (!mounted) return;
    if (result['success'] == false) return _fail(result['error']?.toString() ?? '');
    setState(() {
      _status = _Status.done;
      _note = Translations.of(context).common.update.webDone(version: _latestVersion);
    });
    await Future<void>.delayed(_reloadDelay);
    reloadClient();
  }

  /// The desktop app's own server ("This device"): download the new bundle
  /// and restart it locally — the API self-update doesn't apply to it.
  Future<void> _runLocalServerUpdate() async {
    _startUpdating();
    try {
      await ref.read(localServerProvider.notifier).installAndStart();
    } on Object catch (e) {
      return _fail(e.toString());
    }
    if (!mounted) return;
    ref.invalidate(serverHealthProvider);
    setState(() {
      _status = _Status.done;
      _note = Translations.of(context).common.update.serverDone(version: _latestVersion);
    });
  }

  String get _latestVersion {
    final release = ref.read(latestReleaseProvider).value;
    return release == null ? '?' : normalizeVersion(release.tagName);
  }

  /// Downloads the release APK and hands it to the Android installer. Android
  /// refuses to install for an app lacking the "install unknown apps" grant, so
  /// that case routes the user to the system setting instead of failing.
  Future<void> _runAppUpdate(ReleaseAsset asset) async {
    final installer = ref.read(appUpdateInstallerProvider);
    final t = Translations.of(context);
    _startUpdating();
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
      return _fail(e.toString());
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

  /// `/health` poll until the restarted server reports the new version, then
  /// done (and a web tab reloads onto the updated web client); a server that
  /// never comes back within the deadline needs a manual restart.
  void _pollForVersion(SystemRepository repo, {required bool reloadWeb}) {
    final latest = _latestVersion;
    final deadline = DateTime.now().add(_restartDeadline);
    _poller = Timer.periodic(_pollInterval, (timer) async {
      try {
        final health = await repo.health();
        if (health['version']?.toString() == latest) {
          timer.cancel();
          ref.invalidate(serverHealthProvider);
          if (!mounted) return;
          final t = Translations.of(context).common.update;
          setState(() {
            _status = _Status.done;
            _note = [t.serverDone(version: latest), ?_note].join('\n\n');
          });
          if (reloadWeb) {
            await Future<void>.delayed(_reloadDelay);
            reloadClient();
          }
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
    // dialog is driven by [desktopUpdateProvider] rather than the flow below.
    if (widget.target == UpdateTarget.app &&
        isDesktopChannel(ref.watch(appUpdateChannelProvider))) {
      return _buildDesktop(context, t, c, release, version);
    }

    final busy = _status == _Status.updating || _status == _Status.restarting;
    final localServer =
        widget.target == UpdateTarget.server && ref.watch(activeServerIsLocalProvider);

    final body = switch (_status) {
      _Status.confirm => switch (widget.target) {
        UpdateTarget.app => t.common.update.appConfirm(version: version),
        UpdateTarget.web => t.common.update.webConfirm(version: version),
        UpdateTarget.server when localServer => t.common.update.localServerConfirm(
          version: version,
        ),
        UpdateTarget.server => t.common.update.confirm(version: version),
      },
      _Status.updating when localServer => t.common.update.localServerUpdating,
      _Status.updating =>
        _progress > 0
            ? '${t.common.update.downloading} ${(_progress * 100).round()}%'
            : t.common.update.downloading,
      _Status.restarting => [t.common.update.restarting, ?_note].join('\n\n'),
      _Status.done => _note ?? t.common.update.done(version: version),
      _Status.manualRestart => _note ?? t.common.update.manualRestart,
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
            : '${updateTargetName(t, widget.target)} · v$version',
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
            if (!busy)
              AppButton(
                variant: AppButtonVariant.secondary,
                onPressed: _close,
                child: Text(t.chat.common.close),
              ),
            if (_status == _Status.confirm) ...[
              const SizedBox(width: 12),
              AppButton(onPressed: _runUpdate, child: Text(updateTargetAction(t, widget.target))),
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
