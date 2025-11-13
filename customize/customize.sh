#!/bin/bash
#
# Omarchy Customization Manager
# Interactive menu-driven customization system
#

set -e

# Get the customize directory
CUSTOMIZE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "$CUSTOMIZE_DIR/lib/common.sh"

# Track installed modules
declare -a SELECTED_MODULES=()
declare -a FAILED_MODULES=()

# Show main menu
show_main_menu() {
    clear
    echo "╔════════════════════════════════════════════════╗"
    echo "║     Omarchy Customization Manager              ║"
    echo "╚════════════════════════════════════════════════╝"
    echo
    echo "Select a category:"
    echo "  1. Editors"
    echo "  2. Applications (coming soon)"
    echo "  3. System Tweaks (coming soon)"
    echo "  4. Quick Install: Zed Editor (full setup)"
    echo "  5. Exit"
    echo
    read -p "Choice [1-5]: " choice
    echo

    case $choice in
        1) show_editors_menu ;;
        2) print_info "Applications modules coming soon!"; sleep 2; show_main_menu ;;
        3) print_info "System tweaks modules coming soon!"; sleep 2; show_main_menu ;;
        4) quick_install_zed ;;
        5) exit 0 ;;
        *) print_error "Invalid choice"; sleep 1; show_main_menu ;;
    esac
}

# Show editors submenu
show_editors_menu() {
    clear
    print_header "Editors"
    echo "Available editor modules:"
    echo
    echo "  1. ☐ Install Zed Editor"
    echo "  2. ☐ Configure Zed as Default"
    echo "  3. ☐ Enable Zed Theme Integration"
    echo "  4. ☐ Complete Zed Setup (all above)"
    echo "  5. ☐ Uninstall Neovim"
    echo "  6. ☐ Uninstall Zed"
    echo
    echo "  b. Back to main menu"
    echo
    read -p "Choice: " choice
    echo

    case $choice in
        1) run_module "editors/zed" "install.sh" "Install Zed Editor"; show_editors_menu ;;
        2) run_module "editors/zed" "configure.sh" "Configure Zed"; show_editors_menu ;;
        3) run_module "editors/zed" "theme-integration.sh" "Zed Theme Integration"; show_editors_menu ;;
        4) quick_install_zed; show_editors_menu ;;
        5) run_module "editors/neovim" "uninstall.sh" "Uninstall Neovim"; show_editors_menu ;;
        6) run_module "editors/zed" "uninstall.sh" "Uninstall Zed"; show_editors_menu ;;
        b|B) show_main_menu ;;
        *) print_error "Invalid choice"; sleep 1; show_editors_menu ;;
    esac
}

# Quick install Zed (all steps)
quick_install_zed() {
    clear
    print_header "Quick Install: Zed Editor"
    echo "This will:"
    echo "  1. Install Zed and remove Neovim"
    echo "  2. Configure Zed as default editor"
    echo "  3. Enable automatic theme synchronization"
    echo

    if ! ask_yes_no "Continue with full Zed setup?"; then
        return
    fi

    echo
    run_module "editors/zed" "install.sh" "Install Zed" true
    run_module "editors/zed" "configure.sh" "Configure Zed" true
    run_module "editors/zed" "theme-integration.sh" "Theme Integration" true

    echo
    if [ ${#FAILED_MODULES[@]} -eq 0 ]; then
        print_success "✓ Zed editor fully configured!"
        echo
        print_info "Next steps:"
        print_info "  1. Restart your session (logout/login)"
        print_info "  2. Test with: omarchy-launch-editor"
        print_info "  3. Change themes and watch Zed update automatically!"
    else
        print_error "Some steps failed:"
        for module in "${FAILED_MODULES[@]}"; do
            print_error "  ✗ $module"
        done
    fi

    echo
    read -p "Press Enter to continue..."
}

# Run a module script
run_module() {
    local category="$1"
    local script="$2"
    local description="$3"
    local quiet="${4:-false}"

    local module_path="$CUSTOMIZE_DIR/modules/$category/$script"

    if [ ! -f "$module_path" ]; then
        print_error "Module not found: $module_path"
        return 1
    fi

    if [ "$quiet" != "true" ]; then
        echo
        print_header "$description"
    fi

    if bash "$module_path"; then
        SELECTED_MODULES+=("$description")
        if [ "$quiet" != "true" ]; then
            echo
            print_success "✓ $description completed"
            read -p "Press Enter to continue..."
        fi
        return 0
    else
        FAILED_MODULES+=("$description")
        if [ "$quiet" != "true" ]; then
            echo
            print_error "✗ $description failed"
            read -p "Press Enter to continue..."
        fi
        return 1
    fi
}

# Main execution
main() {
    # Check if running on Omarchy
    if ! is_omarchy; then
        print_warning "This doesn't appear to be an Omarchy installation."
        if ! ask_yes_no "Continue anyway?"; then
            exit 1
        fi
        echo
    fi

    show_main_menu
}

# Run main
main
