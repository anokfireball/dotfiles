# Enable vi-mode (command + insert modes)
bindkey -v
# Use bash-like word boundaries
autoload -Uz select-word-style
select-word-style bash

# Custom keybindings
bindkey "^[[1;2C" forward-word   # Shift+Right Arrow
bindkey "^[[1;2D" backward-word  # Shift+Left Arrow
