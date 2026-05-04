#!/bin/zsh

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "${BLUE}Linking dotfiles...${NC}"

ln -sf "$CONFIG/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$CONFIG/zsh/.zshenv" "$HOME/.zshenv"
ln -sf "$CONFIG/zsh/.zprofile" "$HOME/.zprofile"
ln -sf "$CONFIG/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$CONFIG/git/.gitconfig-work" "$HOME/.gitconfig-work"

echo "${GREEN}Linked!${NC}"

# 1. Brew
echo "${BLUE}Updating system packages via Brew...${NC}"
brew bundle --clean # Uses HOMEBREW_BUNDLE_FILE defined in ~/.zshenv

# 2. Run Version Manager Package Manifests
V_MANAGERS="$HOME/.config/scripts/version_managers"

for script in "$V_MANAGERS"/*.sh; do
  echo "${GREEN}Running $(basename "$script")...${NC}"
  zsh "$script"
done

# 3. MacOS Defaults
echo "${BLUE}Configuring MacOS settings...${NC}"

# https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
defaults write com.apple.dock expose-group-apps -bool true && killall Dock
# https://nikitabobko.github.io/AeroSpace/guide#a-note-on-displays-have-separate-spaces
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

echo "${GREEN}Configured!${NC}"

echo "${BLUE}Sync complete!${NC}"
