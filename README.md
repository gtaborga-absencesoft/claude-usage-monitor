# Claude Usage Monitor

A terminal monitoring tool for tracking Claude usage limits, inspired by macmon.
**Matches the exact metrics from claude.ai/settings/usage**

## Overview

`claude-usage` is a lightweight, portable command-line tool that displays your Claude usage statistics with colorful progress bars directly in your terminal. It tracks the three usage metrics shown on the official Claude settings page.

**Features:**
- 🎨 Color-coded progress bars (green → yellow → red)
- 📊 Track all three usage metrics from claude.ai/settings/usage
- 🦊 **NEW:** Firefox by default - uses dedicated profile, won't interfere with your browsers!
- 🤖 Automatic extraction using browser automation (Firefox or Chrome)
- 💾 Local storage (no external dependencies)
- 🚀 Zero-dependency Python 3 script (Playwright optional for auto mode)
- 📦 Portable installer for easy sharing

---

## Usage Metrics Tracked

The tool tracks the three metrics exactly as shown on **claude.ai/settings/usage**:

1. **Current Session** - Usage in your current chat session (resets frequently)
2. **Weekly Limits (All Models)** - Combined usage across all Claude models
3. **Weekly Limits (Opus Only)** - Usage specifically for Claude Opus

---

## Quick Start

### Installation

#### Method 1: Run the Installer (Recommended for Sharing)

```bash
# If you have the installer script
bash install-claude-usage.sh

# Or download and run in one command (when hosted)
curl -sSL https://your-url.com/install-claude-usage.sh | bash
```

#### Method 2: Manual Installation

```bash
# Create directory
mkdir -p ~/.local/bin

# Copy the claude-usage script to ~/.local/bin
cp claude-usage ~/.local/bin/

# Make executable
chmod +x ~/.local/bin/claude-usage

# Add to PATH (for zsh)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# Reload shell or run
export PATH="$HOME/.local/bin:$PATH"
```

### First Use

**One-Time Setup (Recommended):**
```bash
# 1. Install Playwright and Firefox
pip install playwright
playwright install firefox

# 2. Set up Firefox profile (one-time login)
claude-usage setup-firefox
# Firefox will open - log in to Claude, then close the browser

# 3. That's it! From now on, just run:
claude-usage
# Starts continuous monitoring with auto-refresh every 5 minutes!
```

**Why Firefox?** Uses a dedicated profile that won't interfere with any of your browsers!

**Alternative: Manual Entry**
If you prefer not to use browser automation:
```bash
# Visit https://claude.ai/settings/usage
# Then manually enter your data:
claude-usage manual
```

---

## Usage

### Default Mode (Continuous Monitoring)

Simply run the command to start continuous monitoring:

```bash
claude-usage
```

This command will:
1. Automatically extract fresh usage data from claude.ai (headless Firefox)
2. Display your dashboard with colorful progress bars
3. Show countdown timer until next refresh
4. Update every 5 minutes automatically

**That's it!** Just `claude-usage` - continuous monitoring by default. Press Ctrl+C to stop.

### One-Time Check

Extract usage once and display, then exit (no continuous monitoring):

```bash
claude-usage --once
```

This is useful when you just want a quick check without the continuous monitoring loop.

### View Dashboard Only

Display cached usage statistics without extracting new data:

```bash
claude-usage view
```

### Manual Entry Mode

Interactively enter your usage information manually:

```bash
claude-usage manual
```

**You'll be prompted for:**
- **Plan type**: Pro, Free, or Enterprise
- **Current Session**: Usage percentage and reset time
- **Weekly Limits (All Models)**: Usage percentage and reset time
- **Weekly Limits (Opus Only)**: Usage percentage and reset time

**Example inputs:**
```
Plan (Pro/Free/Enterprise) [Pro]: Pro
Current Session:
Usage percentage [0]: 33
Resets in (e.g., '2 hr 5 min') []: 2 hr 5 min

Weekly Limits (All Models):
Usage percentage [0]: 84
Resets in (e.g., '16 hr 5 min') []: 16 hr 5 min

Weekly Limits (Opus Only):
Usage percentage [0]: 0
Resets in (e.g., '16 hr 5 min') []: 16 hr 5 min
```

### Advanced: Visible Browser Mode

If you want to see the browser during extraction (useful for debugging):

```bash
claude-usage auto           # Firefox with visible browser
claude-usage auto chrome    # Chrome with visible browser (close Chrome first)
```

These commands perform a one-time extraction with a visible browser window.

**How Automatic Extraction Works:**
1. Launches Firefox in headless mode with dedicated profile
2. Navigates to claude.ai/settings/usage
3. Extracts all three metrics automatically
4. Saves data and displays your dashboard
5. Your regular browsers are never touched!

**Why Firefox with dedicated profile:**
- ✓ Won't interfere with any of your browsers!
- ✓ Uses dedicated profile at `~/.config/claude-usage/firefox-profile`
- ✓ Login persists between runs
- ✓ No "browser already running" errors
- ✓ Completely isolated from your regular Firefox/Chrome

### Show Help

Display help information:

```bash
claude-usage --help
```

---

## Example Output

```
╔═══════════════════════════════════════════════════════════════╗
║                 Claude Usage Monitor                          ║
╚═══════════════════════════════════════════════════════════════╝

Last updated: 2025-10-22 14:30:00

Plan: Pro

Current Session:
  █████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░ 33%
  Resets in: 2 hr 5 min

Weekly Limits (All Models):
  █████████████████████████████████░░░░░░░ 84%
  Resets in: 16 hr 5 min

Weekly Limits (Opus Only):
  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 0%
  Resets in: 16 hr 5 min

─────────────────────────────────────────────────────────────────

Refresh: claude-usage (auto-extracts) | Manual: claude-usage manual
Help: claude-usage --help
```

---

## Features

### Color-Coded Progress Bars

Visual indicators show your usage status at a glance:

- 🟢 **Green** (0-74% usage) - Safe zone
- 🟡 **Yellow** (75-89% usage) - Approaching limit
- 🔴 **Red** (90-100% usage) - Near or at limit

### Persistent Local Storage

Data is saved locally at:
```
~/.config/claude-usage/usage.json
```

### Last Updated Timestamp

Always know when you last updated your usage data.

---

## Configuration

### Config File Location

```
~/.config/claude-usage/usage.json
```

### Example Configuration

```json
{
  "plan": "Pro",
  "last_updated": "2025-10-22T14:30:00.123456",
  "current_session": {
    "used_percent": 33,
    "reset_time": "2 hr 5 min"
  },
  "weekly_all_models": {
    "used_percent": 84,
    "reset_time": "16 hr 5 min"
  },
  "weekly_opus": {
    "used_percent": 0,
    "reset_time": "16 hr 5 min"
  }
}
```

### Manual Configuration

You can also edit the JSON file directly:

```bash
# Open in your editor
nano ~/.config/claude-usage/usage.json
```

---

## Sharing with Others

### Share the Installer Script

The portable installer script (`install-claude-usage.sh`) is completely self-contained and includes the entire claude-usage tool.

**To share:**

1. **Send the file directly**:
   ```bash
   # User runs:
   bash install-claude-usage.sh
   ```

2. **Host it online** (GitHub, website, etc.):
   ```bash
   # User runs:
   curl -sSL https://your-url.com/install-claude-usage.sh | bash
   ```

3. **Share via Git**:
   ```bash
   git clone your-repo
   cd your-repo
   bash install-claude-usage.sh
   ```

### What the Installer Does

1. ✓ Checks for Python 3
2. ✓ Creates `~/.local/bin` if needed
3. ✓ Installs the `claude-usage` script
4. ✓ Makes it executable
5. ✓ Adds `~/.local/bin` to PATH (if needed)
6. ✓ Provides instructions for immediate use

---

## Workflow

### Regular Monitoring

**Continuous Monitoring (Default):**
```bash
# Start continuous monitoring - updates every 5 minutes
claude-usage
```

The tool automatically:
1. Extracts fresh data from claude.ai (headless)
2. Displays your dashboard with progress bars
3. Shows countdown timer until next refresh
4. Updates continuously every 5 minutes
5. Press Ctrl+C to stop monitoring

**Quick Check:**
```bash
# One-time check (extract once and exit)
claude-usage --once
```

**View Cached Data:**
```bash
# Display dashboard without extracting new data
claude-usage view
```

**Manual Entry (if you prefer):**
```bash
# 1. Check actual usage on Claude website
open https://claude.ai/settings/usage

# 2. Enter data manually
claude-usage manual
```

### Understanding the Metrics

**Current Session:**
- Resets frequently (every few hours)
- Tracks usage in your current active session
- Helps pace your conversation

**Weekly Limits (All Models):**
- Resets weekly
- Combines usage from all Claude models (Sonnet, Haiku, etc.)
- Your main usage limit to watch

**Weekly Limits (Opus Only):**
- Resets weekly (same as all models)
- Separate limit just for Claude Opus
- Often shows 0% if you haven't used Opus

### How Often to Monitor

With continuous monitoring as the default, you can:

- **Start at beginning of work day**: Run `claude-usage` and let it monitor continuously
- **Quick checks**: Use `claude-usage --once` for a one-time status update
- **Before important work**: Quick check to ensure you have capacity
- **Heavy usage periods**: Keep monitoring running to stay aware of limits

The continuous monitoring mode automatically refreshes every 5 minutes, so you're always up to date!

---

## Troubleshooting

### Command not found

If you get "command not found", ensure `~/.local/bin` is in your PATH:

```bash
# Add to PATH for current session
export PATH="$HOME/.local/bin:$PATH"

# Or restart your terminal to load the updated shell config
```

### Run with full path

You can always run with the full path:

```bash
~/.local/bin/claude-usage
```

### Python not found

Ensure Python 3 is installed:

```bash
# Check Python version
python3 --version

# Install Python 3 (macOS with Homebrew)
brew install python3

# Install Python 3 (Ubuntu/Debian)
sudo apt install python3
```

### Reset configuration

To start fresh, delete the config file:

```bash
rm ~/.config/claude-usage/usage.json
```

Then run `claude-usage` (auto-extract) or `claude-usage manual` to reconfigure.

### Permissions issue

If you can't write to `~/.local/bin`:

```bash
# Ensure directory exists and has correct permissions
mkdir -p ~/.local/bin
chmod 755 ~/.local/bin
```

---

## Technical Details

- **Language**: Python 3 (standard library only)
- **Dependencies**: None (uses only Python standard library)
- **Platform**: macOS, Linux, WSL (any Unix-like system with Python 3)
- **Config location**: `~/.config/claude-usage/`
- **Executable location**: `~/.local/bin/claude-usage`
- **Size**: ~10KB (single file)

### Why It's Portable

- ✓ Single Python file (no package dependencies)
- ✓ Uses only standard library (json, os, sys, datetime, pathlib)
- ✓ Self-contained installer
- ✓ Works on any system with Python 3
- ✓ No compilation needed
- ✓ Easy to audit (readable Python code)

---

## Files

### Project Files

```
~/Documents/claude/
├── claude-usage-monitor.md       # This documentation
└── install-claude-usage.sh       # Portable installer script

~/.local/bin/
└── claude-usage                  # The main executable

~/.config/claude-usage/
└── usage.json                    # Your usage data (created on first run)
```

### Installer Script

**Location**: `~/Documents/claude/install-claude-usage.sh`

The installer is a self-contained bash script that includes the entire Python tool embedded within it. This makes it perfect for sharing.

---

## Privacy & Security

- **No external connections**: Tool operates entirely offline
- **Local storage only**: All data stored on your machine
- **No tracking**: No analytics or telemetry
- **Open source**: Readable Python code, easy to audit
- **No API keys required**: Manual data entry only
- **No passwords**: Doesn't store any credentials

---

## Comparison with Claude Web Interface

| Feature | claude-usage | Claude Web UI |
|---------|--------------|---------------|
| **Speed** | Instant | Requires browser |
| **Offline** | ✓ | ✗ |
| **Automation** | ✓ (scriptable) | ✗ |
| **Real-time** | Manual update | Real-time |
| **Historical data** | Not yet | ✓ |
| **Accuracy** | User-entered | Authoritative |

---

## Understanding Claude Usage Limits

### Current Session
- **What it is**: Usage in your active chat session
- **Reset frequency**: Every few hours
- **Purpose**: Rate limiting for active conversations
- **Tip**: If you hit this limit, wait for the reset

### Weekly Limits (All Models)
- **What it is**: Combined usage across all Claude models
- **Reset frequency**: Weekly (typically Sunday/Monday)
- **Models included**: Sonnet, Haiku, etc.
- **Purpose**: Your main weekly usage allocation
- **Tip**: This is the key metric to monitor

### Weekly Limits (Opus Only)
- **What it is**: Separate limit for Claude Opus
- **Reset frequency**: Weekly (same as all models)
- **Purpose**: Premium model has its own allocation
- **Tip**: Only counts when you explicitly use Opus

---

## Future Enhancements

Possible improvements:

- [x] Auto-refresh/watch mode (✓ implemented in v4.0)
- [ ] API integration for automatic updates (when available)
- [ ] Export usage history to CSV
- [ ] Weekly/monthly usage trends and graphs
- [ ] Desktop notifications when approaching limits
- [ ] Multiple profile support (personal, work, etc.)
- [ ] Integration with Claude CLI
- [ ] Widget mode for macOS/Linux desktops
- [ ] Percentage change tracking

---

## FAQ

**Q: Does this tool connect to Claude's servers?**
A: In automatic mode, yes - it opens Firefox in a dedicated profile and extracts data from claude.ai/settings/usage. In manual mode, no - you enter data yourself. All data stays local.

**Q: Why Firefox instead of Chrome?**
A: Firefox uses a dedicated profile at `~/.config/claude-usage/firefox-profile` that's completely isolated from your regular browsers. This means:
- Won't interfere with Chrome, Safari, or your regular Firefox
- No "browser already running" errors
- Your browsing sessions stay separate
- Can run while you work in any other browser

You can still use Chrome with `claude-usage auto chrome`, but you'll need to close Chrome first.

**Q: Do I need to close my browser to use automatic extraction?**
A: With Firefox (default): No! It uses a dedicated profile that's completely separate from any browsers you have open.
With Chrome: Yes, you need to close all Chrome windows first.

**Q: How do I set up Firefox for the first time?**
A: Just run `claude-usage setup-firefox` - it will open Firefox with the dedicated profile, you log in to Claude once, then close the browser. After that, simply run `claude-usage` anytime to auto-extract and display!

**Q: Will this work on Windows?**
A: It works on WSL (Windows Subsystem for Linux). Native Windows support could be added.

**Q: Can I track multiple Claude accounts?**
A: Not yet, but this feature could be added.

**Q: How often should I check my usage?**
A: The default `claude-usage` command runs continuous monitoring that automatically refreshes every 5 minutes. Just start it at the beginning of your work session and let it run. For quick one-time checks, use `claude-usage --once`.

**Q: Is this official?**
A: No, this is a community tool. Visit https://claude.ai/settings/usage for official data.

**Q: Can I contribute?**
A: Yes! The tool is designed to be hackable. Feel free to modify and improve it.

**Q: What if the percentages shown on claude.ai change?**
A: The continuous monitoring mode refreshes every 5 minutes automatically. If you want to force an immediate refresh, press Ctrl+C and run `claude-usage` again, or use `claude-usage --once` for a quick one-time update.

---

## Credits

- **Inspired by**: macmon (macOS system monitor)
- **Created**: 2025-10-22
- **License**: Free to use and modify
- **Author**: Community tool for Claude users

---

## Support

For issues or questions:

1. Check this documentation
2. Verify your Python 3 installation
3. Check file permissions
4. Review the config JSON file
5. Try resetting configuration

---

## Quick Reference

```bash
# Default: Continuous monitoring (auto-refresh every 5 min)
claude-usage

# One-time check (extract once and exit)
claude-usage --once

# View dashboard only (no extraction)
claude-usage view

# Manual entry mode
claude-usage manual

# Setup Firefox profile (one-time)
claude-usage setup-firefox

# Advanced: Auto-extract with visible browser (one-time)
claude-usage auto              # Firefox visible
claude-usage auto chrome       # Chrome visible (close Chrome first)

# Help
claude-usage --help

# Install Playwright with Firefox
pip install playwright && playwright install firefox

# Optional: Install Chromium for Chrome support
playwright install chromium

# Config file
~/.config/claude-usage/usage.json

# Firefox profile location
~/.config/claude-usage/firefox-profile

# Install for others
bash install-claude-usage.sh

# Manual edit config
nano ~/.config/claude-usage/usage.json

# Reset config
rm ~/.config/claude-usage/usage.json
```

---

**Last Updated**: 2025-10-23
**Version**: 4.0 (Continuous monitoring by default!)
**Documentation**: `~/Documents/claude/claude-usage-monitor.md`
**Installer**: `~/Documents/claude/install-claude-usage-complete.sh`
**Playwright Helper**: `~/Documents/claude/install-playwright.sh`
