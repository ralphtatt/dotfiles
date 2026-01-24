#!/usr/bin/env bash

set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SETUP_DIR}/../scripts/utils.sh"

info "Setting up Zsh and Oh My Zsh..."

# Add Homebrew to PATH if on Linux
if is_linux && [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

info "Setting up Zsh and Oh My Zsh..."

# Check if Zsh is installed
if ! command_exists zsh; then
  if ! is_linux; then # ← Fixed: added space after !
    error "Zsh is not installed."
    exit 1
  fi
  brew install zsh
fi

# Install Oh My Zsh (idempotent)
ZSH_DIR="${HOME}/.oh-my-zsh"
if [[ ! -d "$ZSH_DIR" ]]; then
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  success "Oh My Zsh installed"
else
  success "Oh My Zsh already installed"

  # Update Oh My Zsh
  info "Updating Oh My Zsh..."
  cd "$ZSH_DIR" && git pull
fi

# Install popular plugins
info "Installing Oh My Zsh plugins..."

# zsh-autosuggestions
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  success "zsh-autosuggestions already installed"
  cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && git pull
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  success "zsh-syntax-highlighting already installed"
  cd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && git pull
fi

# Add ZSH to /etc/shells
if ! grep -q "$(which zsh)" /etc/shells; then
  info "Adding Homebrew zsh to /etc/shells..."
  echo "$(which zsh)" | sudo tee -a /etc/shells
fi

# Set Zsh as default shell (if not already)
if [[ "$SHELL" != "$(which zsh)" ]]; then
  info "Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
  success "Zsh set as default shell (restart terminal to apply)"
else
  success "Zsh is already the default shell"
fi

# Create .zshrc file
ZSHRC_FILE="$HOME/.zshrc"

touch $ZSHRC_FILE

# The code to add
SOURCE_CODE='
# Source all files in ~/.config/zsh
if [ -d ~/.config/zsh ]; then
  for config_file in ~/.config/zsh/*; do
    if [ -f "$config_file" ]; then
      source "$config_file"
    fi
  done
fi
'

# Check if the code is already in .zshrc
if grep -qF "# Source all files in ~/.config/zsh" "$ZSHRC_FILE"; then
  echo "The sourcing code is already present in $ZSHRC_FILE."
else
  # Append the code to .zshrc
  echo "$SOURCE_CODE" >>"$ZSHRC_FILE"
  echo "Sourcing code added to $ZSHRC_FILE."
fi

success "Zsh setup complete!"
