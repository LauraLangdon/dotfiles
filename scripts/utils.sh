#!/usr/bin/env bash
# utils.sh — Shared helper functions for the bootstrap scripts.
#
# Sourced by bootstrap.sh before anything else runs. Each numbered script
# can also source this file directly for standalone use.

# Colors (ANSI)
_RED='\033[0;31m'
_GREEN='\033[0;32m'
_YELLOW='\033[0;33m'
_BLUE='\033[0;34m'
_RESET='\033[0m'

info()    { printf "${_BLUE}[INFO]${_RESET}  %s\n" "$*"; }
success() { printf "${_GREEN}[ OK ]${_RESET}  %s\n" "$*"; }
warn()    { printf "${_YELLOW}[WARN]${_RESET}  %s\n" "$*"; }
error()   { printf "${_RED}[ERR ]${_RESET}  %s\n" "$*" >&2; }

# Prompt for y/n. Returns 0 for yes, 1 for no.
# Usage: ask "Do the thing?" && do_the_thing
ask() {
    printf "${_YELLOW}[????]${_RESET}  %s [y/N] " "$1"
    read -r reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

# Check if a command exists.
command_exists() {
    command -v "$1" &>/dev/null
}

# Create a symlink safely, backing up any existing file.
#
# Usage: symlink_safe <source> <target>
#   source: path relative to $DOTFILES (e.g. "Zsh/.zshrc")
#   target: absolute path (e.g. "$HOME/.zshrc")
#
# Behavior:
#   - If target is already the correct symlink → skip (idempotent)
#   - If target exists (file, directory, or different symlink) → back up, then link
#   - If target doesn't exist → create the link
symlink_safe() {
    local source="$DOTFILES/$1"
    local target="$2"

    # Ensure the parent directory exists
    mkdir -p "$(dirname "$target")"

    # Already correct?
    if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
        success "Already linked: $target"
        return 0
    fi

    # Back up existing file/directory/symlink
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        local backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        mv "$target" "$backup_dir/"
        warn "Backed up existing $(basename "$target") to $backup_dir/"
    fi

    ln -s "$source" "$target"
    success "Linked: $target → $source"
}
