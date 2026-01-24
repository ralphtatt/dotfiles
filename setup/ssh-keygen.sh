#!/usr/bin/env bash

set -e

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SETUP_DIR}/../scripts/utils.sh"

info "SSH Key Generator"
echo ""

SSH_DIR="${HOME}/.ssh"

# Create .ssh directory if it doesn't exist
if [[ ! -d "$SSH_DIR" ]]; then
  info "Creating .ssh directory..."
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
fi

# Prompt for key name
read -p "Enter a name for this SSH key (e.g., github, gitlab, work): " key_name

if [[ -z "$key_name" ]]; then
  error "Key name is required"
  exit 1
fi

# Construct full path
SSH_KEY_PATH="${SSH_DIR}/${key_name}"

# Check if key already exists
if [[ -f "$SSH_KEY_PATH" ]]; then
  error "SSH key already exists at $SSH_KEY_PATH"
  info "Existing public key:"
  echo "========================================"
  cat "${SSH_KEY_PATH}.pub"
  echo "========================================"
  exit 1
fi

# Prompt for passphrase
echo ""
info "You can optionally add a passphrase for extra security"
read -p "Do you want to add a passphrase? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  USE_PASSPHRASE=true
else
  USE_PASSPHRASE=false
fi

# Generate SSH key
info "Generating ED25519 SSH key at: $SSH_KEY_PATH"

if [[ "$USE_PASSPHRASE" == true ]]; then
  ssh-keygen -t ed25519 -f "$SSH_KEY_PATH"
else
  ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N ""
fi

if [[ $? -ne 0 ]]; then
  error "Failed to generate SSH key"
  exit 1
fi

# Set correct permissions
chmod 600 "$SSH_KEY_PATH"
chmod 644 "${SSH_KEY_PATH}.pub"

success "SSH key generated successfully!"

# Start ssh-agent if not running
info "Adding key to ssh-agent..."
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent -s)"
fi

# Add key to ssh-agent
if ssh-add "$SSH_KEY_PATH"; then
  success "Key added to ssh-agent"
else
  warning "Could not add key to ssh-agent (may require passphrase later)"
fi

# Display the public key
echo ""
info "Your public key:"
echo "========================================"
cat "${SSH_KEY_PATH}.pub"
echo "========================================"
echo ""

info "Key location:"
echo "  Private: $SSH_KEY_PATH"
echo "  Public:  ${SSH_KEY_PATH}.pub"
echo ""

# Copy to clipboard
cat "${SSH_KEY_PATH}.pub" | copy_to_clipboard

echo ""
success "Done!"
