bindkey -v
bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

setopt IGNORE_EOF
setopt PROMPT_SUBST

alias ls="ls -G"
alias la="ls -lahG"
alias treedme='tree -a --gitignore --dirsfirst -I ".git/" --noreport | pbcopy'
alias daily="$SCRIPTS/daily_note.sh"
alias work="$SCRIPTS/work.sh"
alias cssbattle="pbpaste | python $SCRIPTS/cssbattle_condenser.py | pbcopy"
alias love="/Applications/love.app/Contents/MacOS/love"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias im="nvim"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

eval "$(pyenv init -)"

source "$SCRIPTS/git-prompt.sh"
PROMPT='%F{blue}%1~%f$(__git_ps1) %# '
