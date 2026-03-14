#!/usr/bin/env bash
# anki-sync.sh — Update the add-on list and configs from the current machine.

[[ -z "${DOTFILES:-}" ]] && DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
source "$DOTFILES/scripts/utils.sh"

ADDON_LIST="$DOTFILES/Anki/addons.txt"
ADDON_CONFIGS="$DOTFILES/Anki/addon-configs"
ADDON_DIR="$HOME/Library/Application Support/Anki2/addons21"

if [[ ! -d "$ADDON_DIR" ]]; then
    warn "Anki add-ons directory not found"
    exit 0
fi

# Rebuild addons.txt from installed add-ons
info "Updating add-on list..."
echo "# Anki add-on IDs — one per line" > "$ADDON_LIST"
echo "# Install: Tools > Add-ons > Get Add-ons, paste all IDs separated by spaces" >> "$ADDON_LIST"
echo "# Or run: ../scripts/anki-addons.sh" >> "$ADDON_LIST"

for dir in "$ADDON_DIR"/*/; do
    id="$(basename "$dir")"
    [[ "$id" == "__pycache__" ]] && continue
    # Try to get the name from meta.json
    name=""
    if [[ -f "$dir/meta.json" ]]; then
        name=$(python3 -c "import json; print(json.load(open('$dir/meta.json')).get('name',''))" 2>/dev/null)
    fi
    if [[ -n "$name" ]]; then
        printf '%-12s# %s\n' "$id" "$name" >> "$ADDON_LIST"
    else
        echo "$id" >> "$ADDON_LIST"
    fi
done

success "Add-on list updated"

# Export configs (stored in meta.json under the "config" key)
info "Exporting add-on configs..."
exported=0
for dir in "$ADDON_DIR"/*/; do
    id="$(basename "$dir")"
    [[ "$id" == "__pycache__" ]] && continue
    [[ -f "$dir/meta.json" ]] || continue
    has_config=$(python3 -c "import json; print('yes' if 'config' in json.load(open('$dir/meta.json')) else 'no')" 2>/dev/null)
    if [[ "$has_config" == "yes" ]]; then
        mkdir -p "$ADDON_CONFIGS/$id"
        cp "$dir/meta.json" "$ADDON_CONFIGS/$id/meta.json"
        ((exported++))
    fi
done

# Remove configs for add-ons no longer installed
for config_dir in "$ADDON_CONFIGS"/*/; do
    [[ -d "$config_dir" ]] || continue
    id="$(basename "$config_dir")"
    if [[ ! -d "$ADDON_DIR/$id" ]]; then
        rm -rf "$config_dir"
        info "Removed config for uninstalled add-on $id"
    fi
done

success "$exported add-on config(s) exported"
