#!/bin/sh
cliphist list | wofi --dmenu -I -n -W 20% -H 30% -i -p "Clipboard history..." | awk '{print $1}' | xargs -r cliphist decode | wl-copy