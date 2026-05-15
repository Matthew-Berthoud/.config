#!/usr/bin/env zsh

is_window=false
pass_args=()

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --window) is_window=true ;;
    *) pass_args+=("$1") ;;
  esac
  shift
done

notes_path=$(tmux display-message -p '#{@notes_path}')

if [[ -z "$notes_path" ]]; then
  session_path=$(tmux display-message -p '#{session_path}')
  if [[ "$session_path" == "$CONFIG" ]]; then
    notes_path="$NOTES/config"
  elif [[ "$session_path" == "$REPOS"/* ]]; then
    notes_path="$NOTES/${session_path#$REPOS/}"
  else
    notes_path="$NOTES/$(basename "$session_path")"
  fi
fi

daily_dir="$notes_path/daily"

if [[ ! -d "$daily_dir" ]]; then
  printf 'Notes dir does not exist:\n  %s\nCreate it? [y/N] ' "$daily_dir"
  read -r answer
  [[ "$answer" == "y" || "$answer" == "Y" ]] || exit 0
fi

if [[ "$is_window" == true ]]; then
  tmux new-window -n "notes" "zsh $WORKFLOW/open_daily_note.sh $daily_dir $pass_args"
else
  exec zsh "$WORKFLOW/open_daily_note.sh" "$daily_dir" "${pass_args[@]}"
fi
