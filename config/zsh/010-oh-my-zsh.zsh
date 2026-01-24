# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="crunch"

# Plugins
# Find more here https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
    aws
    brew
    docker
    git
    golang
    helm
    iterm2
    k9s
    kubectl
    kubectx
    macos
    pre-commit
    ssh
    ssh-agent
    sudo
    terraform
    tmux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

