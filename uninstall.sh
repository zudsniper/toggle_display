#!/bin/bash
# Uninstaller for blackout

set -e

SCRIPT_NAME="blackout"
INSTALL_DIR="$HOME/scripts/toggle_display"
SYMLINK_PATH="$HOME/.local/bin/$SCRIPT_NAME"
STATE_DIR="$HOME/.local/state/$SCRIPT_NAME"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Uninstalling blackout...${NC}"

# Restore display if currently blacked out
if [ -f "$STATE_DIR/display_state" ] && [ "$(cat "$STATE_DIR/display_state")" = "blackout" ]; then
    echo -e "${YELLOW}Restoring display before uninstall...${NC}"
    "$INSTALL_DIR/$SCRIPT_NAME" off 2>/dev/null || true
fi

# Remove files
echo "Removing files..."
[ -L "$SYMLINK_PATH" ] && rm -f "$SYMLINK_PATH"
[ -f "$INSTALL_DIR/$SCRIPT_NAME" ] && rm -f "$INSTALL_DIR/$SCRIPT_NAME"

# Remove state directory
if [ -d "$STATE_DIR" ]; then
    echo "Removing state directory..."
    rm -rf "$STATE_DIR"
fi

# Clean up empty directories
rmdir "$INSTALL_DIR" 2>/dev/null || true
rmdir "$HOME/scripts" 2>/dev/null || true

echo -e "${GREEN}✓ Blackout uninstalled successfully${NC}"
echo
echo "Note: PATH modifications in shell RC files were not removed."
echo "Remove manually if desired from ~/.bashrc, ~/.zshrc, or ~/.profile"