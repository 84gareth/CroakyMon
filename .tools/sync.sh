#!/bin/bash
# CroakyMon auto-sync: pulls remote changes, commits local changes, pushes.
# Runs every N seconds under launchd (see .tools/com.croakymon.sync.plist).
#
# Design notes:
# - Always pull --rebase FIRST so the optimizer bot's commits never leave us
#   stuck in "fetch first" hell.
# - Aborts a bad rebase cleanly rather than leaving the tree half-merged.
# - Silently deletes known-junk files (.DS_Store, "assets alias" leftovers)
#   before staging, so they never enter git.
# - Exits 0 on network failure so launchd doesn't back off.
# - All output tees to sync.log — inspect with:  tail -f ~/CroakyMon/.tools/sync.log

set -u
REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO" || exit 0

LOG="$REPO/.tools/sync.log"
STAMP="$(date '+%Y-%m-%d %H:%M:%S')"
log() { printf '[%s] %s\n' "$STAMP" "$*" >> "$LOG"; }

# Prevent overlapping runs (defensive; launchd throttles too)
LOCK="$REPO/.tools/.sync.lock"
exec 9>"$LOCK"
flock -n 9 || exit 0

# 1) Sweep known junk before doing anything else
find "$REPO" -name '.DS_Store' -delete 2>/dev/null
find "$REPO" -maxdepth 3 -name '* alias' -delete 2>/dev/null

# 2) Pull remote first. If it fails or conflicts, back out cleanly.
if ! git pull --rebase --autostash origin main >>"$LOG" 2>&1; then
  git rebase --abort >>"$LOG" 2>&1 || true
  git stash pop >>"$LOG" 2>&1 || true
  log "pull failed — will retry next tick"
  exit 0
fi

# 3) Stage everything git tracks or newly sees, then push if there's a diff.
git add -A
if git diff --cached --quiet; then
  exit 0
fi

# Commit with a message that summarises what changed
CHANGED="$(git diff --cached --name-only | tr '\n' ',' | sed 's/,$//' | cut -c1-140)"
git commit -m "sync from Cowork: $CHANGED" >>"$LOG" 2>&1
git push >>"$LOG" 2>&1 || log "push failed — will retry next tick"
log "pushed: $CHANGED"
