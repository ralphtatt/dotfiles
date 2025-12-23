# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
# ZSH_THEME="robbyrussell"
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
    ssh
    ssh-agent
    sudo
    terraform
    tmux
    vscode
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'

# Aliases
alias vim='nvim'

# Prefer batcat on Linux (some distros name it that), fallback to bat
if command -v batcat >/dev/null 2>&1; then
    alias cat='batcat'
elif command -v bat >/dev/null 2>&1; then
    alias cat='bat'
fi

# Custom PATH additions
export PATH="$HOME/bin:$PATH"

# Kubectx prompt info
RPS1='$(kubectx_prompt_info)'

# Load custom configs if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

. /opt/homebrew/opt/asdf/libexec/asdf.sh
