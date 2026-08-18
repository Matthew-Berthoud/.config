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

# Install global packages in the global node version
nvm use "$NODE_VERSION"

# List of global packages to ensure are present
packages=(
  "@fsouza/prettierd"
  "@google/gemini-cli"
  "@tailwindcss/language-server@latest"
  "bash-language-server"
  "graphql-language-service-cli"
  "npm@latest"
  "oxfmt"
  "oxlint"
  "prettier"
  "pyright"
  "vscode-langservers-extracted"
)

for pkg in $packages; do
  # Strip only a trailing version tag. "${pkg%%@*}" would expand to the empty
  # string for scoped names like @fsouza/prettierd, so `npm list -g ""` always
  # succeeded and those packages were silently never installed.
  name="${pkg%@*}"
  [ -z "$name" ] && name="$pkg"
  if ! npm list -g --depth=0 "$name" &>/dev/null; then
    echo "Installing global npm package: $pkg"
    npm i -g "$pkg"
  fi
done
