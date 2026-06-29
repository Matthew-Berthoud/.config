#!/usr/bin/env zsh

today_only=false
quiet=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -t|--today) today_only=true ;;
    -q|--quiet) quiet=true ;;
    *) daily_notes="$1" ;;
  esac
  shift
done

daily_notes="${daily_notes:-$PWD/daily}"
mkdir -p "$daily_notes"

todays_note_file="$daily_notes/$(date +'%Y-%m-%d').md"
all_notes=($daily_notes/*.md(N.On))
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
    [[ "$quiet" == false ]] && tmux display-message "Copying tasks from yesterday's note..."
    sed '/^# Done/q' "$prev_note" > "$todays_note_file"
  else
    [[ "$quiet" == false ]] && tmux display-message "No previous note found. Creating fresh template..."
    printf '%s\n' '# To Do' '' '# Done' > "$todays_note_file"
  fi
else
  [[ "$quiet" == false ]] && tmux display-message "Today's note already exists. Opening..."
fi

# Open Neovim
if [[ "$today_only" == true ]]; then
  nvim "$todays_note_file"
elif [ -n "$prev_note" ]; then
  nvim -O "$todays_note_file" "$prev_note"
else
  nvim "$todays_note_file"
fi
