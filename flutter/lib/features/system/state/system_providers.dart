import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `GET /health` — `{status, version, installMode}` of the connected server.
/// "Current version" in the About tab is the *server's* running version (the
/// web client bakes package.json into its bundle; this app talks to a remote
/// DDAgent whose version is what matters).
final serverHealthProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) => ref.watch(systemRepositoryProvider).health(),
);

/// `GET /api/system/latest-release` — server-side GitHub releases lookup
/// (the repo needs the user's stored GitHub token). Port of the
/// `useVersionCheck` fetch; the 5-minute web poll is dropped — the check is
/// re-run on each visit, plus the manual "Check for updates" button.
final latestReleaseProvider = FutureProvider.autoDispose<Release?>(
  (ref) => ref.watch(systemRepositoryProvider).latestRelease(),
);

/// `GET /api/system/releases` — newest-first list for the changelog.
final releasesProvider = FutureProvider.autoDispose<List<Release>>(
  (ref) => ref.watch(systemRepositoryProvider).releases(),
);

/// `compareVersions` port (`src/hooks/useVersionCheck.ts`): positive when
/// a > b, negative when a < b, 0 on equal. Numeric dot-separated only.
int compareVersions(String a, String b) {
  final pa = a.split('.').map(int.tryParse).toList();
  final pb = b.split('.').map(int.tryParse).toList();
  final len = pa.length > pb.length ? pa.length : pb.length;
  for (var i = 0; i < len; i++) {
    final x = i < pa.length ? pa[i] ?? 0 : 0;
    final y = i < pb.length ? pb[i] ?? 0 : 0;
    if (x != y) return x - y;
  }
  return 0;
}

/// `GET /api/system/update-info` — what the connected server can update
/// (itself, its hosted web client). Null when the server predates it.
final serverUpdateInfoProvider = FutureProvider.autoDispose<Map<String, dynamic>?>(
  (ref) => ref.watch(systemRepositoryProvider).updateInfo(),
);
