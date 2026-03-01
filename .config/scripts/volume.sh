#!/bin/sh

case "$1" in
  up)
    pactl set-sink-volume @DEFAULT_SINK@ +10%
    ;;
  down)
    pactl set-sink-volume @DEFAULT_SINK@ -10%
    ;;
  mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    ;;
esac

VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o "[0-9]\+%" | head -n1 | tr -d "")
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

/usr/local/bin/eww -c ~/.config/eww/bar update volume_percent=$VOL muted=$MUTED
