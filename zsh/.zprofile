eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"

export EDITOR='nvim'
export PYENV_ROOT="$HOME/.pyenv"
