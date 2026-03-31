#!/bin/zsh

if [[ -z "$1" ]]; then
  echo "Usage: new-cowork-project <project-name>"
  exit 1
fi

PROJECT_NAME="$1"
PROJECT_DIR=~/Claude-Cowork/projects/"$PROJECT_NAME"
COWORK_ROOT=~/Claude-Cowork

if [[ -d "$PROJECT_DIR" ]]; then
  echo "Error: $PROJECT_DIR already exists."
  exit 1
fi

mkdir -p "$PROJECT_DIR/inbox" "$PROJECT_DIR/outputs"

ln -s "$COWORK_ROOT/_INSTRUCTIONS.md" "$PROJECT_DIR/_INSTRUCTIONS.md"
ln -s "$COWORK_ROOT/_PROFILE.md" "$PROJECT_DIR/_PROFILE.md"

cat > "$PROJECT_DIR/_MANIFEST.md" << MANIFEST
# Cowork Project Manifest — $PROJECT_NAME

## Always read first (every session)
- _INSTRUCTIONS.md — behavioral rules and working style
- _PROFILE.md — who Laura is, role context

## Read when relevant (not every session)
- Add project-specific reference files here as the project grows

## Write locations
- outputs/ — all generated files go here unless instructed otherwise
- inbox/ — drop zone for files to process

## Never modify
- _INSTRUCTIONS.md — read-only
- _MANIFEST.md — read-only
- _PROFILE.md — read-only

## Ignore
- .DS_Store
- Any file ending in .tmp or .bak
MANIFEST

echo "Created project: $PROJECT_DIR"
echo "Next: point Cowork at $PROJECT_DIR in the UI"
