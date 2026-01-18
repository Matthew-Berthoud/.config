CONFIG="$HOME/.config"

ln -sf "$CONFIG/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$CONFIG/zsh/.zshenv" "$HOME/.zshenv"
ln -sf "$CONFIG/zsh/.zprofile" "$HOME/.zprofile"
ln -sf "$CONFIG/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$CONFIG/git/.gitconfig-work" "$HOME/.gitconfig-work"

brew bundle --clean

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

nvm i --lts
nvm u --lts

npm i -g pyright
