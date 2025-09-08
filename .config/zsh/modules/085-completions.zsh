# Purpose:
#  - Generate Persistent #compdef Completion Scripts for Selected Tools.
#  - Avoid Sourcing Dynamic Generators Every Startup (Performance and Stability).
#  - Automatically Regenerate When the Underlying Binary Changes (Package Upgrade).
#  - Provide Compregen Helper to Purge Cached Completions Manually.

# System Completion Path Discovery
# Add system and Homebrew completion directories to fpath dynamically
ZSH_INSTALL_DIR="${ZSH_VERSION:+$(dirname $(dirname $(whence -p zsh)))}"

# Try common zsh completion directories
typeset -a completion_dirs=(
    # System locations
    "/usr/share/zsh/site-functions"
    "/usr/share/zsh/vendor-completions"
    "/usr/local/share/zsh/site-functions"
    # Homebrew zsh installation (if available)
    "${BREW_PREFIX}/share/zsh/site-functions"
    # Dynamic zsh installation directory
    "${ZSH_INSTALL_DIR}/share/zsh/site-functions"
)

# Add existing directories to fpath, avoiding duplicates
for dir in $completion_dirs; do
    if [[ -d "$dir" ]] && (( ${fpath[(I)$dir]} == 0 )); then
        fpath=("$dir" $fpath)
    fi
done
unset completion_dirs dir

# Cache Directory for Generated Completions
local _compdir="${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/completions"
mkdir -p "$_compdir" 2>/dev/null || true
# Enforce Private Permissions to Avoid Injection (Ignore Errors on Non-POSIX FS)
chmod 700 "$_compdir" 2>/dev/null || true
if (( ${fpath[(I)$_compdir]} == 0 )); then
    # Prepend So Our Generated Completions Have Priority
    fpath=("$_compdir" $fpath)
fi

# Tool Mapping
# Map of Tool -> Generation Command (Associative Array for Extensibility).
# Extend by Appending: _dyn_comp_cmds+=( tool 'tool completion zsh' )
typeset -A _dyn_comp_cmds
_dyn_comp_cmds=(
    delta   'delta --generate-completion zsh'
    bat     'bat --completion zsh'
    stern   'stern --completion zsh'
    helm    'helm completion zsh'
    kubectl 'kubectl completion zsh'
)

# Fingerprint Helper
# _comp_fp: Create a Lightweight Fingerprint (dev:inode:size:mtime) for a Binary.
_comp_fp() {
    local p=$1
    command -v stat >/dev/null 2>&1 || return 1
    stat -Lc '%d:%i:%s:%Y' "$p" 2>/dev/null || stat -f '%d:%i:%z:%m' "$p" 2>/dev/null
}

# Generation Helper
# _comp_gen: Generate or Refresh a Completion for One Tool if Needed.
# Triggers Regeneration When:
#   - Completion File Missing
#   - Metadata Missing
#   - Fingerprint Changed
#   - ZSH_FORCE_COMP_REGEN Is Set (User Override)
_comp_gen() {
    local cmd=$1 gen=$2 bin meta compfile regen=0 header out primary fp curfp
    # Skip if Tool Not Installed
    bin=$(command -v "$cmd" 2>/dev/null) || return
    compfile="$_compdir/_$cmd"
    meta="$_compdir/.meta_$cmd"
    if [[ -n $ZSH_FORCE_COMP_REGEN || ! -s $compfile || ! -s $meta ]]; then
        regen=1
    else
        fp=$(_comp_fp "$bin") || regen=1
        read -r curfp < "$meta" 2>/dev/null || regen=1
        [[ $fp != $curfp ]] && regen=1
    fi
    (( regen == 0 )) && return
    # Run Generator Quietly
    out=$(eval "$gen" 2>/dev/null) || return
    header=${out[(f)1]}
    # Use Primary Name if Multi-Compdef
    if [[ $header == "#compdef"* ]]; then
        # Fix: Use a safer parsing method for the compdef line
        local header_without_compdef="${header#\#compdef }"
        local names=()
        # Use read to split the string on spaces
        read -A names <<< "$header_without_compdef"
        primary=$names[1]
        [[ -n $primary ]] && compfile="$_compdir/_$primary"
    fi
    # Write Completion File
    print -r -- "$out" >| "$compfile" 2>/dev/null || return
    fp=$(_comp_fp "$bin") || fp="unknown"
    { print -r -- "$fp"; print -r -- "$bin"; print -r -- "$(date +%s)"; } >| "$meta" 2>/dev/null || true
}

# Iterate All Configured Tools
local _tool
for _tool in ${(k)_dyn_comp_cmds}; do
    _comp_gen "$_tool" "${_dyn_comp_cmds[$_tool]}"
done
unset _tool

# Stale Tool Cleanup
# Remove Cached Completions Whose Source Binary No Longer Exists
for _meta in "$_compdir"/.meta_*; do
    [[ ! -f $_meta ]] && continue
    _toolname=${${_meta:t}#.meta_}
    # Skip if still configured (kept even if temporarily not in PATH)
    if [[ -n ${_dyn_comp_cmds[$_toolname]} ]]; then
        # If tool is configured but binary is presently missing, skip deletion (user may install later)
        continue
    fi
    read -r _fp < "$_meta" 2>/dev/null || true
    read -r _bin < <(sed -n '2p' "$_meta" 2>/dev/null) || true
    if [[ -n $_bin && ! -x $_bin ]]; then
        rm -f "$_compdir/_$_toolname" "$_meta" 2>/dev/null || true
    fi
done
unset _meta _toolname _fp _bin

# Maintenance Helper
# compregen: Purge Completions & Metadata to Force Regeneration Next Shell Launch (or With ZSH_FORCE_COMP_REGEN=1)
if ! typeset -f compregen >/dev/null 2>&1; then
    compregen() {
        local _dir="${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/completions" _t
        for _t in ${(k)_dyn_comp_cmds}; do
            rm -f "$_dir/_$_t" "$_dir/.meta_$_t"
        done
        print -r -- "Removed cached completion files. Start a new shell (or set ZSH_FORCE_COMP_REGEN=1) to regenerate." >&2
    }
fi

# Completion Styles
# Core Style Controls (Extend as Needed)
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' rehash true

# Initialize Completion System (After Our Cache Path Is on fpath)
zcomet compinit
