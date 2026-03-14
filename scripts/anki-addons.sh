#!/usr/bin/env bash
# anki-addons.sh — Install Anki add-ons and restore their configs.
#
# Anki doesn't have a CLI for add-on installation. This script:
# 1. Prints the add-on IDs to paste into Tools > Add-ons > Get Add-ons
# 2. Restores saved configs after add-ons are installed

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
if [[ -d "$ADDON_DIR" && -d "$ADDON_CONFIGS" ]]; then
    restored=0
    for config_dir in "$ADDON_CONFIGS"/*/; do
        [[ -d "$config_dir" ]] || continue
        id="$(basename "$config_dir")"
        if [[ -d "$ADDON_DIR/$id" && -f "$config_dir/config.json" ]]; then
            cp "$config_dir/config.json" "$ADDON_DIR/$id/config.json"
            ((restored++))
        fi
    done
    if ((restored > 0)); then
        success "$restored add-on config(s) restored — restart Anki to apply"
    fi
else
    info "Anki not set up yet — run this script again after installing add-ons"
fi
