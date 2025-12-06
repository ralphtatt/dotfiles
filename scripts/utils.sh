#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check OS
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

is_linux() {
    [[ "$OSTYPE" == "linux-gnu"* ]]
}

# Copy text to clipboard (cross-platform)
# Usage: copy_to_clipboard "text to copy"
#    or: echo "text" | copy_to_clipboard
copy_to_clipboard() {
    local content
    
    # Read from argument or stdin
    if [[ -n "$1" ]]; then
        content="$1"
    else
        content=$(cat)
    fi
    
    # Try different clipboard commands based on platform
    if command_exists pbcopy; then
        # macOS
        echo -n "$content" | pbcopy
        success "Copied to clipboard (macOS)!"
        return 0
    elif command_exists xclip; then
        # Linux with xclip
        echo -n "$content" | xclip -selection clipboard
        success "Copied to clipboard (Linux)!"
        return 0
    elif command_exists xsel; then
        # Linux with xsel
        echo -n "$content" | xsel --clipboard
        success "Copied to clipboard (Linux)!"
        return 0
    elif command_exists clip.exe; then
        # WSL
        echo -n "$content" | clip.exe
        success "Copied to clipboard (WSL)!"
        return 0
    else
        warning "Could not copy to clipboard automatically"
        return 1
    fi
}
