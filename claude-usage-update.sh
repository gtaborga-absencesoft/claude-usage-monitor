#!/usr/bin/env bash
#
# Claude Usage Monitor - Update Script
#
# This script updates an existing claude-usage installation with the latest version
# including the new Rich library dependency for smooth in-place display updates.
#
# Usage:
#   bash claude-usage-update.sh
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="claude-usage"
INSTALL_PATH="$INSTALL_DIR/$SCRIPT_NAME"
# Get the directory where this update script is located
UPDATER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SCRIPT="$UPDATER_DIR/claude-usage"

echo -e "${BOLD}${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         Claude Usage Monitor - Update Script                 ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}\n"

echo -e "${DIM}This script will update your existing claude-usage installation${RESET}"
echo -e "${DIM}with the latest version featuring smooth in-place display updates.${RESET}\n"

# =============================================================================
# Step 1: Check if claude-usage is installed
# =============================================================================

echo -e "${BOLD}${BLUE}[1/3] Checking existing installation...${RESET}\n"

if [ ! -f "$INSTALL_PATH" ]; then
    echo -e "${RED}✗ claude-usage not found at ${INSTALL_PATH}${RESET}"
    echo -e "\nIt looks like claude-usage is not installed yet."
    echo -e "Please use the installer instead:"
    echo -e "  ${BOLD}bash install-claude-usage.sh${RESET}\n"
    exit 1
fi

echo -e "${GREEN}✓ Found existing installation${RESET} ${DIM}(${INSTALL_PATH})${RESET}"

# =============================================================================
# Step 2: Install/verify dependencies
# =============================================================================

echo -e "\n${BOLD}${BLUE}[2/3] Installing dependencies...${RESET}\n"

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python 3 is required but not found${RESET}"
    exit 1
fi

echo -e "${GREEN}✓ Python 3 found${RESET}"

# Install Rich library (required for new version)
if python3 -c "import rich" 2>/dev/null; then
    echo -e "${GREEN}✓ Rich library already installed${RESET}"
else
    echo -e "${DIM}Installing Rich library...${RESET}"

    if pip3 install rich --quiet 2>&1 | grep -q "Successfully installed\|Requirement already satisfied"; then
        echo -e "${GREEN}✓ Rich library installed${RESET}"
    else
        echo -e "${RED}✗ Failed to install Rich library${RESET}"
        echo -e "\nPlease install manually:"
        echo -e "  ${BOLD}pip3 install rich${RESET}"
        exit 1
    fi
fi

# Check if Playwright is installed (optional dependency)
if python3 -c "import playwright" 2>/dev/null; then
    echo -e "${GREEN}✓ Playwright already installed${RESET}"
else
    echo -e "${YELLOW}⚠ Playwright not installed (needed for auto-extraction)${RESET}"
    echo -e "${DIM}  Install with: pip3 install playwright && playwright install firefox${RESET}"
fi

# =============================================================================
# Step 3: Update claude-usage script
# =============================================================================

echo -e "\n${BOLD}${BLUE}[3/3] Updating claude-usage script...${RESET}\n"

# Check if source script exists
if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo -e "${RED}✗ Source script not found at ${SOURCE_SCRIPT}${RESET}"
    echo -e "\nPlease ensure you're running this update script from the correct directory"
    echo -e "The claude-usage script should be in the same directory as this updater"
    exit 1
fi

# Backup existing script
BACKUP_PATH="${INSTALL_PATH}.backup"
cp "$INSTALL_PATH" "$BACKUP_PATH"
echo -e "${DIM}Created backup: ${BACKUP_PATH}${RESET}"

# Copy new script
cp "$SOURCE_SCRIPT" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

echo -e "${GREEN}✓ claude-usage updated${RESET} ${DIM}(${INSTALL_PATH})${RESET}"

# =============================================================================
# Update Complete
# =============================================================================

echo -e "\n${BOLD}${GREEN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                   Update Complete! 🎉                         ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${RESET}\n"

echo -e "${BOLD}What's New:${RESET}\n"

echo -e "  ${GREEN}✓${RESET} Smooth in-place display updates (no more scrolling!)"
echo -e "  ${GREEN}✓${RESET} Rich library integration for enhanced terminal UI"
echo -e "  ${GREEN}✓${RESET} Enhanced countdown timer with spinner animation"
echo -e "  ${GREEN}✓${RESET} Proper ANSI code rendering with Text.from_ansi()\n"

echo -e "${BOLD}Quick Test:${RESET}\n"

echo -e "  Try the updated monitor:"
echo -e "  ${DIM}\$${RESET} ${BOLD}${CYAN}claude-usage${RESET}\n"

echo -e "${DIM}Your previous configuration and Firefox profile remain unchanged.${RESET}"
echo -e "${DIM}A backup of your old script is saved at: ${BACKUP_PATH}${RESET}\n"

echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${DIM}For issues or questions, see: README.md in the repository${RESET}\n"
