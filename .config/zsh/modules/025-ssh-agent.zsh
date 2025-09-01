# Based on GitHub's SSH agent documentation

SSH_ENV="$HOME/.ssh/env"

agent_load_env() {
    [[ -f "$SSH_ENV" ]] && source "$SSH_ENV" >/dev/null 2>&1
}

agent_start() {
    (
        umask 077
        ssh-agent > "$SSH_ENV"
    )
    source "$SSH_ENV" >/dev/null 2>&1
}

# Check if SSH agent is running and has keys loaded
# Returns: 0=agent running with keys; 1=agent without keys; 2=agent not running
agent_run_state() {
    ssh-add -l >/dev/null 2>&1
    echo $?
}

ssh_agent_init() {
    agent_load_env

    local state=$(agent_run_state)
    if [[ ! "$SSH_AUTH_SOCK" ]] || [[ $state -eq 2 ]]; then
        agent_start
        ssh-add
    elif [[ "$SSH_AUTH_SOCK" ]] && [[ $state -eq 1 ]]; then
        ssh-add
    fi
    # If state is 0, agent is running with keys - nothing to do
}

ssh_agent_init
