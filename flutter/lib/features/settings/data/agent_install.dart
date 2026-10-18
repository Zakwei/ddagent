/// Per-provider CLI install commands and documentation links.
///
/// The command is run through the existing terminal dialog so the user sees
/// the installer output on the host that runs the server. `claude`, `codex`,
/// `opencode` and `commandcode` install via npm — the server itself is a Node
/// process, so npm is always present — while the remaining CLIs ship a native
/// install script. [windows] is the *server's* OS (from `GET /health`
/// `platform`) — the command runs on the server host, which may not be this
/// client's machine; on Windows the native installers are their official
/// PowerShell one-liners (the server runs terminals in PowerShell).
String providerInstallCommand(String provider, {bool windows = false}) => switch (provider) {
  'cursor' when windows => "irm 'https://cursor.com/install?win32=true' | iex",
  'antigravity' when windows => 'irm https://antigravity.google/cli/install.ps1 | iex',
  'devin' when windows => 'irm https://static.devin.ai/cli/setup.ps1 | iex',
  'cursor' => 'curl https://cursor.com/install -fsS | bash',
  'antigravity' => 'curl -fsSL https://antigravity.google/cli/install.sh | bash',
  'devin' => 'curl -fsSL https://cli.devin.ai/install.sh | bash',
  _ => npmGlobalInstallCommand(providerNpmPackage(provider)),
};

/// npm package behind the npm-distributed provider CLIs.
String providerNpmPackage(String provider) => switch (provider) {
  'claude' => '@anthropic-ai/claude-code',
  'codex' => '@openai/codex',
  'opencode' => '@opencode/cli',
  'commandcode' => 'command-code',
  _ => provider,
};

/// `npm install -g` for a provider package. npm 11.19+ refuses to run a
/// package's install scripts unless it is on the `allow-scripts` list, and
/// prints only a warning: `@anthropic-ai/claude-code` (postinstall fetches
/// the native binary) and `@opencode/cli` then "install" with exit code 0 but
/// are left without a working binary — the in-app update looked successful
/// and changed nothing. The flag names the package explicitly; older npm
/// ignores the unknown option with a warning.
String npmGlobalInstallCommand(String package, {bool latest = false}) =>
    'npm install -g --allow-scripts=$package $package${latest ? '@latest' : ''}';

/// Per-provider CLI update commands, run through the same terminal dialog as
/// [providerInstallCommand]. The npm-packaged CLIs re-install pinned to
/// `@latest`; the script-installed ones have no separate updater — their
/// install script replaces the binary in place, so it doubles as the update.
///
/// The CLI itself is a single host-wide installation (the server resolves it
/// from PATH), shared by every named provider account — so updating is a
/// provider-level action, never a per-account one.
String providerUpdateCommand(String provider, {bool windows = false}) => switch (provider) {
  'cursor' || 'antigravity' || 'devin' => providerInstallCommand(provider, windows: windows),
  // Claude Code is usually a *native* install (its install.sh, or the npm
  // package's postinstall) living under ~/.local/share/claude/versions with a
  // launcher in ~/.local/bin; `npm install -g` would only refresh a package
  // that launcher never runs. `claude update` upgrades a native install and
  // exits non-zero for a pure npm one, where the npm command then applies.
  'claude' => _firstThatSucceeds(
    'claude update',
    npmGlobalInstallCommand(providerNpmPackage(provider), latest: true),
    windows: windows,
  ),
  _ => npmGlobalInstallCommand(providerNpmPackage(provider), latest: true),
};

/// `first || second` for the server's shell — PowerShell 5 has no `||`.
String _firstThatSucceeds(String first, String second, {required bool windows}) =>
    windows ? '$first; if (\$LASTEXITCODE -ne 0) { $second }' : '$first || $second';

/// Official installation docs for a provider CLI. Null when no stable docs
/// URL is known; the install card then hides its documentation link.
String? providerInstallDocsUrl(String provider) => switch (provider) {
  'claude' => 'https://code.claude.com/docs/en/setup',
  'cursor' => 'https://cursor.com/docs/cli/installation',
  'codex' => 'https://github.com/openai/codex',
  'opencode' => 'https://opencode.ai/docs',
  'antigravity' => 'https://antigravity.google/docs/cli/install',
  'devin' => 'https://docs.devin.ai/cli',
  _ => null,
};
