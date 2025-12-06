# Dotfiles

This repository contains a curated set of dotfiles and automation scripts to provision a consistent, reproducible development environment across machines.

Key features

- Install script that symlinks configuration files and installs required packages.
- Homebrew Brewfile(s) for packages and casks.
- Shell, editor, git, and terminal configurations kept in a single place.
- Minimal machine-specific tweaks to keep defaults portable and easy to audit.

Goals

- Make new machines ready for development with a single command.
- Keep configurations versioned and easy to customize.
- Ensure setups are idempotent and safe to re-run.

## Quick Start

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Remove files not needed in brew/ directory
./install.sh
```

## Changes

### Update Brewfile(s)

To dump the things already installed by brew on a machine:

```bash
brew bundle dump
```

Then they are sorted manually into each section dependant on their usefulness
