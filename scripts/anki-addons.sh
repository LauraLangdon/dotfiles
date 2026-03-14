#!/usr/bin/env bash
# anki-addons.sh — Install Anki add-ons and restore their configs.
#
# Anki doesn't have a CLI for add-on installation. This script:
# 1. Prints the add-on IDs to paste into Tools > Add-ons > Get Add-ons
# 2. Restores saved configs (stored in meta.json) after add-ons are installed

[[ -z "${DOTFILES:-}" ]] && DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
source "$DOTFILES/scripts/utils.sh"

ADDON_LIST="$DOTFILES/Anki/addons.txt"
ADDON_CONFIGS="$DOTFILES/Anki/addon-configs"
ADDON_DIR="$HOME/Library/Application Support/Anki2/addons21"

if [[ ! -f "$ADDON_LIST" ]]; then
    error "Add-on list not found at $ADDON_LIST"
    exit 1
fi

# Collect IDs from addons.txt
ids=()
while IFS= read -r line; do
    id="$(echo "$line" | sed 's/#.*//' | tr -d '[:space:]')"
    [[ -z "$id" ]] && continue
    ids+=("$id")
done < "$ADDON_LIST"

# Print IDs for manual install
info "To install Anki add-ons: Tools > Add-ons > Get Add-ons, paste:"
echo ""
echo "  ${ids[*]}"
echo ""

# Restore configs for any add-ons already installed
# Anki stores user config inside meta.json under the "config" key
if [[ -d "$ADDON_DIR" && -d "$ADDON_CONFIGS" ]]; then
    restored=0
    for config_dir in "$ADDON_CONFIGS"/*/; do
        [[ -d "$config_dir" ]] || continue
        id="$(basename "$config_dir")"
        if [[ -d "$ADDON_DIR/$id" && -f "$config_dir/meta.json" && -f "$ADDON_DIR/$id/meta.json" ]]; then
            # Merge saved config into existing meta.json (preserve mod, name, etc.)
            python3 -c "
import json, sys
live = json.load(open('$ADDON_DIR/$id/meta.json'))
saved = json.load(open('$config_dir/meta.json'))
if 'config' in saved:
    live['config'] = saved['config']
    json.dump(live, open('$ADDON_DIR/$id/meta.json', 'w'), indent=2)
    print('ok')
else:
    print('skip')
" | grep -q 'ok' && ((restored++))
        fi
    done
    if ((restored > 0)); then
        success "$restored add-on config(s) restored — restart Anki to apply"
    fi
else
    info "Anki not set up yet — run this script again after installing add-ons"
fi
