#!/bin/bash
layout=$(hyprctl -j devices | jq -r '.keyboards[0].active_keymap')
if [[ $layout == "English (US)" ]]; then
    result="English"
elif [[ $layout == "Swedish" ]]; then
    result="Svenska"
else
    result=$layout
fi
echo "  $result"