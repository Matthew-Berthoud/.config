local notes_dir="$HOME/Desktop/black-cape/notes/daily"
mkdir -p "$notes_dir"

local todays_note_file="$notes_dir/$(date +'%Y-%m-%d').md"

if [ -f "$todays_note_file" ]; then
  nvim "$todays_note_file"
  return
fi

local source_note
source_note=$(ls -t "$notes_dir"/*.md 2>/dev/null | head -n 1)

if [ -n "$source_note" ]; then
  sed '/^# Done/q' "$source_note" >"$todays_note_file"
else
  printf '%s\n' '# Bank' '' '# To Do' '' '# In Progress' '' '# In Review' '' '# Done' >"$todays_note_file"
fi

nvim "$todays_note_file"
