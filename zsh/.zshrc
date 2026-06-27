bindkey -v
bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

setopt IGNORE_EOF
setopt PROMPT_SUBST

alias cssbattle="pbpaste | python $SCRIPTS/cssbattle_condenser.py | pbcopy"
alias daily="$WORKFLOW/open_daily_note.sh"
alias dockernuke="docker system prune --all --volumes --force"
alias dotsync="zsh $SCRIPTS/sync.sh"
alias ai="clear && claude"
alias beer="zsh $SCRIPTS/beer.sh"
alias im="nvim"
alias la="ls -lahG"
alias love="/Applications/love.app/Contents/MacOS/love"
alias ls="ls -G"
alias mc="$SCRIPTS/toggle_minecraft_keybinds.sh"
alias so="source $CONFIG/zsh/.zshenv && source $CONFIG/zsh/.zprofile && source $CONFIG/zsh/.zshrc"
alias treedme='tree -a --gitignore --dirsfirst -I ".git/" --noreport | pbcopy'
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias vrg='nvim $(git diff --name-only HEAD; git ls-files --others --exclude-standard)'
alias wtf="npm -v && node -v && which npm && which node"
alias ald="cd $WORK_REPOS/ATOMS/atoms-local-dev/starscream && docker desktop start && make down-v && git pull && make pull && make up && cd -"
alias dif='open "https://tex.gerbil-cloud.ts.net:3000/oms/atoms-ui/compare/main...$(git branch --show-current)"'

eval "$(pyenv init -)"

source "$SCRIPTS/git-prompt.sh"
PROMPT='
%F{8}╭─%f %F{cyan}%*%f %F{blue}%1~%f$(__git_ps1)
%F{8}╰─%f %# '

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Ruby version manager
eval "$(rbenv init - zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Docker auto-completions
FPATH="$HOME/.docker/completions:$FPATH"
autoload -Uz compinit
compinit

# claude
export PATH="$HOME/.local/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/matthewberthoud/.lmstudio/bin"
# End of LM Studio CLI section

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
