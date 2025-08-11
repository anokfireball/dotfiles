if command -v gsed &>/dev/null; then
    ln -sf "$(command -v gsed)" "$HOME/.local/bin/sed"
fi
