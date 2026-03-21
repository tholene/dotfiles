#!/usr/bin/env bash
set -euo pipefail

ACTIVE="$HOME/.config/hypr/conf.d/10-monitors-active.conf"
NOTIFY_APP="--app-name System"
NOTIFY_ICON="$HOME/.local/share/icons/hicolor/96x96/arch.png"
NOTIFY_APP_ICON="$HOME/.local/share/icons/hicolor/50x50/display.png"
NOTIFY_TITLE="Display"

notify_layout() {
  notify-send $NOTIFY_APP --app-icon="$NOTIFY_APP_ICON" --icon="$NOTIFY_ICON" "$NOTIFY_TITLE" "$1"
}

HDR="$HOME/.config/hypr/conf.d/10-monitors-hdr.conf"
SDR="$HOME/.config/hypr/conf.d/10-monitors-sdr.conf"

need() { [[ -f "$1" ]] || { echo "Missing file: $1" >&2; exit 1; }; }
need "$HDR"
need "$SDR"

current=""
if [[ -L "$ACTIVE" ]]; then
  current="$(readlink -f "$ACTIVE" || true)"
fi

if [[ "$current" == "$(readlink -f "$HDR")" ]]; then
  ln -sfn "$SDR" "$ACTIVE"
  msg="HDR → SDR"
else
  ln -sfn "$HDR" "$ACTIVE"
  msg="SDR → HDR"
fi

hyprctl reload >/dev/null || true

if command -v notify-send >/dev/null 2>&1; then
  notify_layout "$msg"
fi

echo "$msg"