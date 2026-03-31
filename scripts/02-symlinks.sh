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

# SSH
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
symlink_safe "SSH/config"                        "$HOME/.ssh/config"

# Mackup
symlink_safe "Mackup/.mackup.cfg"               "$HOME/.mackup.cfg"
symlink_safe "Mackup/.mackup"                   "$HOME/.mackup"

# Git
symlink_safe "Git/.gitconfig"                   "$HOME/.gitconfig"
symlink_safe "Git/.gitignore_global"            "$HOME/.gitignore_global"

# Editors
symlink_safe "nvim"                             "$HOME/.config/nvim"
symlink_safe "Vim/.vimrc"                       "$HOME/.vimrc"
symlink_safe "Vim/.vim"                         "$HOME/.vim"

# Terminals
symlink_safe "Warp"                             "$HOME/.warp"

# Helper scripts
mkdir -p "$HOME/bin"
for script in "$DOTFILES"/bin/*.sh; do
    [[ -f "$script" ]] || continue
    name="$(basename "$script")"
    cp "$script" "$HOME/bin/$name"
    chmod +x "$HOME/bin/$name"
    success "Copied $name to ~/bin"
done

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

# VS Code custom themes (not on marketplace — built from GitHub repos)
VSCODE_EXT="$HOME/.vscode/extensions"
mkdir -p "$VSCODE_EXT"

vscode_themes=(
    "https://github.com/LauraLangdon/light-pinkish.git"
    "https://github.com/LauraLangdon/hyper-owl.git"
)

for repo in "${vscode_themes[@]}"; do
    name="$(basename "$repo" .git)"
    if code --list-extensions 2>/dev/null | grep -qi "$name"; then
        success "VS Code theme '$name' already installed"
    else
        info "Installing VS Code theme '$name'..."
        tmpdir="$(mktemp -d)"
        git clone "$repo" "$tmpdir/$name"
        (cd "$tmpdir/$name" && npx --yes @vscode/vsce package -o "$tmpdir/$name.vsix" && code --install-extension "$tmpdir/$name.vsix" --force)
        rm -rf "$tmpdir"
        success "VS Code theme '$name' installed"
    fi
done

# Zen Browser profile files (copy into active profiles)
ZEN_PROFILES="$HOME/Library/Application Support/zen/Profiles"
ZEN_DIR="$DOTFILES/Zen"
ZEN_FILES=(
    user.js
    containers.json
    zen-themes.json
    zen-keyboard-shortcuts.json
)
if [[ -d "$ZEN_DIR" && -d "$ZEN_PROFILES" ]]; then
    for profile in "$ZEN_PROFILES"/*/; do
        [[ -f "$profile/prefs.js" ]] || continue
        pname="$(basename "$profile")"
        for f in "${ZEN_FILES[@]}"; do
            if [[ -f "$ZEN_DIR/$f" ]]; then
                cp "$ZEN_DIR/$f" "$profile/$f"
                success "Zen $f copied to $pname"
            fi
        done
    done
elif [[ -d "$ZEN_DIR" ]]; then
    info "Zen not installed yet — profile files will be copied on next apply"
fi

success "Symlinks created"
