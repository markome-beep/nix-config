function set_my_prompt {
    local git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$git_branch" ]; then
        PS1="[\u@\h:\w ($git_branch)]\$ "
    else
        PS1="[\u@\h:\w]\$ "
    fi
}
PROMPT_COMMAND="set_my_prompt"

eval "$(zoxide init bash --cmd cd)"

if [[ $- =~ i ]] && [[ -z "$TMUX" ]]; then
        tmux attach-session -t main || tmux new-session -s main
fi
