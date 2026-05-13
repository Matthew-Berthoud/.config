#!/usr/bin/env zsh

session=$(tmux display-message -p '#S')
notes_path=$(tmux display-message -p -t "${session}:notes" '#{pane_current_path}' 2>/dev/null)

if [[ -z "$notes_path" ]]; then
  notes_path="$NOTES/config"
fi

exec zsh "$WORKFLOW/open_daily_note.sh" "$notes_path/daily"
