#!/usr/bin/env bash
# anki-addons.sh — Install Anki add-ons from addons.txt
#
# Anki doesn't have a CLI for add-on installation, but it watches
# the addons21 directory. This script creates placeholder directories
# so Anki knows to download them on next launch.
#
# After running this script, open Anki — it will detect the new
# add-on IDs and download them automatically.

[[ -z "${DOTFILES:-}" ]] && DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
source "$DOTFILES/scripts/utils.sh"

ADDON_LIST="$DOTFILES/Anki/addons.txt"
ADDON_DIR="$HOME/Library/Application Support/Anki2/addons21"

if [[ ! -f "$ADDON_LIST" ]]; then
    error "Add-on list not found at $ADDON_LIST"
    exit 1
fi

# Find the Anki profile directory — if addons21 doesn't exist yet,
# Anki hasn't been run. Tell the user to open Anki first.
if [[ ! -d "$ADDON_DIR" ]]; then
    warn "Anki add-ons directory not found — open Anki once first, then re-run this script"
    exit 0
fi

installed=0
skipped=0

while IFS= read -r line; do
    # Strip comments and whitespace
    id="$(echo "$line" | sed 's/#.*//' | tr -d '[:space:]')"
    [[ -z "$id" ]] && continue

    if [[ -d "$ADDON_DIR/$id" ]]; then
        ((skipped++))
    else
        mkdir -p "$ADDON_DIR/$id"
        # Create minimal meta.json so Anki knows to update it
        echo '{"mod": 0, "conflicts": []}' > "$ADDON_DIR/$id/meta.json"
        ((installed++))
    fi
done < "$ADDON_LIST"

if ((installed > 0)); then
    success "$installed add-on(s) queued for download — open Anki to complete installation"
else
    success "All $skipped add-on(s) already installed"
fi
