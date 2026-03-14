#!/usr/bin/env bash
# default-editor-samples.sh — Create sample files for setting default editor.
#
# Creates one file per type in ~/Desktop/set-default-editor/
# so you can quickly right-click > Get Info > Open With > Change All
# for each file type. Delete the folder when done.

[[ -z "${DOTFILES:-}" ]] && { DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"; source "$DOTFILES/scripts/utils.sh"; }

SAMPLE_DIR="$HOME/Desktop/set-default-editor"
mkdir -p "$SAMPLE_DIR"

extensions=(
    # Code
    py sh js ts go rs rb c swift java
    # Web
    html css scss
    # Data / Config
    json yaml yml toml xml plist csv
    # Docs / Text
    md txt log rst
    # Other
    Makefile Dockerfile
)

for ext in "${extensions[@]}"; do
    if [[ "$ext" == "Makefile" || "$ext" == "Dockerfile" ]]; then
        touch "$SAMPLE_DIR/$ext"
    else
        touch "$SAMPLE_DIR/sample.$ext"
    fi
done

success "Sample files created in $SAMPLE_DIR"
info "For each file: right-click > Get Info > Open With > Sublime Text > Change All"
info "Delete the folder when done."
