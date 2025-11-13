#!/bin/bash
#
# Neovim - Uninstallation Module
# Removes Neovim and its configuration
#

set -e

# Get the module directory
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOMIZE_DIR="$(cd "$MODULE_DIR/../../.." && pwd)"

# Source libraries
source "$CUSTOMIZE_DIR/lib/common.sh"
source "$CUSTOMIZE_DIR/lib/package-utils.sh"

print_header "Uninstalling Neovim"

# Remove neovim packages
echo "📦 Removing Neovim packages..."
remove_package "nvim" true || true
remove_package "omarchy-nvim" true || true

# Remove neovim config (optional - ask user)
if [ -d "$HOME/.config/nvim" ]; then
    echo
    print_info "Found Neovim configuration directory: $HOME/.config/nvim"
    if ask_yes_no "Remove Neovim config?"; then
        # Backup first
        if ask_yes_no "Create backup before removing?"; then
            BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)"
            cp -r "$HOME/.config/nvim" "$BACKUP_DIR"
            print_success "Backed up to: $BACKUP_DIR"
        fi

        rm -rf "$HOME/.config/nvim"
        print_success "Removed Neovim config"
    else
        print_info "Keeping Neovim config"
    fi
fi

# Remove neovim cache and data
if [ -d "$HOME/.local/share/nvim" ]; then
    echo
    if ask_yes_no "Remove Neovim data directory (~/.local/share/nvim)?"; then
        rm -rf "$HOME/.local/share/nvim"
        print_success "Removed Neovim data"
    fi
fi

if [ -d "$HOME/.local/state/nvim" ]; then
    if ask_yes_no "Remove Neovim state directory (~/.local/state/nvim)?"; then
        rm -rf "$HOME/.local/state/nvim"
        print_success "Removed Neovim state"
    fi
fi

if [ -d "$HOME/.cache/nvim" ]; then
    if ask_yes_no "Remove Neovim cache (~/.cache/nvim)?"; then
        rm -rf "$HOME/.cache/nvim"
        print_success "Removed Neovim cache"
    fi
fi

echo
print_success "Neovim uninstallation complete!"
print_warning "If Neovim was your default editor, set a new one:"
print_info "  export EDITOR=<your-editor>"
