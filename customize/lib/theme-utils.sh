#!/bin/bash
#
# Theme integration utilities for Omarchy customization
#

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get current Omarchy theme
get_current_theme() {
    if [ -f "$HOME/.config/omarchy/current/theme" ]; then
        basename "$(readlink -f "$HOME/.config/omarchy/current/theme")"
    else
        echo ""
    fi
}

# Install theme hook
install_theme_hook() {
    local hook_file="$HOME/.config/omarchy/hooks/theme-set"
    local hook_command="$1"
    local description="$2"

    ensure_dir "$(dirname "$hook_file")"

    if [ -f "$hook_file" ]; then
        # Hook exists, check if our command is already there
        if grep -q "$hook_command" "$hook_file"; then
            print_info "Hook already configured"
            return 0
        fi

        # Backup and append
        backup_file "$hook_file"
        echo "" >> "$hook_file"
        echo "# $description" >> "$hook_file"
        echo "$hook_command 2>/dev/null || true" >> "$hook_file"
        print_success "Added to existing theme hook"
    else
        # Create new hook
        cat > "$hook_file" << EOF
#!/bin/bash
#
# Omarchy theme-set hook
# Called when the system theme changes
#
# Arguments: \$1 = new theme name
#

# $description
$hook_command 2>/dev/null || true
EOF
        chmod +x "$hook_file"
        print_success "Created theme hook: $hook_file"
    fi

    return 0
}

# Remove theme hook command
remove_theme_hook() {
    local hook_file="$HOME/.config/omarchy/hooks/theme-set"
    local hook_command="$1"

    if [ ! -f "$hook_file" ]; then
        print_info "No theme hook found"
        return 0
    fi

    if ! grep -q "$hook_command" "$hook_file"; then
        print_info "Hook command not found in theme hook"
        return 0
    fi

    backup_file "$hook_file"
    sed -i "/$hook_command/d" "$hook_file"
    print_success "Removed hook command from theme hook"
    return 0
}

# Update JSON settings file with jq
update_json_setting() {
    local file="$1"
    local key="$2"
    local value="$3"

    if ! command_exists jq; then
        print_error "jq not installed, cannot update JSON settings"
        return 1
    fi

    ensure_dir "$(dirname "$file")"

    # Create file if it doesn't exist
    if [ ! -f "$file" ]; then
        echo "{}" > "$file"
    fi

    # Update setting
    local tmp=$(mktemp)
    jq --arg key "$key" --arg value "$value" '.[$key] = $value' "$file" > "$tmp"
    mv "$tmp" "$file"

    return 0
}

# Export functions
export -f get_current_theme
export -f install_theme_hook
export -f remove_theme_hook
export -f update_json_setting
