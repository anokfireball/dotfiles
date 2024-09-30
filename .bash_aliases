# ESC-ESC: toggle `sudo` before the current or previous command
bind -x '"\e\e": sude'
sude() {
  local command
  if [ -z "$READLINE_LINE" ]; then
    command=$(fc -ln -0 | awk '{$1=$1;print}')
  else
    command=$(echo "$READLINE_LINE" | awk '{$1=$1;print}')
  fi

  if [[ $command == sudo* ]]; then
    command=${command#sudo }
  else
    command="sudo $command"
  fi

  READLINE_LINE="$command"
  READLINE_POINT=${#READLINE_LINE}
}

upgrade() {
  if command -v apt &>/dev/null; then
    sudo apt update -qq && sudo apt upgrade -y -qq
  fi
  if command -v yay &>/dev/null; then
    yay -Syu --noconfirm --quiet
  elif command -v pacman &>/dev/null; then
    sudo pacman -Syu --noconfirm --quiet
  fi
  if command -v flatpak &>/dev/null; then
    sudo flatpak update -y -q
  fi
  if command -v snap &>/dev/null; then
    sudo snap refresh
  fi
  if command -v brew &>/dev/null; then
    brew update --quiet && brew upgrade --quiet
  fi
}

if command -v bat &>/dev/null; then
  alias cat='bat'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"

  export BAT_THEME="Dracula"
fi

if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='eza --group-directories-first -lb --color-scale=all --git --git-repos'
  l.() {
    if [ "$#" -eq 0 ]; then
      # just assume CWD when no args is given
      set -- "."
    fi
    for dir in "$@"; do
      [ "$#" -gt 1 ] && echo "$dir:"
      (cd "$dir" && command eza --group-directories-first -lb --color-scale=all --git --git-repos -ad .*)
      if [ "$#" -gt 1 ] && [ "$dir" != "${@: -1}" ]; then
        echo ""
      fi
    done
  }
fi

if command -v fd &>/dev/null; then
  fd() {
    current_dir=$(realpath "$PWD")
    home=$(realpath "$HOME")
    if [[ $current_dir == $home || $current_dir == $home/* ]]; then
      # workaround for this dotfile config repo
      command fd --no-ignore-vcs "$@"
    else
      command fd "$@"
    fi
  }
fi

if command -v fzf &>/dev/null; then
  # TODO https://github.com/lincheney/fzf-tab-completion/
  _fzf_setup_completion dir cd eza fd find mkdir ls ll l. rmdir tree z zoxide
  _fzf_setup_completion path bat cat cp g git k kubectl ln mv nvim rm v vi vim

  export FZF_COMPLETION_TRIGGER="''"
fi

if command -v fzf &>/dev/null && command -v bfs &>/dev/null; then
  _fzf_compgen_path() {
    bfs -H "$1" -color -exclude \( -name .git \) 2>/dev/null
  }

  _fzf_compgen_dir() {
    bfs -H "$1" -color -exclude \( -name .git \) -type d 2>/dev/null
  }

  export FZF_DIR_COMMAND='bfs . -color -mindepth 1 -exclude \( -name .git \) -type d | sed \"s/\.\///g\" 2>/dev/null'
  export FZF_FILE_COMMAND='bfs . -color -mindepth 1 -exclude \( -name .git \) -type f | sed \"s/\.\///g\" 2>/dev/null'

  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --ansi --bind 'alt-d:reload(eval \"$FZF_DIR_COMMAND\"),alt-f:reload(eval \"$FZF_FILE_COMMAND\")'"
  export FZF_CTRL_T_COMMAND="bfs -color -mindepth 1 -exclude \( -name .git \) -printf '%P\n' 2>/dev/null"
  export FZF_ALT_C_COMMAND="bfs -color -mindepth 1 -exclude \( -name .git \) -type d -printf '%P\n' 2>/dev/null"
fi

if command -v git &>/dev/null; then
  alias g=git
  if [ -n "$(type -t __git_complete)" ]; then
    __git_complete g __git_main
  fi
fi

if command -v kubectl &>/dev/null; then
  alias k=kubectl
  if [ -n "$(type -t __start_kubectl)" ]; then
    complete -F __start_kubectl k
  fi

  klsctx() {
    if [ -n "$1" ]; then
      kubectl config get-contexts | grep "$1"
    else
      kubectl config get-contexts
    fi
  }
  alias kctx='kubectl config use-context'
  _kctx_completions() {
    COMPREPLY=($(compgen -W "$(kubectl config get-contexts | awk 'NR>1 {gsub(/^\*/, ""); print $1}')" -- "${COMP_WORDS[COMP_CWORD]}"))
  }
  complete -F _kctx_completions kctx

  klsns() {
    if [ -n "$1" ]; then
      kubectl get ns | grep "$1"
    else
      kubectl get ns
    fi
  }
  alias kns='kubectl config set-context --current --namespace'
  _kns_completions() {
    COMPREPLY=($(compgen -W "$(kubectl get ns | awk 'NR>1 {print $1}')" -- "${COMP_WORDS[COMP_CWORD]}"))
  }
  complete -F _kns_completions kns
fi

if command -v kubectl &>/dev/null && command -v fzf &>/dev/null; then
  _fzf_completions() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"
    case "$prev" in
    kctx)
      COMPREPLY=($(compgen -W "$(kubectl config get-contexts | awk 'NR>1 {gsub(/^\*/, ""); print $1}')" -- "${COMP_WORDS[COMP_CWORD]}"))
      ;;
    kns)
      COMPREPLY=($(compgen -W "$(kubectl get ns | awk 'NR>1 {print $1}')" -- "$cur"))
      ;;
    esac

    if [[ ${#COMPREPLY[@]} -gt 1 ]]; then
      COMPREPLY=($(printf "%s\n" "${COMPREPLY[@]}" | fzf))
    fi
  }
  complete -F _fzf_completions kctx
  complete -F _fzf_completions kns
fi

if command -v nvim &>/dev/null; then
  ln -sf $(command -v nvim) ~/.local/bin/vi
  ln -sf $(command -v nvim) ~/.local/bin/vim

  alias v='nvim'
fi

if command -v rg &>/dev/null; then
  rg() {
    current_dir=$(realpath "$PWD")
    home=$(realpath "$HOME")
    if [[ $current_dir == $home || $current_dir == $home/* ]]; then
      # workaround for this dotfile config repo
      command rg -u "$@"
    else
      command rg "$@"
    fi
  }
fi
