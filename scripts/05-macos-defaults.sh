#!/usr/bin/env bash
# 05-macos-defaults.sh — Set macOS system preferences via `defaults write`.
#
# These settings are captured from Laura's current machine. Each one
# includes a comment explaining what it does. The script asks for
# confirmation before restarting affected processes (Dock, Finder).
#
# To read the current value of any setting:
#   defaults read <domain> <key>
#
# To reset a setting to system default:
#   defaults delete <domain> <key>

# Allow standalone use
[[ -z "${DOTFILES:-}" ]] && { DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"; source "$DOTFILES/scripts/utils.sh"; }

info "Configuring macOS preferences..."

# =============================================================================
# Dock
# =============================================================================

# Icon size in pixels (default: 48)
defaults write com.apple.dock tilesize -int 66

# Automatically hide the Dock when not in use
defaults write com.apple.dock autohide -bool true

# Remove the delay before the Dock auto-hides (default: 0.5)
defaults write com.apple.dock autohide-delay -float 0

# Dock position: bottom, left, or right
defaults write com.apple.dock orientation -string "bottom"

# Minimize windows into their app icon instead of a separate Dock tile
defaults write com.apple.dock minimize-to-application -bool true

# Minimize animation: genie, scale, or suck
defaults write com.apple.dock mineffect -string "genie"

# Don't show recently opened apps in the Dock
defaults write com.apple.dock show-recents -bool false

# =============================================================================
# Finder
# =============================================================================

# Show all file extensions (e.g. .txt, .md, .py)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show the path bar at the bottom of Finder windows
defaults write com.apple.finder ShowPathbar -bool true

# Show hidden files (files starting with .)
defaults write com.apple.finder AppleShowAllFiles -bool true

# Default to list view (other options: icnv, clmv, glyv)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default (not "This Mac")
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# =============================================================================
# Keyboard
# =============================================================================

# Tap to click on the trackpad (not just physical press)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# =============================================================================
# Screenshots
# =============================================================================

# Save screenshots to ~/Downloads instead of Desktop
defaults write com.apple.screencapture location -string "${HOME}/Downloads"

# Save screenshots as JPG instead of PNG
defaults write com.apple.screencapture type -string "JPG"

# =============================================================================
# Appearance
# =============================================================================

# System highlight/accent color: Pink
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.749020 0.823529 Pink"

# =============================================================================
# Hot Corners — all disabled (value 1 = no action)
#
# Possible values:
#   0: no action    2: Mission Control    3: Show application windows
#   4: Desktop      5: Start screen saver 6: Disable screen saver
#  10: Put display to sleep   11: Launchpad   12: Notification Center
#  13: Lock Screen   14: Quick Note
# =============================================================================

defaults write com.apple.dock wvous-tl-corner -int 1   # Top-left
defaults write com.apple.dock wvous-tr-corner -int 1   # Top-right
defaults write com.apple.dock wvous-bl-corner -int 1   # Bottom-left
defaults write com.apple.dock wvous-br-corner -int 1   # Bottom-right

# =============================================================================
# Apply changes
# =============================================================================

success "macOS preferences configured"

if ask "Restart Dock and Finder to apply changes now?"; then
    killall Dock
    killall Finder
    success "Dock and Finder restarted"
else
    info "Changes will take effect on next login or restart"
fi
