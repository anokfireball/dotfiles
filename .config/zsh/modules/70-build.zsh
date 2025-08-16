if [[ ! -x $HOME/.local/bin/pathpicker && -f $HOME/.local/src/pathpicker/main.go ]]; then
    if command -v go >/dev/null 2>&1; then
        go build -o "$HOME/.local/bin/pathpicker" "$HOME/.local/src/pathpicker" >/dev/null 2>&1
    fi
fi
if [[ ! -x $HOME/.local/bin/urlpicker && -d $HOME/.local/src/urlpicker ]]; then
    if command -v go >/dev/null 2>&1; then
        (cd "$HOME/.local/src/urlpicker" && go build -o "$HOME/.local/bin/urlpicker" .) >/dev/null 2>&1
    fi
fi
