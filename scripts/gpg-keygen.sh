#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

info "GPG Key Generator for Git Commit Signing"
echo ""

# Check if GPG is installed
if ! command_exists gpg; then
    error "GPG is not installed. Install with: brew install gnupg"
    exit 1
fi

# Get user info
read -p "Enter your name: " user_name
read -p "Enter your email: " user_email

if [[ -z "$user_name" || -z "$user_email" ]]; then
    error "Name and email are required"
    exit 1
fi

# Generate key config
info "Generating GPG key..."
GPG_CONFIG=$(mktemp)
trap "rm -f $GPG_CONFIG" EXIT

cat > "$GPG_CONFIG" << EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $user_name
Name-Email: $user_email
Expire-Date: 1y
%commit
EOF

gpg --batch --gen-key "$GPG_CONFIG"
success "GPG key generated!"

# Get key ID
KEY_ID=$(gpg --list-secret-keys --keyid-format=long "$user_email" | grep sec | awk '{print $2}' | cut -d'/' -f2 | head -n1)

# Configure Git
info "Configuring Git..."
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true
git config --global gpg.program $(which gpg)

success "Git configured to sign commits with key $KEY_ID"
echo ""

# Show and copy public key
info "Your public GPG key:"
echo "========================================"
gpg --armor --export "$KEY_ID"
echo "========================================"

# Copy to clipboard
gpg --armor --export "$KEY_ID" | copy_to_clipboard

echo ""
info "Add to GitHub: https://github.com/settings/gpg/new"
info "Add to GitLab: https://gitlab.com/-/profile/gpg_keys"
