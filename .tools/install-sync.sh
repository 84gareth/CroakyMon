#!/bin/bash
# One-time install for the CroakyMon auto-sync LaunchAgent.
# Idempotent — safe to re-run.

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
LABEL="com.croakymon.sync"
AGENT_DIR="$HOME/Library/LaunchAgents"
AGENT_PATH="$AGENT_DIR/$LABEL.plist"
SRC_PLIST="$REPO/.tools/com.croakymon.sync.plist"

echo "Installing CroakyMon auto-sync for repo at: $REPO"

# 1) Stop any old fswatch loops from previous sessions
pkill -f 'fswatch -o.*CroakyMon' 2>/dev/null || true

# 2) Ensure git will pull-rebase by default in this repo
git -C "$REPO" config pull.rebase true

# 3) Make sync script executable
chmod +x "$REPO/.tools/sync.sh"

# 4) Unload any previous version so we can overwrite cleanly
launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl unload "$AGENT_PATH" 2>/dev/null || true

# 5) Render plist with the actual repo path substituted in
mkdir -p "$AGENT_DIR"
sed "s|REPO_PATH|$REPO|g" "$SRC_PLIST" > "$AGENT_PATH"

# 6) Load and enable
launchctl load -w "$AGENT_PATH"

echo ""
echo "Installed. Log lives at:"
echo "  $REPO/.tools/sync.log"
echo ""
echo "Status:"
launchctl list | grep "$LABEL" || echo "  (agent not listed — check log)"
echo ""
echo "To watch it work in real time:"
echo "  tail -f $REPO/.tools/sync.log"
