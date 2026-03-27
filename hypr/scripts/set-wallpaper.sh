#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
LAST_INDEX_FILE="$HOME/.last_wallpaper_index"
SYMLINK_PATH="$WALLPAPER_DIR/ACTIVE_WALLPAPER.jpg"

mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort)
NUM_WALLPAPERS=${#WALLPAPERS[@]}

if [[ -f "$LAST_INDEX_FILE" ]]; then
    INDEX=$(< "$LAST_INDEX_FILE")
else
    INDEX=-1
fi

INDEX=$(( (INDEX + 1) % NUM_WALLPAPERS ))
NEW_WALLPAPER="${WALLPAPERS[$INDEX]}"

ln -sf "${NEW_WALLPAPER}" "$SYMLINK_PATH"

awww img "${SYMLINK_PATH}" -t grow --transition-duration 0.4 --transition-fps 240 --transition-step 255 --transition-pos center

echo "$INDEX" > "$LAST_INDEX_FILE"
