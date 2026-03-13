#!/usr/bin/env bash
# apply.sh — Pull latest dotfiles and apply settings on a secondary machine.
#
# Run manually or via launchd (weekly). Pulls the latest changes from
# the remote repo and re-runs the relevant bootstrap scripts.
#
# Usage:
#   ./apply.sh          # Interactive — asks before applying defaults
#   ./apply.sh --quiet  # Scripted/scheduled — applies everything silently

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES/scripts/utils.sh"

QUIET=false
[[ "${1:-}" == "--quiet" ]] && QUIET=true

# =============================================================================
# Pull latest changes
# =============================================================================

info "Pulling latest dotfiles..."

cd "$DOTFILES"
git fetch origin

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [[ "$LOCAL" == "$REMOTE" ]]; then
    $QUIET || success "Already up to date"
else
    git pull --recurse-submodules origin main
    success "Pulled latest changes"
fi

# =============================================================================
# Update Homebrew packages
# =============================================================================

info "Checking Homebrew packages..."

if command_exists brew; then
    if ! brew bundle check --file="$DOTFILES/Brewfile" &>/dev/null; then
        info "Installing new Brewfile entries..."
        brew bundle --file="$DOTFILES/Brewfile"
        success "Homebrew packages updated"
    else
        $QUIET || success "Homebrew packages up to date"
    fi
else
    warn "Homebrew not found — skipping package check"
fi

# =============================================================================
# Verify symlinks
# =============================================================================

info "Checking symlinks..."
source "$DOTFILES/scripts/02-symlinks.sh"

# =============================================================================
# Apply macOS defaults
# =============================================================================

if $QUIET; then
    source "$DOTFILES/scripts/05-macos-defaults.sh"
else
    if ask "Apply macOS defaults (Dock, Finder, Warp, etc.)?"; then
        source "$DOTFILES/scripts/05-macos-defaults.sh"
    else
        info "Skipping macOS defaults"
    fi
fi

# =============================================================================
# Validate git tools
# =============================================================================

source "$DOTFILES/scripts/04-git.sh"

# =============================================================================
# Summary
# =============================================================================

echo ""
success "Apply complete!"
$QUIET || info "Run scripts/06-post-install.sh for a full verification check"
echo ""
