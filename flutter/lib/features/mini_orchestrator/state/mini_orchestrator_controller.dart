import 'package:ddagent_app/features/mini_orchestrator/data/mini_orchestrator_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// POST /api/mini-orchestrator/sessions — returns the new session id.
Future<String> createMiniOrchestratorSession(
  WidgetRef ref, {
  required String projectPath,
  String? initialMessage,
}) async {
  final data = await ref.read(miniOrchestratorRepositoryProvider).createSession({
    'projectPath': projectPath,
    if (initialMessage != null && initialMessage.isNotEmpty) 'initialMessage': initialMessage,
  });
  return data['sessionId']?.toString() ?? '';
}
