#!/usr/bin/env zsh

[[ -z "$TMUX" ]] && { echo "Tmux is not running. Exiting..."; exit 0; }

WINDOW_NAME=$(tmux display-message -p '#W')
PANE_ID=$(tmux display-message -p '#{pane_id}')

[[ "$WINDOW_NAME" != "notes" ]] && { echo "This is not the notes window. Exiting..."; exit 0; }

# save and quit all vim buffers
tmux send-keys -t "$PANE_ID" :wqa C-m
sleep 0.2
tmux send-keys -t "$PANE_ID" "daily" C-m
