#!/usr/bin/env bash
# 03-shell.sh — Set up shell: Oh-My-Zsh submodule, NVM, default shell.
#
# Oh-My-Zsh is checked in as a git submodule so it stays up to date
# with upstream. NVM (Node Version Manager) manages Node.js versions
# and is installed via its official script, not Homebrew.

# Allow standalone use
[[ -z "${DOTFILES:-}" ]] && { DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"; source "$DOTFILES/scripts/utils.sh"; }

# --- Oh-My-Zsh submodule ---

info "Initializing git submodules..."
git -C "$DOTFILES" submodule update --init --recursive
success "Git submodules initialized (Oh-My-Zsh)"

# --- NVM ---

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    success "NVM already installed"
else
    info "Installing NVM..."
    PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh)"
    success "NVM installed (run 'nvm install --lts' to install Node.js)"
fi

# --- Default shell ---

if [[ "$SHELL" == */zsh ]]; then
    success "Default shell is already zsh"
else
    info "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    success "Default shell set to zsh (takes effect on next login)"
fi
