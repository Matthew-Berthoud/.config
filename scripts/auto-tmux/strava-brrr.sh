#!/usr/bin/env zsh

SESH="strava-brrr"
DIR="$REPOS/strava-brrr"

tmux has-session -t $SESH 2>/dev/null

if [ $? != 0 ]; then
  tmux new-session -d -s $SESH -n "editor" -c $DIR

  tmux send-keys -t ${SESH}:editor "cd $DIR" C-m
  tmux send-keys -t ${SESH}:editor "nvim ." C-m

  tmux new-window -t $SESH -n "terminal"
  tmux send-keys -t ${SESH}:terminal "cd $DIR" C-m
  tmux send-keys -t ${SESH}:terminal "git status" C-m

  tmux select-window -t ${SESH}:terminal
fi
