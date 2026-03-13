#!/usr/bin/env bash
# 04-git.sh — Validate git tooling.
#
# The .gitconfig in this repo uses 1Password for SSH commit signing
# and Git Credential Manager for HTTPS auth. This script checks that
# those tools are actually installed and warns if they're missing.

# Allow standalone use
[[ -z "${DOTFILES:-}" ]] && { DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"; source "$DOTFILES/scripts/utils.sh"; }

info "Validating git configuration..."

# Check 1Password SSH signing
if [[ -f "/Applications/1Password.app/Contents/MacOS/op-ssh-sign" ]]; then
    success "1Password SSH signing available"
else
    warn "1Password app not found — SSH commit signing won't work until it's installed"
    warn "Download from: https://1password.com/downloads"
fi

# Check Git Credential Manager
if [[ -f "/usr/local/share/gcm-core/git-credential-manager" ]]; then
    success "Git Credential Manager available"
else
    warn "Git Credential Manager not found at expected path"
    warn "It should have been installed by Homebrew (cask 'git-credential-manager')"
fi

# Check diff-so-fancy (used as git pager)
if command_exists diff-so-fancy; then
    success "diff-so-fancy available"
else
    warn "diff-so-fancy not found — git diff output will fall back to default pager"
fi

# Check git-lfs
if command_exists git-lfs; then
    success "git-lfs available"
else
    warn "git-lfs not found — large file support won't work"
fi

success "Git configuration validated"
