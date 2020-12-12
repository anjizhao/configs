
source ~/.git-completion.bash


git_branch() {
    # -- Finds and outputs the current branch name by parsing the list of all branches
    # -- Current branch is identified by an asterisk at the beginning
    # -- If not in a Git repository, error message goes to /dev/null and no output is produced
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

git_status() {
    # Outputs a series of indicators based on the status of the
    # working directory:  (actually the comments are not accurate bc i changed shit --@anji)
    # + changes are staged and ready to commit
    # ! unstaged changes are present
    # ? untracked files are present
    # S changes have been stashed
    # P local commits need to be pushed to the remote
    local status="$(git status --porcelain 2>/dev/null)"
    local output=""
    [[ -n $(egrep '^[MADRC]' <<<"$status") ]] && output="$output+"  # green with star
    [[ -n $(egrep '^.[MD]' <<<"$status") ]] && output="$output*"    # red with star
    [[ -n $(egrep '^\?\?' <<<"$status") ]] && output="$output?"     # red with no star
    # [[ -n $(git stash list) ]] && output="${output}S"
    # [[ -n $(git log --branches --not --remotes) ]] && output="${output}P"
    # [[ -n $output ]] && output="|$output"  # separate from branch name
    echo "$output"
}

git_color() {
    # Receives output of git_status as argument; produces appropriate color
    # code based on status of working directory:
    # - White if everything is clean
    # - Green if all changes are staged
    # - Red if there are uncommitted changes with nothing staged
    # - Yellow if there are both staged and unstaged changes
    # - Blue if there are unpushed commits
    local staged=$([[ $1 =~ \+ ]] && echo yes)
    local dirty=$([[ $1 =~ [!\?] ]] && echo yes)
    local needs_push=$([[ $1 =~ P ]] && echo yes)
    if [[ -n $dirty ]]; then
        echo -e '\033[31m'  # red
    elif [[ -n $needs_push ]]; then
        echo -e '\033[34m' # blue
    else
        echo -e '\033[32m'  # green
    fi
}

git_prompt() {
    # First, get the branch name...
    local branch=$(git_branch)
    # Empty output? Then we're not in a Git repository, so bypass the rest
    # of the function, producing no output
    if [[ -n $branch ]]; then
        local state=$(git_status)
        local color=$(git_color $state)
        local staged=$([[ $state =~ \+ ]] && echo yes)
        local needs_push=$([[ $state =~ P ]] && echo yes)
        if [[ -n $staged ]]; then
            state='*'
        elif [[ -n $needs_push ]]; then
            state=''
        fi
        # Now output the actual code to insert the branch and status
        echo -e "\x01$color\x02[$branch$state]\x01\033[00m\x02"  # last bit resets color
    fi
}

export PS1="\u@\h \W\[\033[32m\]\$(git_prompt)\[\033[00m\] \$ "






# Load pyenv automatically by appending
# the following to ~/.bash_profile:

eval "$(pyenv init -)"


