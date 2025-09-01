local _expected_binaries_file="$HOME/.expected_binaries"

if [[ ! -f $_expected_binaries_file ]]; then
    print -r -- "Configuration file $_expected_binaries_file not found. Skipping binary check."
    return
fi

local _os_type _os
_os_type=$(uname -s)
if [[ $_os_type == "Linux" ]]; then
    if [[ -d /run/WSL ]]; then
        _os="wsl2"
    else
        _os="linux"
    fi
elif [[ $_os_type == "Darwin" ]]; then
    _os="osx"
else
    print -r -- "Unsupported operating system: $_os_type. Skipping binary check."
    return
fi

local _missing_binaries=()
local _binary _line
while IFS= read -r _line; do
    if [[ -z $_line || $_line =~ '^[[:space:]]*$' ]]; then
        continue
    fi

    _binary=$_line

    if [[ $_binary =~ '^osx:' && $_os != "osx" ]]; then
        continue
    elif [[ $_binary =~ '^linux:' && $_os != "linux" ]]; then
        continue
    elif [[ $_binary =~ '^wsl:' && $_os != "wsl2" ]]; then
        continue
    fi

    _binary=${_binary#osx:}
    _binary=${_binary#linux:}
    _binary=${_binary#wsl:}

    if ! command -v "$_binary" &>/dev/null; then
        _missing_binaries+=("$_binary")
    fi
done <"$_expected_binaries_file"

if ((${#_missing_binaries[@]} > 0)); then
    print -r -- "The following binaries are not installed:"
    local _binary_list=""
    for _binary in "${_missing_binaries[@]}"; do
        _binary_list+="\n  - \e[31m$_binary\e[0m"
    done
    print -r -- "$_binary_list"
    print -r -- "\nYour shell experience will probably differ from the intended one."
fi

unset _expected_binaries_file _os_type _os _missing_binaries _binary _line _binary_list
