#!/usr/bin/env bash
set -euo pipefail

MON="DP-4"
NOTIFY_APP="--app-name System"
NOTIFY_ICON="$HOME/.local/share/icons/hicolor/96x96/arch.png"
NOTIFY_APP_ICON="$HOME/.local/share/icons/hicolor/50x50/display.png"
NOTIFY_TITLE="Display"

notify_layout() {
  notify-send $NOTIFY_APP --app-icon="$NOTIFY_APP_ICON" --icon="$NOTIFY_ICON" "$NOTIFY_TITLE" "$1"
}


is_disabled="$(
  hyprctl monitors | awk -v mon="$MON" '
    $1=="Monitor" && $2==mon {inmon=1}
    inmon && $1=="disabled:" {print $2; exit}
  '
)"

if [[ "$is_disabled" == "false" ]]; then
  # Optional: shove you to the remaining monitor first (avoids “focus on gone output” moments)
  hyprctl dispatch focusmonitor DP-5 >/dev/null 2>&1 || true

  # Disable DP-4
  hyprctl keyword monitor "$MON,disable"
  notify_layout "Disabled main monitor"
else
  # Re-enable and restore your exact layout
  hyprctl keyword monitor "DP-4,3840x2160@239.99,0x0,1"
  hyprctl keyword monitor "DP-5,2560x1440@179.96,3840x0,1"

  # Restore workspace -> monitor pinning (same as your conf)
  hyprctl keyword workspace "1,monitor:DP-4"
  hyprctl keyword workspace "2,monitor:DP-5"
  notify_layout "Enabled both monitors"
fi