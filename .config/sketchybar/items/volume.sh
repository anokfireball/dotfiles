#!/bin/bash

volume=(
    icon=$VOLUME_100
    label="100%"
    icon.font="$FONT:Black:16.0"
    icon.padding_right=5
    label.align=left
    label.font="$FONT:Black:16.0"
    padding_left=5
    padding_right=5
    script="$PLUGIN_DIR/volume.sh"
)

sketchybar -m --add item volume right \
    --set volume "${volume[@]}" \
    --subscribe volume volume_change
