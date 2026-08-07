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
# Uses HOMEBREW_BUNDLE_FILE defined in ~/.zshenv
brew bundle cleanup --force
brew trust nikitabobko/tap
brew bundle install

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

# Disable command space for Spotlight, since we use Raycast now.
# Must be XML: the old-style "{enabled = 0; ...}" syntax types every token as a
# string, which the hotkey system ignores, so the shortcut returns after reboot.
disable_hotkey() {
  local id="$1" modifier="$2"
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$id" "
    <dict>
      <key>enabled</key><false/>
      <key>value</key>
      <dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>32</integer>
          <integer>49</integer>
          <integer>$modifier</integer>
        </array>
      </dict>
    </dict>"
}

disable_hotkey 64 1048576 # Cmd+Space     -> Show Spotlight search
disable_hotkey 65 1572864 # Cmd+Opt+Space -> Show Finder search window

# Flush the cached prefs and reload the hotkey table so this applies now,
# rather than being overwritten from cache at the next logout.
killall cfprefsd
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

echo "${GREEN}Configured!${NC}"

echo "${BLUE}Sync complete!${NC}"
