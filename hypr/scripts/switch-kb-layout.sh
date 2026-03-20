#!/usr/bin/env bash

current=$(hyprctl devices -j | jq -r '[.keyboards[] | select(.main==true) | .layout] | first')

NOTIFY_APP="--app-name System"
NOTIFY_ICON="$HOME/.local/share/icons/hicolor/96x96/arch.png"
NOTIFY_TITLE="Keyboard Layout"

SE_FLAG="$HOME/.local/share/icons/hicolor/512x512/flags/sweden.png"
US_FLAG="$HOME/.local/share/icons/hicolor/512x512/flags/united-states.png"

notify_layout() {
  notify-send $NOTIFY_APP --app-icon="$1" --icon="$NOTIFY_ICON" "$NOTIFY_TITLE" "$2"
}

if [[ "$current" == "us" ]]; then
  hyprctl keyword input:kb_layout sv
  notify_layout "$SE_FLAG" "Switched to Swedish (sv)"
else
  hyprctl keyword input:kb_layout us
  notify_layout "$US_FLAG" "Switched to English (us)"
fi