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

  String? get rejectAlwaysEntry => rejectAlwaysEntryOf(context);
}

/// ACP asks (Devin / Command Code) list the agent's own options in
/// `context.options`; a `reject_always` one enables "Always deny", answered
/// as a deny carrying its label as `rememberEntry`.
String? rejectAlwaysEntryOf(Map<String, dynamic>? context) {
  final options = context?['options'];
  if (options is! List) return null;
  for (final o in options) {
    if (o is Map && o['kind'] == 'reject_always') {
      final name = o['name']?.toString();
      return name == null || name.isEmpty ? 'Always deny' : name;
    }
  }
  return null;
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

/// Composer mode to switch to once an approved ask takes the agent out of
/// plan mode — Claude `ExitPlanMode`, or a Command Code plan-approval question
/// answered "Yes…" ("Yes, auto-accept edits" → acceptEdits). Null otherwise.
String? planExitModeFor(
  String toolName,
  Map<String, dynamic> input, {
  required bool allow,
  dynamic updatedInput,
}) {
  if (!allow) return null;
  if (toolName.toLowerCase().replaceAll(RegExp('[ _]'), '') == 'exitplanmode') return 'default';
  final questions = input['questions'];
  final answers = updatedInput is Map ? updatedInput['answers'] : null;
  if (questions is! List || answers is! Map) return null;
  for (final q in questions) {
    if (q is! Map) continue;
    final isPlan =
        (q['planContent']?.toString() ?? '').isNotEmpty ||
        q['header'] == 'Plan Review' ||
        q['header'] == 'Exit Plan';
    if (!isPlan) continue;
    final answer = answers[q['question']]?.toString().toLowerCase() ?? '';
    if (!answer.startsWith('yes')) return null;
    return answer.contains('auto-accept') ? 'acceptEdits' : 'default';
  }
  return null;
}

/// One "leave plan mode" request; a fresh instance per approval so the same
/// mode twice still notifies.
class PlanExit {
  PlanExit(this.mode);

  final String mode;
}

/// Per-session plan-exit signal: the transcript raises it when the user
/// approves leaving plan mode, the composer switches its mode picker.
class PlanExitController extends Notifier<PlanExit?> {
  PlanExitController(this.sessionId);

  final String sessionId;

  @override
  PlanExit? build() => null;

  void request(String mode) => state = PlanExit(mode);
}

final planExitProvider = NotifierProvider.family<PlanExitController, PlanExit?, String>(
  PlanExitController.new,
);
