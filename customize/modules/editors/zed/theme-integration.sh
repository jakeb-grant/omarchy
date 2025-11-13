#!/bin/bash
#
# Zed Editor - Theme Integration Module
# Integrates Zed with Omarchy's theme system for automatic theme synchronization
#

set -e

# Get the module directory
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOMIZE_DIR="$(cd "$MODULE_DIR/../../.." && pwd)"

# Source libraries
source "$CUSTOMIZE_DIR/lib/common.sh"
source "$CUSTOMIZE_DIR/lib/theme-utils.sh"

THEMES_DIR="$HOME/.local/share/omarchy-customize/themes-zed"

print_header "Integrating Zed with Omarchy Themes"

# Check if Zed is installed
if ! command_exists zed; then
    print_error "Zed editor not found"
    print_info "Please install Zed first using install.sh"
    exit 1
fi

# Install theme files
echo "📦 Installing Zed theme configurations..."
ensure_dir "$THEMES_DIR"
cp "$MODULE_DIR/themes/"*.json "$THEMES_DIR/"
print_success "Installed $(ls -1 "$THEMES_DIR"/*.json | wc -l) theme configurations"
print_info "Location: $THEMES_DIR"

# Install theme-set script
echo
echo "📦 Installing omarchy-theme-set-zed script..."
SCRIPT_LOCATION=$(install_script "$MODULE_DIR/bin/omarchy-theme-set-zed")
print_success "Installed theme script"

# Set up Omarchy hook
echo
echo "📝 Setting up Omarchy theme hook..."
install_theme_hook "omarchy-theme-set-zed" "Zed theme integration"

# Apply current theme
echo
echo "🎨 Applying current Omarchy theme to Zed..."
if "$SCRIPT_LOCATION" 2>&1; then
    print_success "Theme applied successfully"
else
    print_warning "Could not apply theme automatically"
    print_info "You can manually run: omarchy-theme-set-zed"
fi

echo
print_success "Zed theme integration complete!"
echo
print_info "How it works:"
print_info "  • When you change Omarchy themes, Zed will automatically update"
print_info "  • Theme files: $THEMES_DIR"
print_info "  • Hook script: ~/.config/omarchy/hooks/theme-set"
print_info "  • Manual update: omarchy-theme-set-zed"
echo
print_info "Supported themes:"
print_info "  • Catppuccin (Mocha/Latte) • Tokyo Night • Gruvbox"
print_info "  • Nord • Rose Pine • Kanagawa • Everforest"
print_info "  • Flexoki Light • Matte Black • Osaka Jade • Ristretto"
