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
alias play="$SCRIPTS/play.sh"
alias mc="$SCRIPTS/toggle_minecraft_keybinds.sh"
alias cssbattle="pbpaste | python $SCRIPTS/cssbattle_condenser.py | pbcopy"
alias love="/Applications/love.app/Contents/MacOS/love"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias im="nvim"
alias wtf="npm -v && node -v && which npm && which node"

eval "$(pyenv init -)"

source "$SCRIPTS/git-prompt.sh"
PROMPT='%F{blue}%1~%f$(__git_ps1) %# '

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/matthewberthoud/.lmstudio/bin"
# End of LM Studio CLI section

# Added by nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# End of nvm section

# Fast node manager (nvm alternative)
eval "$(fnm env --use-on-cd --shell zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
