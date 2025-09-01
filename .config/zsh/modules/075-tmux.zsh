# Auto Attach/Create tmux Session
# If Not Inside tmux and Not in an SSH Session, Attach/Create a Persistent 'main' Session.
# Using exec on New Session Ensures Shell Does Not Linger as Parent.
if command -v tmux >/dev/null 2>&1; then
    if [[ -z $TMUX && -z $SSH_CONNECTION && -z $SSH_TTY ]]; then
        if tmux has-session -t main 2>/dev/null; then
            tmux attach -t main
        else
            exec tmux new-session -s main
        fi
    fi
fi
