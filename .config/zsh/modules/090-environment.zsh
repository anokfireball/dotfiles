export GPG_TTY=$(tty)

# PATH modifications (must run after 035-homebrew.zsh to ensure correct precedence)
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
if [[ -d "$HOME/.krew/bin" ]]; then
    export PATH="$HOME/.krew/bin:$PATH"
fi

# Update tmux server environment to match current shell
# This ensures popups inherit the correct PATH and environment variables
if [[ -n "$TMUX" ]]; then
    tmux set-environment -g PATH "$PATH" 2>/dev/null || true
    tmux set-environment -g LG_CONFIG_FILE "$LG_CONFIG_FILE" 2>/dev/null || true
fi
