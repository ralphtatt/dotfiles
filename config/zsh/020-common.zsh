# User configuration
export EDITOR="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgrep"

# Aliases
alias af="alias | rg"
alias sz="echo Sourcing .zshrc; source ~/.zshrc"
alias cat="bat"
alias grep="rg"
alias tmac="tmux new -A -s"
alias vim="nvim"

# Custom PATH additions
export PATH="$HOME/bin:$PATH"
. $(brew --prefix asdf)/libexec/asdf.sh

# Kubectx prompt info
RPS1="$(kubectx_prompt_info)"

