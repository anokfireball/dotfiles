#!/usr/bin/env bash

AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
AEROSPACE_WORKSPACE_FOCUSED_MONITOR=$(aerospace list-workspaces --monitor focused --empty no)
AEROSPACE_EMPTY_WORKSPACE=$(aerospace list-workspaces --monitor focused --empty)

reload_workspace_icon() {
  apps=$(aerospace list-windows --workspace "$@" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip=" —"
  fi

  sketchybar --animate sin 10 --set space.$@ label="$icon_strip"
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  source "$CONFIG_DIR/colors.sh"

  reload_workspace_icon "$PREV_WORKSPACE"
  reload_workspace_icon "$FOCUSED_WORKSPACE"



  sketchybar --set space.$FOCUSED_WORKSPACE icon.color=$ACCENT_ACTIVE_NUMBER \
                         label.color=$WHITE \
                         background.border_color=${ACCENT_PRIMARY:-$BACKGROUND_2} background.color=$TINT_ACTIVE_SPACE

  sketchybar --set space.$PREV_WORKSPACE icon.color=$WHITE \
                         label.color=$GREY \
                         background.color=$BACKGROUND_1 \
                         background.border_color=$BACKGROUND_2

  for i in $AEROSPACE_WORKSPACE_FOCUSED_MONITOR; do
    sketchybar --set space.$i display=$(($(aerospace list-monitors | wc -l) + 1 - $AEROSPACE_FOCUSED_MONITOR))
  done

  for i in $AEROSPACE_EMPTY_WORKSPACE; do
    sketchybar --set space.$i display=0
  done

  sketchybar --set space.$AEROSPACE_FOCUSED_WORKSPACE display=$AEROSPACE_FOCUSED_MONITOR
fi