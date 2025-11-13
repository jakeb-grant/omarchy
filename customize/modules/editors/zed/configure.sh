#!/bin/bash
#
# Zed Editor - Configuration Module
# Sets Zed as the default EDITOR and updates launch scripts
#

set -e

# Get the module directory
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOMIZE_DIR="$(cd "$MODULE_DIR/../../.." && pwd)"

# Source libraries
source "$CUSTOMIZE_DIR/lib/common.sh"

print_header "Configuring Zed as Default Editor"

# Check if Zed is installed
if ! command_exists zed; then
    print_error "Zed is not installed"
    print_info "Run install.sh first"
    exit 1
fi

# Update uwsm config (main EDITOR setting)
UWSM_CONFIG="$HOME/.config/uwsm/default"

echo "📝 Updating $UWSM_CONFIG..."

if [ -f "$UWSM_CONFIG" ]; then
    backup_file "$UWSM_CONFIG"

    # Replace nvim with zed
    sed -i 's/^export EDITOR=nvim/export EDITOR=zed/' "$UWSM_CONFIG"

    # Also handle if someone changed it to something else, add if not present
    if ! grep -q "^export EDITOR=" "$UWSM_CONFIG"; then
        echo "" >> "$UWSM_CONFIG"
        echo "# Use zed as default editor" >> "$UWSM_CONFIG"
        echo "export EDITOR=zed" >> "$UWSM_CONFIG"
    fi

    print_success "Updated EDITOR to zed"
else
    print_warning "$UWSM_CONFIG not found"
    print_info "Creating it now..."
    ensure_dir "$(dirname "$UWSM_CONFIG")"
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
    print_success "Created $UWSM_CONFIG with EDITOR=zed"
fi

# Update current shell session
echo
print_info "Updating current shell environment..."
export EDITOR=zed
print_success "EDITOR set to zed for current session"

# Add to bashrc if needed (for terminal sessions)
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "export EDITOR=zed" "$HOME/.bashrc"; then
        echo
        if ask_yes_no "Add 'export EDITOR=zed' to ~/.bashrc?"; then
            echo "" >> "$HOME/.bashrc"
            echo "# Set Zed as default editor" >> "$HOME/.bashrc"
            echo "export EDITOR=zed" >> "$HOME/.bashrc"
            print_success "Added to ~/.bashrc"
        fi
    else
        print_info "~/.bashrc already contains EDITOR setting"
    fi
fi

# Update omarchy-launch-editor
echo
print_info "Updating omarchy-launch-editor..."

LAUNCH_EDITOR_SCRIPT=$(which omarchy-launch-editor 2>/dev/null || echo "")

if [ -z "$LAUNCH_EDITOR_SCRIPT" ]; then
    print_warning "omarchy-launch-editor not found"
    print_info "Skipping launch editor modification"
else
    backup_file "$LAUNCH_EDITOR_SCRIPT"

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
    print_success "Updated omarchy-launch-editor"
fi

echo
print_success "Configuration complete!"
print_warning "Restart your session for changes to take full effect"
print_info "Or run: export EDITOR=zed"
