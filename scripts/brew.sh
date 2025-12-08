#!/usr/bin/env bash

set -e

source "$(dirname "$0")/utils.sh"

info "Setting up Homebrew..."

if ! is_macos; then
    warning "This script is intended for macOS only."
    warning "Skipping Homebrew setup!"
    exit 0
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    success "Homebrew already installed"
fi

# Update Homebrew
info "Updating Homebrew..."
brew update

# Install from Brewfiles in brew directory
if [[ -d "brew" ]]; then
    info "Installing packages from Brewfiles..."
    for brewfile in brew/Brewfile*; do
        if [[ -f "$brewfile" ]]; then
            info "Processing $brewfile..."
            brew bundle --file="$brewfile"
        fi
    done
    success "Brew packages installed"
else
    error "brew directory not found"
    exit 1
fi

# Cleanup
info "Cleaning up..."
brew cleanup
success "Homebrew setup complete!"
