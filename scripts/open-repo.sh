#!/bin/bash

# git-open-browser.sh
# Opens the current git repo in your default browser.
# Works on macOS, Ubuntu, and WSL Ubuntu.

target_path="${1:-.}"

# Check if the target path is a git repo
if ! git -C "$target_path" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Not a git repository: $target_path"
    exit 1
fi

# Get the remote URL
remote_url=$(git -C "$target_path" remote get-url origin 2>/dev/null)
if [ -z "$remote_url" ]; then
    echo "No remote named 'origin' found."
    exit 1
fi

if [[ "$remote_url" =~ ^git@ ]]; then
    remote_url="${remote_url#git@}"    # Remove git@
    remote_url="${remote_url/://}"     # Replace : with /
    remote_url="https://${remote_url}" # Prepend https://
    remote_url="${remote_url%.git}"    # Remove .git
fi

# Open the URL in the default browser
case "$(uname -s)" in
    Darwin)
        open "$remote_url"
        ;;
    Linux)
        if grep -q Microsoft /proc/version; then
            # WSL: use cmd.exe to open the default Windows browser
            cmd.exe /c start "$remote_url"
        else
            # Native Linux
            xdg-open "$remote_url"
        fi
        ;;
    *)
        echo "Unsupported OS."
        exit 1
        ;;
esac

