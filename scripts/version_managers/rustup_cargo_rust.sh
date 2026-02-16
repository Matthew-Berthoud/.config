if ! command -v cargo &> /dev/null; then
    echo "Rust/Cargo not found. Please install via rustup."
    return 1
fi

packages=(
    "tree-sitter-cli"
    "weathr"
)

for pkg in $packages; do
    if ! cargo install --list | grep -q "^$pkg "; then
        echo "Installing cargo package: $pkg"
        if [ "$pkg" = "tree-sitter-cli" ]; then
            cargo install --locked tree-sitter-cli
        else
            cargo install "$pkg"
        fi
    fi
done
