#!/usr/bin/env zsh

search_dirs=(
  "$HOME/repos"
  "$HOME/repos/black-cape"
  "$HOME/.config"
)

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(ls -d $^search_dirs/*(D/) | fzf)
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
