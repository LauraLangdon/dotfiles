# Manual Post-Bootstrap Steps

These steps can't be automated and need to be done by hand after running `./bootstrap.sh`.

## 1. Sign in to iCloud

System Settings > Apple ID > Sign in. This syncs Keychain, Safari bookmarks, Notes, Reminders, and other iCloud data.

## 2. Set up 1Password

1. Download and sign in to [1Password](https://1password.com/downloads) (if not already installed via Homebrew cask)
2. Go to **System Settings > General > Login Items & Extensions > Allow in the Background** and make sure 1Password is enabled
3. Go to **1Password > Settings > Developer** and enable:
   - **SSH Agent** — lets git use your 1Password SSH keys for signing and auth
   - **CLI Integration** — allows the `op` CLI to access your vault
4. Fully quit 1Password (`killall "1Password"` — Cmd-Q may not fully quit it) and relaunch
5. Run `op signin` in the terminal to authorize the CLI

Without this, SSH commit signing (`gpg.ssh.program` in `.gitconfig`) won't work.

## 3. Install Node.js via NVM

The bootstrap installed NVM but not Node.js itself. Install the latest LTS version:

```bash
nvm install --lts
```

## 4. VS Code settings sync

1. Open VS Code
2. Sign in with your GitHub account (bottom-left profile icon)
3. Settings Sync will restore your VS Code settings, keybindings, and snippets

The Brewfile handles extension installation, but settings/keybindings come from sync.

## 5. Mac App Store apps

The bootstrap optionally installs App Store apps from `Brewfile.mas` using `mas`. Some apps (like TestFlight) can't be installed via `mas` on macOS 26+ due to SIP restrictions — install these directly from the App Store app.

**Apps that require manual App Store install:**

- **TestFlight** — `mas` fails with "Operation not permitted" (SIP blocks pkg install to system volume)

**Apps removed (no longer in App Store):**

- **Speechify** — pulled from the App Store as of March 2026

**Using `mas` for everything else:**

```bash
mas list          # Show currently installed App Store apps (on an existing machine)
mas search <app>  # Find an app
mas install <id>  # Install by ID
```

To capture your current App Store apps for the Brewfile, run `mas list` on your existing machine and add them as `mas "<name>", id: <id>` entries.

## 6. Terminal font

Set your terminal's font to a Nerd Font so Starship prompt icons render correctly:

- **Warp**: Settings > Appearance > Font → "AnonymicePro Nerd Font" or "FantasqueSansM Nerd Font"
- **iTerm2**: Profiles > Text > Font → same

## 7. iTerm2 settings

If using iTerm2, point it to the dotfiles settings:

1. Open iTerm2
2. Preferences > General > Preferences
3. Check "Load preferences from a custom folder or URL"
4. Set the path to `~/Repos/dotfiles/iTerm/settings/`

## 8. Set up scheduled sync/apply

The install script generates launchd plists with the correct paths for the current user — works regardless of username.

**On your main machine** (the source of truth):

```bash
./launchd/install.sh sync
```

This runs `sync.sh --quiet` daily at noon, logging to `~/.dotfiles-sync.log`.

**On secondary machines:**

```bash
./launchd/install.sh apply
```

This runs `apply.sh --quiet` every Monday at noon, logging to `~/.dotfiles-apply.log`.

You can also run either script manually at any time:

```bash
./sync.sh    # Check for drift on main machine
./apply.sh   # Pull and apply on secondary machine
```

## 9. Restore from Time Machine (optional)

If you have a Time Machine backup, you can use Migration Assistant or manually copy:

- `~/Documents/`
- `~/Pictures/`
- `~/Repos/` (though you'll want to `git pull` in each repo instead)
- Any other personal files
