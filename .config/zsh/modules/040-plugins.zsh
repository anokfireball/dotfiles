# Install location
export ZCOMET_HOME="${ZCOMET_HOME:-$HOME/.zcomet}"
# Cache for compiled files
export ZCOMET_CACHE="${ZCOMET_CACHE:-$HOME/.zcomet_cache}"
if [[ ! -f "$ZCOMET_HOME/zcomet.zsh" ]]; then
    git clone https://github.com/agkozak/zcomet "$ZCOMET_HOME" >/dev/null 2>&1
fi
source "$ZCOMET_HOME/zcomet.zsh"

# Prompt Theme (Fast, Async Segments)
zcomet load romkatv/powerlevel10k
# Additional Completion Definitions
zcomet load zsh-users/zsh-completions
# Replace Menu Selection With fzf Interface
zcomet load Aloxaf/fzf-tab
zstyle ':completion:*' menu no
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' fzf-flags --border
# Ghosted Suggestions From History
zcomet load zsh-users/zsh-autosuggestions
# Syntax Highlight After Suggestions (Must Load Last)
zcomet load zsh-users/zsh-syntax-highlighting
