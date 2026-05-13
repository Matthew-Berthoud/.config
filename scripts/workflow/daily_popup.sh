#!/usr/bin/env zsh

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

exec zsh "$WORKFLOW/open_daily_note.sh" "$daily_dir"
