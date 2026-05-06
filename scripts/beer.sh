#!/usr/bin/env zsh

# beer.sh - Homebrew wrapper to automate Brewfile management
# Usage: beer [brew-install-args]

BREWFILE="${HOMEBREW_BUNDLE_FILE:-$HOME/.config/Brewfile}"

# Run brew install
if ! brew install "$@"; then
    echo "beer: brew install failed. Brewfile was not updated."
    exit 1
fi

# Detect if we are installing a cask or a formula
is_cask=false
packages=()

for arg in "$@"; do
    case $arg in
        --cask) is_cask=true ;;
        --formula) is_cask=false ;;
        -*) ;; # Ignore other flags
        *) packages+=("$arg") ;;
    esac
done

# Update Brewfile
for pkg in "${packages[@]}"; do
    if [[ "$is_cask" == true ]]; then
        line="cask \"$pkg\""
    else
        # Default to brew if not specified as cask
        line="brew \"$pkg\""
    fi

    # Check if line already exists (ignoring whitespace)
    if ! grep -qxE "[[:space:]]*${line}[[:space:]]*" "$BREWFILE"; then
        echo "$line" >> "$BREWFILE"
        echo "beer: Added '$line' to $BREWFILE"
    fi
done

# Sort and clean Brewfile
# 1. Remove empty lines
# 2. Sort alphabetically
# 3. Remove duplicate lines
# 4. Save back to BREWFILE
tmp_file=$(mktemp)
sed '/^[[:space:]]*$/d' "$BREWFILE" | sort | uniq > "$tmp_file"
mv "$tmp_file" "$BREWFILE"

echo "beer: Brewfile updated and sorted."
