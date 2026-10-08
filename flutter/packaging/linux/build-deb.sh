#!/usr/bin/env bash
# Build a .deb from the flutter linux release bundle.
#   bash flutter/packaging/linux/build-deb.sh v0.8.0
# Output: release/flutter/ddagent-flutter-linux-x64-<tag>.deb (repo root)
set -euo pipefail

VERSION="${1:?usage: build-deb.sh <version-tag, e.g. v0.8.0>}"
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
BUNDLE="$ROOT/flutter/build/linux/x64/release/bundle"
[[ -x "$BUNDLE/ddagent_app" ]] || { echo "missing bundle: $BUNDLE (run flutter build linux --release first)"; exit 1; }

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/opt/ddagent" "$STAGE/usr/bin" \
  "$STAGE/usr/share/applications" \
  "$STAGE/usr/share/icons/hicolor/512x512/apps" \
  "$STAGE/DEBIAN"

cp -a "$BUNDLE/." "$STAGE/opt/ddagent/"
ln -s /opt/ddagent/ddagent_app "$STAGE/usr/bin/ddagent"
cp "$ROOT/flutter/web/icons/Icon-512.png" "$STAGE/usr/share/icons/hicolor/512x512/apps/ddagent.png"

cat > "$STAGE/usr/share/applications/ddagent.desktop" <<'EOF'
[Desktop Entry]
Name=DDAgent
Comment=Self-hosted interface for AI coding agents
Exec=/usr/bin/ddagent
Icon=ddagent
Terminal=false
Type=Application
Categories=Development;
EOF

cat > "$STAGE/DEBIAN/control" <<EOF
Package: ddagent
Version: ${VERSION#v}
Section: devel
Priority: optional
Architecture: amd64
Maintainer: DDAgent <https://github.com/Zakwei/ddagent>
Depends: libgtk-3-0t64 | libgtk-3-0, libsecret-1-0, liblzma5
Description: Self-hosted interface for AI coding agents
 Flutter desktop client for DDAgent — connect to a DDAgent server and drive
 Claude Code, Codex, Cursor CLI, OpenCode, Devin and other agents.
EOF

mkdir -p "$ROOT/release/flutter"
dpkg-deb --root-owner-group --build "$STAGE" \
  "$ROOT/release/flutter/ddagent-flutter-linux-x64-${VERSION}.deb"
