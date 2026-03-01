#!/usr/bin/env bash

# ===============================
# Rofi Logout / Power Menu
# ===============================

THEME="$HOME/.config/rofi/power-menu.rasi"

rofi_cmd="rofi -dmenu \
  -theme $THEME \
  -mesg \"L: Lock   E: Logout   S: Shutdown   U: Suspend   R: Reboot   H: Hibernate   ← ↑ ↓ → Navigate\" \
  -kb-custom-1 l \
  -kb-custom-2 e \
  -kb-custom-3 s \
  -kb-custom-4 u \
  -kb-custom-5 r \
  -kb-custom-6 h"

# Menu entries (icon + text)
chosen=$(printf \
"Lock\0icon\x1flock\n\
Logout\0icon\x1flogout\n\
Shutdown\0icon\x1fsystem-shutdown\n\
Suspend\0icon\x1fsystem-suspend\n\
Reboot\0icon\x1fsystem-reboot\n\
Hibernate\0icon\x1fsystem-hibernate\n" | eval "$rofi_cmd")

exit_code=$?

# ===============================
# Actions
# ===============================
run_action() {
    case "$1" in
        lock)
            i3lock -c 000000
            ;;
        logout)
            i3-msg exit
            ;;
        shutdown)
            systemctl poweroff
            ;;
        suspend)
            systemctl suspend
            ;;
        reboot)
            systemctl reboot
            ;;
        hibernate)
            systemctl hibernate
            ;;
    esac
}

# ===============================
# Custom keybind handling
# ===============================
case "$exit_code" in
    10) run_action lock ;;
    11) run_action logout ;;
    12) run_action shutdown ;;
    13) run_action suspend ;;
    14) run_action reboot ;;
    15) run_action hibernate ;;
esac

# ===============================
# Arrow / Enter selection handling
# ===============================
case "$chosen" in
    Lock) run_action lock ;;
    Logout) run_action logout ;;
    Shutdown) run_action shutdown ;;
    Suspend) run_action suspend ;;
    Reboot) run_action reboot ;;
    Hibernate) run_action hibernate ;;
esac
