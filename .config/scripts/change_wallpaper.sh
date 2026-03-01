#!/bin/bash

# 1. Path to your wallpaper
WALLPAPER="$1"

# 2. Run Pywal to generate colors
wal -i "$WALLPAPER"

# 3. Generate the blurred version for the background
magick "$WALLPAPER" -resize 1920x1080^ -gravity center -extent 1920x1080 -blur 0x30 ~/.cache/blurred_wall.jpg

# 4. Set the actual wallpaper (using feh or your choice)
feh --bg-fill "$WALLPAPER"
