#!/usr/bin/env bash
# bootstrap.sh — One-command macOS setup.
#
# Usage:
#   git clone --recursive git@github.com:LauraLangdon/dotfiles.git ~/Repos/dotfiles
#   cd ~/Repos/dotfiles
#   ./bootstrap.sh
#
# Safe to re-run: every step checks before acting.

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES

source "$DOTFILES/scripts/utils.sh"

echo ""
info "=== macOS Bootstrap ==="
info "Dotfiles directory: $DOTFILES"
echo ""

# Run each numbered script in order.
# Scripts are named 00-xcode.sh, 01-homebrew.sh, etc.
for script in "$DOTFILES"/scripts/[0-9]*.sh; do
    echo ""
    info "--- Running $(basename "$script") ---"
    source "$script"
done

echo ""
success "=== Bootstrap complete! ==="
info "See docs/MANUAL_STEPS.md for remaining manual steps."
echo ""
