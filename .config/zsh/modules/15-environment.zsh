export PATH="$HOME/.local/bin:$PATH"
if [[ -d "$HOME/.krew" ]]; then
    export PATH="$HOME/.krew/bin:$PATH"
fi

export VISUAL=vim
export EDITOR=vim

export GPG_TTY=$(tty)

export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

export OPENCODE_MODEL_BUILD="github-copilot/claude-sonnet-4"
export OPENCODE_MODEL_DOCS="github-copilot/claude-3.7-sonnet"
export OPENCODE_MODEL_PLAN="github-copilot/gpt-5"
export OPENCODE_MODEL_RESEARCH="github-copilot/gpt-5-mini"
export OPENCODE_MODEL_REVIEW="github-copilot/gemini-2.5-pro"
export OPENCODE_MODEL_TICKET="github-copilot/claude-3.7-sonnet"
