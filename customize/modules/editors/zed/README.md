# Zed Editor Module

Replace Neovim with Zed editor as the default editor in Omarchy, with full theme integration.

## What This Module Does

- Removes Neovim (`nvim`, `omarchy-nvim`)
- Installs Zed editor from AUR
- Sets Zed as the default `EDITOR`
- Updates `omarchy-launch-editor` to support Zed
- Integrates Zed with Omarchy's theme system for automatic theme sync

## Usage

### Install Everything (Recommended)

```bash
cd modules/editors/zed
bash install.sh
bash configure.sh
bash theme-integration.sh
```

### Individual Steps

**1. Install Zed**
```bash
bash install.sh
```
- Removes Neovim packages
- Installs Zed from AUR
- Optionally removes Neovim config

**2. Configure as Default**
```bash
bash configure.sh
```
- Sets `EDITOR=zed` in `~/.config/uwsm/default`
- Updates `omarchy-launch-editor`
- Optionally adds to `~/.bashrc`

**3. Enable Theme Integration**
```bash
bash theme-integration.sh
```
- Installs theme configurations for all Omarchy themes
- Sets up `omarchy-theme-set-zed` script
- Configures Omarchy hook for automatic theme switching
- Applies current theme

### Uninstall

```bash
bash uninstall.sh
```

Reverts all changes:
- Removes Zed package
- Restores backup files
- Removes theme hook and configurations

## Theme Support

All 12 Omarchy themes are supported:

- **Catppuccin** (Mocha & Latte)
- **Tokyo Night**
- **Gruvbox**
- **Nord**
- **Rose Pine**
- **Kanagawa**
- **Everforest**
- **Flexoki Light**
- **Matte Black**
- **Osaka Jade**
- **Ristretto**

Themes automatically sync when you change your Omarchy theme.

## Files

```
zed/
├── install.sh              # Install Zed, remove Neovim
├── configure.sh            # Set as default editor
├── theme-integration.sh    # Enable theme sync
├── uninstall.sh           # Remove everything
├── bin/
│   └── omarchy-theme-set-zed  # Theme switching script
└── themes/
    └── *.json             # Theme configurations
```

## Requirements

- Omarchy installation
- Internet connection (for AUR packages)
- `sudo` privileges
- `jq` (for JSON manipulation)

## Notes

- All changes create backup files (`.backup` extension)
- Scripts are idempotent - safe to run multiple times
- Theme integration uses Omarchy's native hook system
- Manual theme update: `omarchy-theme-set-zed`
