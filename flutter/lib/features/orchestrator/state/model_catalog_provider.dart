import 'package:ddagent_app/features/orchestrator/data/orchestrator_config.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// provider → selectable models (`/api/providers/{p}/models` OPTIONS).
///
/// Best-effort: a provider that fails to answer gets an empty list so the model
/// picker falls back to the stored raw value instead of blocking the section.
/// Shared by the orchestrator and mini-orchestrator settings so both offer the
/// same catalog instead of hand-typed model ids.
final modelCatalogProvider = FutureProvider<Map<String, List<OrchModelOption>>>((ref) async {
  final repo = ref.watch(sessionsRepositoryProvider);
  final entries = await Future.wait(
    orchProviders.keys.map((provider) async {
      try {
        final res = await repo.models(provider);
        return MapEntry(provider, [for (final m in res.options) OrchModelOption.fromJson(m)]);
      } on Object {
        return MapEntry(provider, const <OrchModelOption>[]);
      }
    }),
  );
  return Map.fromEntries(entries);
});
