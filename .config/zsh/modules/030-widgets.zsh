# Toggle sudo prefix on current command line (or last history entry if empty)
_sudo-toggle() {
    local buf=$BUFFER
    # Use last command from history if buffer is empty
    [[ -z $buf ]] && buf=$(fc -nl -1)
    # Strip leading whitespace
    buf=${buf## }
    # Toggle sudo: remove if present, add if absent
    if [[ $buf == sudo\ * ]]; then
        buf=${buf#sudo }
    else
        buf="sudo $buf"
    fi
    BUFFER=$buf
    # Move cursor to end of line
    CURSOR=${#BUFFER}
}
zle -N _sudo-toggle
