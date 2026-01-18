# Dotfiles

[![volkswagen status](https://auchenberg.github.io/volkswagen/volkswagen_ci.svg?v=1)](https://github.com/auchenberg/volkswagen)

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

## Test in Docker

Run the following in the project root to help test the script in an Ubuntu environment.

```bash
docker run -it --rm -v $(pwd):/mnt ubuntu:latest \
  bash -c "apt-get update && apt-get install -y sudo curl git && \
           echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
           su - ubuntu"
```

You will need to set a password `sudo passwd ubuntu`.

## nvim 0.12

At the moment nvim is still on 0.11 where as we require the 0.12 version. This is a short manual workaround until 0.12 is released in brew.

```bash

# Install tools on linux
sudo apt install build-essential

cargo install bob-nvim

bob install nightly
bob use nightly
```

You will also need to add both to the PATH.

