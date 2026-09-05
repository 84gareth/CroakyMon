#!/bin/bash
# Removes the auto-sync LaunchAgent for the repo this script lives in.
set -eu
REPO="$(cd "$(dirname "$0")/.." && pwd)"
REPO_SLUG="$(basename "$REPO" | tr '[:upper:]' '[:lower:]')"
LABEL="com.croakymon-sync.${REPO_SLUG}"
AGENT_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl unload "$AGENT_PATH" 2>/dev/null || true
rm -f "$AGENT_PATH"
echo "Uninstalled $LABEL."
