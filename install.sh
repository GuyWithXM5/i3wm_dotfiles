#!/bin/bash
# Dotfiles installation script for Arch Linux
# Run from the dotfiles directory: ./install.sh

set -e
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:-$HOME}"

echo "==> Installing dotfiles from $DOTFILES_DIR to $HOME_DIR"

mkdir -p "$HOME_DIR/.config"

# Symlink config directories
for dir in i3 eww rofi picom alacritty scripts polybar neofetch btop gtk-3.0 Thunar; do
    src="$DOTFILES_DIR/.config/$dir"
    dst="$HOME_DIR/.config/$dir"
    if [ -d "$src" ]; then
        rm -rf "$dst"
        ln -sf "$src" "$dst"
        echo "  Linked .config/$dir"
    fi
done

# Symlink individual config files
[ -f "$DOTFILES_DIR/.config/mimeapps.list" ] && ln -sf "$DOTFILES_DIR/.config/mimeapps.list" "$HOME_DIR/.config/mimeapps.list" && echo "  Linked mimeapps.list"
[ -f "$DOTFILES_DIR/.zshrc" ] && ln -sf "$DOTFILES_DIR/.zshrc" "$HOME_DIR/.zshrc" && echo "  Linked .zshrc"

# Make scripts executable
chmod +x "$HOME_DIR/.config/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME_DIR/.config/rofi/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME_DIR/.config/eww/bar/launch_bar" 2>/dev/null || true
chmod +x "$HOME_DIR/.config/eww/bar/scripts/"* 2>/dev/null || true
chmod +x "$HOME_DIR/.config/polybar/launch.sh" 2>/dev/null || true

echo ""
echo "==> Next steps:"
echo "  1. Install dependencies: sudo pacman -S i3 i3lock dex xss-lock network-manager-applet alacritty rofi picom feh thunar flameshot brightnessctl pulseaudio jq ttf-jetbrains-mono-nerd ttf-fira-sans ttf-font-awesome papirus-icon-theme adw-gtk3"
echo "  2. Install from AUR: yay -S eww autotiling"
echo "  3. Power menu symlink: sudo ln -sf ~/.config/rofi/scripts/power-menu.sh /usr/local/bin/rofi-powermenu"
echo "  4. Set wallpaper: feh --bg-fill /path/to/wallpaper.jpg"
echo "  5. Run pywal: wal -i /path/to/wallpaper.jpg"
echo ""
echo "See README.md for full documentation."
