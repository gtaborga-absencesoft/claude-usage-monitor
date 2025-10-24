#!/usr/bin/env bash
#
# Claude Usage Monitor - Complete Installation Script
#
# This script performs a full installation including:
# - Claude Usage script installation
# - Playwright and Firefox installation
# - Firefox profile setup (one-time login)
# - PATH configuration
#
# Installation:
#   bash install-claude-usage-complete.sh
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="claude-usage"
INSTALL_PATH="$INSTALL_DIR/$SCRIPT_NAME"
SOURCE_SCRIPT="$HOME/.local/bin/claude-usage"

echo -e "${BOLD}${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║    Claude Usage Monitor - Complete Setup v3.0                ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}\n"

echo -e "${DIM}This installer will set up claude-usage with headless auto-extraction${RESET}"
echo -e "${DIM}After setup, just run 'claude-usage' to extract + display in one command!${RESET}"
echo -e "${DIM}Estimated time: 2-3 minutes${RESET}\n"

# =============================================================================
# Step 1: Check Prerequisites
# =============================================================================

echo -e "${BOLD}${BLUE}[1/6] Checking prerequisites...${RESET}\n"

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python 3 is required but not found${RESET}"
    echo -e "\nPlease install Python 3:"
    echo -e "  ${BOLD}brew install python3${RESET}  # macOS"
    echo -e "  ${BOLD}sudo apt install python3${RESET}  # Ubuntu/Debian"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo -e "${GREEN}✓ Python 3 found${RESET} ${DIM}(${PYTHON_VERSION})${RESET}"

# Check for pip
if ! command -v pip3 &> /dev/null && ! python3 -m pip --version &> /dev/null; then
    echo -e "${RED}✗ pip is required but not found${RESET}"
    echo -e "\nPlease install pip:"
    echo -e "  ${BOLD}python3 -m ensurepip${RESET}"
    exit 1
fi

echo -e "${GREEN}✓ pip found${RESET}"

# =============================================================================
# Step 2: Install Claude Usage Script
# =============================================================================

echo -e "\n${BOLD}${BLUE}[2/6] Installing claude-usage script...${RESET}\n"

# Create installation directory
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
    echo -e "${DIM}Created directory: ${INSTALL_DIR}${RESET}"
fi

# Check if source script exists (already installed)
if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo -e "${RED}✗ Source script not found at ${SOURCE_SCRIPT}${RESET}"
    echo -e "\nPlease ensure claude-usage is already installed in ~/.local/bin/"
    exit 1
fi

# Copy script (overwrites if exists)
cp "$SOURCE_SCRIPT" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

echo -e "${GREEN}✓ claude-usage installed${RESET} ${DIM}(${INSTALL_PATH})${RESET}"

# =============================================================================
# Step 3: Configure PATH
# =============================================================================

echo -e "\n${BOLD}${BLUE}[3/6] Configuring PATH...${RESET}\n"

# Detect shell
SHELL_NAME=$(basename "$SHELL")
SHELL_RC=""

case "$SHELL_NAME" in
    bash)
        SHELL_RC="$HOME/.bashrc"
        ;;
    zsh)
        SHELL_RC="$HOME/.zshrc"
        ;;
    fish)
        SHELL_RC="$HOME/.config/fish/config.fish"
        ;;
    *)
        echo -e "${YELLOW}⚠ Unknown shell: $SHELL_NAME${RESET}"
        SHELL_RC="$HOME/.bashrc"
        ;;
esac

# Check if PATH already includes ~/.local/bin
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    echo -e "${GREEN}✓ PATH already configured${RESET}"
else
    # Add to shell config
    if [ -f "$SHELL_RC" ]; then
        echo "" >> "$SHELL_RC"
        echo "# Added by claude-usage installer" >> "$SHELL_RC"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
        echo -e "${GREEN}✓ Added to PATH${RESET} ${DIM}(${SHELL_RC})${RESET}"
        echo -e "${YELLOW}  Note: Restart your terminal or run: source ${SHELL_RC}${RESET}"
    else
        echo -e "${YELLOW}⚠ Could not update PATH automatically${RESET}"
        echo -e "  Please add manually: ${BOLD}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    fi
fi

# Export PATH for current session
export PATH="$HOME/.local/bin:$PATH"

# =============================================================================
# Step 4: Install Playwright
# =============================================================================

echo -e "\n${BOLD}${BLUE}[4/6] Installing Playwright...${RESET}\n"

# Check if Playwright is already installed
if python3 -c "import playwright" 2>/dev/null; then
    echo -e "${GREEN}✓ Playwright already installed${RESET}"
else
    echo -e "${DIM}Installing Playwright Python package...${RESET}"

    if pip3 install playwright --quiet 2>&1 | grep -q "Successfully installed\|Requirement already satisfied"; then
        echo -e "${GREEN}✓ Playwright Python package installed${RESET}"
    else
        echo -e "${RED}✗ Failed to install Playwright${RESET}"
        echo -e "\nPlease install manually:"
        echo -e "  ${BOLD}pip3 install playwright${RESET}"
        exit 1
    fi
fi

# =============================================================================
# Step 5: Install Firefox Browser
# =============================================================================

echo -e "\n${BOLD}${BLUE}[5/6] Installing Firefox browser for Playwright...${RESET}\n"

echo -e "${DIM}This may take a few minutes (downloading ~100MB)...${RESET}\n"

# Install Firefox
if python3 -m playwright install firefox 2>&1 | tee /tmp/playwright-install.log; then
    echo -e "\n${GREEN}✓ Firefox browser installed${RESET}"
else
    echo -e "\n${RED}✗ Failed to install Firefox browser${RESET}"
    echo -e "\nPlease install manually:"
    echo -e "  ${BOLD}python3 -m playwright install firefox${RESET}"
    exit 1
fi

# =============================================================================
# Step 6: Setup Firefox Profile (One-Time Login)
# =============================================================================

echo -e "\n${BOLD}${BLUE}[6/6] Setting up Firefox profile...${RESET}\n"

echo -e "${MAGENTA}${BOLD}IMPORTANT: One-time login required${RESET}"
echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

echo -e "In a moment, Firefox will open. Please:"
echo -e "  1. Log in to your Claude account"
echo -e "  2. Navigate to ${CYAN}https://claude.ai/settings/usage${RESET}"
echo -e "  3. Verify you can see your usage page"
echo -e "  4. ${BOLD}Close the Firefox window${RESET} when done\n"

echo -e "${DIM}After this one-time login:${RESET}"
echo -e "${DIM}  • Just run ${BOLD}claude-usage${RESET}${DIM} anytime - that's it!${RESET}"
echo -e "${DIM}  • Auto-extracts headlessly and displays your dashboard${RESET}"
echo -e "${DIM}  • Fast, seamless, one command${RESET}\n"

read -p "Press ENTER to open Firefox and log in... " -r
echo ""

# Run setup-firefox
if "$INSTALL_PATH" setup-firefox; then
    echo -e "\n${GREEN}✓ Firefox profile configured${RESET}"
else
    echo -e "\n${YELLOW}⚠ Firefox setup incomplete${RESET}"
    echo -e "  You can run it later: ${BOLD}claude-usage setup-firefox${RESET}"
fi

# =============================================================================
# Installation Complete
# =============================================================================

echo -e "\n${BOLD}${GREEN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                  Installation Complete! 🎉                    ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}\n"

echo -e "${BOLD}Quick Start:${RESET}\n"

echo -e "  ${BOLD}${CYAN}claude-usage${RESET}              Continuous monitoring (default, updates every 5min)"
echo -e "  ${BOLD}${CYAN}claude-usage --once${RESET}       One-time extract + display, then exit"
echo -e "  ${BOLD}${CYAN}claude-usage view${RESET}         Display cached data only"
echo -e "  ${BOLD}${CYAN}claude-usage manual${RESET}       Manual entry mode\n"

echo -e "${BOLD}Examples:${RESET}\n"

echo -e "  # Default: Continuous monitoring with countdown timer"
echo -e "  ${DIM}\$${RESET} claude-usage\n"

echo -e "  # One-time check (extract once and exit)"
echo -e "  ${DIM}\$${RESET} claude-usage --once\n"

echo -e "  # View cached data only"
echo -e "  ${DIM}\$${RESET} claude-usage view\n"

echo -e "  # Manual entry mode"
echo -e "  ${DIM}\$${RESET} claude-usage manual\n"

echo -e "${BOLD}Configuration:${RESET}\n"

echo -e "  Config file: ${DIM}~/.config/claude-usage/usage.json${RESET}"
echo -e "  Firefox profile: ${DIM}~/.config/claude-usage/firefox-profile${RESET}"
echo -e "  Script location: ${DIM}${INSTALL_PATH}${RESET}\n"

echo -e "${BOLD}Help:${RESET}\n"

echo -e "  ${DIM}\$${RESET} claude-usage --help\n"

# Check if PATH needs terminal restart
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "${YELLOW}${BOLD}⚠ IMPORTANT:${RESET} ${YELLOW}Restart your terminal or run:${RESET}"
    echo -e "  ${BOLD}source ${SHELL_RC}${RESET}\n"
fi

echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${DIM}For issues or questions, see: ~/Documents/claude/claude-usage-monitor.md${RESET}\n"
