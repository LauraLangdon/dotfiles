#!/usr/bin/env bash
# 01-homebrew.sh — Install Homebrew and run the Brewfile.
#
# Homebrew is the package manager for macOS. The Brewfile declares
# every CLI tool, cask, font, and VS Code extension to install.

# Allow standalone use
[[ -z "${DOTFILES:-}" ]] && { DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"; source "$DOTFILES/scripts/utils.sh"; }

# --- Install Homebrew ---

if command_exists brew; then
    success "Homebrew already installed"
else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the rest of this session
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    success "Homebrew installed"
fi

# --- Ensure Homebrew is in PATH (needed on fresh installs) ---

if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# --- Update and install packages ---

info "Updating Homebrew..."
brew update

info "Installing packages from Brewfile..."
# Continue on non-fatal errors (e.g. link conflicts) — post-install will report missing tools.
if ! brew bundle --file="$DOTFILES/Brewfile"; then
    warn "Some Brewfile entries had issues — check output above"
    warn "You may need to run 'brew link --overwrite <formula>' for conflicts"
fi

info "Upgrading outdated packages..."
brew upgrade

info "Cleaning up..."
brew cleanup

success "Homebrew packages installed"

# --- Mac App Store apps (optional, requires sign-in) ---

if [[ -f "$DOTFILES/Brewfile.mas" ]]; then
    echo ""
    if ask "Install Mac App Store apps? (requires Apple ID sign-in)"; then
        info "Installing App Store apps..."
        if ! brew bundle --file="$DOTFILES/Brewfile.mas"; then
            warn "Some App Store installs had issues — you can retry with: brew bundle --file=Brewfile.mas"
        fi
        success "App Store apps installed"
    else
        info "Skipping App Store apps — install later with: brew bundle --file=Brewfile.mas"
    fi
fi
