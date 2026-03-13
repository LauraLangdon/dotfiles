# dotfiles

One-command macOS setup. Run `./bootstrap.sh` on a fresh Mac and get a fully configured development environment.

Originally forked from [sheharyarn/dotfiles](https://github.com/sheharyarn/dotfiles), now completely rewritten.

## What's included

- **Shell**: Zsh + [Oh-My-Zsh](https://ohmyz.sh/) (git submodule) + [Starship](https://starship.rs/) prompt
- **Editors**: [Neovim](https://neovim.io/) (Lua config with lazy.nvim) + Vim (legacy) + VS Code extensions
- **Terminals**: [Warp](https://www.warp.dev/) + [iTerm2](https://iterm2.com/) (themes and keybindings)
- **Git**: [1Password SSH signing](https://developer.1password.com/docs/ssh/git-commit-signing/), [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy), Git LFS
- **CLI tools**: bat, eza, fd, fzf, ripgrep, zoxide, tmux, lazygit, and more
- **macOS preferences**: Dock, Finder, keyboard, trackpad, screenshots, appearance
- **Fonts**: Nerd Font variants for terminal icons (via Homebrew)

## Quick start

```bash
# Clone the repo (--recursive pulls the Oh-My-Zsh submodule)
git clone --recursive git@github.com:LauraLangdon/dotfiles.git ~/Repos/dotfiles

# Run the bootstrap
cd ~/Repos/dotfiles
./bootstrap.sh
```

## How it works

`bootstrap.sh` runs a series of numbered scripts in order. Each script handles one concern and is safe to re-run (idempotent).

| Script | What it does |
|--------|-------------|
| `00-xcode.sh` | Installs Xcode Command Line Tools and Rosetta |
| `01-homebrew.sh` | Installs Homebrew and all packages from the `Brewfile` |
| `02-symlinks.sh` | Creates symlinks from the repo to `~/` and `~/.config/` |
| `03-shell.sh` | Initializes the Oh-My-Zsh submodule and installs NVM |
| `04-git.sh` | Validates git tool dependencies (1Password, GCM, etc.) |
| `05-macos-defaults.sh` | Configures macOS system preferences |
| `06-post-install.sh` | Verifies everything and shows remaining manual steps |

Each script can also be run standalone:

```bash
bash scripts/02-symlinks.sh   # Just redo symlinks
```

## Symlinks

The repo creates these symlinks:

| Target | Points to |
|--------|-----------|
| `~/.zshrc` | `Zsh/.zshrc` |
| `~/.zprofile` | `Zsh/.zprofile` |
| `~/.config/starship.toml` | `Zsh/Starship/starship.toml` |
| `~/.gitconfig` | `Git/.gitconfig` |
| `~/.gitignore_global` | `Git/.gitignore_global` |
| `~/.config/nvim` | `nvim/` |
| `~/.vimrc` | `Vim/.vimrc` |
| `~/.vim` | `Vim/.vim` |
| `~/.warp` | `Warp/` |

Existing files are backed up to `~/.dotfiles_backup/` before being replaced.

## After bootstrap

Some things can't be automated. See [docs/MANUAL_STEPS.md](docs/MANUAL_STEPS.md) for:

- Signing in to iCloud and 1Password
- Installing Node.js via NVM
- Setting terminal fonts
- VS Code settings sync
- Mac App Store apps
