# Podman machine auto-start (macOS)

if [[ "$(uname -s)" == "Darwin" ]] && command -v podman &>/dev/null; then
    alias docker=podman
    {
        if [[ "$(podman machine info --format '{​{.Host.MachineState}}' 2>/dev/null)" != "Running" ]]; then
            podman machine start
        fi
    } &>/dev/null &!
fi
