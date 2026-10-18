import 'package:ddagent_app/features/provider_accounts/state/provider_accounts_controller.dart';

/// One "run this agent on that account" profile for the terminal's `⌄`
/// dropdown: opens a provider CLI tab whose PTY carries the account's
/// config-dir env (`CLAUDE_CONFIG_DIR`, `CODEX_HOME`, `XDG_CONFIG_HOME`, …),
/// so the CLI signs in and bills as that account instead of the host default.
class TerminalAccountProfile {
  const TerminalAccountProfile({required this.provider, required this.account});

  final String provider;
  final ProviderAccountEntry account;

  /// Tab title and menu label: `Claude CLI · Work`.
  String title(String providerLabel) => '$providerLabel · ${account.label}';
}

/// Account profiles to list under the provider profiles, in [providers] order
/// (the dropdown's fixed profile order) and then by account label. Only
/// providers the server can start a CLI tab for are offered, and only accounts
/// that actually redirect something — an account with no env overrides would
/// open the very same CLI as the plain provider profile.
List<TerminalAccountProfile> terminalAccountProfiles(
  List<ProviderAccountEntry> accounts, {
  required List<String> providers,
}) {
  final profiles = <TerminalAccountProfile>[];
  for (final provider in providers) {
    final ofProvider =
        accounts.where((a) => a.provider == provider && a.envOverrides.isNotEmpty).toList()
          ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
    profiles.addAll([
      for (final account in ofProvider)
        TerminalAccountProfile(provider: provider, account: account),
    ]);
  }
  return profiles;
}
