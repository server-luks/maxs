
#!/bin/bash

echo "📦 Installing Max Language..."

# Directories
LOCAL_BIN="$HOME/.local/bin"
LOCAL_LIB="$HOME/.local/lib/max"

mkdir -p "$LOCAL_BIN"
mkdir -p "$LOCAL_LIB"

# Base URL for raw files on GitHub (adjust if needed)
BASE_URL="https://raw.githubusercontent.com/server-luks/maxis/main/max_source"

# Download files
curl -fsSL "$BASE_URL/mox" -o "$LOCAL_BIN/mox" || { echo "Failed to download mox"; exit 1; }
curl -fsSL "$BASE_URL/core.py" -o "$LOCAL_LIB/core.py" || { echo "Failed to download core.py"; exit 1; }
curl -fsSL "$BASE_URL/version.txt" -o "$LOCAL_LIB/version.txt" || { echo "Failed to download version.txt"; exit 1; }

# Make executable
chmod +x "$LOCAL_BIN/mox"

# Add to PATH if needed
SHELL_RC="$HOME/.bashrc"
[ -n "$ZSH_VERSION" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
  # shellcheck source=/dev/null
  source "$SHELL_RC"
fi

echo "✅ Max installed successfully! You can run it by typing: mox"
echo "To update later, run: mox update"
