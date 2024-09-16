# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) ;;
esac

# нєяє вє ∂яαgσиѕ #

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
        source "${BREW_PREFIX}/etc/profile.d/bash_completion.sh"
    fi
    for COMPLETION in "${BREW_PREFIX}/etc/bash_completion.d/"*; do
        if [[ -r "${COMPLETION}" ]]; then
            source "${COMPLETION}"
        fi
    done

    export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
fi

# manual completions
for COMPLETION in /usr/share/bash-completion/completions/*; do
    if [[ -r "${COMPLETION}" ]]; then
        source "${COMPLETION}"
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
