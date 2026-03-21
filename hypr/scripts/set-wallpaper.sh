#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

LAST_INDEX_FILE="$HOME/.last_wallpaper_index"

mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort)

NUM_WALLPAPERS=${#WALLPAPERS[@]}

if [[ -f "$LAST_INDEX_FILE" ]]; then
    INDEX=$(< "$LAST_INDEX_FILE")
else
    INDEX=-1
fi

INDEX=$(( (INDEX + 1) % NUM_WALLPAPERS ))

swww img "${WALLPAPERS[$INDEX]}" -t grow --transition-duration 0.4 --transition-fps 240 --transition-step 255 --transition-pos center

echo "$INDEX" > "$LAST_INDEX_FILE"