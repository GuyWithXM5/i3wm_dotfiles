#!/usr/bin/env bash

# ===============================
# Rofi Wallpaper Picker
#   - grid of live thumbnail previews from ~/wallpaper (recursive)
#   - cached thumbnails for snappy launches
#   - Enter  : apply (pywal + blur + feh via change_wallpaper.sh)
#   - Alt+r  : apply a random wallpaper and close
#   - Alt+s  : shuffle — apply random, then reopen the picker
# ===============================

WALL_DIR="$HOME/wallpaper"
THUMB_DIR="$HOME/.cache/wallpaper-thumbs"
THEME="$HOME/.config/rofi/wallpaper.rasi"
APPLY="$HOME/.config/scripts/change_wallpaper.sh"
THUMB_SIZE=500

mkdir -p "$THUMB_DIR"

# --- collect images (recursive) ---
mapfile -d '' IMAGES < <(find "$WALL_DIR" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
       -o -iname '*.webp' -o -iname '*.gif' -o -iname '*.bmp' \) -print0 | sort -z)

if [ "${#IMAGES[@]}" -eq 0 ]; then
    rofi -e "No images found in $WALL_DIR"
    exit 1
fi

# --- clean display name: strip dir + ext, _/- -> space ---
clean_name() {
    local base="${1##*/}"
    base="${base%.*}"
    base="${base//_/ }"
    base="${base//-/ }"
    printf '%s' "$base"
}

# --- thumbnail path for an image (hash of full path) ---
thumb_path() {
    local hash
    hash="$(printf '%s' "$1" | md5sum | cut -d' ' -f1)"
    printf '%s/%s.png' "$THUMB_DIR" "$hash"
}

# --- ensure thumbnail exists / is fresh ---
ensure_thumb() {
    local img="$1" thumb="$2"
    if [ ! -f "$thumb" ] || [ "$img" -nt "$thumb" ]; then
        magick "$img" -thumbnail "${THUMB_SIZE}x${THUMB_SIZE}^" \
            -gravity center -extent "${THUMB_SIZE}x${THUMB_SIZE}" \
            "$thumb" 2>/dev/null
    fi
}

# --- build rofi entries (name \0 icon \x1f thumbpath) ---
build_menu() {
    local img thumb name
    for img in "${IMAGES[@]}"; do
        thumb="$(thumb_path "$img")"
        ensure_thumb "$img" "$thumb"
        name="$(clean_name "$img")"
        printf '%s\0icon\x1f%s\n' "$name" "$thumb"
    done
}

# --- apply by cleaned-name match ---
apply_by_name() {
    local target="$1" img
    for img in "${IMAGES[@]}"; do
        if [ "$(clean_name "$img")" = "$target" ]; then
            "$APPLY" "$img"
            return 0
        fi
    done
    return 1
}

apply_random() {
    local img="${IMAGES[RANDOM % ${#IMAGES[@]}]}"
    "$APPLY" "$img"
}

HINT="↵ apply    Alt+r random    Alt+s shuffle    ␛ cancel    type to filter"

chosen="$(build_menu | rofi -dmenu \
    -theme "$THEME" \
    -p "Wallpaper" \
    -mesg "$HINT" \
    -kb-custom-1 "Alt+r" \
    -kb-custom-2 "Alt+s")"
exit_code=$?

case "$exit_code" in
    10) apply_random ;;                        # Alt+r : random, done
    11) apply_random; exec "$0" ;;             # Alt+s : shuffle, reopen
    0)  [ -n "$chosen" ] && apply_by_name "$chosen" ;;
    *)  exit 0 ;;                              # Esc / cancel
esac
