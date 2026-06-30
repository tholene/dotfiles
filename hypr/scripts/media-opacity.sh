#!/bin/bash

LOCKED_FILE="/tmp/hypr-media-opacity-locked"
LAST_CHROME_FILE="/tmp/hypr-media-opacity-last-chrome"
INACTIVE_OPACITY="0.75"
LOG="/tmp/hypr-media-opacity.log"

log() { echo "[$(date +%T)] $*" >> "$LOG"; }

unlock() {
    [[ -f "$LOCKED_FILE" ]] || return
    local addr
    addr=$(cat "$LOCKED_FILE")
    hyprctl setprop address:"$addr" alphainactive "$INACTIVE_OPACITY" 0 >/dev/null 2>&1
    rm -f "$LOCKED_FILE"
    log "unlocked $addr"
}

lock_last_chrome() {
    [[ -f "$LAST_CHROME_FILE" ]] || return
    local addr
    addr=$(cat "$LAST_CHROME_FILE")
    unlock
    hyprctl setprop address:"$addr" alphainactive 1.0 1 >/dev/null 2>&1
    echo "$addr" > "$LOCKED_FILE"
    log "locked $addr"
}

# playerctld returns its own name as {{playerName}}, not the underlying player.
# Query playerctl -l directly to find chromium instances.
is_chrome_playing() {
    while IFS= read -r player; do
        [[ "$player" == chromium.instance* ]] || continue
        [[ "$(playerctl -p "$player" status 2>/dev/null)" == "Playing" ]] && return 0
    done < <(playerctl -l 2>/dev/null)
    return 1
}

init() {
    unlock

    local active_json active_class active_addr
    active_json=$(hyprctl activewindow -j 2>/dev/null)
    active_class=$(echo "$active_json" | jq -r '.class // empty')
    active_addr=$(echo "$active_json" | jq -r '.address // empty')

    if [[ "$active_class" == "google-chrome" && -n "$active_addr" ]]; then
        echo "$active_addr" > "$LAST_CHROME_FILE"
        log "init: chrome focused, tracking $active_addr"
    else
        local chrome_addr
        chrome_addr=$(hyprctl clients -j 2>/dev/null | \
            jq -r '[.[] | select(.class == "google-chrome")] | sort_by(.focusHistoryID) | first | .address // empty')
        if [[ -n "$chrome_addr" ]]; then
            echo "$chrome_addr" > "$LAST_CHROME_FILE"
            log "init: tracking most-recent chrome $chrome_addr"
        fi
        is_chrome_playing && lock_last_chrome
    fi
}

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
[[ -S "$SOCKET" ]] || { log "socket not found: $SOCKET"; exit 1; }

log "starting, socket: $SOCKET"
init

while IFS= read -r line; do
    line="${line%$'\r'}"
    case "$line" in
        activewindowv2\>\>*)
            [[ "${line#activewindowv2>>}" == "" ]] && continue

            active_json=$(hyprctl activewindow -j 2>/dev/null)
            class=$(echo "$active_json" | jq -r '.class // empty')
            addr=$(echo "$active_json" | jq -r '.address // empty')
            log "focus → $class ($addr)"

            if [[ "$class" == "google-chrome" ]]; then
                echo "$addr" > "$LAST_CHROME_FILE"
                unlock
            else
                if is_chrome_playing; then
                    lock_last_chrome
                else
                    unlock
                fi
            fi
            ;;
        closewindow\>\>*)
            raw="${line#closewindow>>}"
            [[ "$raw" != 0x* ]] && addr="0x$raw" || addr="$raw"
            if [[ -f "$LOCKED_FILE" ]] && [[ "$(cat "$LOCKED_FILE")" == "$addr" ]]; then
                rm -f "$LOCKED_FILE"
                log "closed locked window $addr, cleared lock"
            fi
            if [[ -f "$LAST_CHROME_FILE" ]] && [[ "$(cat "$LAST_CHROME_FILE")" == "$addr" ]]; then
                rm -f "$LAST_CHROME_FILE"
                log "closed tracked chrome $addr, cleared tracker"
            fi
            ;;
    esac
done < <(socat -u "UNIX-CONNECT:$SOCKET" - 2>/dev/null)

log "socat exited"
