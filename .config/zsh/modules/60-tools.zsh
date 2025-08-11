if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh)"
fi

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
fi
