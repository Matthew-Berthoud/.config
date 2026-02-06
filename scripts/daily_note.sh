#!/usr/bin/env zsh

all_notes="$HOME/Desktop/black-cape/notes"
bank_note="$all_notes/bank.md"
notes_dir="$all_notes/daily"
mkdir -p "$notes_dir"

todays_note_file="$notes_dir/$(date +'%Y-%m-%d').md"

# Get all .md files sorted by modification time (.om)
# Iterate through them to find the first one that is NOT today's file
# We find the correct "yesterday" whether today's file exists or not
all_notes=($notes_dir/*.md(.om))
prev_note=""

for note in $all_notes; do
  if [[ "$note" != "$todays_note_file" ]]; then
    prev_note="$note"
    break
  fi
done

# Create Today's note if it doesn't exist
if [ ! -f "$todays_note_file" ]; then
  if [ -n "$prev_note" ]; then
    # Copy uncompleted tasks from the previous note
    sed '/^# Done/q' "$prev_note" > "$todays_note_file"
  else
    # Create a fresh template if no previous note exists
    printf '%s\n' '# Bank' '' '# To Do' '' '# In Progress' '' '# In Review' '' '# Done' > "$todays_note_file"
  fi
fi

# If a previous note exists, open side-by-side with today's note
if [ -n "$prev_note" ]; then
  nvim -p "$todays_note_file" "$bank_note" -c "vsplit $prev_note"
else
  nvim -p "$todays_note_file" "$bank_note"
fi
