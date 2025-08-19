# Extract function - multi-format archive extraction
extract() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: extract <archive> <destination>"
        return 1
    fi

    local src="$1" dest="$2"
    case "$src" in
        *.tar.bz2) mkdir -p "$dest"; tar xjf "$src" -C "$dest" ;;
        *.tar.gz)  mkdir -p "$dest"; tar xzf "$src" -C "$dest" ;;
        *.tar.xz)  mkdir -p "$dest"; tar xJf "$src" -C "$dest" ;;
        *.bz2)     mkdir -p "$dest"; bunzip2 -c "$src" > "$dest" ;;
        *.rar)     mkdir -p "$dest"; unrar x "$src" "$dest" ;;
        *.gz)      mkdir -p "$dest"; gunzip -c "$src" > "$dest" ;;
        *.tar)     mkdir -p "$dest"; tar xf "$src" -C "$dest" ;;
        *.tbz2)    mkdir -p "$dest"; tar xjf "$src" -C "$dest" ;;
        *.tgz)     mkdir -p "$dest"; tar xzf "$src" -C "$dest" ;;
        *.zip)     mkdir -p "$dest"; unzip "$src" -d "$dest" ;;
        *.Z)       mkdir -p "$dest"; uncompress -c "$src" > "$dest" ;;
        *.7z)      mkdir -p "$dest"; 7za x "$src" -o"$dest" ;;
        *.xz)      mkdir -p "$dest"; xz -dc "$src" > "$dest" ;;
        *.exe)     mkdir -p "$dest"; cabextract "$src" -d "$dest" ;;
        *) echo "Error: '$src' cannot be extracted via extract()" ;;
    esac
}
alias x='extract'

# System upgrade function - handles multiple package managers
upgrade() {
    if command -v apt &>/dev/null; then
        echo "Updating apt packages..."
        sudo apt update -qq && sudo apt full-upgrade -y -qq
        echo "Cleaning up apt packages..."
        sudo apt autoremove -y -qq && sudo apt autoclean -qq
    fi
    if command -v pacman &>/dev/null; then
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
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export BAT_THEME="Dracula"
fi

if command -v eza &>/dev/null; then
    alias ls='eza --group-directories-first --color=always'
    alias lsl='eza --group-directories-first --color=always --git --git-repos -bl'
    alias lsa='eza --group-directories-first --color=always --git --git-repos -abl'
    alias lsd='eza --color=always --git-repos -bDl'
    alias lsf='eza --color=always --git -blf'

    ls.() {
        if [[ "$#" -eq 0 ]]; then
            set -- "."
        fi
        for dir in "$@"; do
            [[ "$#" -gt 1 ]] && echo "$dir:"
            (cd "$dir" && command eza --group-directories-first --color=always --git --git-repos -abdl .*)
            if [[ "$#" -gt 1 && "$dir" != "${@: -1}" ]]; then
                echo ""
            fi
        done
    }

    tree() {
        if [[ "$#" -eq 0 ]]; then
            set -- "."
        fi
        eza "$@" --group-directories-first --color=always --git --git-repos --ignore-glob ".git" -albT --color=always
    }
fi

if command -v fd &>/dev/null; then
    fd() {
        local current_dir=$(realpath "$PWD")
        local home=$(realpath "$HOME")
        if [[ $current_dir == $home || $current_dir == $home/* ]]; then
            command fd --no-ignore-vcs "$@"
        else
            command fd "$@"
        fi
    }
fi

if command -v rg &>/dev/null; then
    rg() {
        local current_dir=$(realpath "$PWD")
        local home=$(realpath "$HOME")
        if [[ $current_dir == $home || $current_dir == $home/* ]]; then
            command rg -u "$@"
        else
            command rg "$@"
        fi
    }
fi

if command -v fzf &>/dev/null && command -v bfs &>/dev/null; then
    export FZF_DEFAULT_COMMAND='bfs . -color -mindepth 1 -printf "%P\n" 2>/dev/null'
    export FZF_RELOAD_DIR_COMMAND='bfs . -color -mindepth 1 -type d -printf "%P\n" 2>/dev/null'
    export FZF_RELOAD_FILE_COMMAND='bfs . -color -mindepth 1 -type f -printf "%P\n" 2>/dev/null'
    export FZF_RELOAD_PARENT_COMMAND='pwd | awk -F/ "{print \"/\"; for(i=2; i<=NF; i++) {path=\"\"; for(j=2; j<=i; j++) path=path\"/\"\$j; print path}}"'

    export FZF_LAYOUT="--layout reverse --border"
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
        --ansi \
        --prompt 'A> ' \
        --bind 'ctrl-a:reload(eval \$FZF_DEFAULT_COMMAND)+change-prompt(A> )' \
        --bind 'ctrl-d:reload(eval \$FZF_RELOAD_DIR_COMMAND)+change-prompt(D> )' \
        --bind 'ctrl-f:reload(eval \$FZF_RELOAD_FILE_COMMAND)+change-prompt(F> )' \
        --bind 'ctrl-u:reload(eval \$FZF_RELOAD_PARENT_COMMAND)+change-prompt(U> )' \
        $FZF_LAYOUT"
    export FZF_CTRL_T_OPTS="--walker file,dir,follow,hidden --walker-skip .git"
    export FZF_ALT_C_COMMAND=""
fi

if command -v fzf &>/dev/null && command -v rg &>/dev/null && command -v vim &>/dev/null && command -v bat &>/dev/null; then
    vg() {
        local query match file line
        local temp_rg temp_fzf

        temp_rg="/tmp/vg-rg-$$"
        temp_fzf="/tmp/vg-fzf-$$"

        # Clean up any existing temp files and create fresh ones
        rm -f "$temp_rg" "$temp_fzf"

        # Initial query setup
        query=${1:-}

        # Save initial query to rg temp file for mode switching
        echo "$query" > "$temp_rg"
        echo "" > "$temp_fzf"

        trap 'rm -f "$temp_rg" "$temp_fzf"' EXIT

        RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "

        match=$(fzf --ansi --disabled \
            --bind "start:reload:$RG_PREFIX '$query' 2>/dev/null || true" \
            --bind "ctrl-r:execute(echo {q} > '$temp_fzf')+transform-query(cat '$temp_rg')+change-prompt(rg> )+disable-search+rebind(change)" \
            --bind "change:reload:sleep 0.1; $RG_PREFIX {q} 2>/dev/null || true" \
            --bind "ctrl-f:execute(echo {q} > '$temp_rg')+transform-query(cat '$temp_fzf')+change-prompt(fzf> )+enable-search+unbind(change)" \
            --prompt 'fzf> ' \
            --header 'CTRL-R: rg mode / CTRL-F: fzf mode' \
            --layout=reverse-list \
            --delimiter ':' \
            --bind 'ctrl-a:ignore,ctrl-d:ignore' \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --preview '
                bat --plain \
                    --color=always \
                    --highlight-line={2} \
                    --paging=never \
                    {1} 2>/dev/null || cat {1} 2>/dev/null || echo "Cannot preview file"
            ' \
            --preview-window 'right:50%:~3:+{2}-/2' | \
            cut -d : -f 1-2)

        if [[ -n $match ]]; then
            IFS=: read -r file line <<<"$match"
            vim +"call cursor($line,1)" "$file"
        fi
    }
fi

if command -v git &>/dev/null; then
    alias g='git'
    compdef git g
fi

if command -v helm &>/dev/null; then
    alias h='helm'
    compdef _helm h
fi

if command -v kubectl &>/dev/null; then
    alias k='kubectl'
    compdef _kubectl k

    # Context and namespace helpers
    klsctx() { kubectl config get-contexts ${1:+| grep "$1"}; }
    kctx() { kubectl config use-context "$@"; }
    klsns() { kubectl get ns ${1:+| grep "$1"}; }
    kns() { kubectl config set-context --current --namespace "$@"; }

    # Enhanced diff tool
    if command -v dyff &>/dev/null; then
        export KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code"
    fi

    # Completion for custom functions
    _kctx() { compadd $(kubectl config get-contexts | awk 'NR>1 {gsub(/^[*]/, ""); print $1}') }
    _kns() { compadd $(kubectl get ns | awk 'NR>1 {print $1}') }
    compdef _kctx kctx
    compdef _kns kns
fi

if command -v nvim &>/dev/null; then
    alias v='nvim'
    alias vimdiff='nvim -d'

    ln -sf "$(command -v nvim)" "$HOME/.local/bin/vi"
    ln -sf "$(command -v nvim)" "$HOME/.local/bin/vim"
fi

if command -v tmux &>/dev/null; then
    alias t='tmux'
    compdef _tmux t 2>/dev/null || true
fi
