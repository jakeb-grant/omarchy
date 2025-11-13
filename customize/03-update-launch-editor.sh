#!/bin/bash
#
# Post-install script: Update omarchy-launch-editor to handle Zed
# Adds Zed to the GUI editor detection logic
#

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Updating omarchy-launch-editor"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

LAUNCH_EDITOR_SCRIPT="/usr/local/bin/omarchy-launch-editor"

# Check if the script exists
if [ ! -f "$LAUNCH_EDITOR_SCRIPT" ]; then
    echo "⚠️  Warning: $LAUNCH_EDITOR_SCRIPT not found"
    echo "  This script might be installed differently on your system"
    echo "  Checking alternative locations..."

    # Try to find it in PATH
    LAUNCH_EDITOR_SCRIPT=$(which omarchy-launch-editor 2>/dev/null || echo "")

    if [ -z "$LAUNCH_EDITOR_SCRIPT" ]; then
        echo "  ✗ Could not find omarchy-launch-editor"
        echo "  Skipping this modification"
        exit 0
    else
        echo "  ✓ Found at: $LAUNCH_EDITOR_SCRIPT"
    fi
fi

# Backup original
echo "📝 Backing up original script..."
sudo cp "$LAUNCH_EDITOR_SCRIPT" "$LAUNCH_EDITOR_SCRIPT.backup"
echo "  ✓ Backup saved: $LAUNCH_EDITOR_SCRIPT.backup"

# Create updated version
echo "📝 Updating script to handle Zed..."

sudo tee "$LAUNCH_EDITOR_SCRIPT" > /dev/null << 'EOF'
#!/bin/bash

omarchy-cmd-present "$EDITOR" || EDITOR=zed

case "$EDITOR" in
nvim | vim | nano | micro | hx | helix)
  exec setsid uwsm-app -- xdg-terminal-exec "$EDITOR" "$@"
  ;;
*)
  # GUI editors (including zed, code, etc.)
  exec setsid uwsm-app -- "$EDITOR" "$@"
  ;;
esac
EOF

sudo chmod +x "$LAUNCH_EDITOR_SCRIPT"

echo "  ✓ Updated omarchy-launch-editor"
echo "  ✓ Zed will now launch as a GUI application"

echo
echo "✓ Launch editor script updated!"
echo "  Original backed up to: $LAUNCH_EDITOR_SCRIPT.backup"
