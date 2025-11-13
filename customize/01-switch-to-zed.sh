#!/bin/bash
#
# Post-install script: Replace Neovim with Zed as the default editor
# Run this after installing vanilla Omarchy
#

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Switching from Neovim to Zed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check if running on Omarchy
if [ ! -f "$HOME/.config/omarchy/current/theme" ] && [ ! -d "$HOME/.local/share/omarchy" ]; then
    echo "⚠️  Warning: This doesn't appear to be an Omarchy installation."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Remove neovim packages
echo "📦 Removing Neovim packages..."
if pacman -Q nvim &>/dev/null; then
    sudo pacman -Rns --noconfirm nvim || echo "  ⚠️  Could not remove nvim"
fi

if pacman -Q omarchy-nvim &>/dev/null; then
    sudo pacman -Rns --noconfirm omarchy-nvim || echo "  ⚠️  Could not remove omarchy-nvim"
fi

# Remove neovim config (optional - ask user)
if [ -d "$HOME/.config/nvim" ]; then
    echo
    echo "Found Neovim configuration directory: $HOME/.config/nvim"
    read -p "Remove Neovim config? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "  Removing $HOME/.config/nvim..."
        rm -rf "$HOME/.config/nvim"
        echo "  ✓ Removed"
    else
        echo "  Keeping Neovim config"
    fi
fi

# Install Zed
echo
echo "📦 Installing Zed editor..."
if ! pacman -Q zed &>/dev/null; then
    yay -S --noconfirm zed
    echo "  ✓ Zed installed"
else
    echo "  ✓ Zed already installed"
fi

echo
echo "✓ Package changes complete!"
echo "  Next: Update EDITOR environment variable"
