#!/bin/bash
#
# Post-install script: Set Zed as the default EDITOR
# Updates ~/.config/uwsm/default and bash environment
#

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setting Zed as Default Editor"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Update uwsm config (main EDITOR setting)
UWSM_CONFIG="$HOME/.config/uwsm/default"

if [ -f "$UWSM_CONFIG" ]; then
    echo "📝 Updating $UWSM_CONFIG..."

    # Backup original
    cp "$UWSM_CONFIG" "$UWSM_CONFIG.backup"

    # Replace nvim with zed
    sed -i 's/^export EDITOR=nvim/export EDITOR=zed/' "$UWSM_CONFIG"

    # Also handle if someone changed it to something else, add if not present
    if ! grep -q "^export EDITOR=" "$UWSM_CONFIG"; then
        echo "" >> "$UWSM_CONFIG"
        echo "# Use zed as default editor" >> "$UWSM_CONFIG"
        echo "export EDITOR=zed" >> "$UWSM_CONFIG"
    fi

    echo "  ✓ Updated EDITOR to zed"
    echo "  Backup saved: $UWSM_CONFIG.backup"
else
    echo "⚠️  Warning: $UWSM_CONFIG not found"
    echo "  Creating it now..."
    mkdir -p "$(dirname "$UWSM_CONFIG")"
    cat > "$UWSM_CONFIG" << 'EOF'
# Changes require a restart to take effect.

# Install other terminals via Install > Terminal
export TERMINAL=xdg-terminal-exec

# Use zed as default editor
export EDITOR=zed

# Use a custom directory for screenshots (remember to make the directory!)
# export OMARCHY_SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Use a custom directory for screenrecordings (remember to make the directory!)
# export OMARCHY_SCREENRECORD_DIR="$HOME/Videos/Screencasts"
EOF
    echo "  ✓ Created $UWSM_CONFIG with EDITOR=zed"
fi

# Update current shell session
echo
echo "📝 Updating current shell environment..."
export EDITOR=zed
echo "  ✓ EDITOR set to zed for current session"

# Add to bashrc if needed (for terminal sessions)
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "export EDITOR=zed" "$HOME/.bashrc"; then
        echo
        read -p "Add 'export EDITOR=zed' to ~/.bashrc? (Y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            echo "" >> "$HOME/.bashrc"
            echo "# Set Zed as default editor" >> "$HOME/.bashrc"
            echo "export EDITOR=zed" >> "$HOME/.bashrc"
            echo "  ✓ Added to ~/.bashrc"
        fi
    else
        echo "  ✓ ~/.bashrc already contains EDITOR setting"
    fi
fi

echo
echo "✓ Default editor updated!"
echo "  ⚠️  Note: Restart your session for changes to take full effect"
echo "  Or run: export EDITOR=zed"
