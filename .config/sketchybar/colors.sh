#!/bin/bash

# Unified theme loader (Dracula primary)
# Sources Dracula palette; provides backward compatible variable names.

PALETTE_FILE="${CONFIG_DIR:-$HOME/.config/sketchybar}/palette_dracula.sh"
[ -f "$PALETTE_FILE" ] && source "$PALETTE_FILE"

if [ -n "$DRACULA_BG" ]; then
  # Map Dracula palette to legacy generic names (for plugins/items expecting old vars)
  export BLACK=0xff000000
  export WHITE=$DRACULA_FG
  export RED=$DRACULA_RED
  export GREEN=$DRACULA_GREEN
  export BLUE=$DRACULA_CYAN
  export YELLOW=$DRACULA_YELLOW
  export ORANGE=$DRACULA_ORANGE
  export MAGENTA=$DRACULA_PURPLE
  export GREY=$DRACULA_COMMENT
  export TRANSPARENT=0x00000000
  export BG0=$DRACULA_BG
  export BG1=$DRACULA_BG_ALT
  export BG2=$DRACULA_BORDER

  # Battery gradients (high -> critical)
  export BATTERY_1=$DRACULA_GREEN
  export BATTERY_2=$DRACULA_YELLOW
  export BATTERY_3=$DRACULA_ORANGE
  export BATTERY_4=$DRACULA_PINK
  export BATTERY_5=$DRACULA_RED

  # Primary accent semantic
  export ACCENT_PRIMARY=$DRACULA_PURPLE

  # Bar / popup mappings
  export BAR_COLOR=$BG0
  export BAR_BORDER_COLOR=0x6644475A  # subtle translucent border
  export BACKGROUND_1=$BG1
  export BACKGROUND_2=$BG2
  export ICON_COLOR=$WHITE
  export LABEL_COLOR=$WHITE
  export POPUP_BACKGROUND_COLOR=$DRACULA_ELEVATED
  export POPUP_BORDER_COLOR=$DRACULA_BORDER
  export SHADOW_COLOR=$BLACK
else
  # Fallback to previous Sonokai defaults if palette missing
  export BLACK=0xff181819
  export WHITE=0xffe2e2e3
  export RED=0xfffc5d7c
  export GREEN=0xff9ed072
  export BLUE=0xff76cce0
  export YELLOW=0xffe7c664
  export ORANGE=0xfff39660
  export MAGENTA=0xffb39df3
  export GREY=0xff7f8490
  export TRANSPARENT=0x00000000
  export BG0=0xff2c2e34
  export BG1=0xff363944
  export BG2=0xff414550

  export BATTERY_1=0xffa6da95
  export BATTERY_2=0xffeed49f
  export BATTERY_3=0xfff5a97f
  export BATTERY_4=0xffee99a0
  export BATTERY_5=0xffed8796

  export BAR_COLOR=$BG0
  export BAR_BORDER_COLOR=$BG2
  export BACKGROUND_1=$BG1
  export BACKGROUND_2=$BG2
  export ICON_COLOR=$WHITE
  export LABEL_COLOR=$WHITE
  export POPUP_BACKGROUND_COLOR=$BAR_COLOR
  export POPUP_BORDER_COLOR=$WHITE
  export SHADOW_COLOR=$BLACK
fi
