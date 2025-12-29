#!/usr/bin/env zsh

if [[ $# -eq 1 ]]; then
  selected=$1
else
  repos_dirs=($REPOS/*(D/))
  personal_repos=(${repos_dirs:#*/black-cape})
  atoms_dirs=($WORK_REPOS/ATOMS/*(D/))
  cdao_dirs=($WORK_REPOS/CDAO/*(D/))
  config="$HOME/.config"
  notes="$HOME/Desktop/black-cape/notes" 
  selected=$(print -l $config $notes $atoms_dirs $cdao_dirs $personal_repos | fzf)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(echo ${selected:t} | tr . _)

if [[ -z $TMUX ]]; then
  tmux new-session -A -s "$selected_name" -c "$selected"
  exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
