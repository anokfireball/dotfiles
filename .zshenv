export EDITOR=nvim
export VISUAL=nvim

export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

export OPENCODE_MODEL_SMALL="github-copilot/gpt-5-mini"
export OPENCODE_MODEL_BUILD="github-copilot/claude-sonnet-4.5"
export OPENCODE_MODEL_DOCS="github-copilot/gpt-5-mini"
export OPENCODE_MODEL_PLAN="github-copilot/gpt-5"
export OPENCODE_MODEL_RESEARCH="github-copilot/claude-sonnet-4.5"
export OPENCODE_MODEL_REVIEW="github-copilot/gpt-5-codex"
export OPENCODE_MODEL_SCOUT="github-copilot/claude-haiku-4.5"
export OPENCODE_MODEL_TICKET="github-copilot/claude-sonnet-4.5"

if [[ -f "$HOME/.work/.zshenv" ]]; then
    source "$HOME/.work/.zshenv"
fi
