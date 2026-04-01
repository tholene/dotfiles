#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
LAST_INDEX_FILE="$HOME/.last_wallpaper_index"
SYMLINK_PATH="$WALLPAPER_DIR/ACTIVE_WALLPAPER.jpg"

ln -sf "$1" "$SYMLINK_PATH"

awww img "${SYMLINK_PATH}" -t grow --transition-duration 0.4 --transition-fps 240 --transition-step 255 --transition-pos center

echo "$INDEX" > "$LAST_INDEX_FILE"

awww img $1 -t grow --transition-duration 0.4 --transition-fps 240 --transition-step 255 --transition-pos center

