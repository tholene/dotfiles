#!/bin/bash
img=$(find ~/Pictures/Wallpapers -type f | shuf -n 1)
swww img "$img" -t any --transition-duration 0.5 --transition-fps 240 --transition-step 255