#!/usr/bin/env bash

set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SETUP_DIR}/../scripts/utils.sh"

info "Setting up Homebrew..."

if is_linux; then
  echo >>$HOME/.bashrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >>$HOME/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Can't remember if this needs to be done with macos as well, will find out next time!
  if is_linux; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
  fi
else
  success "Homebrew already installed"
fi

# Update Homebrew
info "Updating Homebrew..."
brew update

# Install from Brewfiles in brew directory
if [[ -d "brew" ]]; then
  info "Installing packages from Brewfiles..."
  brew bundle --file="brew/Brewfile" --verbose
  if is_macos; then
    info "Installing cask packages from Brewfiles..."
    brew bundle --file="brew/Brewfile.cask" --verbose
  fi
  success "Brew packages installed"
else
  error "brew directory not found"
  exit 1
fi

# Cleanup
info "Cleaning up..."
brew cleanup
success "Homebrew setup complete!"
