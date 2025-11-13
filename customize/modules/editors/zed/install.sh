#!/bin/bash
#
# Zed Editor - Installation Module
# Installs Zed editor and removes Neovim
#

set -e

# Get the module directory
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOMIZE_DIR="$(cd "$MODULE_DIR/../../.." && pwd)"

# Source libraries
source "$CUSTOMIZE_DIR/lib/common.sh"
source "$CUSTOMIZE_DIR/lib/package-utils.sh"

print_header "Installing Zed Editor"

# Check if running on Omarchy
if ! is_omarchy; then
    print_warning "This doesn't appear to be an Omarchy installation."
    if ! ask_yes_no "Continue anyway?"; then
        exit 1
    fi
fi

# Remove neovim packages
echo "📦 Removing Neovim packages..."
remove_package "nvim" true || true
remove_package "omarchy-nvim" true || true

# Remove neovim config (optional - ask user)
if [ -d "$HOME/.config/nvim" ]; then
    echo
    print_info "Found Neovim configuration directory: $HOME/.config/nvim"
    if ask_yes_no "Remove Neovim config?"; then
        rm -rf "$HOME/.config/nvim"
        print_success "Removed Neovim config"
    else
        print_info "Keeping Neovim config"
    fi
fi

# Install Zed
echo
echo "📦 Installing Zed editor..."
if install_package "zed"; then
    print_success "Zed editor installed successfully"
else
    print_error "Failed to install Zed"
    exit 1
fi

echo
print_success "Installation complete!"
print_info "Next: Run configure.sh to set Zed as default editor"
