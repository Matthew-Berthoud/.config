#!/usr/bin/env zsh

notes_dir="$HOME/Desktop/black-cape/notes/daily"
mkdir -p "$notes_dir"

todays_note_file="$notes_dir/$(date +'%Y-%m-%d').md"

if [ -f "$todays_note_file" ]; then
  nvim "$todays_note_file"
  exit 0 
fi

source_note=($notes_dir/*.md(.om[1]))

if [ -f "$source_note" ]; then
  sed '/^# Done/q' "$source_note" > "$todays_note_file"
else
  printf '%s\n' '# Bank' '' '# To Do' '' '# In Progress' '' '# In Review' '' '# Done' > "$todays_note_file"
fi

nvim "$todays_note_file"
