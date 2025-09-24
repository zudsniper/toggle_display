#!/bin/bash
# Installer for blackout
# Based on killport installer format

set -e

# Configuration
REPO_URL="https://github.com/zudsniper/blackout"
SCRIPT_NAME="blackout"
INSTALL_DIR="$HOME/scripts/toggle_display"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"
SYMLINK_PATH="$HOME/.local/bin/$SCRIPT_NAME"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Blackout Installer v1.0      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════╝${NC}"
echo

# Check Ubuntu version
if ! lsb_release -d | grep -q "Ubuntu"; then    echo -e "${YELLOW}Warning: This script is designed for Ubuntu. Detected: $(lsb_release -d | cut -f2)${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create directories
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p "$INSTALL_DIR"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/state/$SCRIPT_NAME"

# Check for required dependencies
echo -e "${YELLOW}Checking dependencies...${NC}"
MISSING_DEPS=()

# Check display server dependencies
if [ -n "${DISPLAY:-}" ]; then
    # X11 environment
    if ! command -v xrandr &>/dev/null; then
        MISSING_DEPS+=("x11-xserver-utils")
    fi
elif [ -n "${WAYLAND_DISPLAY:-}" ]; then    # Wayland environment
    if ! command -v wlr-randr &>/dev/null && ! command -v ddcutil &>/dev/null; then
        echo -e "${YELLOW}Wayland detected. Recommend installing wlr-randr or ddcutil${NC}"
        MISSING_DEPS+=("ddcutil")
    fi
fi

# Install missing dependencies
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "${YELLOW}Installing missing dependencies: ${MISSING_DEPS[*]}${NC}"
    sudo apt update
    sudo apt install -y "${MISSING_DEPS[@]}"
fi

# Download/copy the main script
if [ -f "blackout" ]; then
    # Local installation
    echo -e "${YELLOW}Installing from local file...${NC}"
    cp blackout "$SCRIPT_PATH"
else
    # Download from repository
    echo -e "${YELLOW}Downloading from repository...${NC}"
    if command -v curl &>/dev/null; then
        curl -sSL "$REPO_URL/raw/main/blackout" -o "$SCRIPT_PATH"
    elif command -v wget &>/dev/null; then        wget -q "$REPO_URL/raw/main/blackout" -O "$SCRIPT_PATH"
    else
        echo -e "${RED}Error: Neither curl nor wget found${NC}"
        exit 1
    fi
fi

# Make executable
chmod +x "$SCRIPT_PATH"

# Create symlink for PATH access
echo -e "${YELLOW}Creating symlink...${NC}"
ln -sf "$SCRIPT_PATH" "$SYMLINK_PATH"

# Add ~/.local/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "${YELLOW}Adding ~/.local/bin to PATH...${NC}"
    
    # Detect shell
    if [ -n "$BASH_VERSION" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        SHELL_RC="$HOME/.zshrc"
    else
        SHELL_RC="$HOME/.profile"
    fi    
    echo '' >> "$SHELL_RC"
    echo '# Added by blackout installer' >> "$SHELL_RC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    
    echo -e "${YELLOW}Please run: ${GREEN}source $SHELL_RC${NC}"
    echo -e "${YELLOW}Or start a new terminal session${NC}"
fi

# Additional setup for Wayland users
if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    echo
    echo -e "${BLUE}Wayland Setup Notes:${NC}"
    echo "1. For better Wayland support, consider installing wlr-randr:"
    echo "   ${GREEN}sudo apt install wlr-randr${NC} (if available)"
    echo
    echo "2. For hardware-level control, ddcutil is recommended:"
    echo "   ${GREEN}sudo apt install ddcutil${NC}"
    echo "   ${GREEN}sudo usermod -a -G i2c $USER${NC}"
    echo "   Then logout and login again"
fi

# Test installation
echo
echo -e "${YELLOW}Testing installation...${NC}"if "$SCRIPT_PATH" version &>/dev/null; then
    echo -e "${GREEN}✓ Installation successful!${NC}"
else
    echo -e "${RED}✗ Installation test failed${NC}"
    exit 1
fi

# Success message
echo
echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Installation Complete! 🎉      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
echo
echo "Usage:"
echo "  ${BLUE}blackout${NC}         - Toggle display blackout"
echo "  ${BLUE}blackout on${NC}      - Enable blackout"
echo "  ${BLUE}blackout off${NC}     - Disable blackout"
echo "  ${BLUE}blackout status${NC}  - Check current state"
echo "  ${BLUE}blackout help${NC}    - Show help"
echo
echo "Script location: ${GREEN}$SCRIPT_PATH${NC}"
echo "Repository: ${BLUE}$REPO_URL${NC}"