import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Numeric dot-version compare — port of `compareVersions` in
/// `useVersionCheck.ts`. Positive if [a] > [b].
int compareVersions(String a, String b) {
  final pa = a.split('.').map(int.tryParse).map((p) => p ?? 0).toList();
  final pb = b.split('.').map(int.tryParse).map((p) => p ?? 0).toList();
  for (var i = 0; i < pa.length || i < pb.length; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x - y;
  }
  return 0;
}

/// Strip the `v` prefix a GitHub tag carries (`v1.2.3` → `1.2.3`).
String normalizeVersion(String v) =>
    v.startsWith('v') || v.startsWith('V') ? v.substring(1) : v;

/// `GET /health` — running server version probe (also used after update).
final serverHealthProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) => ref
      .watch(systemRepositoryProvider)
      .health()
      .catchError((_) => const <String, dynamic>{}),
);

/// `GET /api/system/latest-release` — newest GitHub release (null on failure).
final latestReleaseProvider = FutureProvider.autoDispose<Release?>(
  (ref) => ref
      .watch(systemRepositoryProvider)
      .latestRelease()
      .catchError((_) => null),
);

/// Whether the server is behind the latest GitHub release — the web client's
/// `useVersionCheck` (latest tag vs the version /health reports).
final updateAvailableProvider = Provider.autoDispose<bool>((ref) {
  final release = ref.watch(latestReleaseProvider).value;
  final health = ref.watch(serverHealthProvider).value;
  final running = health?['version']?.toString();
  if (release == null || running == null || running.isEmpty) return false;
  return compareVersions(normalizeVersion(release.tagName), running) > 0;
});
