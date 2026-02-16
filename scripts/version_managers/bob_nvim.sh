# Only update if we aren't on nightly or if we want to force an update
if ! nvim --version | grep -q "dev"; then
    echo "Switching to Neovim nightly..."
    yes | bob use nightly
fi
