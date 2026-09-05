#!/bin/bash
# Removes the CroakyMon auto-sync LaunchAgent.
set -eu
LABEL="com.croakymon.sync"
AGENT_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl unload "$AGENT_PATH" 2>/dev/null || true
rm -f "$AGENT_PATH"
echo "Uninstalled $LABEL."
