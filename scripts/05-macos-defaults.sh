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

# Enable magnification (icons grow when hovered)
defaults write com.apple.dock magnification -bool true

# Magnified icon size in pixels (default: 128)
defaults write com.apple.dock largesize -int 89

# Don't show recently opened apps in the Dock
defaults write com.apple.dock show-recents -bool false

# --- Dock app layout ---
# Clear existing Dock apps and set the exact layout.
# Apps that aren't installed yet will show as "?" icons until installed.

defaults write com.apple.dock persistent-apps -array

dock_apps=(
    "/System/Applications/System Settings.app"
    "/Applications/Warp.app"
    "/Applications/1Password.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/Zen Browser.app"
    "/Applications/Obsidian.app"
    "/Applications/Vimcal.app"
    "/Applications/Things3 2.app"
    "/Applications/Discord.app"
    "/Applications/Slack.app"
    "/Applications/Spotify.app"
    "/Applications/zoom.us.app"
    "/Applications/Signal.app"
    "/System/Applications/Messages.app"
    "/Applications/Microsoft Outlook.app"
    "/Applications/Mona 2.app"
)

for app in "${dock_apps[@]}"; do
    defaults write com.apple.dock persistent-apps -array-add \
        "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
done

# Remove pinned folders/files from the right side of the Dock (e.g. Downloads)
defaults write com.apple.dock persistent-others -array

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

# New Finder windows open to ~/Downloads
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"

# Show external drives and removable media on Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# =============================================================================
# Trackpad
# =============================================================================

# Tap to click (not just physical press)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Two-finger right-click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# Three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Force click disabled (light click threshold)
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 0
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

# Pinch to zoom
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true

# Rotate with two fingers
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true

# Smart zoom (two-finger double tap)
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -bool true

# Swipe between pages (two-finger horizontal swipe)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0

# Swipe between full-screen apps (four-finger horizontal swipe)
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2

# Mission Control (four-finger vertical swipe)
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2

# Disable notification center swipe from right edge
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

# =============================================================================
# Keyboard & Text
# =============================================================================

# Enable press-and-hold for accents/special characters (disable for key repeat)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true

# Auto-corrections (all enabled — matches macOS defaults)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool true
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool true

# =============================================================================
# Mission Control & Spaces
# =============================================================================

# Don't rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool true

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

# System accent color: Pink
# Values: -1=Graphite, 0=Red, 1=Orange, 2=Yellow, 3=Green, 4=Blue, 5=Purple, 6=Pink
defaults write NSGlobalDomain AppleAccentColor -int 6

# System highlight color: Pink (text selection, etc.)
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.749020 0.823529 Pink"

# Folder icon tint color: custom Pink
# Values for AppleIconAppearanceTintColor: Monochrome, Multicolor, Other (custom)
defaults write NSGlobalDomain AppleIconAppearanceTintColor -string "Other"
defaults write NSGlobalDomain AppleIconAppearanceCustomTintColor -string "1.000000 0.475000 0.732994 0.940000"

# =============================================================================
# Accessibility
# =============================================================================

# Reduce motion (less animation in UI transitions)
defaults write com.apple.universalaccess reduceMotion -bool true

# =============================================================================
# Stage Manager & Window Management
# =============================================================================

# Disable Stage Manager
defaults write com.apple.WindowManager GloballyEnabled -bool false

# =============================================================================
# Trackpad Speed
# =============================================================================

# Tracking speed (0.0 = slowest, 3.0 = fastest)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 0.6875

# =============================================================================
# Sidebar & Scroll Bars
# =============================================================================

# Sidebar icon size: 1=small, 2=medium, 3=large
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Show scroll bars: Automatic, WhenScrolling, Always
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

# Click in scroll bar to jump to the clicked spot (not page up/down)
# 0 = jump to next page, 1 = jump to spot
defaults write NSGlobalDomain AppleScrollerPagingBehavior -int 1

# =============================================================================
# Clock / Menu Bar
# =============================================================================

# Digital clock, show day of week and AM/PM, no date
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0
defaults write com.apple.menuextra.clock IsAnalog -bool false

# =============================================================================
# Sound
# =============================================================================

# Alert sound
defaults write NSGlobalDomain com.apple.sound.beep.sound -string "/System/Library/Sounds/Blow.aiff"

# Disable UI sound effects (clicking, trash, etc.)
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -bool false

# =============================================================================
# Security
# =============================================================================

# Enable firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Login window shows username and password fields (not user list)
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# =============================================================================
# Desktop & Dock (additional)
# =============================================================================

# Hide widgets when in Stage Manager
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true

# Don't hide widgets on desktop (show them normally)
defaults write com.apple.WindowManager StandardHideWidgets -bool false

# Prefer tabs when opening documents: always, fullscreen, manual
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"

# =============================================================================
# Keyboard Shortcuts
# =============================================================================

# Mission Control shortcut: Ctrl+M (key code 46 = M, modifier 262144 = Ctrl)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 \
    "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>109</integer><integer>46</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"

# Application Windows shortcut: Ctrl+Shift+M
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 \
    "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>109</integer><integer>46</integer><integer>393216</integer></array><key>type</key><string>standard</string></dict></dict>"

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
# Warp Terminal
# =============================================================================
# Warp stores its settings in defaults (dev.warp.Warp-Stable).
# Themes, keybindings, and launch configs are symlinked via ~/.warp.

# Font
defaults write dev.warp.Warp-Stable FontName -string "PTMono Nerd Font"
defaults write dev.warp.Warp-Stable FontSize -float 13.0
defaults write dev.warp.Warp-Stable LineHeightRatio -float 1.2
defaults write dev.warp.Warp-Stable UseThinStrokes -string "OnHighDpiDisplays"

# Theme — uses custom theme from ~/.warp/themes/ (symlinked from dotfiles)
defaults write dev.warp.Warp-Stable Theme -string '{"Custom":{"name":"Light-pinkish","path":"'"$HOME"'/.warp/themes/light-pinkish.yaml"}}'
defaults write dev.warp.Warp-Stable SystemTheme -bool true

# Editor
defaults write dev.warp.Warp-Stable VimModeEnabled -bool true
defaults write dev.warp.Warp-Stable VimUnnamedSystemClipboard -bool true
defaults write dev.warp.Warp-Stable CursorBlink -string "Enabled"
defaults write dev.warp.Warp-Stable InputMode -string "PinnedToBottom"

# Behavior
defaults write dev.warp.Warp-Stable HonorPS1 -bool true
defaults write dev.warp.Warp-Stable CompletionsOpenWhileTyping -bool true
defaults write dev.warp.Warp-Stable AliasExpansionEnabled -bool true
defaults write dev.warp.Warp-Stable ShowWarningBeforeQuitting -bool false
defaults write dev.warp.Warp-Stable UseAudibleBell -bool true

# Panes
defaults write dev.warp.Warp-Stable ShouldDimInactivePanes -bool true
defaults write dev.warp.Warp-Stable FocusPaneOnHover -bool true

# Display
defaults write dev.warp.Warp-Stable AltScreenPadding -string '{"Custom":{"uniform_padding":0.0}}'
defaults write dev.warp.Warp-Stable OpenWindowsAtCustomSize -bool false
defaults write dev.warp.Warp-Stable EnforceMinimumContrast -string "Never"
defaults write dev.warp.Warp-Stable Spacing -string "Normal"
defaults write dev.warp.Warp-Stable ZoomLevel -int 100
defaults write dev.warp.Warp-Stable AppIcon -string "Sticker"

# =============================================================================
# Wallpaper
# =============================================================================

# Set desktop wallpaper (bundled in the repo so it works before iCloud sign-in)
WALLPAPER="$DOTFILES/wallpaper/whale-wallpaper.jpg"
if [[ -f "$WALLPAPER" ]]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
    success "Desktop wallpaper set"
else
    warn "Wallpaper not found at $WALLPAPER"
fi

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
