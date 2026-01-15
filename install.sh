#!/usr/bin/env bash

set -e # Exit on error

# Source utilities
source "$(dirname "$0")/scripts/utils.sh"

# Menu-driven installation
echo "What would you like to install?"
echo "1) Initial setup (everything)"
echo "2) Package manager + packages (Homebrew on macOS, APT on Linux)"
echo "3) ZSH + Oh My Zsh"
echo "4) Symlink dotfiles"
echo "5) Local Git Configuration"
echo "-----------------------"
echo "6) SSH Key Generator"
echo "7) GPG Key Generator"

read -p "Enter number of choice: " choice

case $choice in
  1)
    info "Running full setup..."
    bash scripts/git-config.sh

    if is_macos; then
      info "Detected macOS — running Homebrew installer"
      bash scripts/brew.sh
    elif is_linux; then
      info "Detected Linux — running APT installer"
      bash scripts/apt.sh
    else
      warning "Unrecognized OS — skipping package installer step"
    fi

    bash scripts/zsh.sh
    bash scripts/symlinks.sh
    ;;
  2)
    if is_macos; then
      bash scripts/brew.sh
    elif is_linux; then
      bash scripts/apt.sh
    else
      warning "Unrecognized OS — no package manager selected"
    fi
    ;;
  3)
    bash scripts/zsh.sh
    ;;
  4)
    bash scripts/symlinks.sh
    ;;
  5)
    bash scripts/git-config.sh
    ;;
  6)
    bash scripts/ssh-keygen.sh
    ;;
  7)
    bash scripts/gpg-keygen.sh
    ;;
esac
