# Homebrew installs bob read-only and bob copies that mode to its nvim proxy,
# so it can't overwrite the proxy after a bob upgrade. Removing it lets bob recreate it.
rm -f "$HOME/Library/Application Support/bob/nvim-bin/nvim"
bob use nightly
