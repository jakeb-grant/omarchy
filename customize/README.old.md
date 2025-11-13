# Omarchy Post-Install Customization Scripts

These scripts allow you to customize a vanilla Omarchy installation without maintaining a full fork.

## What These Scripts Do

This customization replaces **Neovim** with **Zed** as the default editor in Omarchy, and integrates Zed with the Omarchy theme system for automatic theme synchronization.

### Changes Made:

1. **Package Management** (`01-switch-to-zed.sh`)
   - Removes `nvim` and `omarchy-nvim` packages
   - Installs `zed` editor
   - Optionally removes Neovim configuration

2. **Environment Configuration** (`02-set-zed-default-editor.sh`)
   - Updates `~/.config/uwsm/default` to set `EDITOR=zed`
   - Optionally adds to `~/.bashrc`
   - Backs up original files

3. **Launch Integration** (`03-update-launch-editor.sh`)
   - Updates `omarchy-launch-editor` script
   - Ensures Zed launches as a GUI application
   - Falls back to Zed if `$EDITOR` is not found

4. **Theme System Integration** (`04-integrate-zed-themes.sh`)
   - Installs Zed theme configurations for all 12 Omarchy themes
   - Sets up `omarchy-theme-set-zed` script for theme switching
   - Configures Omarchy hook to automatically update Zed when themes change
   - Applies current Omarchy theme to Zed

## Usage

### Quick Start (Run All Changes)

```bash
bash customize-omarchy.sh
```

This master script will:
- Walk you through all modifications
- Ask for confirmation before making changes
- Create backups of all modified files
- Report success/failure for each step

### Individual Scripts

You can also run individual scripts:

```bash
# Just switch the packages
bash 01-switch-to-zed.sh

# Just update the environment
bash 02-set-zed-default-editor.sh

# Just update the launcher
bash 03-update-launch-editor.sh

# Just integrate themes
bash 04-integrate-zed-themes.sh
```

## After Installation

**Restart your session** (logout/login) for all changes to take effect.

Or manually run:
```bash
export EDITOR=zed
```

Test the editor:
```bash
omarchy-launch-editor
```

## Theme Integration

After running the customization, Zed will automatically sync with Omarchy's theme system:

- **Automatic theme switching**: When you change your Omarchy theme, Zed updates automatically
- **Manual theme update**: Run `omarchy-theme-set-zed` to apply the current theme
- **Supported themes**: All 12 Omarchy themes have Zed configurations:
  - Catppuccin (Mocha & Latte)
  - Tokyo Night
  - Gruvbox
  - Nord
  - Rose Pine
  - Kanagawa
  - Everforest
  - Flexoki Light
  - Matte Black
  - Osaka Jade
  - Ristretto

The integration uses the Omarchy hooks system (`~/.config/omarchy/hooks/theme-set`) to trigger theme updates automatically.

## Backup Files

All modifications create backup files:
- `~/.config/uwsm/default.backup`
- `/usr/local/bin/omarchy-launch-editor.backup`

You can restore from these if needed.

## Reverting Changes

To revert back to Neovim:

1. Restore backup files:
   ```bash
   cp ~/.config/uwsm/default.backup ~/.config/uwsm/default
   sudo cp /usr/local/bin/omarchy-launch-editor.backup /usr/local/bin/omarchy-launch-editor
   ```

2. Remove Zed and reinstall Neovim:
   ```bash
   sudo pacman -Rns zed
   yay -S nvim omarchy-nvim
   ```

3. Restart your session

## Requirements

- Vanilla Omarchy installation
- Internet connection (to download Zed from AUR)
- Sudo privileges

## Notes

- These scripts are **idempotent** - safe to run multiple times
- All original files are backed up before modification
- The scripts will ask for confirmation before destructive operations
- Zed theme integration uses Omarchy's native hook system for seamless synchronization
- Theme configurations are stored in `~/.local/share/omarchy-customize/themes-zed/`

## Adding Your Own Customizations

Follow this pattern for additional modifications:

1. Create numbered scripts: `05-your-mod.sh`, `06-another-mod.sh`
2. Make them executable: `chmod +x 05-your-mod.sh`
3. Add them to `customize-omarchy.sh` as additional steps
4. Always backup original files before modification
5. Use clear echo statements to show progress

## Support

These are custom scripts, not officially part of Omarchy.

For Omarchy itself, see: https://omarchy.org
