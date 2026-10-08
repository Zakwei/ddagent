<!-- Docker Hub short description (100 chars max): -->
<!-- Sandbox templates running Claude Code or Codex with the ddagent server for remote control -->

# Sandboxed coding agents with ddagent

[Docker Sandbox](https://docs.docker.com/ai/sandboxes/) templates that add the [ddagent](https://github.com/Zakwei/ddagent) server on top of Claude Code and Codex. Connect the ddagent Flutter client (web, Linux/Windows desktop or Android) to the sandbox and drive the agent from any device.

## Get started

### 1. Install the sbx CLI

Docker Sandboxes run agents in isolated microVMs. Install the `sbx` CLI:

- **macOS**: `brew install docker/tap/sbx`
- **Windows**: `winget install -h Docker.sbx`
- **Linux**: `sudo apt-get install docker-sbx`

Full instructions: [docs.docker.com/ai/sandboxes/get-started](https://docs.docker.com/ai/sandboxes/get-started/)

### 2. Store your API key

`sbx` manages credentials securely — your API key never enters the sandbox. Store it once:

```bash
sbx login
sbx secret set -g anthropic
```

### 3. Launch Claude Code

> Run the `ddagent` CLI below as `node dist-server/server/modules/cli/cli.js` inside a ddagent install (`~/.ddagent/app`) or a source checkout — see the [main README](https://github.com/Zakwei/ddagent#install).

```bash
ddagent sandbox ~/my-project
```

The server is published on **http://localhost:3001** (use `--port <port>` to pick another host port). It serves the REST/WebSocket API only — point the ddagent Flutter client at that URL and create the owner account on first connect.

### Using a different agent

Store the matching API key and pass `--agent`:

```bash
# OpenAI Codex
sbx secret set -g openai
ddagent sandbox ~/my-project --agent codex
```

### Available templates

| Agent | Template |
|-------|----------|
| **Claude Code** (default) | `docker.io/ddagentai/sandbox:claude-code` |
| OpenAI Codex | `docker.io/ddagentai/sandbox:codex` |

These are used with `--template` when running `sbx` directly (see [Advanced usage](#advanced-usage)).

## Managing sandboxes

```bash
sbx ls                               # List all sandboxes
sbx stop my-project                  # Stop (preserves state)
sbx start my-project                 # Restart a stopped sandbox
sbx rm my-project                    # Remove everything
sbx exec my-project bash             # Open a shell inside the sandbox
```

The same `ddagent` CLI manages sandboxes:

```bash
ddagent sandbox ls
ddagent sandbox start my-project    # Restart and re-launch the ddagent server
ddagent sandbox logs my-project     # View server logs
```

## What you get

Through the Flutter client connected to the sandbox:

- **Chat** — Markdown rendering, code blocks, message history
- **Files** — File tree with syntax-highlighted editor
- **Git** — Diff viewer, staging, branch switching, commits
- **Shell** — Built-in terminal emulator
- **MCP** — Configure Model Context Protocol servers visually
- **Any device** — web, Linux/Windows desktop and Android

Your project directory is mounted bidirectionally — edits propagate in real time, both ways.

## Configuration

Set variables at creation time with `--env` (repeatable):

```bash
ddagent sandbox ~/my-project --env CONTEXT_WINDOW=200000
```

Or inside a running sandbox:

```bash
sbx exec my-project bash -c 'echo "export CONTEXT_WINDOW=200000" >> /etc/sandbox-persistent.sh'
```

Restart ddagent for changes to take effect:

```bash
sbx exec my-project bash -c 'pkill -f "server/index.js"'
sbx exec -d my-project ddagent start --port 3001
```

| Variable | Default | Description |
|----------|---------|-------------|
| `HOST` | `0.0.0.0` | Bind address (must be `0.0.0.0` for `sbx ports`) |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | SQLite database location |
| `CONTEXT_WINDOW` | `200000` | Fallback context window (tokens) until the Claude SDK reports one |

Inside the sandbox the server always listens on port `3001` (the launch commands pass `--port 3001`, which overrides `SERVER_PORT`). To expose it on a different host port, use `ddagent sandbox ... --port <port>` or `sbx ports <name> --publish <port>:3001`.

## Advanced usage

For branch mode, multiple workspaces, memory limits, or the terminal agent experience, use `sbx` with the template:

```bash
# Terminal agent + ddagent server
sbx run --template docker.io/ddagentai/sandbox:claude-code claude ~/my-project --name my-project
sbx ports my-project --publish 3001:3001

# Branch mode (Git worktree isolation)
sbx run --template docker.io/ddagentai/sandbox:claude-code claude ~/my-project --branch my-feature

# Multiple workspaces
sbx run --template docker.io/ddagentai/sandbox:claude-code claude ~/project ~/shared-libs:ro

# Pass a prompt directly
sbx run --template docker.io/ddagentai/sandbox:claude-code claude ~/my-project -- "Fix the auth bug"
```

ddagent auto-starts via `.bashrc` when using `sbx run`.

Full options in the [Docker Sandboxes usage guide](https://docs.docker.com/ai/sandboxes/usage/).

## Network policies

Sandboxes restrict outbound access by default. To reach host services from inside the sandbox:

```bash
sbx policy allow network localhost:11434
# Inside the sandbox: curl http://host.docker.internal:11434
```

The ddagent server itself doesn't need a policy — reach it via `sbx ports`.

## Links

- [Documentation](https://github.com/Zakwei/ddagent#readme) — install and configuration guide
- [GitHub](https://github.com/Zakwei/ddagent) — source code and issues
