#!/usr/bin/env zsh

if [[ $# -eq 1 ]]; then
  directory=${1:A}
else
  repos_dirs=($REPOS/*(N/D))
  personal_repos=(${repos_dirs:#*/black-cape})
  work_repos=($WORK_REPOS/*/*(N/D))
  directory=$(print -l $CONFIG $work_repos $personal_repos | fzf --delimiter / --with-nth -1)
fi

if [[ -z $directory ]]; then
  exit 0
fi

session_name=$(basename "$directory" | tr . _)

if [[ -z $TMUX ]]; then
  tmux new-session -A -s "$session_name" -c "$directory"
  exit 0
fi

if ! tmux has-session -t="$session_name" 2>/dev/null; then
  tmux new-session -ds "$session_name" -n "editor" -c "$directory"
  tmux send-keys -t ${session_name}:editor "cd $directory" C-m

  tmux new-window -t $session_name -n "terminal" -c "$directory"
  tmux send-keys -t ${session_name}:terminal "git status" C-m

  tmux new-window -t $session_name -n "server" -c "$directory"

  tmux new-window -t $session_name -n "notes" -c "$directory"
  # Open notes directory with same path relative to $NOTES as the repo is relative to $REPOS
  relative_path="${directory#$REPOS/}"
  echo $relative_path
  # Config isn't in $REPOS so its notes are just in $NOTES/config
  if [[ $directory == $CONFIG ]]; then
    tmux send-keys -t ${session_name}:notes "cd $NOTES/config" C-m
  else
    tmux send-keys -t ${session_name}:notes "mkdir -p $NOTES/$relative_path && cd $NOTES/$relative_path" C-m
  fi

  tmux select-window -t ${session_name}:terminal
fi

tmux switch-client -t "$session_name"
