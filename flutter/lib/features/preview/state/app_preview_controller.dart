import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/preview/data/app_preview_models.dart';
import 'package:ddagent_app/features/preview/data/app_preview_repository.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppPreviewState {
  const AppPreviewState({this.targets = const [], this.loaded = false, this.error});

  final List<AppPreviewTarget> targets;
  final bool loaded;
  final String? error;

  AppPreviewTarget? byId(String? id) {
    if (id == null) return null;
    for (final t in targets) {
      if (t.id == id) return t;
    }
    return null;
  }

  AppPreviewTarget? byUrl(String? url) {
    if (url == null) return null;
    for (final t in targets) {
      if (t.url == url) return t;
    }
    return null;
  }

  AppPreviewState copyWith({
    List<AppPreviewTarget>? targets,
    bool? loaded,
    String? Function()? error,
  }) => AppPreviewState(
    targets: targets ?? this.targets,
    loaded: loaded ?? this.loaded,
    error: error != null ? error() : this.error,
  );
}

/// What the workspace should do when an agent upserts a preview target.
sealed class PreviewFollowAction {
  const PreviewFollowAction();
}

/// Open a new preview pane bound to the target.
class OpenPreviewPane extends PreviewFollowAction {
  const OpenPreviewPane();
}

/// Retarget (or refresh the device of) an existing preview pane.
class UpdatePreviewPane extends PreviewFollowAction {
  const UpdatePreviewPane(this.paneId, {required this.retarget});
  final String paneId;

  /// False when the pane already shows this URL — only the device may change.
  final bool retarget;
}

class NoPreviewAction extends PreviewFollowAction {
  const NoPreviewAction();
}

/// Decides how a preview upsert lands in the workspace — pure so it is unit
/// tested without a container.
///
/// A pane already showing the URL just picks up the new device; otherwise the
/// agent's latest target goes to the active preview pane (it is "following"
/// the agent), else to the first preview pane, else a new pane is opened when
/// the grid still has room. Device changes are only pushed when the agent
/// chose a device explicitly, so a user's manual preset survives reloads.
PreviewFollowAction previewFollowAction(
  WorkspaceState ws,
  AppPreviewTarget target, {
  required bool created,
}) {
  final previews = ws.panes.where((p) => p.kind == PaneKind.preview).toList();
  for (final p in previews) {
    if (p.url == target.url) return UpdatePreviewPane(p.id, retarget: false);
  }
  if (previews.isEmpty) {
    return canAddSplitPane(ws.panes) ? const OpenPreviewPane() : const NoPreviewAction();
  }
  // An update to a target no pane shows any more is not a reason to hijack
  // a pane the user pointed elsewhere; a freshly opened target is.
  if (!created && previews.every((p) => p.url != null)) {
    return const NoPreviewAction();
  }
  final active = previews.where((p) => p.id == ws.activePaneId).firstOrNull;
  final empty = previews.where((p) => p.url == null).firstOrNull;
  return UpdatePreviewPane((empty ?? active ?? previews.first).id, retarget: true);
}

/// Preview registry mirror + "follow the agent" behaviour.
///
/// Keep it watched while the workspace is mounted: it is what turns an
/// agent's `preview_open` MCP call into a pane appearing on screen.
class AppPreviewController extends Notifier<AppPreviewState> {
  StreamSubscription<ServerEvent>? _sub;
  AppPreviewRepository get _repo => ref.read(appPreviewRepositoryProvider);

  @override
  AppPreviewState build() {
    _sub?.cancel();
    _sub = ref.watch(chatChannelProvider).events.listen(handleServerEvent);
    ref.onDispose(() => unawaited(_sub?.cancel()));
    unawaited(refresh());
    return const AppPreviewState();
  }

  Future<void> refresh() async {
    try {
      final targets = await _repo.list();
      state = state.copyWith(targets: targets, loaded: true, error: () => null);
    } on AppError catch (e) {
      state = state.copyWith(loaded: true, error: () => e.message);
    }
  }

  void handleServerEvent(ServerEvent e) {
    final kind = e.kind;
    if (!kind.startsWith(BroadcastKinds.appPreviewPrefix)) return;
    switch (kind) {
      case 'app-preview-upserted':
      case 'app-preview-reloaded':
        final target = AppPreviewTarget.fromJson(e.raw['preview']);
        if (target == null) return;
        _upsert(target);
        if (kind == 'app-preview-upserted') {
          _follow(target, created: e.raw['created'] == true);
        }
      case 'app-preview-removed':
        final id = e.raw['previewId'];
        if (id is String) {
          state = state.copyWith(targets: state.targets.where((t) => t.id != id).toList());
        }
    }
  }

  void _upsert(AppPreviewTarget target) {
    final next = [...state.targets];
    final i = next.indexWhere((t) => t.id == target.id);
    if (i >= 0) {
      next[i] = target;
    } else {
      next.add(target);
    }
    state = state.copyWith(targets: next, loaded: true);
  }

  void _follow(AppPreviewTarget target, {required bool created}) {
    final wsCtrl = ref.read(workspaceProvider.notifier);
    switch (previewFollowAction(ref.read(workspaceProvider), target, created: created)) {
      case OpenPreviewPane():
        wsCtrl.openPane(PaneKind.preview, url: target.url, device: target.device);
      case UpdatePreviewPane(:final paneId, :final retarget):
        wsCtrl.updatePane(
          paneId,
          url: retarget ? () => target.url : null,
          // A retargeted pane adopts the target's device (or its platform
          // default when the agent named none); a same-URL refresh keeps the
          // user's preset unless the agent chose one explicitly.
          device: retarget || target.device != null ? () => target.device : null,
        );
        if (retarget) wsCtrl.setActivePaneId(paneId);
      case NoPreviewAction():
        break;
    }
  }

  // ─── Pane-driven mutations (the user, not the agent) ─────────────────────

  Future<AppPreviewTarget?> register({
    required String url,
    PreviewPlatform? platform,
    String? device,
    bool? landscape,
  }) async {
    try {
      final t = await _repo.register(
        url: url,
        platform: platform,
        device: device,
        landscape: landscape,
      );
      _upsert(t);
      return t;
    } on AppError catch (e) {
      state = state.copyWith(error: () => e.message);
      return null;
    }
  }

  Future<AppPreviewTarget?> update(
    String id, {
    String? device,
    PreviewPlatform? platform,
    bool? landscape,
  }) async {
    try {
      final t = await _repo.update(id, device: device, platform: platform, landscape: landscape);
      _upsert(t);
      return t;
    } on AppError catch (e) {
      state = state.copyWith(error: () => e.message);
      return null;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _repo.remove(id);
      state = state.copyWith(targets: state.targets.where((t) => t.id != id).toList());
    } on AppError catch (e) {
      state = state.copyWith(error: () => e.message);
    }
  }

  void clearError() => state = state.copyWith(error: () => null);
}

final appPreviewControllerProvider = NotifierProvider<AppPreviewController, AppPreviewState>(
  AppPreviewController.new,
);
