# inspired by https://github.com/mrzool/bash-sensible/blob/master/sensible.bash

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Guard variable to ensure the file is only sourced once
if [ -n "${_BASHRC_SOURCED}" ]; then
    return
fi
_BASHRC_SOURCED=1

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Record each line as it gets issued
PROMPT_COMMAND='history -a'

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2>/dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*) ;;
esac

# нєяє вє ∂яαgσиѕ #

if [ -f ~/.bash_ssh_agent ]; then
    source ~/.bash_ssh_agent
fi

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    BREW_PREFIX=/home/linuxbrew/.linuxbrew
elif [ -f /opt/homebrew/bin/brew ]; then
    BREW_PREFIX=/opt/homebrew
elif [ -f /usr/local/bin/brew ]; then
    BREW_PREFIX=/usr/local
fi
if [ -n "$BREW_PREFIX" ]; then
    eval "$(${BREW_PREFIX}/bin/brew shellenv)"

    # brew completions
    if [[ -r "${BREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${BREW_PREFIX}/etc/profile.d/bash_completion.sh" 2>/dev/null
    fi
    for COMPLETION in "${BREW_PREFIX}/etc/bash_completion.d/"*; do
        if [[ -r "${COMPLETION}" ]]; then
            source "${COMPLETION}" 2>/dev/null
        fi
    done

    # nvm
    if [ -s "${BREW_PREFIX}/opt/nvm/nvm.sh" ]; then
        export NVM_DIR="$HOME/.nvm"
        source "${BREW_PREFIX}/opt/nvm/nvm.sh"
    fi

    export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
fi

# manual completions
for COMPLETION in /usr/share/bash-completion/completions/*; do
    if [[ -r "${COMPLETION}" ]]; then
        source "${COMPLETION}" 2>/dev/null
    fi
done

if [ -f ~/.binary_check ]; then
    source ~/.binary_check
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi
export PATH="$HOME/.local/bin:$PATH"
export VISUAL=vim
export EDITOR=vim
export GPG_TTY=$(tty)

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
