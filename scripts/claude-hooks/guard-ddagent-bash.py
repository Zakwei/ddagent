#!/usr/bin/env python3
"""Claude Code PreToolUse hook (Bash): refuses commands that can take down the
local ddagent deployment on this machine.

Wired from `.claude/settings.json`. Reads the hook JSON on stdin and prints a
`permissionDecision: deny` when the command matches one of the rules below;
anything else passes through untouched (exit 0, no output).

Why: an agent once killed processes by name and launched nested `claude`
sessions while probing a terminal bug — the user had to rebuild the local
deployment. AGENTS.md already forbids restarting/killing ddagent, devin and
opencode without approval; this makes the rule mechanical.
"""
import json
import re
import sys

DEPLOY = r"(ddagent|pty-host|devin|opencode|windsurf|dist-server|start-ddagent|flutter-web|claude)"

RULES = [
    # Process killing by name — matches the user's own Claude/ddagent processes.
    (r"(^|[\s;&|(])(pkill|killall)\b", "pkill/killall kill processes by name — the user's ddagent, Devin and Claude sessions run on this machine. Ask the user instead."),
    (r"(^|[\s;&|(])kill\b.*" + DEPLOY, "kill against a ddagent/devin/claude process needs the user's explicit approval (AGENTS.md)."),
    # Service control of the local deployment.
    (r"\bsystemctl\b.*\b(stop|restart|disable|kill|mask|reload)\b.*(ddagent|flutter-web|windsurf)", "Restarting/stopping ddagent services kills the user's sessions — hand the command to the user and wait (AGENTS.md)."),
    (r"\bservice\s+(ddagent|flutter-web|windsurf)\S*\s+(stop|restart)", "Restarting/stopping ddagent services needs the user's explicit approval."),
    # Deleting build/runtime artefacts the live instance serves from.
    (r"\brm\b.*(dist-server|flutter/build|build/web|\.ddagent(/|\b)|local-server\.json|\.ddagent-patch|start-ddagent\.sh)", "That path is what the live ddagent instance runs from — never delete it; rebuild in place instead."),
    (r"\bflutter\s+clean\b", "`flutter clean` wipes flutter/build/web, which flutter-web.service serves live. Rebuild with `flutter build web --release` instead."),
    # Destructive git operations on the working tree.
    (r"\bgit\s+clean\b", "`git clean` can remove untracked local deployment files. Ask the user."),
    (r"\bgit\s+reset\s+--hard\b", "`git reset --hard` discards uncommitted work. Ask the user."),
    (r"\bgit\s+(checkout|restore)\s+(--\s+)?\.(\s|$)", "Discarding the whole working tree needs the user's approval."),
    (r"\bgit\s+push\b.*(--force\b|-f\b|\+\S+)", "Force-pushing needs the user's explicit approval."),
    # Nested interactive Claude Code sessions inherit this session's env and hooks.
    (r"(^|[\s;&|(])(claude|/[\w./-]*/claude)(\s+--allow-dangerously-skip-permissions|\s+--dangerously-skip-permissions)?(\s*$|\s*[;&|)])", "Do not launch an interactive `claude` from a Claude session — it inherits this session's environment and runs the user's hooks. Use a pty probe only with the user's approval."),
]


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return 0
    if payload.get("tool_name") != "Bash":
        return 0
    command = str((payload.get("tool_input") or {}).get("command") or "")
    for pattern, reason in RULES:
        if re.search(pattern, command, re.MULTILINE):
            json.dump(
                {
                    "hookSpecificOutput": {
                        "hookEventName": "PreToolUse",
                        "permissionDecision": "deny",
                        "permissionDecisionReason": f"guard-ddagent-bash: {reason}",
                    }
                },
                sys.stdout,
            )
            return 0
    return 0


if __name__ == "__main__":
    sys.exit(main())
