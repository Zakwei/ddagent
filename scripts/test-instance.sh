#!/bin/bash
# Parallel "test beside prod" instance — never touches the systemd prod service
# (ddagent.service on :10087 / flutter-web.service on :8085).
#
#   backend : 127.0.0.1:10088  (dist-server/server/index.js)
#   web     : 0.0.0.0:8086     (scripts/serve-flutter-web.cjs -> :10088)
#   data    : /workspace/ddagent-test/auth.db (snapshot of the live DB)
#
# Auth skip for testing: VITE_IS_PLATFORM=true puts the backend in platform
# mode, where authenticateToken()/authenticateWebSocket() resolve the first DB
# user without a token — the UI is reachable with no login. The snapshot DB
# already carries that user. See server/modules/auth/auth.middleware.ts.
#
# Usage: scripts/test-instance.sh {start|stop|status|restart}
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
DIR="${DDAGENT_TEST_DIR:-/workspace/ddagent-test}"
BACKEND_PORT="${DDAGENT_TEST_BACKEND_PORT:-10088}"
WEB_PORT="${DDAGENT_TEST_WEB_PORT:-8086}"
NODE_BIN="${NODE_BIN:-node}"
LIVE_DB="${DATABASE_PATH:-/home/opencode/.local/share/opencode/ddagent/auth.db}"
PROJECT_PATH="${DDAGENT_TEST_PROJECT_PATH:-/workspace/ddagent-src}"

backend_pid_file="$DIR/backend.pid"
web_pid_file="$DIR/web.pid"

alive() { [ -f "$1" ] && kill -0 "$(cat "$1")" 2>/dev/null; }

# WAL-safe snapshot of the live DB via SQLite's own backup API.
snapshot_db() {
  mkdir -p "$DIR"
  [ -f "$LIVE_DB" ] || { echo "live DB not found: $LIVE_DB" >&2; exit 1; }
  "$NODE_BIN" -e '
    const Database = require("better-sqlite3");
    const src = new Database(process.argv[1], { readonly: true, fileMustExist: true });
    src.backup(process.argv[2]).then(() => process.exit(0)).catch((e) => {
      console.error(e); process.exit(1);
    });
  ' "$LIVE_DB" "$DIR/auth.db"
}

wait_for() {
  local url="$1" i
  for i in $(seq 1 60); do
    curl -sf "$url" >/dev/null && return 0
    sleep 0.5
  done
  echo "timed out waiting for $url" >&2
  return 1
}

start() {
  mkdir -p "$DIR"
  if alive "$backend_pid_file" || alive "$web_pid_file"; then
    echo "test instance already running — use 'stop' first" >&2
    exit 0
  fi
  snapshot_db

  (
    cd "$ROOT"
    VITE_IS_PLATFORM=true SERVER_PORT="$BACKEND_PORT" HOST=127.0.0.1 \
      DATABASE_PATH="$DIR/auth.db" WORKSPACES_ROOT=/workspace \
      "$NODE_BIN" dist-server/server/index.js > "$DIR/backend.log" 2>&1 &
    echo $! > "$backend_pid_file"
  )
  wait_for "http://127.0.0.1:$BACKEND_PORT/health"

  (
    cd "$ROOT"
    FLUTTER_WEB_PORT="$WEB_PORT" FLUTTER_BACKEND_PORT="$BACKEND_PORT" \
      DATABASE_PATH="$DIR/auth.db" \
      "$NODE_BIN" scripts/serve-flutter-web.cjs > "$DIR/web.log" 2>&1 &
    echo $! > "$web_pid_file"
  )
  wait_for "http://127.0.0.1:$WEB_PORT/"

  echo "backend : http://127.0.0.1:$BACKEND_PORT  (pid $(cat "$backend_pid_file"))"
  echo "web     : http://127.0.0.1:$WEB_PORT  (pid $(cat "$web_pid_file"))"
  echo "terminal: http://127.0.0.1:$WEB_PORT/terminal?projectPath=$PROJECT_PATH"
  echo "logs    : $DIR/backend.log  $DIR/web.log"
}

stop() {
  for f in "$web_pid_file" "$backend_pid_file"; do
    if [ -f "$f" ]; then
      kill "$(cat "$f")" 2>/dev/null || true
      rm -f "$f"
    fi
  done
  echo "test instance stopped"
}

status() {
  if alive "$backend_pid_file"; then
    echo "backend: running (pid $(cat "$backend_pid_file"))"
  else
    echo "backend: stopped"
  fi
  if alive "$web_pid_file"; then
    echo "web: running (pid $(cat "$web_pid_file"))"
  else
    echo "web: stopped"
  fi
}

case "${1:-start}" in
  start) start ;;
  stop) stop ;;
  status) status ;;
  restart) stop; sleep 1; start ;;
  *) echo "usage: $0 {start|stop|status|restart}" >&2; exit 2 ;;
esac
