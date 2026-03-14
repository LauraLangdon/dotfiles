#!/usr/bin/env bash
# sync.sh — Capture current machine state and update dotfiles repo.
#
# Run manually or via launchd (daily). Updates repo files from the
# current machine state but does NOT commit — review the diff first.
#
# Usage:
#   ./sync.sh          # Interactive — shows diff at the end
#   ./sync.sh --quiet  # Scripted/scheduled — only outputs if changes found

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES/scripts/utils.sh"

QUIET=false
[[ "${1:-}" == "--quiet" ]] && QUIET=true

# =============================================================================
# Brewfile
# =============================================================================

info "Capturing Homebrew packages..."
brew bundle dump --file="$DOTFILES/Brewfile.new" --force

# Preserve the curated comments and organization from the existing Brewfile
# by only flagging if there are differences in the package list
if ! diff -q <(grep -v '^#' "$DOTFILES/Brewfile" | grep -v '^$' | sort) \
             <(grep -v '^#' "$DOTFILES/Brewfile.new" | grep -v '^$' | sort) &>/dev/null; then
    info "Brewfile has changed — review Brewfile.new and merge manually"
    info "  diff Brewfile Brewfile.new"
else
    rm "$DOTFILES/Brewfile.new"
    $QUIET || success "Brewfile up to date"
fi

# =============================================================================
# Dock layout
# =============================================================================

info "Capturing Dock layout..."

# Extract current Dock apps
current_apps=()
while IFS= read -r app; do
    current_apps+=("$app")
done < <(defaults read com.apple.dock persistent-apps | grep '"_CFURLString"' | sed 's/.*"\(.*\.app\)\/\{0,1\}".*/\1/' | sed 's|^file://||' | python3 -c "import sys, urllib.parse; [print(urllib.parse.unquote(l.strip())) for l in sys.stdin]")

# Build the dock_apps array for the script
dock_block="dock_apps=("
for app in "${current_apps[@]}"; do
    dock_block+=$'\n'"    \"$app\""
done
dock_block+=$'\n'")"

# Check if the Dock layout has changed by comparing app lists
script_apps=$(grep '"/.*\.app"' "$DOTFILES/scripts/05-macos-defaults.sh" | sed 's/.*"\(\/.*\.app\)".*/\1/' | sort)
current_sorted=$(printf '%s\n' "${current_apps[@]}" | sort)

if [[ "$script_apps" != "$current_sorted" ]]; then
    info "Dock layout has changed"
    $QUIET || {
        info "Current Dock apps:"
        printf '    %s\n' "${current_apps[@]}"
        info "Update scripts/05-macos-defaults.sh manually with the new layout"
    }
else
    $QUIET || success "Dock layout up to date"
fi

# =============================================================================
# macOS defaults — spot-check key settings
# =============================================================================

info "Checking macOS preferences..."

changes_found=false

check_default() {
    local domain="$1" key="$2" expected="$3" label="$4"
    local actual
    actual=$(defaults read "$domain" "$key" 2>/dev/null || echo "__unset__")
    # Normalize boolean representations (true/1, false/0)
    local norm_actual="$actual" norm_expected="$expected"
    [[ "$norm_actual" == "true" ]] && norm_actual="1"
    [[ "$norm_actual" == "false" ]] && norm_actual="0"
    [[ "$norm_expected" == "true" ]] && norm_expected="1"
    [[ "$norm_expected" == "false" ]] && norm_expected="0"
    if [[ "$norm_actual" != "$norm_expected" ]]; then
        warn "$label: expected '$expected', got '$actual'"
        changes_found=true
    fi
}

check_default com.apple.dock tilesize "66" "Dock icon size"
check_default com.apple.dock autohide "1" "Dock autohide"
check_default com.apple.dock magnification "1" "Dock magnification"
check_default com.apple.dock largesize "89" "Dock magnified size"
check_default com.apple.dock orientation "bottom" "Dock position"
check_default com.apple.dock show-recents "0" "Dock show recents"
check_default com.apple.dock mru-spaces "0" "Spaces rearrange"
check_default com.apple.dock expose-group-apps "1" "Expose group apps"
check_default com.apple.finder FXPreferredViewStyle "Nlsv" "Finder view style"
check_default com.apple.finder _FXSortFoldersFirst "1" "Finder folders first"
check_default com.apple.finder AppleShowAllFiles "1" "Finder show hidden"
check_default NSGlobalDomain AppleAccentColor "6" "Accent color"
check_default com.apple.screencapture type "JPG" "Screenshot format"
check_default com.apple.AppleMultitouchTrackpad Clicking "1" "Tap to click"
check_default com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag "1" "Three-finger drag"

if ! $changes_found; then
    $QUIET || success "macOS preferences match"
fi

# =============================================================================
# VS Code extensions
# =============================================================================

info "Checking VS Code extensions..."

if command_exists code; then
    installed=$(code --list-extensions | sort)
    brewfile_exts=$(grep '^vscode ' "$DOTFILES/Brewfile" | sed 's/vscode "\(.*\)"/\1/' | sort)

    new_exts=$(comm -23 <(echo "$installed") <(echo "$brewfile_exts"))
    removed_exts=$(comm -13 <(echo "$installed") <(echo "$brewfile_exts"))

    if [[ -n "$new_exts" ]]; then
        info "Extensions installed but not in Brewfile:"
        echo "$new_exts" | while read -r ext; do
            info "  + $ext"
        done
    fi

    if [[ -n "$removed_exts" ]]; then
        info "Extensions in Brewfile but not installed:"
        echo "$removed_exts" | while read -r ext; do
            info "  - $ext"
        done
    fi

    if [[ -z "$new_exts" ]] && [[ -z "$removed_exts" ]]; then
        $QUIET || success "VS Code extensions match"
    fi
else
    $QUIET || warn "VS Code CLI (code) not found — skipping extension check"
fi

# =============================================================================
# Zen Browser
# =============================================================================

ZEN_USERJS="$DOTFILES/Zen/user.js"
ZEN_PROFILES="$HOME/Library/Application Support/Zen/Profiles"

if [[ -f "$ZEN_USERJS" && -d "$ZEN_PROFILES" ]]; then
    info "Checking Zen Browser preferences..."

    # Find the active profile (most recently modified prefs.js)
    zen_profile=""
    for profile in "$ZEN_PROFILES"/*/; do
        if [[ -f "$profile/prefs.js" ]]; then
            zen_profile="$profile"
        fi
    done

    if [[ -n "$zen_profile" ]]; then
        # Extract the keys we care about from user.js
        zen_keys=$(grep '^user_pref(' "$ZEN_USERJS" | sed 's/user_pref("\([^"]*\)".*/\1/')

        zen_drift=false
        while IFS= read -r key; do
            repo_val=$(grep "\"$key\"" "$ZEN_USERJS" | sed 's/.*,\s*//' | sed 's/);\s*$//')
            live_val=$(grep "\"$key\"" "$zen_profile/prefs.js" | sed 's/.*,\s*//' | sed 's/);\s*$//')

            if [[ -n "$live_val" && "$repo_val" != "$live_val" ]]; then
                warn "Zen pref changed: $key"
                warn "  repo: $repo_val"
                warn "  live: $live_val"
                zen_drift=true
                changes_found=true
            fi
        done <<< "$zen_keys"

        if ! $zen_drift; then
            $QUIET || success "Zen Browser preferences match"
        fi
    fi
fi

# =============================================================================
# Summary
# =============================================================================

echo ""
if [[ -f "$DOTFILES/Brewfile.new" ]] || $changes_found || [[ -n "${new_exts:-}" ]] || [[ -n "${removed_exts:-}" ]]; then
    info "Changes detected — review above and update repo files as needed"
    info "Then commit: cd $DOTFILES && git add -p && git commit"
else
    $QUIET || success "Everything in sync!"
fi
