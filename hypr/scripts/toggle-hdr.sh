#!/usr/bin/env bash
set -euo pipefail

STATE="$HOME/.config/hypr/.display-mode"
NOTIFY_ICON="$HOME/.local/share/icons/hicolor/96x96/arch.png"
NOTIFY_APP_ICON="$HOME/.local/share/icons/hicolor/50x50/display.png"

current=$(cat "$STATE" 2>/dev/null || echo "sdr")
if [[ "$current" == "hdr" ]]; then
  echo "sdr" > "$STATE"
  msg="HDR → SDR"
else
  echo "hdr" > "$STATE"
  msg="SDR → HDR"
fi

if ! reload_out=$(hyprctl reload 2>&1); then
  notify-send --app-name System --urgency=critical \
    --app-icon="$NOTIFY_APP_ICON" --icon="$NOTIFY_ICON" \
    "Display — reload failed" "$reload_out"
  exit 1
fi

notify-send --app-name System \
  --app-icon="$NOTIFY_APP_ICON" --icon="$NOTIFY_ICON" \
  "Display" "$msg"
echo "$msg"
