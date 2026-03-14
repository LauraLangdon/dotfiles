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

On a fresh Mac, start by installing Xcode Command Line Tools (needed for `git`):

```bash
xcode-select --install
```

Wait for that to finish, then clone and run:

```bash
mkdir -p ~/Repos
git clone --recursive https://github.com/LauraLangdon/dotfiles.git ~/Repos/dotfiles
cd ~/Repos/dotfiles
./bootstrap.sh
```

> **Note:** Uses HTTPS for the clone since SSH keys won't be set up on a fresh machine yet. After bootstrap and 1Password setup, you can switch the remote to SSH:
> ```bash
> git remote set-url origin git@github.com:LauraLangdon/dotfiles.git
> ```

## Troubleshooting

**`brew link` fails for `pkgconf`:** Run `brew link --overwrite pkgconf` and re-run `./bootstrap.sh`.

**`brew install` fails with "undefined method 'install'":** A known Homebrew 5.1.0 regression. Run `brew update-reset` first, then retry the install.

**`zsh: command not found: brew`:** Homebrew isn't in your PATH yet. Run `eval "$(/opt/homebrew/bin/brew shellenv)"` and re-run `./bootstrap.sh`.

**`unsupported value for gpg.format: ssh`:** The Xcode CLT git is too old. Run `eval "$(/opt/homebrew/bin/brew shellenv)"` to use Homebrew's git, then retry.

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
