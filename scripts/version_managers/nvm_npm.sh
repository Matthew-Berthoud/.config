# Ensure nvm is loaded
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v nvm &>/dev/null; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
  source "$NVM_DIR/nvm.sh"
fi

# Desired Node version
NODE_VERSION=24

if ! nvm ls "$NODE_VERSION" &>/dev/null; then
  nvm install "$NODE_VERSION"
  nvm alias default "$NODE_VERSION"
fi

# List of global packages to ensure are present
packages=(
  "npm@latest"
  "prettier"
  "pyright"
  "@fsouza/prettierd"
  "bash-language-server"
  "@google/gemini-cli"
)

for pkg in $packages; do
  if ! npm list -g "${pkg%%@*}" &>/dev/null; then
    echo "Installing global npm package: $pkg"
    npm i -g "$pkg"
  fi
done
