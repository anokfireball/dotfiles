#!/bin/bash

battery=(
    icon.font="$FONT:Black:16.0"
    icon.padding_right=5
    label.align=left
    label.font="$FONT:Black:16.0"
    padding_left=5
    padding_right=5
    script="$PLUGIN_DIR/battery.sh"
    update_freq=1
)

sketchybar -m --add item battery right \
    --set battery "${battery[@]}"
