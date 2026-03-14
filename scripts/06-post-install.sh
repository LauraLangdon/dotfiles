#!/usr/bin/env bash
# 06-post-install.sh — Verify the bootstrap and show next steps.
#
# Checks that key tools, symlinks, and fonts are in place.
# Prints a summary and points to the manual steps doc.

# Allow standalone use
[[ -z "${DOTFILES:-}" ]] && { DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"; source "$DOTFILES/scripts/utils.sh"; }

info "Running post-install checks..."

# --- Tool verification ---

tools=(starship eza zoxide nvim gh bat fd rg fzf tmux git-lfs)
missing=()

for tool in "${tools[@]}"; do
    if command_exists "$tool"; then
        success "$tool found"
    else
        warn "$tool not found"
        missing+=("$tool")
    fi
done

# --- Symlink verification ---
# Using parallel arrays for bash 3 compatibility (macOS ships bash 3).

link_targets=(
    "$HOME/.zshrc"
    "$HOME/.zprofile"
    "$HOME/.config/starship.toml"
    "$HOME/.gitconfig"
    "$HOME/.gitignore_global"
    "$HOME/.config/nvim"
    "$HOME/.vimrc"
    "$HOME/.vim"
    "$HOME/.warp"
)
link_sources=(
    "$DOTFILES/Zsh/.zshrc"
    "$DOTFILES/Zsh/.zprofile"
    "$DOTFILES/Zsh/Starship/starship.toml"
    "$DOTFILES/Git/.gitconfig"
    "$DOTFILES/Git/.gitignore_global"
    "$DOTFILES/nvim"
    "$DOTFILES/Vim/.vimrc"
    "$DOTFILES/Vim/.vim"
    "$DOTFILES/Warp"
)

link_ok=true
for i in "${!link_targets[@]}"; do
    target="${link_targets[$i]}"
    expected="${link_sources[$i]}"
    if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$expected" ]]; then
        success "Symlink OK: $target"
    else
        warn "Symlink issue: $target"
        link_ok=false
    fi
done

# --- Font verification ---

font_ok=true
for font_pattern in "AnonymiceProNerdFont" "FantasqueSansMNerdFont"; do
    if ls "$HOME/Library/Fonts/"*"$font_pattern"* &>/dev/null || \
       ls "/Library/Fonts/"*"$font_pattern"* &>/dev/null; then
        success "Font found: $font_pattern"
    else
        warn "Font not found: $font_pattern"
        font_ok=false
    fi
done

# --- Anki add-ons ---

source "$DOTFILES/scripts/anki-addons.sh"

# --- Default editor sample files ---

source "$DOTFILES/scripts/default-editor-samples.sh"

# --- Mackup (app settings restore) ---

if command_exists mackup; then
    info "Mackup can restore app settings from iCloud."
    info "Run 'mackup restore' after iCloud has finished syncing."
    info "On your main machine, run 'mackup backup' first if you haven't already."
fi

# --- Summary ---

echo ""
info "=== Post-Install Summary ==="

if [[ ${#missing[@]} -eq 0 ]]; then
    success "All tools installed"
else
    warn "Missing tools: ${missing[*]}"
fi

if $link_ok; then
    success "All symlinks correct"
else
    warn "Some symlinks need attention (see above)"
fi

if $font_ok; then
    success "Nerd Fonts installed"
else
    warn "Some fonts missing — terminal icons may not render correctly"
fi

echo ""
info "=== Manual Steps Remaining ==="
info "See: $DOTFILES/docs/MANUAL_STEPS.md"
echo ""
info "Quick reminders:"
info "  1. Sign in to iCloud"
info "  2. Sign in to 1Password and enable SSH agent"
info "  3. Run: nvm install --lts"
info "  4. Sign in to VS Code for settings sync"
echo ""
