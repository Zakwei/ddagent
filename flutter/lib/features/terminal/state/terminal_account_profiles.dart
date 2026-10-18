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

/// Binary the server's shell bridge starts for a provider CLI tab — kept in
/// step with `buildShellCommand` in shell-websocket.service.ts.
String providerCliBinary(String provider, {required bool windows}) => switch (provider) {
  // Same flag the server's shell bridge adds: it puts "bypass permissions"
  // into Claude's Shift+Tab cycle without starting in it.
  'claude' => 'claude --allow-dangerously-skip-permissions',
  'cursor' => 'cursor-agent',
  'commandcode' => windows ? 'cmdc' : 'command-code',
  'antigravity' => 'agy',
  'codex' || 'opencode' || 'devin' => provider,
  _ => provider,
};

String _posixQuote(String value) => "'${value.replaceAll("'", r"'\''")}'";
String _powerShellQuote(String value) => "'${value.replaceAll("'", "''")}'";

/// One shell line that starts [provider]'s CLI with [env] applied, typed into
/// the shell the user already has open — so the CLI runs in that shell's
/// working directory. POSIX shells get `env K=V … bin`, which scopes the
/// variables to the CLI process; PowerShell has no such prefix form, so the
/// variables are assigned to the session first (`$env:K='V'; bin`) and stay
/// set in that tab afterwards.
String terminalAccountCommand({
  required String provider,
  required Map<String, String> env,
  required bool windows,
}) {
  final bin = providerCliBinary(provider, windows: windows);
  final keys = env.keys.toList()..sort();
  if (windows) {
    return [for (final k in keys) '\$env:$k=${_powerShellQuote(env[k]!)};', bin].join(' ');
  }
  if (keys.isEmpty) return bin;
  return ['env', for (final k in keys) '$k=${_posixQuote(env[k]!)}', bin].join(' ');
}
