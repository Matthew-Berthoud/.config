#!/bin/zsh

CONFIG="$HOME/.config"
SCRIPTS="$CONFIG/scripts"

ln -sf "$CONFIG/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$CONFIG/zsh/.zshenv" "$HOME/.zshenv"
ln -sf "$CONFIG/zsh/.zprofile" "$HOME/.zprofile"
ln -sf "$CONFIG/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$CONFIG/git/.gitconfig-work" "$HOME/.gitconfig-work"

brew bundle --clean

source "$SCRIPTS/fnm_npm.sh"
source "$SCRIPTS/rustup_cargo_rust.sh"
