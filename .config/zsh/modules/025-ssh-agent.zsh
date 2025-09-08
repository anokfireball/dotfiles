# Based on GitHub's SSH agent documentation

SSH_ENV="$HOME/.ssh/env"

agent_load_env() {
    if [[ -f "$SSH_ENV" ]]; then
        # Source the SSH env file but suppress any echo output
        source "$SSH_ENV" >/dev/null 2>&1
    fi
}

agent_start() {
    # Temporarily disable noclobber for this function to avoid "file exists" errors
    local old_noclobber
    [[ -o noclobber ]] && old_noclobber=1 || old_noclobber=0
    unsetopt noclobber

    (
        umask 077
        # Generate SSH agent env but filter out the echo command
        ssh-agent | grep -v '^echo ' >"$SSH_ENV"
    ) 2>/dev/null

    # Restore noclobber setting
    ((old_noclobber)) && setopt noclobber

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
        ssh-add >/dev/null 2>&1
    elif [[ "$SSH_AUTH_SOCK" ]] && [[ $state -eq 1 ]]; then
        ssh-add >/dev/null 2>&1
    fi
    # If state is 0, agent is running with keys - nothing to do
}

ssh_agent_init
