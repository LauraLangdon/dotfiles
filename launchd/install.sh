#!/usr/bin/env bash
# launchd/install.sh — Generate and install launchd jobs for dotfiles sync/apply.
#
# Generates plist files with the correct paths for the current user,
# then loads them into launchd.
#
# Usage:
#   ./launchd/install.sh sync    # Daily sync (main machine)
#   ./launchd/install.sh apply   # Weekly apply (secondary machines)
#   ./launchd/install.sh both    # Both jobs

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
source "$DOTFILES/scripts/utils.sh"

LAUNCH_AGENTS="$HOME/Library/LaunchAgents"
mkdir -p "$LAUNCH_AGENTS"

install_sync() {
    local plist="$LAUNCH_AGENTS/com.dotfiles.sync.plist"

    cat > "$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dotfiles.sync</string>
    <key>ProgramArguments</key>
    <array>
        <string>$DOTFILES/sync.sh</string>
        <string>--quiet</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>12</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>$HOME/.dotfiles-sync.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.dotfiles-sync.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        <key>HOME</key>
        <string>$HOME</string>
    </dict>
</dict>
</plist>
EOF

    # Unload first if already loaded (idempotent)
    launchctl unload "$plist" 2>/dev/null || true
    launchctl load "$plist"
    success "Installed daily sync job (runs at noon)"
}

install_apply() {
    local plist="$LAUNCH_AGENTS/com.dotfiles.apply.plist"

    cat > "$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dotfiles.apply</string>
    <key>ProgramArguments</key>
    <array>
        <string>$DOTFILES/apply.sh</string>
        <string>--quiet</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>1</integer>
        <key>Hour</key>
        <integer>12</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>$HOME/.dotfiles-apply.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.dotfiles-apply.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        <key>HOME</key>
        <string>$HOME</string>
    </dict>
</dict>
</plist>
EOF

    # Unload first if already loaded (idempotent)
    launchctl unload "$plist" 2>/dev/null || true
    launchctl load "$plist"
    success "Installed weekly apply job (runs Mondays at noon)"
}

case "${1:-}" in
    sync)  install_sync ;;
    apply) install_apply ;;
    both)  install_sync; install_apply ;;
    *)
        error "Usage: $0 {sync|apply|both}"
        exit 1
        ;;
esac
