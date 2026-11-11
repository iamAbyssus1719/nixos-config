#!/bin/bash

INFO=$(hyprctl activewindow -j)
IS_FLOATING=$(echo "$INFO" | jq -r '.floating')
WINDOW_CLASS=$(echo "$INFO" | jq -r '.class')

hyprctl dispatch 'hl.dsp.window.float({ action = "toggle" })'

if [ "$IS_FLOATING" = "false" ]; then
    sleep 0.05

    case $WINDOW_CLASS in
        "cava")    W=900;  H=100 ;;
        "wezterm") W=550;  H=300 ;;
        "Thunar")  W=1000; H=650 ;;
        *)         W=800;  H=500 ;;
    esac

    hyprctl dispatch "hl.dsp.window.resize({ x = $W, y = $H, relative = false })"
    hyprctl dispatch 'hl.dsp.window.center()'
fi
