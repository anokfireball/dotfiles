if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    BREW_PREFIX=/home/linuxbrew/.linuxbrew
elif [[ -f /opt/homebrew/bin/brew ]]; then
    BREW_PREFIX=/opt/homebrew
elif [[ -f /usr/local/bin/brew ]]; then
    BREW_PREFIX=/usr/local
fi

if [[ -n "$BREW_PREFIX" ]]; then
    eval "$(${BREW_PREFIX}/bin/brew shellenv zsh)"

    export HOMEBREW_NO_INSTALL_CLEANUP=TRUE

    if [[ -d "${BREW_PREFIX}/opt/tpm/" && ! -d ~/.tmux/plugins/tpm/ ]]; then
        mkdir -p ~/.tmux/plugins/
        ln -sf "${BREW_PREFIX}/opt/tpm/share/tpm/" ~/.tmux/plugins/tpm
    fi
fi
