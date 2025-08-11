if [[ ! -x $HOME/.local/bin/pathpicker && -f $HOME/.local/src/pathpicker.go ]]; then
    if command -v go >/dev/null 2>&1; then
        go build -o "$HOME/.local/bin/pathpicker" "$HOME/.local/src/pathpicker.go" >/dev/null 2>&1
    fi
fi
