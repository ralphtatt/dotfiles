#!/usr/bin/env bash

set -e # Exit on error

# Source utilities
source "$(dirname "$0")/scripts/utils.sh"

# Menu-driven installation
echo "What would you like to install?"
echo "1) Initial setup (everything)"
echo "2) Package manager + packages (Homebrew)"
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
  bash setup/git-config.sh
  bash setup/brew.sh
  bash setup/zsh.sh
  bash setup/symlinks.sh
  ;;
2)
  bash setup/brew.sh
  ;;
3)
  bash setup/zsh.sh
  ;;
4)
  bash setup/symlinks.sh
  ;;
5)
  bash setup/git-config.sh
  ;;
6)
  bash setup/ssh-keygen.sh
  ;;
7)
  bash setup/gpg-keygen.sh
  ;;
esac
