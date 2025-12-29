bindkey -v
setopt IGNORE_EOF
setopt PROMPT_SUBST

alias ls="ls -G"
alias la="ls -lahG"
alias treedme='tree -a --gitignore --dirsfirst -I ".git/" --noreport | pbcopy'
alias daily="source $SCRIPTS/daily_note.sh"
alias cssbattle="pbpaste | python $SCRIPTS/cssbattle_condenser.py | pbcopy"
alias love="/Applications/love.app/Contents/MacOS/love"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias im="nvim"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

eval "$(rbenv init - zsh)"
eval "$(pyenv init -)"

export SDKMAN_DIR="$(brew --prefix sdkman-cli)/libexec"
[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

source "$SCRIPTS/git-prompt.sh"
PROMPT='%F{blue}%1~%f$(__git_ps1) $ '
