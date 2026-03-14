#!/usr/bin/env bash
# 02-symlinks.sh — Create symlinks from dotfiles repo to home directory.
#
# Each config file lives in the repo and gets symlinked to where
# macOS/apps expect to find it. If a file already exists at the
# target location, it's backed up to ~/.dotfiles_backup/ first.

# Allow standalone use
[[ -z "${DOTFILES:-}" ]] && { DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"; source "$DOTFILES/scripts/utils.sh"; }

info "Creating symlinks..."

# Format: repo_path → target_path
# symlink_safe handles backup, creation, and idempotency.

# Shell
symlink_safe "Zsh/.zshrc"                      "$HOME/.zshrc"
symlink_safe "Zsh/.zprofile"                    "$HOME/.zprofile"
symlink_safe "Zsh/Starship/starship.toml"       "$HOME/.config/starship.toml"

# Git
symlink_safe "Git/.gitconfig"                   "$HOME/.gitconfig"
symlink_safe "Git/.gitignore_global"            "$HOME/.gitignore_global"

# Editors
symlink_safe "nvim"                             "$HOME/.config/nvim"
symlink_safe "Vim/.vimrc"                       "$HOME/.vimrc"
symlink_safe "Vim/.vim"                         "$HOME/.vim"

# Terminals
symlink_safe "Warp"                             "$HOME/.warp"

# Custom fonts (not available via Homebrew)
FONT_DIR="$HOME/Library/Fonts"
mkdir -p "$FONT_DIR"
for font in "$DOTFILES"/fonts/*.ttf "$DOTFILES"/fonts/*.otf; do
    [[ -f "$font" ]] || continue
    name="$(basename "$font")"
    if [[ -f "$FONT_DIR/$name" ]]; then
        success "Font '$name' already installed"
    else
        cp "$font" "$FONT_DIR/$name"
        success "Font '$name' installed"
    fi
done

# VS Code custom themes (not on marketplace — cloned from GitHub)
VSCODE_EXT="$HOME/.vscode/extensions"
mkdir -p "$VSCODE_EXT"

vscode_themes=(
    "https://github.com/LauraLangdon/light-pinkish.git"
    "https://github.com/LauraLangdon/hyper-owl.git"
)

for repo in "${vscode_themes[@]}"; do
    name="$(basename "$repo" .git)"
    if [[ -d "$VSCODE_EXT/$name" ]]; then
        success "VS Code theme '$name' already installed"
    else
        info "Cloning VS Code theme '$name'..."
        git clone "$repo" "$VSCODE_EXT/$name"
        success "VS Code theme '$name' installed"
    fi
done

# Zen Browser user.js (copy into active profile)
ZEN_PROFILES="$HOME/Library/Application Support/Zen/Profiles"
ZEN_USERJS="$DOTFILES/Zen/user.js"
if [[ -f "$ZEN_USERJS" && -d "$ZEN_PROFILES" ]]; then
    for profile in "$ZEN_PROFILES"/*/; do
        if [[ -f "$profile/prefs.js" ]]; then
            cp "$ZEN_USERJS" "$profile/user.js"
            success "Zen user.js copied to $(basename "$profile")"
        fi
    done
elif [[ -f "$ZEN_USERJS" ]]; then
    info "Zen not installed yet — user.js will be copied on next apply"
fi

success "Symlinks created"
