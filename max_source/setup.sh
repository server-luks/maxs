#!/bin/bash

set -e

LOCAL_BIN="$HOME/.local/bin"
LOCAL_LIB="$HOME/.local/lib/max"
REPO_RAW_BASE="https://raw.githubusercontent.com/server-luks/maxs/main"

echo "Updating package lists..."
if command -v apt >/dev/null 2>&1; then
    sudo apt update
    echo "Installing required packages: python3, git, curl, python3-pip"
    sudo apt install -y python3 git curl python3-pip
elif command -v pkg >/dev/null 2>&1; then
    # Termux package manager
    pkg update -y
    pkg install -y python git curl
else
    echo "Warning: Could not detect package manager. Please ensure python3, git, curl, and pip are installed."
fi

echo "Installing Python packages..."
pip3 install --upgrade pip
pip3 install rich

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

# Detect shell and corresponding rc file
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

# Add ~/.local/bin to PATH if not already present
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo "Added ~/.local/bin to PATH in $SHELL_RC"
else
    echo "~/.local/bin is already in your PATH"
fi

# Source shell config file to update PATH now
if [ -f "$SHELL_RC" ]; then
    echo "Sourcing $SHELL_RC to update PATH for current session..."
    # shellcheck source=/dev/null
    source "$SHELL_RC"
fi

echo "✅ Max installed successfully!"
echo "You can now run it by typing: max"
echo "If 'max' command not found, please restart your terminal."
