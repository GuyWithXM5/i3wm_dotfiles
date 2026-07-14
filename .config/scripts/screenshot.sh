#!/usr/bin/env bash
# Delete screenshot files in /tmp older than 1 day to save space
find /tmp -name "snap_*" -mtime +1 -delete 2>/dev/null

# Define the unique temporary file path
FILE="/tmp/snap_$(date +%s).png"

# Capture image and pipe path to greenclip via xclip
flameshot gui -r > "$FILE" && echo "$FILE" | xclip -selection clipboard
