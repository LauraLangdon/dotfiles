#!/usr/bin/env bash
# 00-xcode.sh — Install Xcode Command Line Tools and Rosetta.
#
# Xcode CLT provides git, clang, make, and other build essentials.
# Rosetta lets Apple Silicon Macs run x86_64 binaries.

# Allow standalone use
[[ -z "${DOTFILES:-}" ]] && source "$(cd "$(dirname "$0")" && pwd)/utils.sh"

# --- Xcode Command Line Tools ---

if xcode-select -p &>/dev/null; then
    success "Xcode Command Line Tools already installed"
else
    info "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait for installation to complete
    info "Waiting for Xcode CLT installation (follow the dialog)..."
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    success "Xcode Command Line Tools installed"
fi

# --- Rosetta (Apple Silicon only) ---

if [[ "$(uname -m)" == "arm64" ]]; then
    if /usr/bin/pgrep -q oahd; then
        success "Rosetta already installed"
    else
        info "Installing Rosetta..."
        softwareupdate --install-rosetta --agree-to-license
        success "Rosetta installed"
    fi
else
    info "Intel Mac detected — Rosetta not needed"
fi
