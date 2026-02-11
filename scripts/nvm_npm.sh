if command -v nvm &> /dev/null; then
    echo "nvm is already installed"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
    source ~/.zshrc
fi

nvm install 24
nvm alias default 24
nvm use default

npm i -g npm@latest
npm i -g prettier
npm i -g pyright
npm i -g @fsouza/prettierd

npm i -g @google/gemini-cli
