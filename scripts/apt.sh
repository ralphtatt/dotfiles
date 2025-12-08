#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND=noninteractive
export TZ="Europe/London"

source "$(dirname "$0")/utils.sh"

info "Setting up APT packages..."

if ! is_linux; then
    warning "This script is intended for Debian/Ubuntu Linux only."
    warning "Skipping APT setup!"
    exit 0
fi

if ! command -v apt &> /dev/null; then
    error "apt not found on this system."
    exit 1
fi

# Use sudo when not running as root
SUDO=""
if [ "$EUID" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        warning "Not running as root and 'sudo' is not available — installs may fail"
    fi
fi

info "Updating apt cache..."
$SUDO apt update

if [[ -d "apt" ]]; then
    info "Installing packages from apt directory..."
    for pkgfile in apt/packages*; do
        if [[ -f "$pkgfile" ]]; then
            info "Processing $pkgfile..."
            packages=$(grep -E -v '^\s*(#|$)' "$pkgfile" | tr '\n' ' ')
            if [[ -n "$packages" ]]; then
                $SUDO apt install -y $packages
            else
                info "No packages listed in $pkgfile"
            fi
        fi
    done
    success "APT packages installed"
else
    error "apt directory not found"
    exit 1
fi

info "Cleaning up..."
$SUDO apt autoremove -y
$SUDO apt autoclean
success "APT setup complete!"
