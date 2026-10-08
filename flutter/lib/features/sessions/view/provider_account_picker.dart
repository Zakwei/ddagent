import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/features/provider_accounts/data/provider_accounts_repository.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A provider/account the user picked in the new-chat dialog. [accountId] is
/// `null` when the ambient (unpinned) login was chosen.
class ProviderAccountSelection {
  const ProviderAccountSelection(this.provider, this.accountId);

  final String provider;
  final String? accountId;
}

/// Result of [showProviderAccountPicker]:
///
/// - `null` — no accounts are configured or the accounts API is unavailable,
///   so the caller should fall back to its flat provider list.
/// - otherwise [selection] holds the pick; a `null` [selection] means the user
///   dismissed the dialog without choosing.
class ProviderAccountPickerResult {
  const ProviderAccountPickerResult(this.selection);

  final ProviderAccountSelection? selection;
}

/// Opens the "new chat" provider dialog grouped by provider → accounts.
///
/// Every provider surfaces its ambient (unpinned) login as an account row
/// whenever a name is known — either from a named `provider_accounts` row or
/// from the quota adapter's ambient label (codex, antigravity, …) — so the
/// picker names the logged-in account instead of rendering a bare provider row
/// the user cannot tell apart. Providers with neither keep their single row.
Future<ProviderAccountPickerResult?> showProviderAccountPicker({
  required BuildContext context,
  required WidgetRef ref,
  required List<String> providers,
  String? title,
}) async {
  List<ProviderAccount> accounts;
  try {
    accounts = await ref.read(providerAccountsRepositoryProvider).list();
  } on Object {
    return null;
  }
  if (accounts.isEmpty || !context.mounted) return null;

  final groups = await _buildGroups(context, ref, providers, accounts);
  if (!context.mounted) return null;
  // Providers without accounts still occupy one selectable row.
  final options = groups.fold<int>(0, (n, g) => n + (g.choices.isEmpty ? 1 : g.choices.length));
  if (options <= 1) {
    // A lone provider/account needs no dialog — pin it directly.
    final sole = groups.firstWhere((g) => g.choices.isNotEmpty, orElse: () => groups.first);
    return ProviderAccountPickerResult(
      ProviderAccountSelection(
        sole.provider,
        sole.choices.isEmpty ? null : sole.choices.first.accountId,
      ),
    );
  }

  final picked = await showDialog<_ProviderPick>(
    context: context,
    builder: (ctx) => AppDialog(
      title: title ?? Translations.of(ctx).workspace.newChatProvider,
      content: _dialogBody(ctx, groups),
    ),
  );
  return ProviderAccountPickerResult(
    picked == null ? null : ProviderAccountSelection(picked.provider, picked.accountId),
  );
}

/// Fetches `/api/quota`, groups the accounts by provider (capabilities order
/// first) and resolves each account's quota health (worst window percentage vs
/// the configured thresholds).
Future<List<_ProviderGroup>> _buildGroups(
  BuildContext context,
  WidgetRef ref,
  List<String> providers,
  List<ProviderAccount> accounts,
) async {
  final i18n = Translations.of(context);
  var quotaById = const <String, QuotaAccount>{};
  var watch = 75.0;
  var danger = 90.0;
  try {
    final snap = QuotaSnapshot.fromJson(await ref.read(quotaRepositoryProvider).snapshot());
    quotaById = {for (final a in snap.accounts) a.id: a};
    if (snap.overview.watchThreshold > 0) watch = snap.overview.watchThreshold;
    if (snap.overview.dangerThreshold > 0) danger = snap.overview.dangerThreshold;
  } on Object {
    // Quota colours are best-effort — the dialog still lists the accounts.
  }

  QuotaTone toneForQuota(QuotaAccount? qa) {
    if (qa == null || qa.status == 'error') return QuotaTone.neutral;
    final worst = qa.windows.fold<double>(0, (m, w) => w.percent > m ? w.percent : m);
    return toneForPercent(worst, watch, danger);
  }

  /// The ambient (unpinned) credential — sessions that pin no account run under
  /// it. Antigravity's quota adapter reports ambient under 'gemini'.
  QuotaAccount? ambientQuota(String provider) =>
      quotaById[provider == 'antigravity' ? 'gemini' : provider];

  _AccountChoice ambientChoice(String provider) {
    final qa = ambientQuota(provider);
    final label = qa?.accountLabel ?? '';
    return _AccountChoice(
      accountId: null,
      label: label.isEmpty
          ? i18n.chat.composer.accountIsDefault
          : i18n.workspace.accountWithLabel(label: label),
      tone: toneForQuota(qa),
    );
  }

  final byProvider = <String, List<ProviderAccount>>{};
  for (final a in accounts) {
    final p = a.provider ?? '';
    if (p.isEmpty) continue;
    byProvider.putIfAbsent(p, () => []).add(a);
  }

  final ordered = <String>[
    ...providers,
    for (final p in byProvider.keys)
      if (!providers.contains(p)) p,
  ];

  return [
    for (final p in ordered)
      _ProviderGroup(
        provider: p,
        choices: [
          // Ambient row for every real provider whose login can be named —
          // named accounts always offer it (so the unpinned login stays
          // pickable), and a known quota label adds it for providers that only
          // have the ambient login (e.g. codex's email).
          if (p != 'orchestrator' &&
              p != 'mini-orchestrator' &&
              ((byProvider[p] ?? const <ProviderAccount>[]).isNotEmpty ||
                  (ambientQuota(p)?.accountLabel ?? '').isNotEmpty))
            ambientChoice(p),
          for (final a in byProvider[p] ?? const <ProviderAccount>[])
            _AccountChoice(
              accountId: a.id,
              label: (a.label ?? '').isNotEmpty ? a.label! : a.id,
              tone: toneForQuota(quotaById[a.id]),
            ),
        ],
      ),
  ];
}

Widget _dialogBody(BuildContext ctx, List<_ProviderGroup> groups) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 360, maxHeight: 420),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final g in groups)
            if (g.choices.isEmpty)
              ListTile(
                dense: true,
                title: Text(_providerLabel(g.provider)),
                onTap: () => Navigator.of(ctx).pop(_ProviderPick(g.provider, null)),
              )
            else ...[
              _groupHeader(ctx, g.provider),
              for (final choice in g.choices) _accountRow(ctx, g.provider, choice),
            ],
        ],
      ),
    ),
  );
}

Widget _groupHeader(BuildContext ctx, String provider) {
  final c = ctx.appColors;
  return Padding(
    padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 2),
    child: Text(
      _providerLabel(provider),
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c.mutedForeground),
    ),
  );
}

Widget _accountRow(BuildContext ctx, String provider, _AccountChoice choice) {
  final c = ctx.appColors;
  return InkWell(
    onTap: () => Navigator.of(ctx).pop(_ProviderPick(provider, choice.accountId)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
      child: Row(
        spacing: AppSpacing.xs,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: quotaToneColor(choice.tone)),
          ),
          Expanded(
            child: Text(
              choice.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: c.foreground),
            ),
          ),
        ],
      ),
    ),
  );
}

String _providerLabel(String provider) => switch (provider) {
  'orchestrator' => t.sessions.autoOrchestrator,
  'mini-orchestrator' => t.sessions.autoMini,
  _ => provider,
};

/// One provider in the account picker dialog. [choices] is empty when the
/// provider has no account to name — it then renders as a single selectable row.
class _ProviderGroup {
  const _ProviderGroup({required this.provider, required this.choices});

  final String provider;
  final List<_AccountChoice> choices;
}

/// One selectable account row — [accountId] is null when no account is pinned.
class _AccountChoice {
  const _AccountChoice({required this.accountId, required this.label, required this.tone});

  final String? accountId;
  final String label;
  final QuotaTone tone;
}

/// The dialog result: a provider plus the optional pinned account.
class _ProviderPick {
  const _ProviderPick(this.provider, this.accountId);

  final String provider;
  final String? accountId;
}
