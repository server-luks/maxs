#!/bin/bash

set -e

LOCAL_BIN="$HOME/.local/bin"
LOCAL_LIB="$HOME/.local/lib/max"
REPO_RAW_BASE="https://raw.githubusercontent.com/server-luks/maxs/main"

echo "Creating directories..."
mkdir -p "$LOCAL_BIN"
mkdir -p "$LOCAL_LIB"

echo "Downloading max launcher..."
curl -fsSL "$REPO_RAW_BASE/max_source/max" -o "$LOCAL_BIN/max"
chmod +x "$LOCAL_BIN/max"

echo "Downloading core.py..."
curl -fsSL "$REPO_RAW_BASE/lib/core.py" -o "$LOCAL_LIB/core.py"

echo "Downloading version.txt..."
curl -fsSL "$REPO_RAW_BASE/max_source/version.txt" -o "$LOCAL_LIB/version.txt"

# Add ~/.local/bin to PATH if not already present
SHELL_RC="$HOME/.bashrc"
[ -n "$ZSH_VERSION" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
  echo "Added ~/.local/bin to PATH in $SHELL_RC. Please restart your shell or run: source $SHELL_RC"
fi

echo "✅ Max installed successfully!"
echo "You can now run it by typing: max"
