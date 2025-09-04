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
zstyle ':fzf-tab:*' fzf-bindings 'right:accept'
zstyle ':fzf-tab:*' fzf-flags --border --ansi
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:complete:*:*' fzf-flags --preview-window=right:50%:wrap
zstyle ':fzf-tab:complete:*:options' fzf-preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview '(( $+commands[eza] )) && eza -1 --color=always --icons -- "$realpath" || ls -1 --color=always -- "$realpath"'
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  if [[ -n $realpath ]]; then
    if [[ -d $realpath ]]; then
      if (( $+commands[eza] )); then
        eza --group-directories-first --git -1 --color=always --icons -- "$realpath"
      else
        ls -la --color=always -- "$realpath"
      fi
    elif [[ -f $realpath ]]; then
      if (( $+commands[bat] )); then
        bat --style=plain --color=always --pager=never --line-range=:300 -- "$realpath"
      else
        sed -n "1,300p" -- "$realpath"
      fi
      printf "\n---\n"; file -bL -- "$realpath" 2>/dev/null || true
    else
      file -bL -- "$realpath" 2>/dev/null || echo "$desc"
    fi
  fi
'
# Ghosted Suggestions From History
zcomet load zsh-users/zsh-autosuggestions
# History Substring Search With Arrow Keys
zcomet load zsh-users/zsh-history-substring-search
# Dracula theme highlighting
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#bd93f9,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#ff5555,bold'
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# Syntax Highlight After Suggestions (Must Load Last)
zcomet load zsh-users/zsh-syntax-highlighting
