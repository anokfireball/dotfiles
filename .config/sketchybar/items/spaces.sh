#!/bin/sh

sketchybar --add event aerospace_workspace_change

for m in $(aerospace list-monitors | awk '{print $1}'); do
  for i in $(aerospace list-workspaces --monitor $m); do
    sid=$i
    space=(
      space="$sid"
      icon="$sid"
      icon.padding_left=10
      icon.padding_right=10
      display=$(($(aerospace list-monitors | wc -l) + 1 - $m))
      padding_left=2
      padding_right=2
      background.color=$BACKGROUND_1
      background.border_color=$BACKGROUND_2
      label.padding_right=20
      label.color=$GREY
      label.font="sketchybar-app-font:Regular:16.0"
      label.y_offset=-1
      script="$PLUGIN_DIR/space_windows.sh"
    )

    sketchybar --add space space.$sid left \
               --set space.$sid "${space[@]}"

    apps=$(aerospace list-windows --workspace $sid | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    icon_strip=" "
    if [ "${apps}" != "" ]; then
      while read -r app
      do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
      done <<< "${apps}"
    else
      icon_strip=" —"
    fi

    sketchybar --set space.$sid label="$icon_strip"
  done

  for i in $(aerospace list-workspaces --monitor $m --empty); do
    sketchybar --set space.$i display=0
  done
done


space_creator=(
  icon=􀆊
  icon.font="$FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  script="$PLUGIN_DIR/space_windows.sh"
  #script="$PLUGIN_DIR/aerospace.sh"
  icon.color=$WHITE
)

sketchybar --add item space_creator left               \
           --set space_creator "${space_creator[@]}"   \
           --subscribe space_creator aerospace_workspace_change

# Trigger an initial workspace change event to apply styling to the focused workspace on startup
FOCUSED_WS=$(aerospace list-workspaces --focused)
if [ -n "$FOCUSED_WS" ]; then
  sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED_WS" PREV_WORKSPACE=""
fi
