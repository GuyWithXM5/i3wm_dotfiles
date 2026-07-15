#!/usr/bin/env bash
# Lockscreen — i3lock-color: blurred wallpaper + clock + small magenta RING.
# Reuses the blurred wallpaper cache from change_wallpaper.sh.

CACHE_JPG="$HOME/.cache/blurred_wall.jpg"
LOCK_PNG="$HOME/.cache/lock.png"

current_wall() {
    grep -oE "'/[^']+'" "$HOME/.fehbg" 2>/dev/null | tr -d "'" | head -1
}

# i3lock-color needs a PNG. Rebuild it when the blurred cache changes.
if [ -f "$CACHE_JPG" ] && { [ ! -f "$LOCK_PNG" ] || [ "$CACHE_JPG" -nt "$LOCK_PNG" ]; }; then
    magick "$CACHE_JPG" "$LOCK_PNG"
elif [ ! -f "$LOCK_PNG" ]; then
    wall="$(current_wall)"
    if [ -n "$wall" ] && [ -f "$wall" ]; then
        magick "$wall" -resize 1920x1080^ -gravity center -extent 1920x1080 \
            -blur 0x8 "$LOCK_PNG"
    else
        magick -size 1920x1080 xc:'#0a0f15' "$LOCK_PNG"
    fi
fi

FONT="JetBrains Mono"

i3lock \
    --image="$LOCK_PNG" \
    --ignore-empty-password \
    --clock --force-clock \
    --time-str="%I:%M %p" \
    --date-str="%A, %b %d" \
    --time-font="$FONT" --date-font="$FONT" \
    --time-size=64 --date-size=24 \
    --time-color=ffffffff --date-color=cfcfcfff \
    --time-pos="w/2:h/2-30" \
    --date-pos="w/2:h/2+8" \
    --ind-pos="w/2:h/2+95" \
    --radius=36 \
    --ring-width=5 \
    --inside-color=00000066 --ring-color=a0a0a0aa \
    --insidever-color=00000088 --ringver-color=9878ffff \
    --insidewrong-color=00000088 --ringwrong-color=ff5555ff \
    --keyhl-color=ff00f1ff --bshl-color=ff5555ff \
    --line-color=00000000 --separator-color=00000000 \
    --verif-color=9878ffff --wrong-color=ff5555ff \
    --verif-font="$FONT" --wrong-font="$FONT" \
    --verif-size=20 --wrong-size=20 \
    --verif-text="verifying…" --wrong-text="wrong"
