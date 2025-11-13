#!/bin/bash
#
# Post-install script: Integrate Zed with Omarchy theme system
# Automatically switches Zed theme when Omarchy theme changes
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$HOME/.local/share/omarchy-customize/themes-zed"
HOOK_FILE="$HOME/.config/omarchy/hooks/theme-set"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Integrating Zed with Omarchy Themes"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check if Zed is installed
if ! command -v zed &> /dev/null; then
    echo "⚠️  Zed editor not found"
    echo "  Please install Zed first using customize-omarchy.sh or:"
    echo "  yay -S zed"
    exit 1
fi

# Install theme files
echo "📦 Installing Zed theme configurations..."
mkdir -p "$THEMES_DIR"
cp "$SCRIPT_DIR/themes-zed/"*.json "$THEMES_DIR/"
echo "  ✓ Installed $(ls -1 "$THEMES_DIR"/*.json | wc -l) theme configurations"
echo "  Location: $THEMES_DIR"

# Install theme-set script
echo
echo "📦 Installing omarchy-theme-set-zed script..."

# Try to install to /usr/local/bin (requires sudo)
if sudo cp "$SCRIPT_DIR/bin/omarchy-theme-set-zed" /usr/local/bin/omarchy-theme-set-zed 2>/dev/null; then
    sudo chmod +x /usr/local/bin/omarchy-theme-set-zed
    SCRIPT_LOCATION="/usr/local/bin/omarchy-theme-set-zed"
    echo "  ✓ Installed to /usr/local/bin/omarchy-theme-set-zed"
else
    # Fallback to ~/bin
    echo "  Could not install to /usr/local/bin (sudo required)"
    echo "  Installing to ~/bin instead..."
    mkdir -p "$HOME/bin"
    cp "$SCRIPT_DIR/bin/omarchy-theme-set-zed" "$HOME/bin/omarchy-theme-set-zed"
    chmod +x "$HOME/bin/omarchy-theme-set-zed"
    SCRIPT_LOCATION="$HOME/bin/omarchy-theme-set-zed"
    echo "  ✓ Installed to ~/bin/omarchy-theme-set-zed"

    # Add ~/bin to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/bin"; then
        echo
        echo "  ⚠️  Note: ~/bin is not in your PATH"
        echo "  Add this to your ~/.bashrc:"
        echo "  export PATH=\"\$HOME/bin:\$PATH\""
    fi
fi

# Set up Omarchy hook
echo
echo "📝 Setting up Omarchy theme hook..."

if [ -f "$HOOK_FILE" ]; then
    # Hook file exists, check if our script is already there
    if grep -q "omarchy-theme-set-zed" "$HOOK_FILE"; then
        echo "  ✓ Hook already configured"
    else
        # Backup existing hook
        cp "$HOOK_FILE" "$HOOK_FILE.backup"
        echo "  Backing up existing hook: $HOOK_FILE.backup"

        # Append our script to existing hook
        echo "" >> "$HOOK_FILE"
        echo "# Zed theme integration (added by customize-omarchy)" >> "$HOOK_FILE"
        echo "omarchy-theme-set-zed 2>/dev/null || true" >> "$HOOK_FILE"
        echo "  ✓ Added Zed integration to existing hook"
    fi
else
    # Create new hook file
    mkdir -p "$(dirname "$HOOK_FILE")"
    cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash
#
# Omarchy theme-set hook
# Called when the system theme changes
#
# Arguments: $1 = new theme name
#

# Zed theme integration (added by customize-omarchy)
omarchy-theme-set-zed 2>/dev/null || true
EOF
    chmod +x "$HOOK_FILE"
    echo "  ✓ Created new theme hook: $HOOK_FILE"
fi

# Apply current theme
echo
echo "🎨 Applying current Omarchy theme to Zed..."
if "$SCRIPT_LOCATION" 2>&1; then
    echo "  ✓ Theme applied successfully"
else
    echo "  ⚠️  Could not apply theme automatically"
    echo "  You can manually run: omarchy-theme-set-zed"
fi

echo
echo "✓ Zed theme integration complete!"
echo
echo "How it works:"
echo "  • When you change Omarchy themes, Zed will automatically update"
echo "  • Theme files are stored in: $THEMES_DIR"
echo "  • Hook script at: $HOOK_FILE"
echo "  • Manual theme update: omarchy-theme-set-zed"
echo
echo "Supported themes:"
echo "  • Catppuccin (Mocha/Latte)"
echo "  • Tokyo Night"
echo "  • Gruvbox"
echo "  • Nord"
echo "  • Rose Pine"
echo "  • Kanagawa"
echo "  • Everforest"
echo "  • Flexoki Light"
echo "  • And more..."
