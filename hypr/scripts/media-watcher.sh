#!/usr/bin/env bash

LOCKFILE="/tmp/media-watcher.lock"
if [ -e "$LOCKFILE" ]; then
  PID=$(cat "$LOCKFILE")
  if kill -0 "$PID" 2>/dev/null; then
    echo "Another instance is running (PID $PID). Exiting."
    exit 1
  fi
fi
echo $$ > "$LOCKFILE"

trap 'rm -f "$LOCKFILE"' EXIT

LOG=/tmp/media-watcher.log
echo "Watcher started at $(date)" >> "$LOG"

chrome_poll() {
    while true; do
        clients=$(hyprctl clients -j)
        # Tag Chrome windows with inhibitingIdle true
        mapfile -t chrome_active < <(echo "$clients" | jq -r \
            '.[] | select(type=="object" and .class=="google-chrome" and .inhibitingIdle==true) | .address')
        # Untag Chrome windows with inhibitingIdle false but currently tagged
        mapfile -t chrome_inactive < <(echo "$clients" | jq -r \
            '.[] | select(type=="object" and .class=="google-chrome" and .inhibitingIdle==false and (.tags|index("media"))) | .address')

        for address in "${chrome_active[@]}"; do
            curr_tag=$(echo "$clients" | jq -r \
                '.[] | select(type=="object" and .address=="'"$address"'") | .tags')
            if [[ "$curr_tag" != *"media"* ]]; then
                hyprctl dispatch tagwindow media address:"$address"
                echo "Chrome: tagged address $address at $(date)" >> "$LOG"
            fi
        done

        for address in "${chrome_inactive[@]}"; do
            hyprctl dispatch tagwindow -- media address:"$address"
            echo "Chrome: untagged address $address at $(date)" >> "$LOG"
        done

        sleep 5
    done
}

spotify_handler() {
    LAST_STATUS=""
    playerctl --follow status | while read -r status; do
        echo "$status" >> "$LOG"
        if [[ "$status" != "$LAST_STATUS" ]]; then
            LAST_STATUS="$status"
            clients=$(hyprctl clients -j)
            player=$(playerctl -l | grep -Fx spotify)
            if [[ -n "$player" ]]; then
                spotify_pid=$(pgrep -x spotify | head -n1)
                mapfile -t spotify_addresses < <(echo "$clients" | jq -r --arg pid "$spotify_pid" \
                    '.[] | select(type=="object" and .pid == ($pid | tonumber) and .class == "spotify") | .address')
                for address in "${spotify_addresses[@]}"; do
                    curr_tag=$(echo "$clients" | jq -r \
                        '.[] | select(type=="object" and .address=="'"$address"'") | .tags')
                    if [[ "$status" == "Playing" ]]; then
                        if [[ "$curr_tag" != *"media"* ]]; then
                            hyprctl dispatch tagwindow media address:"$address"
                            echo "Spotify: tagged address $address at $(date)" >> "$LOG"
                        fi
                    else
                        if [[ "$curr_tag" == *"media"* ]]; then
                            hyprctl dispatch tagwindow media address:"$address"
                            echo "Spotify: untagged address $address at $(date)" >> "$LOG"
                        fi
                    fi
                done
            fi
        fi
    done
}

chrome_poll &
spotify_handler &

wait