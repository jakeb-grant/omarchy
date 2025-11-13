#!/bin/bash
#
# Zed Editor - Uninstallation Module
# Removes Zed editor and reverts configuration changes
#

set -e

# Get the module directory
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOMIZE_DIR="$(cd "$MODULE_DIR/../../.." && pwd)"

# Source libraries
source "$CUSTOMIZE_DIR/lib/common.sh"
source "$CUSTOMIZE_DIR/lib/package-utils.sh"
source "$CUSTOMIZE_DIR/lib/theme-utils.sh"

print_header "Uninstalling Zed Editor"

# Remove Zed package
echo "📦 Removing Zed package..."
remove_package "zed"

# Remove Zed config
if [ -d "$HOME/.config/zed" ]; then
    echo
    if ask_yes_no "Remove Zed configuration directory?"; then
        rm -rf "$HOME/.config/zed"
        print_success "Removed Zed config"
    fi
fi

# Restore uwsm config from backup
UWSM_CONFIG="$HOME/.config/uwsm/default"
if [ -f "$UWSM_CONFIG.backup" ]; then
    echo
    if ask_yes_no "Restore $UWSM_CONFIG from backup?"; then
        cp "$UWSM_CONFIG.backup" "$UWSM_CONFIG"
        print_success "Restored $UWSM_CONFIG"
    fi
fi

# Restore omarchy-launch-editor from backup
LAUNCH_EDITOR=$(which omarchy-launch-editor 2>/dev/null || echo "")
if [ -n "$LAUNCH_EDITOR" ] && [ -f "$LAUNCH_EDITOR.backup" ]; then
    echo
    if ask_yes_no "Restore omarchy-launch-editor from backup?"; then
        sudo cp "$LAUNCH_EDITOR.backup" "$LAUNCH_EDITOR"
        print_success "Restored omarchy-launch-editor"
    fi
fi

# Remove theme hook
echo
echo "📝 Removing theme hook..."
remove_theme_hook "omarchy-theme-set-zed"

# Remove theme files
THEMES_DIR="$HOME/.local/share/omarchy-customize/themes-zed"
if [ -d "$THEMES_DIR" ]; then
    echo
    if ask_yes_no "Remove Zed theme files?"; then
        rm -rf "$THEMES_DIR"
        print_success "Removed theme files"
    fi
fi

# Remove theme-set script
if command_exists omarchy-theme-set-zed; then
    echo
    if ask_yes_no "Remove omarchy-theme-set-zed script?"; then
        SCRIPT_LOC=$(which omarchy-theme-set-zed)
        if [[ "$SCRIPT_LOC" == /usr/local/bin/* ]]; then
            sudo rm "$SCRIPT_LOC"
        else
            rm "$SCRIPT_LOC"
        fi
        print_success "Removed omarchy-theme-set-zed"
    fi
fi

echo
print_success "Zed uninstallation complete!"
print_info "Restart your session for changes to take full effect"
