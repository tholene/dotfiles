#!/bin/bash
img=$(find ~/Pictures/Wallpapers -type f | shuf -n 1)
swww img "$img" -t random --transition-duration 1