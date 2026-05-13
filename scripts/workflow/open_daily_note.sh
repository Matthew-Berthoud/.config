#!/usr/bin/env zsh

daily_notes="${1:-$PWD/daily}"
mkdir -p "$daily_notes"

todays_note_file="$daily_notes/$(date +'%Y-%m-%d').md"
all_notes=($daily_notes/*.md(N.om))
prev_note=""

# Find the most recent note that isn't today's
for note in $all_notes; do
  if [[ "$note" != "$todays_note_file" ]]; then
    prev_note="$note"
    break
  fi
done

# Create Today's note if it doesn't exist
if [ ! -f "$todays_note_file" ]; then
  if [ -n "$prev_note" ]; then
    tmux display-message "Copying tasks from yesterday's note..."
    sed '/^# Done/q' "$prev_note" > "$todays_note_file"
  else
    tmux display-message "No previous note found. Creating fresh template..."
    printf '%s\n' '# To Do' '' '# Done' > "$todays_note_file"
  fi
else
  tmux display-message "Today's note already exists. Opening..."
fi

# Open Neovim
if [ -n "$prev_note" ]; then
  nvim -O "$todays_note_file" "$prev_note"
else
  nvim "$todays_note_file"
fi
