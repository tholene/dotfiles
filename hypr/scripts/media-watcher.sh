#!/usr/bin/env bash

LOG=/tmp/media-watcher.log
echo "Watcher started at $(date)" >> $LOG

LAST_STATUS=""

playerctl --follow status | while read status; do
    echo "$status" >> $LOG

    # Only act if status changes
    if [[ "$status" != "$LAST_STATUS" ]]; then
        LAST_STATUS="$status"

        if [[ "$status" == "Playing" || "$status" == "Paused" || "$status" == "Stopped" ]]; then
            player=$(playerctl -l | head -n1)
            media_title=$(playerctl metadata --player="$player" --format '{{title}}')
            media_artist=$(playerctl metadata --player="$player" --format '{{artist}}')
            echo "[status=$status] [player=$player] [title=$media_title] [artist=$media_artist]" >> $LOG

            clients=$(hyprctl clients -j)
            matched_addresses=()
            pid=""

            if [[ "$player" == "spotify" ]]; then
                pid=$(pgrep -x spotify | head -n1)
                if [ -n "$pid" ]; then
                    matched_addresses=($(echo "$clients" | jq -r --arg pid "$pid" \
                        '.[] | select(.pid == ($pid | tonumber) and .class=="spotify") | .address'))
                fi
            elif [[ "$player" == "chromium" || "$player" == "chrome" || "$player" == "google-chrome" ]]; then
                # Try matching Chrome windows by title substring first
                matched_addresses=($(echo "$clients" | jq -r --arg title "$media_title" \
                    '.[] | select(.class=="google-chrome" and (.title | contains($title))) | .address'))
                # If no match by title, fall back to PID
                pid=$(playerctl metadata --player="$player" --format '{{pid}}')
                if [ "${#matched_addresses[@]}" -eq 0 ] && [ -n "$pid" ]; then
                    matched_addresses=($(echo "$clients" | jq -r --arg pid "$pid" \
                        '.[] | select(.pid | tostring == $pid and .class=="google-chrome") | .address'))
                fi
            else
                # Generic fallback: try to match any by title or by pid
                matched_addresses=($(echo "$clients" | jq -r --arg title "$media_title" \
                    '.[] | select(.title | contains($title)) | .address'))
                pid=$(playerctl metadata --player="$player" --format '{{pid}}')
                if [ "${#matched_addresses[@]}" -eq 0 ] && [ -n "$pid" ]; then
                    matched_addresses=($(echo "$clients" | jq -r --arg pid "$pid" \
                        '.[] | select(.pid | tostring == $pid) | .address'))
                fi
            fi

            for address in "${matched_addresses[@]}"; do
                curr_tag=$(echo "$clients" | jq -r ".[] | select(.address==\"$address\") | .tags")
                if [[ "$status" == "Playing" ]]; then
                    if [[ "$curr_tag" != *"media"* ]]; then
                        hyprctl dispatch tagwindow media address:"$address"
                        echo "Playing: tagged address $address" >> $LOG
                    else
                        echo "Playing: address $address already tagged" >> $LOG
                    fi
                else
                    if [[ "$curr_tag" == *"media"* ]]; then
                        hyprctl dispatch tagwindow media address:"$address"
                        echo "Stopped: removed tag from address $address" >> $LOG
                    else
                        echo "Stopped: address $address not tagged" >> $LOG
                    fi
                fi
            done

            if [ "${#matched_addresses[@]}" -eq 0 ]; then
                if [[ "$player" == "spotify" ]]; then
                    echo "No matching window for status=$status, player=spotify, pid=${pid}" >> $LOG
                else
                    echo "No matching window for status=$status, player=$player, title=$media_title, pid=$pid" >> $LOG
                fi
            fi
        fi
    fi
done