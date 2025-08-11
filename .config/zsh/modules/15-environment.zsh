export PATH="$HOME/.local/bin:$PATH"
if [[ -d "$HOME/.krew" ]]; then
    export PATH="$HOME/.krew/bin:$PATH"
fi

export VISUAL=vim
export EDITOR=vim

export GPG_TTY=$(tty)

export OPENCODE_MODEL_BUILD="github-copilot/claude-sonnet-4"
export OPENCODE_MODEL_PLAN="github-copilot/claude-3.7-sonnet"
