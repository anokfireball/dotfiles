#!/bin/bash
# Dracula Theme Palette (ARGB 0xAARRGGBB)
# Generated integration palette for Sketchybar + Borders

# Core surfaces
export DRACULA_BG=0xff282A36        # Base background
export DRACULA_BG_ALT=0xff303341     # Slightly elevated surface
export DRACULA_SURFACE_DIM=0xff21222C
export DRACULA_BORDER=0xff44475A     # Border / divider / current line
export DRACULA_ELEVATED=0xdd303344   # Elevated popup background (with alpha)

# Text
export DRACULA_FG=0xffF8F8F2
export DRACULA_FG_DIM=0xffB6B7B2
export DRACULA_FG_INVERT=0xff000000

# Accents
export DRACULA_PURPLE=0xffBD93F9   # Primary accent
export DRACULA_PINK=0xffFF79C6     # Secondary accent / media
export DRACULA_CYAN=0xff8BE9FD     # Info / volume
export DRACULA_GREEN=0xff50FA7B    # Success / battery high
export DRACULA_ORANGE=0xffFFB86C   # Attention / medium battery
export DRACULA_RED=0xffFF5555      # Error / battery low
export DRACULA_YELLOW=0xffF1FA8C   # Warning / threshold
export DRACULA_COMMENT=0xff6272A4  # Muted / grey semantic

# Alpha helpers (string fragments, not full colors)
export ALPHA_FULL=ff
export ALPHA_HIGH=dd
export ALPHA_MED=aa
export ALPHA_LOW=66
export ALPHA_GLASS=33

# Semantic layer (high-level usage)
export SURFACE_BASE=$DRACULA_BG
export SURFACE_ALT=$DRACULA_BG_ALT
export SURFACE_DIM=$DRACULA_SURFACE_DIM
export SURFACE_ELEVATED=$DRACULA_ELEVATED

export TEXT_PRIMARY=$DRACULA_FG
export TEXT_SECONDARY=$DRACULA_FG_DIM
export TEXT_MUTED=$DRACULA_COMMENT
export TEXT_INVERT=$DRACULA_FG_INVERT

export ACCENT_PRIMARY=$DRACULA_PURPLE     # Reserved: outer screen focus / primary
export ACCENT_SECONDARY=$DRACULA_PINK     # Media / ephemeral
export ACCENT_ACTIVE_NUMBER=$DRACULA_PINK # Active workspace number color
export ACCENT_INFO=$DRACULA_CYAN
export ACCENT_OK=$DRACULA_GREEN
export ACCENT_WARN=$DRACULA_YELLOW
export ACCENT_ATTENTION=$DRACULA_ORANGE
export ACCENT_ERROR=$DRACULA_RED

export BORDER_DEFAULT=$DRACULA_BORDER
export BORDER_SUBTLE=0x6644475A
export BORDER_FOCUS=$ACCENT_PRIMARY

# Tints / overlays
export TINT_SELECTION=0x22BD93F9
export TINT_ACTIVE_SPACE=0x18282A36
export TINT_ALERT=0x33FF5555
