#!/bin/bash

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr_opacity_reduced"

if [ -f "$STATE_FILE" ]; then
    # Estaba reducida -> volver a normal
    hyprctl eval 'hl.config({ decoration = { active_opacity = 1.0, inactive_opacity = 1.0 } })'
    rm -f "$STATE_FILE"
else
    hyprctl eval 'hl.config({ decoration = { active_opacity = 0.95, inactive_opacity = 0.80 } })'
    touch "$STATE_FILE"
fi
