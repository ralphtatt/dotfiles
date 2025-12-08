#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

info "Git Local Configuration Setup"
echo ""

GITCONFIG_LOCAL="${HOME}/.gitconfig.local"

# Check if it already exists
if [[ -f "$GITCONFIG_LOCAL" ]]; then
    warning "~/.gitconfig.local already exists"
    cat "$GITCONFIG_LOCAL"
    warning "If you want a new one please delete it first."
    info "Keeping existing configuration"
    exit 0
fi

# Get user info
read -p "Enter your name: " git_name
read -p "Enter your email: " git_email

if [[ -z "$git_name" || -z "$git_email" ]]; then
    error "Name and email are required"
    exit 1
fi

# Create .gitconfig.local
cat > "$GITCONFIG_LOCAL" << EOF
[user]
    name = $git_name
    email = $git_email
EOF

success "Created ~/.gitconfig.local"
echo ""
info "Contents:"
cat "$GITCONFIG_LOCAL"
