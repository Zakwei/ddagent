#!/usr/bin/env bash
# scripts/release/gen-release-notes.sh
#
# Generates a draft English "What's new" / "Bug fixes" section for
# scripts/release/release-notes-template.md from git log since the last tag.
#
# Prints to stdout — redirect or copy into the <!-- lang:en --> section.
# The other 11 locale sections must be filled in manually.
#
# Usage:
#   ./scripts/release/gen-release-notes.sh

set -euo pipefail

PREV_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")
RANGE="${PREV_TAG:+${PREV_TAG}..HEAD}"

if [[ -z "$PREV_TAG" ]]; then
  echo "# (no previous tag found — showing all commits)" >&2
fi

FEATURES=()
FIXES=()
OTHER=()

while IFS= read -r line; do
  msg="${line#* }"   # strip leading hash
  case "$msg" in
    feat*|Feature*)   FEATURES+=("$msg") ;;
    fix*|Fix*)        FIXES+=("$msg") ;;
    *)                OTHER+=("$msg") ;;
  esac
done < <(git log ${RANGE:-HEAD} --oneline --no-merges)

echo "<!-- lang:en -->"
echo "### What's new"
if [[ ${#FEATURES[@]} -eq 0 ]]; then
  echo "- TODO"
else
  for f in "${FEATURES[@]}"; do echo "- $f"; done
fi

echo ""
echo "### Bug fixes"
if [[ ${#FIXES[@]} -eq 0 ]]; then
  echo "- TODO"
else
  for f in "${FIXES[@]}"; do echo "- $f"; done
fi

if [[ ${#OTHER[@]} -gt 0 ]]; then
  echo ""
  echo "<!-- other commits (review and move or delete) -->"
  for f in "${OTHER[@]}"; do echo "<!-- $f -->"; done
fi
