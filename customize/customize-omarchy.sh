#!/bin/bash
#
# Omarchy Customization Script
# Post-install modifications for vanilla Omarchy
#
# Usage: bash customize-omarchy.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔════════════════════════════════════════════════╗"
echo "║     Omarchy Post-Install Customization         ║"
echo "╚════════════════════════════════════════════════╝"
echo
echo "This script will make the following changes:"
echo "  1. Remove Neovim packages (nvim, omarchy-nvim)"
echo "  2. Install Zed editor"
echo "  3. Set Zed as the default EDITOR"
echo "  4. Update omarchy-launch-editor to support Zed"
echo
echo "All original files will be backed up."
echo

read -p "Continue with customization? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Customization cancelled."
    exit 0
fi

echo
echo "Starting customization..."
echo

# Track success/failure
FAILED_STEPS=()

# Step 1: Switch to Zed
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 1 of 3: Package Management"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if bash "$SCRIPT_DIR/01-switch-to-zed.sh"; then
    echo "✓ Step 1 completed successfully"
else
    FAILED_STEPS+=("Package management")
    echo "✗ Step 1 failed (see errors above)"
fi

echo
echo

# Step 2: Set default editor
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 2 of 3: Environment Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if bash "$SCRIPT_DIR/02-set-zed-default-editor.sh"; then
    echo "✓ Step 2 completed successfully"
else
    FAILED_STEPS+=("Environment configuration")
    echo "✗ Step 2 failed (see errors above)"
fi

echo
echo

# Step 3: Update launch script
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 3 of 3: Launch Editor Integration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if bash "$SCRIPT_DIR/03-update-launch-editor.sh"; then
    echo "✓ Step 3 completed successfully"
else
    FAILED_STEPS+=("Launch editor integration")
    echo "✗ Step 3 failed (see errors above)"
fi

echo
echo

# Summary
echo "╔════════════════════════════════════════════════╗"
echo "║            Customization Complete              ║"
echo "╚════════════════════════════════════════════════╝"
echo

if [ ${#FAILED_STEPS[@]} -eq 0 ]; then
    echo "✓ All modifications completed successfully!"
    echo
    echo "Next steps:"
    echo "  1. Restart your session (logout/login) to apply all changes"
    echo "  2. Or run: export EDITOR=zed"
    echo "  3. Test with: omarchy-launch-editor"
    echo
    echo "Zed is now your default editor!"
else
    echo "⚠️  Some steps failed:"
    for step in "${FAILED_STEPS[@]}"; do
        echo "    ✗ $step"
    done
    echo
    echo "Please review the error messages above and retry."
    exit 1
fi

echo
echo "═══════════════════════════════════════════════"
echo "Customization Details:"
echo "  • Neovim removed: nvim, omarchy-nvim"
echo "  • Zed installed: $(which zed 2>/dev/null || echo 'not in PATH yet')"
echo "  • Default EDITOR: zed"
echo "  • Config files backed up with .backup extension"
echo "═══════════════════════════════════════════════"
