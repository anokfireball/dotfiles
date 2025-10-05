# Note: fzf initialization moved to 032-vi-mode.zsh hook
# to prevent keybinding conflicts with zsh-vi-mode
# Original code:
# if command -v fzf &>/dev/null; then
#     eval "$(fzf --zsh)"
# fi

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
fi
