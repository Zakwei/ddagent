import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One unanswered permission request, as surfaced by the sticky banner and
/// the pane "needs attention" dot (PermissionRequestsBanner.tsx parity).
class PendingPermission {
  const PendingPermission({
    required this.sessionId,
    required this.requestId,
    required this.toolName,
    this.input = const {},
    this.context,
  });

  final String sessionId;
  final String requestId;
  final String toolName;
  final Map<String, dynamic> input;
  final Map<String, dynamic>? context;

  String? get rememberEntry => context?['rememberEntry']?.toString();
}

/// Requests arrive as `permission_request` WS frames, leave on
/// `permission_cancelled` or once the user answers. Keyed by requestId.
class PendingPermissionsController extends Notifier<Map<String, PendingPermission>> {
  @override
  Map<String, PendingPermission> build() => {};

  void add(PendingPermission request) {
    if (state.containsKey(request.requestId)) return;
    state = {...state, request.requestId: request};
  }

  void remove(String? requestId) {
    if (requestId == null || !state.containsKey(requestId)) return;
    state = {...state}..remove(requestId);
  }

  void removeForSession(String sessionId) {
    final next = {
      for (final e in state.entries)
        if (e.value.sessionId != sessionId) e.key: e.value,
    };
    if (next.length != state.length) state = next;
  }
}

final pendingPermissionsProvider =
    NotifierProvider<PendingPermissionsController, Map<String, PendingPermission>>(
      PendingPermissionsController.new,
    );

/// Sessions with at least one unanswered request — drives the pane dot.
final pendingPermissionSessionsProvider = Provider<Set<String>>(
  (ref) => {for (final p in ref.watch(pendingPermissionsProvider).values) p.sessionId},
);

/// Requests for one session, oldest first (banner order).
final sessionPendingPermissionsProvider = Provider.family<List<PendingPermission>, String>((
  ref,
  sessionId,
) {
  final all = ref.watch(pendingPermissionsProvider);
  return [
    for (final p in all.values)
      if (p.sessionId == sessionId) p,
  ];
});
