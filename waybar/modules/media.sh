#!/bin/sh

# Set icons (for Nerd Fonts/FontAwesome)
spotify_icon=" "
chrome_icon=" "

# Try Spotify first
class=$(playerctl metadata --player=spotify --format '{{lc(status)}}' 2>/dev/null)
if [[ $class == "playing" ]]; then
    info=$(playerctl metadata --player=spotify --format '{{artist}} - {{title}}')
    [ ${#info} -gt 40 ] && info="$(echo $info | cut -c1-40)..."
    text="${info} ${spotify_icon}"
elif [[ $class == "paused" || $class == "stopped" || -z $class ]]; then
    # Fallback: try Chrome/Chromium
    # List running mpris player names with playerctl -l, filter for browser
    browser_player=$(playerctl -l | grep -E 'chrome|chromium' | head -n1)
    if [ -n "$browser_player" ]; then
        browser_status=$(playerctl metadata --player="$browser_player" --format '{{lc(status)}}' 2>/dev/null)
        if [[ $browser_status == "playing" ]]; then
            title=$(playerctl metadata --player="$browser_player" --format '{{xesam:title}}')
            artist=$(playerctl metadata --player="$browser_player" --format '{{xesam:artist}}')
            info="${artist:+$artist - }${title}"
            [ ${#info} -gt 40 ] && info="$(echo $info | cut -c1-40)..."
            text="${info} ${chrome_icon}"
            class="$browser_status"
        else
            text="$chrome_icon"
            class="$browser_status"
        fi
    else
        text=""
        class="stopped"
    fi
fi

echo -e "{\"text\":\"$text\", \"class\":\"$class\"}"