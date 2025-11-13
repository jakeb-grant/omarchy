# Neovim Uninstall Module

Completely removes Neovim and all its configuration from your system.

## Usage

```bash
bash uninstall.sh
```

## What This Does

- Removes `nvim` package
- Removes `omarchy-nvim` package
- Optionally removes:
  - Neovim configuration (`~/.config/nvim`)
  - Neovim data (`~/.local/share/nvim`)
  - Neovim state (`~/.local/state/nvim`)
  - Neovim cache (`~/.cache/nvim`)

## Interactive Prompts

The script will ask before removing each directory, giving you the option to:
- Create a backup before removal
- Skip removal and keep the files

## Notes

- All removals are optional - you choose what to delete
- Backups are created with timestamps
- After removal, remember to set a new default editor:
  ```bash
  export EDITOR=<your-editor>
  ```
