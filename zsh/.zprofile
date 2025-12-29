eval "$(/opt/homebrew/bin/brew shellenv)"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

export PATH="$HOME/.lmstudio/bin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"

export EDITOR='nvim'
export NVM_DIR="$HOME/.nvm"
export PYENV_ROOT="$HOME/.pyenv"

export REPOS="$HOME/repos"
export PERSONAL_REPOS="$REPOS/personal"
export WORK_REPOS="$REPOS/black-cape"
export CONFIG="$HOME/.config"
export SCRIPTS="$CONFIG/scripts"
