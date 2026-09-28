import 'package:ddagent_app/features/orchestrator/data/orchestrator_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Parent session id of an orchestrated child session — null for roots and
/// on lookup failure (the transcript renders fine without it).
final orchestratorParentProvider = FutureProvider.autoDispose
    .family<String?, String>(
      (ref, sessionId) async => ref
          .read(orchestratorRepositoryProvider)
          .parentSession(sessionId)
          .catchError((_) => null),
    );

/// POST /api/orchestrator/sessions — returns the new session id.
Future<String> createOrchestratorSession(
  WidgetRef ref, {
  required String projectPath,
  String? initialMessage,
}) async {
  final data = await ref.read(orchestratorRepositoryProvider).createSession({
    'provider': 'orchestrator',
    'projectPath': projectPath,
    if (initialMessage != null && initialMessage.isNotEmpty)
      'initialMessage': initialMessage,
  });
  return data['sessionId']?.toString() ?? '';
}
