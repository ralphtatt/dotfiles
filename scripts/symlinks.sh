#!/usr/bin/env bash

set -e

source "$(dirname "$0")/utils.sh"

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="${DOTFILES_DIR}/config"

# Function to create symlink safely
link_file() {
    local src="$1"
    local dest="$2"
    
    if [[ -e "$dest" || -L "$dest" ]]; then
        if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$src" ]]; then
            success "Already linked: $dest"
            return 0
        fi
        
        read -p "File exists: $dest. Backup? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "$dest" "${dest}.backup"
            info "Backed up to ${dest}.backup"
        fi
    fi
    
    ln -sf "$src" "$dest"
    success "Linked: $dest → $src"
}

# Zsh config
info "Linking Zsh config..."
link_file "${CONFIG_DIR}/zsh/.zshrc" ~/.zshrc

# Git config
info "Linking Git config..."
link_file "${CONFIG_DIR}/git/.gitconfig" ~/.gitconfig

# Neovim config
info "Linking Neovim config..."
mkdir -p ~/.config
link_file "${CONFIG_DIR}/nvim" ~/.config/nvim
