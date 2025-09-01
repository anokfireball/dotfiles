# Interactive Behavior
# Allow comments (# ...) in interactive commands
setopt interactive_comments
# Enable parameter expansion / substitution in prompts
setopt prompt_subst
# Prevent accidental overwrite with > (use >| to force)
setopt noclobber
# Disable terminal bell
unsetopt beep
# Disable Terminal Flow Control (Ctrl-S / Ctrl-Q)
setopt no_flow_control

# History Options
# Remove older duplicate commands, keep most recent
setopt hist_ignore_all_dups
# Do not record commands starting with a space
setopt hist_ignore_space
# Share history across all sessions in real-time
setopt share_history
# Append rather than overwrite history file on shell exit
setopt append_history
# Save timestamp + duration in history file
setopt extended_history
# Reduce Redundant Whitespace in Saved Commands
setopt hist_reduce_blanks
# Use File Control Locking to Avoid History Corruption with Concurrent Shells (Ignore if Unsupported)
setopt hist_fcntl_lock 2>/dev/null || true

# Large in-memory history; persisted size (SAVEHIST) set slightly smaller to limit disk usage
HISTSIZE=500000
SAVEHIST=100000

# Ensure history directory exists if HISTFILE is defined
[[ -n $HISTFILE ]] && mkdir -p "${HISTFILE:h}" 2>/dev/null || true

# HISTIGNORE: colon-separated patterns similar to bash; & repeats, suppress trivial commands
: ${HISTIGNORE:="&:exit:ls:bg:fg:history:clear"}

# HISTIGNORE implementation (zsh lacks native variable for this bash behavior)
zshaddhistory() {
    emulate -L zsh
    local line=$1 pat
    [[ -z $HISTIGNORE ]] && return 0
    for pat in "${(@s/:/)HISTIGNORE}"; do
        [[ -z $pat ]] && continue
        case $line in
            ${(~j:|:)pat}) return 1 ;;     # Reject (do not add) if matches pattern list
        esac
    done
    return 0
}
