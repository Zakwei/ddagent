#!/usr/bin/env bash
# scripts/release/autodeploy.sh
#
# Full release automation: safety checks → tests → bump → build → push.
# Steps 6-7 (CI watch + release publish) are manual — see SKILL.md.
#
# Usage:
#   BUMP=patch ./scripts/release/autodeploy.sh
#   BUMP=minor DRY_RUN=true ./scripts/release/autodeploy.sh
#   BUMP=patch SKIP_TESTS=true ./scripts/release/autodeploy.sh
#
# Environment variables:
#   BUMP        patch | minor | major   (required)
#   DRY_RUN     true | false            (default: false)
#   SKIP_TESTS  true | false            (default: false)
#   RELEASE_BRANCH                      (default: main)

set -euo pipefail

RELEASE_BRANCH="${RELEASE_BRANCH:-main}"
DRY_RUN="${DRY_RUN:-false}"
SKIP_TESTS="${SKIP_TESTS:-false}"

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; NC='\033[0m'
info()  { echo -e "${GREEN}[autodeploy]${NC} $*"; }
warn()  { echo -e "${YELLOW}[autodeploy][WARN]${NC} $*"; }
abort() { echo -e "${RED}[autodeploy][ABORT]${NC} $*" >&2; exit 1; }

# ─── Validate BUMP ───────────────────────────────────────────────────────────
[[ -z "${BUMP:-}" ]] && abort "BUMP is required: patch | minor | major"
[[ "$BUMP" =~ ^(patch|minor|major)$ ]] || abort "BUMP must be patch, minor, or major (got: $BUMP)"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

# ─── Step 0: Safety checks ───────────────────────────────────────────────────
info "Step 0 — Safety checks"

git diff --exit-code --quiet || abort "Working tree has unstaged changes. Commit or stash first."
git diff --cached --exit-code --quiet || abort "Working tree has staged changes. Commit first."

CURRENT=$(git rev-parse --abbrev-ref HEAD)
[[ "$CURRENT" == "$RELEASE_BRANCH" ]] || abort "Not on $RELEASE_BRANCH (got: $CURRENT). Switch branches first."

git fetch origin "$RELEASE_BRANCH" --quiet
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "origin/$RELEASE_BRANCH")
[[ "$LOCAL" == "$REMOTE" ]] || abort "Branch is out of sync with origin/$RELEASE_BRANCH. Run: git pull --rebase"

[[ -f .git/MERGE_HEAD ]] && abort "Unfinished merge detected. Resolve first."
[[ -f .git/rebase-merge/interactive ]] && abort "Unfinished rebase detected. Resolve first."

info "Safety checks passed."

# ─── Step 1: Tests ───────────────────────────────────────────────────────────
if [[ "$SKIP_TESTS" == "true" ]]; then
  warn "SKIP_TESTS=true — skipping typecheck and tests. Document the reason in the commit."
else
  info "Step 1 — Typecheck + tests"
  npm run typecheck
  npm test
  info "Tests passed."
fi

# ─── Step 2: Bump version + tag ──────────────────────────────────────────────
info "Step 2 — Bump version ($BUMP)"

if [[ "$DRY_RUN" == "true" ]]; then
  CURRENT_VER=$(node -p "require('./package.json').version")
  warn "[DRY RUN] Would run: npm run release:desktop -- $BUMP (current: $CURRENT_VER)"
  NEXT_VERSION="$CURRENT_VER"   # no actual bump in dry-run
else
  npm run release:desktop -- "$BUMP"
  NEXT_VERSION=$(node -p "require('./package.json').version")
  TAG="v${NEXT_VERSION}"
  git tag | grep -qx "$TAG" || abort "Tag $TAG not found after bump. Something went wrong."
  echo "$NEXT_VERSION" > .release-version   # save for rollback reference
  info "Bumped to $TAG."
fi

TAG="v${NEXT_VERSION:-$(node -p "require('./package.json').version")}"

# ─── Step 3: Build ───────────────────────────────────────────────────────────
info "Step 3 — Build server"
npm run build:server

# Sync patch-mirror only when the dir exists (local deployment)
PATCH_DIR="/workspace/.ddagent-patch"
if [[ -d "$PATCH_DIR" && "$DRY_RUN" != "true" ]]; then
  info "Syncing patch-mirror → $PATCH_DIR"
  cp dist-server/server/modules/providers/list/claude/claude-runtime.provider.js "$PATCH_DIR/"
  cp dist-server/server/modules/providers/list/devin/devin-sessions.provider.js "$PATCH_DIR/"
fi

# ─── Step 4: Validate release notes ──────────────────────────────────────────
info "Step 4 — Release notes check"
NOTES_FILE="scripts/release/release-notes-template.md"

if grep -q "^- TODO" "$NOTES_FILE"; then
  if [[ "$DRY_RUN" == "true" ]]; then
    warn "[DRY RUN] Release notes still contain TODO placeholders in $NOTES_FILE"
    warn "Fill all 12 locale sections (en,pl,de,es,fr,it,ja,ko,ru,tr,zh-CN,zh-TW) before publishing."
  else
    abort "Release notes contain TODO placeholders. Fill $NOTES_FILE before releasing.\nTip: run scripts/release/gen-release-notes.sh for an English draft."
  fi
else
  info "Release notes look complete."
fi

# ─── Step 5: Push ────────────────────────────────────────────────────────────
info "Step 5 — Push commit + tag"

if [[ "$DRY_RUN" == "true" ]]; then
  warn "[DRY RUN] Would run: git push origin HEAD $TAG"
  info "Dry run complete — nothing was pushed."
else
  git push origin HEAD "$TAG"
  info "Pushed $TAG to origin."
  info ""
  info "Next manual steps:"
  info "  6. Monitor CI:    gh run list --limit 5"
  info "  7. Publish draft: gh release edit $TAG --draft=false --notes-file $NOTES_FILE"
fi

# ─── Rollback hint ───────────────────────────────────────────────────────────
if [[ "$DRY_RUN" != "true" ]]; then
  info ""
  info "Rollback (if CI fails after push):"
  info "  git push origin :refs/tags/$TAG"
  info "  git tag -d $TAG"
  info "  gh release delete $TAG --yes"
  info "  git revert HEAD --no-edit && git push origin $RELEASE_BRANCH"
fi
