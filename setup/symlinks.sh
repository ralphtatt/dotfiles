#!/usr/bin/env bash

set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="${DOTFILES_DIR}/config"

source "${SETUP_DIR}/../scripts/utils.sh"

# Function to create symlink safely
link_file() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$src" ]]; then
      success "Already linked: $dest"
      return 0
    fi
    mv "$dest" "${dest}.backup"
    info "Backed up existing file to ${dest}.backup"
  fi

  ln -sf "$src" "$dest"
  success "Linked: $dest → $src"
}


# Git config
info "Linking Git config..."
link_file "${CONFIG_DIR}/git/.gitconfig" ~/.gitconfig

# We don't just link the whole config directory due to other tools using it
mkdir -p ~/.config

# Zsh config
info "Linking Zsh config..."
link_file "${CONFIG_DIR}/zsh" ~/.config/zsh

# Zsh config
info "Linking Zsh theme config..."
link_file "${CONFIG_DIR}/zsh/rjt.zsh-theme" ~/.oh-my-zsh/themes/rjt.zsh-theme

# Neovim config
info "Linking Neovim config..."
link_file "${CONFIG_DIR}/nvim" ~/.config/nvim

# Tmux config
info "Linking Tmux config..."
link_file "${CONFIG_DIR}/tmux/tmux.conf" ~/.tmux.conf

# Tmux config
info "Linking efm config..."
link_file "${CONFIG_DIR}/efm-langserver" ~/.config/efm-langserver

# Ripgrep config
info "Linking ripgrep config..."
link_file "${CONFIG_DIR}/ripgrep/config" ~/.ripgrep

# Scripts
mkdir -p ~/.scripts
info "Linking Scripts..."
link_file "${DOTFILES_DIR}/scripts" ~/.scripts

