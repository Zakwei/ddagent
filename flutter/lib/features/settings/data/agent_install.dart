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
  'claude' => 'npm install -g @anthropic-ai/claude-code',
  'cursor' => 'curl https://cursor.com/install -fsS | bash',
  'codex' => 'npm install -g @openai/codex',
  'opencode' => 'npm install -g opencode-ai',
  'commandcode' => 'npm install -g command-code',
  'antigravity' => 'curl -fsSL https://antigravity.google/cli/install.sh | bash',
  'devin' => 'curl -fsSL https://cli.devin.ai/install.sh | bash',
  _ => 'npm install -g $provider',
};

/// Per-provider CLI update commands, run through the same terminal dialog as
/// [providerInstallCommand]. The npm-packaged CLIs re-install pinned to
/// `@latest`; the script-installed ones have no separate updater — their
/// install script replaces the binary in place, so it doubles as the update.
///
/// The CLI itself is a single host-wide installation (the server resolves it
/// from PATH), shared by every named provider account — so updating is a
/// provider-level action, never a per-account one.
String providerUpdateCommand(String provider, {bool windows = false}) => switch (provider) {
  'claude' => 'npm install -g @anthropic-ai/claude-code@latest',
  'codex' => 'npm install -g @openai/codex@latest',
  'opencode' => 'npm install -g opencode-ai@latest',
  'commandcode' => 'npm install -g command-code@latest',
  'cursor' || 'antigravity' || 'devin' => providerInstallCommand(provider, windows: windows),
  _ => 'npm install -g $provider@latest',
};

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
