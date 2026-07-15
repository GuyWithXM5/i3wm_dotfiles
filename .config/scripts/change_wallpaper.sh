#!/bin/bash

# 1. Path to your wallpaper
WALLPAPER="$1"

# 2. Run Pywal to generate colors.
#    -s : don't broadcast the palette to open terminals (keeps ANSI colors,
#         e.g. red error text — only the bg is picked up via Alacritty's import)
#    -t : skip TTY color change   -e : skip external reloads   -q : quiet
wal -i "$WALLPAPER" -s -t -e -q

# 3. Generate the blurred version for the background
magick "$WALLPAPER" -resize 1920x1080^ -gravity center -extent 1920x1080 -blur 0x30 ~/.cache/blurred_wall.jpg

# 4. Set the actual wallpaper (using feh or your choice)
feh --bg-fill "$WALLPAPER"
