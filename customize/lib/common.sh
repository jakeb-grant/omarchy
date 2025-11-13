#!/bin/bash
#
# Common utility functions for Omarchy customization modules
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print a header
print_header() {
    local title="$1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $title"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
}

# Print success message
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Print error message
print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Print warning message
print_warning() {
    echo -e "${YELLOW}⚠️${NC}  $1"
}

# Print info message
print_info() {
    echo -e "${BLUE}ℹ${NC}  $1"
}

# Backup a file
backup_file() {
    local file="$1"
    local backup="${file}.backup"

    if [ -f "$file" ]; then
        cp "$file" "$backup"
        print_success "Backed up: $backup"
        return 0
    else
        print_warning "File not found, skipping backup: $file"
        return 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if package is installed
package_installed() {
    pacman -Q "$1" &> /dev/null
}

# Check if running on Omarchy
is_omarchy() {
    [ -f "$HOME/.config/omarchy/current/theme" ] || [ -d "$HOME/.local/share/omarchy" ]
}

# Ask yes/no question
ask_yes_no() {
    local prompt="$1"
    local default="${2:-y}"

    if [[ "$default" == "y" ]]; then
        read -p "$prompt (Y/n) " -n 1 -r
    else
        read -p "$prompt (y/N) " -n 1 -r
    fi
    echo

    if [[ "$default" == "y" ]]; then
        [[ ! $REPLY =~ ^[Nn]$ ]]
    else
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}

# Create directory if it doesn't exist
ensure_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_success "Created directory: $dir"
    fi
}

# Install script to system bin
install_script() {
    local script="$1"
    local name="$(basename "$script")"

    # Try /usr/local/bin first (requires sudo)
    if sudo cp "$script" "/usr/local/bin/$name" 2>/dev/null; then
        sudo chmod +x "/usr/local/bin/$name"
        print_success "Installed to /usr/local/bin/$name"
        echo "/usr/local/bin/$name"
        return 0
    else
        # Fallback to ~/bin
        print_warning "Could not install to /usr/local/bin (sudo required)"
        print_info "Installing to ~/bin instead..."
        ensure_dir "$HOME/bin"
        cp "$script" "$HOME/bin/$name"
        chmod +x "$HOME/bin/$name"
        print_success "Installed to ~/bin/$name"

        # Check if ~/bin is in PATH
        if ! echo "$PATH" | grep -q "$HOME/bin"; then
            print_warning "~/bin is not in your PATH"
            print_info "Add this to your ~/.bashrc: export PATH=\"\$HOME/bin:\$PATH\""
        fi

        echo "$HOME/bin/$name"
        return 0
    fi
}

# Run a command and show spinner
with_spinner() {
    local message="$1"
    shift
    local cmd="$@"

    echo -n "$message... "

    # Run command in background
    $cmd &> /dev/null &
    local pid=$!

    # Show spinner
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r$message... ${spin:$i:1}"
        sleep 0.1
    done

    # Check exit status
    wait $pid
    local status=$?

    if [ $status -eq 0 ]; then
        printf "\r$message... ${GREEN}✓${NC}\n"
        return 0
    else
        printf "\r$message... ${RED}✗${NC}\n"
        return 1
    fi
}

# Get the customize base directory
get_customize_dir() {
    local script_path="${BASH_SOURCE[0]}"
    local lib_dir="$(cd "$(dirname "$script_path")" && pwd)"
    echo "$(dirname "$lib_dir")"
}

# Export functions for use in other scripts
export -f print_header
export -f print_success
export -f print_error
export -f print_warning
export -f print_info
export -f backup_file
export -f command_exists
export -f package_installed
export -f is_omarchy
export -f ask_yes_no
export -f ensure_dir
export -f install_script
export -f with_spinner
export -f get_customize_dir
