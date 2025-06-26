# `-`: toggle `sudo` before the current or previous command
bind -m vi-command '"``": "\ei``\C-["'
bind -x '"``": sude'
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

extract() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: extract <archive> <destination>"
    return 1
  fi

  local src="$1"
  local dest="$2"

  case "$src" in
  *.tar.bz2)
    mkdir -p "$dest"
    tar xjf "$src" -C "$dest"
    ;;
  *.tar.gz)
    mkdir -p "$dest"
    tar xzf "$src" -C "$dest"
    ;;
  *.tar.xz)
    mkdir -p "$dest"
    tar xJf "$src" -C "$dest"
    ;;
  *.bz2)
    mkdir -p "$dest"
    bunzip2 -c "$src" >"$dest"
    ;;
  *.rar)
    mkdir -p "$dest"
    unrar x "$src" "$dest"
    ;;
  *.gz)
    mkdir -p "$dest"
    gunzip -c "$src" >"$dest"
    ;;
  *.tar)
    mkdir -p "$dest"
    tar xf "$src" -C "$dest"
    ;;
  *.tbz2)
    mkdir -p "$dest"
    tar xjf "$src" -C "$dest"
    ;;
  *.tgz)
    mkdir -p "$dest"
    tar xzf "$src" -C "$dest"
    ;;
  *.zip)
    mkdir -p "$dest"
    unzip "$src" -d "$dest"
    ;;
  *.7z)
    mkdir -p "$dest"
    7z x "$src" -o"$dest"
    ;;
  *.xz)
    mkdir -p "$dest"
    unxz -c "$src" >"$dest"
    ;;
  *) echo "extract: '$src' - unknown archive format" ;;
  esac
}
alias x='extract'

upgrade() {
  if command -v apt-get &>/dev/null; then
    echo "Updating apt packages..."
    sudo apt-get update -qq && sudo apt-get upgrade -y -qq
    echo "Cleaning up apt packages..."
    sudo apt-get autoremove -y -qq && sudo apt-get clean -qq
  fi
  if command -v yay &>/dev/null; then
    echo "Updating yay packages..."
    yay -Syu --noconfirm --quiet
    echo "Cleaning up yay packages..."
    yay -Sc --noconfirm --quiet
  elif command -v pacman &>/dev/null; then
    echo "Updating pacman packages..."
    sudo pacman -Syu --noconfirm --quiet
    echo "Cleaning up pacman packages..."
    sudo pacman -Sc --noconfirm --quiet
  fi
  if command -v flatpak &>/dev/null; then
    echo "Updating flatpak packages..."
    sudo flatpak update -y -q
    echo "Cleaning up flatpak packages..."
    sudo flatpak uninstall --unused -y -q
  fi
  if command -v snap &>/dev/null; then
    echo "Updating snap packages..."
    sudo snap refresh
    echo "Cleaning up snap packages..."
    sudo snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
      sudo snap remove "$snapname" --revision="$revision"
    done
  fi
  if command -v brew &>/dev/null; then
    echo "Updating brew packages..."
    brew update --quiet && brew upgrade --quiet
    echo "Cleaning up brew packages..."
    brew cleanup --prune=all --scrub --quiet
  fi
}
alias u='upgrade'

if command -v bat &>/dev/null; then
  alias cat='bat'
  complete -F _bat bat cat

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
  # TODO https://github.com/junegunn/fzf/issues/1804#issuecomment-574476419
  if [ -f ~/.fzf-tab-completion/bash/fzf-bash-completion.sh ]; then
    source ~/.fzf-tab-completion/bash/fzf-bash-completion.sh
    bind -x '"\t": fzf_bash_completion'
  else
    echo "Warning: fzf installed, but https://github.com/lincheney/fzf-tab-completion not found."
  fi

  export FZF_COMPLETION_AUTO_COMMON_PREFIX=true
  export FZF_COMPLETION_AUTO_COMMON_PREFIX_PART=true
  export FZF_TAB_COMPLETION_PROMPT='✨ '
fi

if command -v fzf &>/dev/null && command -v bfs &>/dev/null; then
  export FZF_COMMAND='bfs . -color -mindepth 1 -exclude \( -name .git \) | sed \"s|\./||g\" 2>/dev/null'
  export FZF_DIR_COMMAND='bfs . -color -mindepth 1 -exclude \( -name .git \) -type d | sed \"s|\./||g\" 2>/dev/null'
  export FZF_FILE_COMMAND='bfs . -color -mindepth 1 -exclude \( -name .git \) -type f | sed \"s|\./||g\" 2>/dev/null'

  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --ansi --bind 'ctrl-a:reload(eval \"$FZF_COMMAND\"),ctrl-s:reload(eval \"$FZF_DIR_COMMAND\"),ctrl-d:reload(eval \"$FZF_FILE_COMMAND\")'"
  export FZF_CTRL_T_COMMAND="bfs -color -mindepth 1 -exclude \( -name .git \) -printf '%P\n' 2>/dev/null"
  export FZF_ALT_C_COMMAND="bfs -color -mindepth 1 -exclude \( -name .git \) -type d -printf '%P\n' 2>/dev/null"
fi

if command -v fzf &>/dev/null && command -v bfs &>/dev/null && command -v vim &>/dev/null; then
  vf() {
    query="${1:-}"
    files=$(bfs . -color -mindepth 1 | sed -e "s|^\./||g" 2>/dev/null | fzf --query="$query" --multi)
    if [ -n "$files" ]; then
      vim "$files"
    fi
  }
fi

if command -v fzf &>/dev/null && command -v rg &>/dev/null && command -v vim &>/dev/null; then
  vg() {
    query="${1:-}"
    match=$(rg . --with-filename --line-number --color=always | fzf --query="$query" | cut -d ":" -f 1-2)
    if [ -n "$match" ]; then
      IFS=: read -r file line <<<"$match"
      vim +"call cursor($line,1)" "$file"
    fi
  }
fi

if command -v git &>/dev/null; then
  alias g=git
  if [ -n "$(type -t __git_complete)" ]; then
    __git_complete g __git_main
  fi
fi

if command -v gsed &>/dev/null; then
  ln -sf $(command -v gsed) ~/.local/bin/sed
fi

if command -v helm &>/dev/null; then
  alias h=helm
  source <(helm completion bash)
  if [ -n "$(type -t __start_helm)" ]; then
    complete -F __start_helm h
  fi
fi

if command -v kubectl &>/dev/null; then
  alias k=kubectl
  source <(kubectl completion bash)
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

if command -v kubectl &>/dev/null && command -v dyff &>/dev/null; then
  export KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code"
fi

if command -v kubectl &>/dev/null && command -v fzf &>/dev/null; then
  _fzf_k_completions() {
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
      COMPREPLY=($(printf "%s\n" "${COMPREPLY[@]}" | fzf --height=-2 --layout reverse --border --info inline-right))
    fi
  }

  complete -F _fzf_k_completions kctx kns
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
