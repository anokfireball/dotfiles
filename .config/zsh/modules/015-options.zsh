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
# Write commands immediately
setopt inc_append_history
# Save timestamp + duration in history file
setopt extended_history
# Reduce Redundant Whitespace in Saved Commands
setopt hist_reduce_blanks
# Use File Control Locking to Avoid History Corruption with Concurrent Shells (Ignore if Unsupported)
setopt hist_fcntl_lock
# Enable extended globbing for advanced patterns
setopt extendedglob
# Don't store history/fc commands in history
setopt hist_no_store
# Don't store function definitions in history
setopt hist_no_functions

# Large in-memory history; persisted size (SAVEHIST) set slightly smaller to limit disk usage
HISTSIZE=500000
SAVEHIST=100000
# Set history file location
HISTFILE="$HOME/.zsh_history"

# Ensure history directory exists if HISTFILE is defined
[[ -n $HISTFILE ]] && mkdir -p "${HISTFILE:h}" 2>/dev/null || true

# Use HISTORY_IGNORE to filter commands that start with blacklisted terms (with optional sudo prefix)
HISTORY_IGNORE='(#s)[[:space:]]#(|sudo[[:space:]]##)(bg|fg|jobs|exit|logout|clear|reset|true|:)*'
