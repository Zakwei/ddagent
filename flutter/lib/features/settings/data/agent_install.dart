/// Per-provider CLI install commands and documentation links.
///
/// The command is run through the existing terminal dialog so the user sees
/// the installer output on the host that runs the server. `claude`, `codex`,
/// `opencode` and `commandcode` install via npm — the server itself is a Node
/// process, so npm is always present — while the remaining CLIs ship a native
/// install script.
String providerInstallCommand(String provider) => switch (provider) {
  'claude' => 'npm install -g @anthropic-ai/claude-code',
  'cursor' => 'curl https://cursor.com/install -fsS | bash',
  'codex' => 'npm install -g @openai/codex',
  'opencode' => 'npm install -g opencode-ai',
  'commandcode' => 'npm install -g command-code',
  'antigravity' => 'curl -fsSL https://antigravity.google/cli/install.sh | bash',
  'devin' => 'curl -fsSL https://cli.devin.ai/install.sh | bash',
  _ => 'npm install -g $provider',
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
