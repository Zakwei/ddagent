# Security Policy

## Supported versions

Security fixes are released for the latest minor version only. Please update
to the newest release before reporting.

| Version | Supported |
|---|---|
| 0.8.x | Yes |
| < 0.8 | No |

## Reporting a vulnerability

Please report security issues privately via
[GitHub Security Advisories](https://github.com/Zakwei/ddagent/security/advisories/new)
("Report a vulnerability" on the Security tab). If you cannot use GitHub, email
kontakt@ddnet.com.pl. Do **not** open a public issue for undisclosed
vulnerabilities.

Include:

- Steps to reproduce and the affected version or commit
- Impact assessment (what an attacker could do)
- Suggested fix or mitigation, if you have one

You should get an acknowledgement within a few days. If the report is accepted,
a fix is prepared privately and a security advisory is published together with
the fixed release.

## Scope

DDAgent is a self-hosted server that runs AI coding agents with real system
access — it can spawn shells, edit files and run git commands on the machine it
is installed on. Treat the server as privileged:

- Do not expose it to untrusted networks; put it behind TLS and, ideally, a VPN
  or an authenticating reverse proxy.
- Platform mode (`VITE_IS_PLATFORM=true`, used by the web client) disables
  authentication entirely — only run it on a trusted network.
- Keep the server and the client updated.

In scope:

- Authentication or authorization bypasses in the REST or WebSocket API, or in
  the Flutter client
- Remote code execution through the API beyond the intended agent capabilities
- Token or credential handling flaws (login tokens, API keys, MCP tokens,
  provider account credentials)
- Sandbox escapes in the provided Docker Sandbox (`sbx`) templates

Out of scope:

- Attacks that require physical or root access to the host
- Unauthenticated access to a server deliberately run in platform mode
- Vulnerabilities in the AI agents themselves (report them to their vendors)
- Social engineering
