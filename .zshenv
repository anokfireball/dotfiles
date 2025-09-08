export PATH="$HOME/.local/bin:$PATH"
if [[ -d "$HOME/.krew" ]]; then
    export PATH="$HOME/.krew/bin:$PATH"
fi

if [[ -f "$HOME/.work/.zshenv" ]]; then
    source "$HOME/.work/.zshenv"
fi
