# Dotfiles

Environment setup that can be ran on any machine to keep it inline with a "standard".

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
