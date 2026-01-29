#!/usr/bin/env zsh

$SCRIPTS/auto-tmux/config.sh
$SCRIPTS/auto-tmux/notes.sh
$SCRIPTS/auto-tmux/epona.sh
$SCRIPTS/auto-tmux/strava-brrr.sh

tmux a -t epona-app
