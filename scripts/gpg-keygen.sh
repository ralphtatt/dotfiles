#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

info "GPG Key Generator for Git Commit Signing"
echo ""

# Check if GPG is installed
if ! command_exists gpg; then
    error "GPG is not installed."
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

# Configure Git in .gitconfig.local
info "Configuring Git..."
GITCONFIG_LOCAL="${HOME}/.gitconfig.local"

if [[ -f "$GITCONFIG_LOCAL" ]]; then
    # Update existing file
    if grep -q "signingkey" "$GITCONFIG_LOCAL"; then
        # Replace existing signingkey
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/signingkey =.*/signingkey = $KEY_ID/" "$GITCONFIG_LOCAL"
        else
            sed -i "s/signingkey =.*/signingkey = $KEY_ID/" "$GITCONFIG_LOCAL"
        fi
        info "Updated signing key in ~/.gitconfig.local"
    else
        # Add signingkey to [user] section
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "/\[user\]/a\\
    signingkey = $KEY_ID
" "$GITCONFIG_LOCAL"
        else
            sed -i "/\[user\]/a\    signingkey = $KEY_ID" "$GITCONFIG_LOCAL"
        fi
        success "Added signing key to ~/.gitconfig.local"
    fi
else
    # Create new .gitconfig.local
    cat > "$GITCONFIG_LOCAL" << EOF
[user]
    name = $user_name
    email = $user_email
    signingkey = $KEY_ID
EOF
    success "Created ~/.gitconfig.local with signing key"
fi

success "Git configured to sign commits with key $KEY_ID"
echo ""

# Show and copy public key
info "Your public GPG key:"
echo "========================================"
gpg --armor --export "$KEY_ID"
echo "========================================"
echo ""

# Copy to clipboard
gpg --armor --export "$KEY_ID" | copy_to_clipboard

echo ""
info "Add to GitHub: https://github.com/settings/gpg/new"
info "Add to GitLab: https://gitlab.com/-/profile/gpg_keys"
