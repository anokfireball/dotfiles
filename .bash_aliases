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

  klsns() {
    if [ -n "$1" ]; then
      kubectl get ns | grep "$1"
    else
      kubectl get ns
    fi
  }
  alias kns='kubectl config set-context --current --namespace'
fi

if command -v git &>/dev/null; then
  alias g=git
  if [ -n "$(type -t __git_complete)" ]; then
    __git_complete g __git_main
  fi
fi

if command -v bat &>/dev/null; then
  alias cat='bat'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='ls -lb --color-scale=all --git --git-repos'
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

if command -v fzf &>/dev/null && command -v fd &>/dev/null; then
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }
  _fzf_setup_completion path eza git kubectl

  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
  _fzf_setup_completion dir tree z zoxide

  export FZF_COMPLETION_TRIGGER='~~'
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
