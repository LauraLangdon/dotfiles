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

# --- Update and install packages ---

info "Updating Homebrew..."
brew update

info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES/Brewfile"

info "Cleaning up..."
brew cleanup

success "Homebrew packages installed"
