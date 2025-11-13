# Omarchy Customization System

A modular, extensible customization framework for Omarchy installations. Add, remove, and configure applications without maintaining a full fork.

## Quick Start

### Interactive Menu (Recommended)

```bash
cd customize
bash customize.sh
```

This launches an interactive menu where you can:
- Browse available modules by category
- Install/configure individual components
- Run quick-install presets
- Uninstall modules

### Quick Install: Zed Editor

Replace Neovim with Zed editor + full theme integration:

```bash
cd customize
bash customize.sh
# Select: 4. Quick Install: Zed Editor (full setup)
```

Or manually:

```bash
cd modules/editors/zed
bash install.sh
bash configure.sh
bash theme-integration.sh
```

## Structure

```
customize/
├── customize.sh           # Interactive menu system
├── lib/                   # Shared utilities
│   ├── common.sh         # Common functions (logging, backups, etc.)
│   ├── package-utils.sh  # Package management helpers
│   └── theme-utils.sh    # Theme integration utilities
├── modules/              # Customization modules
│   ├── editors/
│   │   ├── zed/         # Zed editor module
│   │   │   ├── install.sh
│   │   │   ├── configure.sh
│   │   │   ├── theme-integration.sh
│   │   │   ├── uninstall.sh
│   │   │   ├── bin/     # Scripts
│   │   │   ├── themes/  # Theme configs
│   │   │   └── README.md
│   │   └── neovim/      # Neovim uninstall module
│   │       ├── uninstall.sh
│   │       └── README.md
│   ├── apps/            # Application modules (coming soon)
│   └── system/          # System tweaks (coming soon)
└── README.md            # This file
```

## Available Modules

### Editors

#### Zed Editor (`modules/editors/zed/`)

Replace Neovim with Zed editor as the default, with full Omarchy theme integration.

**Features:**
- Removes Neovim packages
- Installs Zed from AUR
- Sets as default `EDITOR`
- Updates `omarchy-launch-editor`
- Automatic theme synchronization with Omarchy
- Supports all 12 Omarchy themes

**Usage:**
```bash
cd modules/editors/zed
bash install.sh              # Install Zed, remove Neovim
bash configure.sh            # Set as default editor
bash theme-integration.sh    # Enable theme sync
bash uninstall.sh           # Revert everything
```

See [modules/editors/zed/README.md](modules/editors/zed/README.md) for details.

#### Neovim Uninstall (`modules/editors/neovim/`)

Completely remove Neovim and all its configuration.

**Usage:**
```bash
cd modules/editors/neovim
bash uninstall.sh
```

## Creating New Modules

Modules are self-contained directories with scripts and resources. Here's how to create one:

### 1. Create Module Directory

```bash
mkdir -p modules/<category>/<name>
```

Example categories: `editors`, `apps`, `system`

### 2. Create Module Scripts

Each module can have any combination of:

- `install.sh` - Install the application/feature
- `configure.sh` - Configure settings
- `theme-integration.sh` - Integrate with Omarchy themes
- `uninstall.sh` - Remove everything
- `README.md` - Documentation

### 3. Use Shared Libraries

All scripts should source the common libraries:

```bash
#!/bin/bash
set -e

# Get module directory
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOMIZE_DIR="$(cd "$MODULE_DIR/../../.." && pwd)"

# Source libraries
source "$CUSTOMIZE_DIR/lib/common.sh"
source "$CUSTOMIZE_DIR/lib/package-utils.sh"
source "$CUSTOMIZE_DIR/lib/theme-utils.sh"

print_header "Your Module Name"

# Use library functions
if command_exists your-app; then
    print_success "App already installed"
else
    install_package "your-app"
fi
```

### 4. Available Library Functions

**`common.sh`:**
- `print_header`, `print_success`, `print_error`, `print_warning`, `print_info`
- `backup_file`, `ensure_dir`, `install_script`
- `command_exists`, `package_installed`, `is_omarchy`
- `ask_yes_no`

**`package-utils.sh`:**
- `install_package`, `remove_package`
- `install_packages`, `remove_packages`

**`theme-utils.sh`:**
- `get_current_theme`
- `install_theme_hook`, `remove_theme_hook`
- `update_json_setting`

### 5. Module README Template

```markdown
# Module Name

Brief description of what this module does.

## Usage

\`\`\`bash
bash install.sh
bash configure.sh
\`\`\`

## What This Does

- Bullet points of changes
- Made by this module

## Requirements

- List any requirements

## Notes

- Important notes
- Warnings
- Tips
```

### 6. Add to Main Menu (Optional)

Edit `customize.sh` to add your module to the interactive menu.

## Library Usage Examples

### Installing Packages

```bash
source "$CUSTOMIZE_DIR/lib/package-utils.sh"

# Install single package
install_package "zed"

# Install multiple packages
install_packages "package1" "package2" "package3"

# Remove package
remove_package "nvim"
```

### Theme Integration

```bash
source "$CUSTOMIZE_DIR/lib/theme-utils.sh"

# Get current Omarchy theme
theme=$(get_current_theme)
print_info "Current theme: $theme"

# Add hook to run when theme changes
install_theme_hook "my-theme-script" "My App Theme Integration"

# Update JSON settings file
update_json_setting "$HOME/.config/app/settings.json" "theme" "dark-mode"
```

### User Interaction

```bash
source "$CUSTOMIZE_DIR/lib/common.sh"

# Ask yes/no questions
if ask_yes_no "Do you want to continue?"; then
    print_success "Continuing..."
else
    print_warning "Cancelled"
    exit 0
fi

# Show headers and messages
print_header "Installing Application"
print_info "This will take a moment..."
print_success "Installation complete!"
print_error "Something went wrong"
print_warning "Please review the output"
```

## Module Best Practices

1. **Always backup** before modifying files
2. **Be idempotent** - scripts should be safe to run multiple times
3. **Ask before destructive actions** - use `ask_yes_no`
4. **Provide clear feedback** - use print functions liberally
5. **Handle errors gracefully** - check exit codes, provide helpful messages
6. **Document everything** - include a detailed README
7. **Use shared libraries** - don't reinvent the wheel
8. **Test thoroughly** - verify install, configure, and uninstall work

## Examples

### Example: Simple App Install Module

```bash
#!/bin/bash
set -e

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOMIZE_DIR="$(cd "$MODULE_DIR/../../.." && pwd)"

source "$CUSTOMIZE_DIR/lib/common.sh"
source "$CUSTOMIZE_DIR/lib/package-utils.sh"

print_header "Installing Docker"

if command_exists docker; then
    print_info "Docker already installed"
    exit 0
fi

install_packages "docker" "docker-compose"

# Enable service
sudo systemctl enable --now docker.service
print_success "Docker service enabled"

# Add user to docker group
if ! groups | grep -q docker; then
    sudo usermod -aG docker $USER
    print_success "Added $USER to docker group"
    print_warning "Log out and back in for group changes to take effect"
fi

print_success "Docker installation complete!"
```

### Example: Theme-Aware App Module

```bash
#!/bin/bash
set -e

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOMIZE_DIR="$(cd "$MODULE_DIR/../../.." && pwd)"

source "$CUSTOMIZE_DIR/lib/common.sh"
source "$CUSTOMIZE_DIR/lib/theme-utils.sh"

print_header "Integrating MyApp with Omarchy Themes"

# Install theme script
install_script "$MODULE_DIR/bin/myapp-theme-set"

# Add to theme hook
install_theme_hook "myapp-theme-set" "MyApp theme integration"

# Apply current theme
theme=$(get_current_theme)
if [ -f "$MODULE_DIR/themes/$theme.conf" ]; then
    cp "$MODULE_DIR/themes/$theme.conf" "$HOME/.config/myapp/theme.conf"
    print_success "Applied $theme theme"
fi

print_success "Theme integration complete!"
```

## Contributing Modules

Have a useful module? Consider:
1. Testing it thoroughly
2. Writing clear documentation
3. Following the structure guidelines
4. Submitting a pull request

## Requirements

- Omarchy installation
- Internet connection (for package downloads)
- `sudo` privileges
- `bash` 4.0+
- `jq` (for JSON manipulation)

## Notes

- All scripts create backup files before modifications
- Modules are independent and can be run individually
- The framework is designed to be extensible
- More module categories coming soon (apps, system tweaks, etc.)

## Support

This is a community customization framework, not officially part of Omarchy.

For Omarchy itself, see: https://omarchy.org
