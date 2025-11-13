#!/bin/bash
#
# Package management utilities for Omarchy customization
#

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Install package using yay
install_package() {
    local package="$1"
    local quiet="${2:-false}"

    if package_installed "$package"; then
        if [ "$quiet" != "true" ]; then
            print_info "$package already installed"
        fi
        return 0
    fi

    if [ "$quiet" == "true" ]; then
        yay -S --noconfirm "$package" &>/dev/null
    else
        print_info "Installing $package..."
        yay -S --noconfirm "$package"
    fi

    if [ $? -eq 0 ]; then
        print_success "$package installed"
        return 0
    else
        print_error "Failed to install $package"
        return 1
    fi
}

# Remove package
remove_package() {
    local package="$1"
    local quiet="${2:-false}"

    if ! package_installed "$package"; then
        if [ "$quiet" != "true" ]; then
            print_info "$package not installed"
        fi
        return 0
    fi

    if [ "$quiet" == "true" ]; then
        sudo pacman -Rns --noconfirm "$package" &>/dev/null
    else
        print_info "Removing $package..."
        sudo pacman -Rns --noconfirm "$package"
    fi

    if [ $? -eq 0 ]; then
        print_success "$package removed"
        return 0
    else
        print_error "Failed to remove $package"
        return 1
    fi
}

# Install multiple packages
install_packages() {
    local packages=("$@")
    local failed=()

    for package in "${packages[@]}"; do
        if ! install_package "$package"; then
            failed+=("$package")
        fi
    done

    if [ ${#failed[@]} -gt 0 ]; then
        print_error "Failed to install: ${failed[*]}"
        return 1
    fi

    return 0
}

# Remove multiple packages
remove_packages() {
    local packages=("$@")
    local failed=()

    for package in "${packages[@]}"; do
        if ! remove_package "$package"; then
            failed+=("$package")
        fi
    done

    if [ ${#failed[@]} -gt 0 ]; then
        print_error "Failed to remove: ${failed[*]}"
        return 1
    fi

    return 0
}

# Export functions
export -f install_package
export -f remove_package
export -f install_packages
export -f remove_packages
