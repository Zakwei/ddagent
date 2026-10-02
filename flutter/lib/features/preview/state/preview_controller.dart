import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/preview/data/preview_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewState {
  const PreviewState({this.ports = const [], this.selectedPort, this.loading = false, this.error});

  final List<ListeningPort> ports;
  final ListeningPort? selectedPort;
  final bool loading;
  final String? error;

  PreviewState copyWith({
    List<ListeningPort>? ports,
    ListeningPort? Function()? selectedPort,
    bool? loading,
    String? Function()? error,
  }) => PreviewState(
    ports: ports ?? this.ports,
    selectedPort: selectedPort != null ? selectedPort() : this.selectedPort,
    loading: loading ?? this.loading,
    error: error != null ? error() : this.error,
  );
}

/// Polls `GET /api/preview/ports` every 5s scoped to one project's path and
/// builds the reverse-proxy URL `/api/preview/<port>/?token=…`. The timer dies
/// with the provider (autoDispose family), so panes poll only while watched.
class PreviewController extends Notifier<PreviewState> {
  PreviewController(this.projectPath);

  /// `projects.path` — the server attributes ports by process cwd.
  final String? projectPath;

  static const pollInterval = Duration(seconds: 5);

  Timer? _timer;

  PreviewRepository get _repo => ref.read(previewRepositoryProvider);

  @override
  PreviewState build() {
    _timer = Timer.periodic(pollInterval, (_) => unawaited(refresh()));
    ref.onDispose(() => _timer?.cancel());
    unawaited(refresh());
    return const PreviewState(loading: true);
  }

  Future<void> refresh() async {
    try {
      final ports = await _repo.ports(projectPath: projectPath);
      if (!ref.mounted) return;
      final sel = state.selectedPort;
      state = state.copyWith(
        ports: ports,
        loading: false,
        // Keep the selection if it still exists; otherwise auto-select the
        // first port so the pane shows something immediately.
        selectedPort: () => sel != null && ports.any((p) => p.port == sel.port)
            ? ports.firstWhere((p) => p.port == sel.port)
            : (ports.isEmpty ? null : ports.first),
      );
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loading: false, error: () => e.message);
      }
    }
  }

  void selectPort(int port) {
    final match = state.ports.where((p) => p.port == port).firstOrNull;
    if (match != null) {
      state = state.copyWith(selectedPort: () => match);
    }
  }

  /// Reverse-proxy URL for the selected (or given) port. `token` authenticates
  /// the first request; the server then upgrades it into the preview cookie.
  Future<Uri?> proxyUrl({int? port, String path = '/'}) async {
    final p = port ?? state.selectedPort?.port;
    if (p == null) return null;
    final base = ref.read(serverBaseUrlProvider);
    final token = await ref.read(authTokenStoreProvider).token;
    if (!ref.mounted) return null;
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '$base/api/preview/$p$normalized'
      '${token != null ? '${normalized.contains('?') ? '&' : '?'}token=${Uri.encodeQueryComponent(token)}' : ''}',
    );
  }
}

final previewProvider = NotifierProvider.autoDispose
    .family<PreviewController, PreviewState, String?>(PreviewController.new);
