# ~/.zshrc - interactive shell (modular)


# Instant Prompt (Powerlevel10k) MUST Stay at Top
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Only proceed if interactive
[[ $- != *i* ]] && return

# Module dispatcher
_zsh_modules_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/modules"
if [[ -d $_zsh_modules_dir ]]; then
  for m in $_zsh_modules_dir/*.zsh(Nn); do
    # shellcheck disable=SC1090
    source "$m"
  done
fi
