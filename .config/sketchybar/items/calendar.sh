#!/bin/bash

calendar=(
  icon=􀐫
  icon.font="$FONT:Black:16.0"
  icon.padding_right=5
  label.align=left
  label.font="$FONT:Black:16.0"
  padding_left=5
  padding_right=5
  update_freq=5
  script="$PLUGIN_DIR/calendar.sh"
)

sketchybar --add item calendar right       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke
