# Quickly Add/Remove a Leading 'Sudo' on Current/Last Command Line
_sudo-toggle() {
    local buf=$BUFFER
    # Use last history line if current buffer empty
    [[ -z $buf ]] && buf=$(fc -nl -1)
    # Trim leading spaces
    buf=${buf## }
    if [[ $buf == sudo\ * ]]; then
        # Remove existing sudo
        buf=${buf#sudo }
    else
        # Prepend sudo
        buf="sudo $buf"
    fi
    BUFFER=$buf
    # Move cursor to end
    CURSOR=${#BUFFER}
}
zle -N _sudo-toggle
bindkey '``' _sudo-toggle
