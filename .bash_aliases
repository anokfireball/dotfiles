if command -v kubectl &> /dev/null; then
  alias k=kubectl
  alias kctx='kubectl config use-context'
  alias kns='kubectl config set-context --current --namespace'
  if [ -n "$(type -t __start_kubectl)" ]; then
    complete -F __start_kubectl k
  fi
fi

if command -v git &> /dev/null; then
  alias g=git
  if [ -n "$(type -t __git_complete)" ]; then
    __git_complete g __git_main
  fi
fi
