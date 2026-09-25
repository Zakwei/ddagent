# Security Policy

## Reporting a vulnerability

Please report security issues privately via
[GitHub Security Advisories](https://github.com/Zakwei/ddagent/security/advisories/new)
("Report a vulnerability" on the Security tab). Do **not** open a public issue
for undisclosed vulnerabilities.

Include:

- Steps to reproduce and the affected version/commit
- Impact assessment (what an attacker could do)
- Suggested fix or mitigation, if you have one

You should get an acknowledgement within a few days. If the report is accepted,
a fix is prepared privately and a security advisory is published with the fix
release.

## Scope

ddagent is a self-hosted UI that runs AI coding agents with real system access —
it can spawn shells, edit files, and run git commands on the machine it is
installed on. Treat the server as privileged: do not expose it to untrusted
networks without authentication, and keep it updated.

In scope:

- Authentication/authorization bypasses in the web UI, REST, or WebSocket API
- Remote code execution through the API beyond the intended agent capabilities
- Token or credential handling flaws
- Sandbox (`sbx`/Docker) escape issues in the provided templates

Out of scope:

- Attacks requiring physical or root access to the host
- Vulnerabilities in the AI agents themselves (report to their vendors)
- Social engineering
