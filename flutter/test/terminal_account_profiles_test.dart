import 'package:ddagent_app/features/provider_accounts/state/provider_accounts_controller.dart';
import 'package:ddagent_app/features/terminal/state/terminal_account_profiles.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderAccountEntry _account(
  String provider,
  String label, {
  Map<String, String> env = const {'CLAUDE_CONFIG_DIR': '/x'},
}) => ProviderAccountEntry(
  id: '$provider-$label',
  provider: provider,
  label: label,
  envOverrides: env,
  isDefault: false,
);

void main() {
  _commandTests();
  test('account profiles follow the provider order, then the label', () {
    final profiles = terminalAccountProfiles(
      [
        _account('opencode', 'Zeta'),
        _account('claude', 'work'),
        _account('claude', 'Home'),
        _account('codex', 'Team'),
      ],
      providers: const ['claude', 'codex', 'opencode'],
    );
    expect(profiles.map((p) => p.title('${p.provider} CLI')).toList(), [
      'claude CLI · Home',
      'claude CLI · work',
      'codex CLI · Team',
      'opencode CLI · Zeta',
    ]);
  });

  test('accounts of unsupported providers and without env overrides are skipped', () {
    final profiles = terminalAccountProfiles(
      [
        _account('claude', 'Plain', env: const {}),
        _account('mystery', 'Who'),
        _account('claude', 'Isolated'),
      ],
      providers: const ['claude', 'codex'],
    );
    expect(profiles.map((p) => p.account.label).toList(), ['Isolated']);
    expect(profiles.single.account.envOverrides, {'CLAUDE_CONFIG_DIR': '/x'});
  });
}

void _commandTests() {
  test('POSIX command scopes the account env to the CLI process', () {
    expect(
      terminalAccountCommand(
        provider: 'claude',
        env: const {'CLAUDE_CONFIG_DIR': "/home/me/.ddagent/accounts/a'b/claude"},
        windows: false,
      ),
      "env CLAUDE_CONFIG_DIR='/home/me/.ddagent/accounts/a'\\''b/claude' claude",
    );
    expect(
      terminalAccountCommand(
        provider: 'opencode',
        env: const {'XDG_DATA_HOME': '/d', 'XDG_CONFIG_HOME': '/c'},
        windows: false,
      ),
      "env XDG_CONFIG_HOME='/c' XDG_DATA_HOME='/d' opencode",
    );
    expect(
      terminalAccountCommand(provider: 'cursor', env: const {}, windows: false),
      'cursor-agent',
    );
  });

  test('PowerShell command assigns the env then starts the CLI binary', () {
    expect(
      terminalAccountCommand(
        provider: 'commandcode',
        env: const {'HOME': r"C:\Users\me\it's", 'USERPROFILE': r'C:\Users\me'},
        windows: true,
      ),
      r"$env:HOME='C:\Users\me\it''s'; $env:USERPROFILE='C:\Users\me'; cmdc",
    );
    expect(providerCliBinary('commandcode', windows: false), 'command-code');
    expect(providerCliBinary('antigravity', windows: true), 'agy');
  });
}
