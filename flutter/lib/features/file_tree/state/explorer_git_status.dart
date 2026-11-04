import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Project git status (`/api/git/status`) shared by the explorer decorations
/// and the editor's Changed Files section — null when the project isn't a
/// repository (status 400 NOT_A_GIT_REPOSITORY) or the call failed; callers
/// hide git UI rather than erroring.
final gitStatusProvider = FutureProvider.autoDispose.family<Map<String, dynamic>?, String>((
  ref,
  projectId,
) async {
  try {
    return await ref.read(gitRepositoryProvider).status(projectId);
  } on Object {
    return null;
  }
});
