#!/usr/bin/env bash

set -e  # Exit on error

# Source utilities
source "$(dirname "$0")/scripts/utils.sh"

# Menu-driven installation
echo "What would you like to install?"
echo "1) Initial setup (everything)"
echo "2) Homebrew + packages"
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
        bash scripts/brew.sh
        bash scripts/zsh.sh
        bash scripts/symlinks.sh
        ;;
    2)
        bash scripts/brew.sh
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
    # ... other cases
esac
