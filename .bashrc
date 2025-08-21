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

if [ ! -d ~/.local/bin/ ]; then
    mkdir -p ~/.local/bin/
fi

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

    mkdir -p ~/.tmux/plugins/
    if [[ -d "${BREW_PREFIX}/opt/tpm/" && ! -d ~/.tmux/plugins/tpm/ ]]; then
        ln -s "${BREW_PREFIX}/opt/tpm/share/tpm/" ~/.tmux/plugins/tpm
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

if [ ! -f ~/.local/bin/pathpicker ] && [ -f ~/.local/src/pathpicker/main.go ]; then
    if command -v go >/dev/null 2>&1; then
        cd ~/.local/src/pathpicker && go build -o ~/.local/bin/pathpicker .
    fi
fi
if [ ! -f ~/.local/bin/urlpicker ] && [ -f ~/.local/src/urlpicker/main.go ]; then
    if command -v go >/dev/null 2>&1; then
        cd ~/.local/src/urlpicker && go build -o ~/.local/bin/urlpicker .
    fi
fi

if command -v delta &>/dev/null; then
    eval "$(delta --generate-completion bash)"
    ln -sf ~/.gitconfig_delta ~/.gitconfig_delta_active
else
    rm -f ~/.gitconfig_delta_active
fi
if command -v fzf >/dev/null 2>&1; then
    FZF_ALT_C_COMMAND='' eval "$(fzf --bash)"
fi
if command -v bat &>/dev/null; then
    eval "$(bat --completion bash)"
fi
if command -b stern &>/dev/null; then
    eval "$(stern --completion bash)"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi
if [[ -d "$HOME/.krew" ]]; then
    export PATH="$HOME/.krew/bin:$PATH"
fi
export PATH="$HOME/.local/bin:$PATH"
export VISUAL=vim
export EDITOR=vim
export GPG_TTY=$(tty)
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"
export OPENCODE_MODEL_BUILD="github-copilot/claude-sonnet-4"
export OPENCODE_MODEL_PLAN="github-copilot/gpt-5"
export OPENCODE_MODEL_REVIEW="github-copilot/gemini-2.5-pro"
export OPENCODE_MODEL_TICKET="github-copilot/claude-3.7-sonnet"
export OPENCODE_MODEL_RESEARCH="github-copilot/gpt-5-mini"

if [ -f ~/.work/.bashrc ]; then
    source ~/.work/.bashrc
fi

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --cmd cd)"
fi

if [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ] && [ -z "$SSH_TTY" ]; then
    if command -v tmux >/dev/null 2>&1; then
        if tmux has-session -t main 2>/dev/null; then
            tmux attach -t main
        else
            exec tmux new-session -s main
            exit
        fi
    fi
fi
