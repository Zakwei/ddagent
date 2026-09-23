#!/usr/bin/env bash
# ddagent self-hosted server installer.
#
# Clones a release tag of this repository, installs dependencies, builds the
# web UI + backend, and leaves a runnable server:
#
#   <dir>/start.sh                      (node dist-server/server/index.js)
#
# The server serves the web UI and the REST/WS API that ddagent Desktop and
# Mobile connect to remotely.
#
# Usage:
#   ./install.sh [--version vX.Y.Z] [--dir <path>] [--systemd] [--port <port>]
#   curl -fsSL <release-or-raw-url>/install.sh | bash -s -- --systemd
#
# Defaults: latest v* tag, install dir ~/.ddagent/app, port 3001.
# Env overrides: DDAGENT_REPO, DDAGENT_VERSION, DDAGENT_DIR, SERVER_PORT, HOST.
#
# Requirements: git, Node.js >= 22, npm. Native deps (better-sqlite3,
# node-pty, bcrypt) use prebuilt binaries on mainstream platforms; elsewhere a
# C toolchain (python3/make/g++) is needed. While the repo is private, cloning
# needs GitHub auth (e.g. `gh auth setup-git` or SSH keys).
set -euo pipefail

REPO_URL="${DDAGENT_REPO:-https://github.com/Zakwei/ddagent.git}"
VERSION="${DDAGENT_VERSION:-latest}"
INSTALL_DIR="${DDAGENT_DIR:-$HOME/.ddagent/app}"
SERVER_PORT="${SERVER_PORT:-3001}"
USE_SYSTEMD=0

while [ $# -gt 0 ]; do
  case "$1" in
    --version) VERSION="$2"; shift 2 ;;
    --dir) INSTALL_DIR="$2"; shift 2 ;;
    --port) SERVER_PORT="$2"; shift 2 ;;
    --systemd) USE_SYSTEMD=1; shift ;;
    -h|--help) sed -n '2,22p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

need() { command -v "$1" >/dev/null 2>&1 || { echo "error: '$1' is required but not installed" >&2; exit 1; }; }
need git
need node
need npm

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
if [ "$NODE_MAJOR" -lt 22 ]; then
  echo "error: Node.js >= 22 required (found $(node --version))" >&2
  exit 1
fi

if [ "$VERSION" = "latest" ]; then
  VERSION="$(git ls-remote --tags --sort=-v:refname "$REPO_URL" 'v*' | tail -n1 | sed 's|.*refs/tags/||')"
  [ -n "$VERSION" ] || { echo "error: could not resolve latest release tag" >&2; exit 1; }
fi
echo ">> Installing ddagent server $VERSION into $INSTALL_DIR"

if [ -d "$INSTALL_DIR/.git" ]; then
  git -C "$INSTALL_DIR" fetch --depth 1 origin "refs/tags/$VERSION:refs/tags/$VERSION" 2>/dev/null \
    || git -C "$INSTALL_DIR" fetch --depth 1 origin tag "$VERSION"
  git -C "$INSTALL_DIR" checkout --detach --force "$VERSION"
else
  git clone --depth 1 --branch "$VERSION" "$REPO_URL" "$INSTALL_DIR"
fi
cd "$INSTALL_DIR"

# electron is a devDependency and its postinstall downloads a ~100MB binary the
# server never runs — skip just that download, keep every other install script
# (natives, ripgrep).
export ELECTRON_SKIP_BINARY_DOWNLOAD=1
npm ci

# Platform build: without this flag vite emits an OSS-mode bundle whose login
# screen never connects (see .github/workflows/desktop-release.yml).
VITE_IS_PLATFORM=true npm run build

# Drop devDependencies — the server only needs the production set.
npm prune --omit=dev

cat > start.sh <<'EOF'
#!/bin/sh
# Env: SERVER_PORT (default 3001), HOST (default 0.0.0.0). Optional .env file here.
exec node "$(dirname "$0")/dist-server/server/index.js" "$@"
EOF
chmod +x start.sh

if [ "$USE_SYSTEMD" = "1" ]; then
  UNIT_DIR="$HOME/.config/systemd/user"
  mkdir -p "$UNIT_DIR"
  cat > "$UNIT_DIR/ddagent.service" <<EOF
[Unit]
Description=ddagent server
After=network-online.target

[Service]
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/start.sh
Environment=SERVER_PORT=$SERVER_PORT
Restart=on-failure

[Install]
WantedBy=default.target
EOF
  systemctl --user daemon-reload
  systemctl --user enable --now ddagent
  echo ">> systemd user service 'ddagent' enabled on port $SERVER_PORT"
  echo ">> to start it at boot without login: sudo loginctl enable-linger $USER"
fi

cat <<EOF

ddagent server $VERSION installed in $INSTALL_DIR

  Start:      $INSTALL_DIR/start.sh
  Port:       SERVER_PORT=$SERVER_PORT $INSTALL_DIR/start.sh
  Update:     $0 --version vX.Y.Z   (re-run in place)

EOF
