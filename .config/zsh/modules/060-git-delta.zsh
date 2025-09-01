if command -v delta &>/dev/null; then
    ln -sf ~/.gitconfig_delta ~/.gitconfig_delta_active
else
    rm -f ~/.gitconfig_delta_active
fi
