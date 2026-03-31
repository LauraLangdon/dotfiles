#!/bin/zsh
set -a
source ~/.config/claude-secrets.env
set +a
launchctl setenv GOOGLE_CLIENT_ID "$GOOGLE_CLIENT_ID"
launchctl setenv GOOGLE_CLIENT_SECRET "$GOOGLE_CLIENT_SECRET"
echo "Claude env vars set."
