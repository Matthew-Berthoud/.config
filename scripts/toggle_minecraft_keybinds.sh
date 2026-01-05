#!/usr/bin/env zsh

osascript <<EOF
    tell application "System Settings"
        activate
        reveal pane id "com.apple.Keyboard-Settings.extension" 
    end tell

    -- tell application "System Settings" to quit
EOF
