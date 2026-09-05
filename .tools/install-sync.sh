#!/bin/bash
# One-time install for the auto-sync LaunchAgent.
# Idempotent — safe to re-run. Works for any repo folder you drop these tools
# into (label is derived from the folder name, so multiple repos coexist).

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
REPO_SLUG="$(basename "$REPO" | tr '[:upper:]' '[:lower:]')"
LABEL="com.croakymon-sync.${REPO_SLUG}"
AGENT_DIR="$HOME/Library/LaunchAgents"
AGENT_PATH="$AGENT_DIR/$LABEL.plist"
SRC_PLIST="$REPO/.tools/com.croakymon.sync.plist"

echo "Installing auto-sync for repo at: $REPO"
echo "  LaunchAgent label: $LABEL"

# 1) Stop any old fswatch loops from previous sessions
pkill -f 'fswatch -o.*'"$REPO_SLUG" 2>/dev/null || true

# 2) Ensure git will pull-rebase by default in this repo
git -C "$REPO" config pull.rebase true

# 3) Make sync script executable
chmod +x "$REPO/.tools/sync.sh"

# 4) Unload any previous version of this exact agent so we can overwrite cleanly
launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl unload "$AGENT_PATH" 2>/dev/null || true

# 5) Render plist with the actual repo path AND unique label substituted in
mkdir -p "$AGENT_DIR"
sed -e "s|REPO_PATH|$REPO|g" \
    -e "s|LABEL_PLACEHOLDER|$LABEL|g" \
    "$SRC_PLIST" > "$AGENT_PATH"

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
