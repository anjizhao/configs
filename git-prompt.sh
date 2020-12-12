
# Adds the current branch to the bash prompt when the working directory is
# part of a Git repository. Includes color-coding and indicators to quickly
# indicate the status of working directory.

# source: https://github.com/jcgoble3/gitstuff/blob/master/gitprompt.sh
# modified by me


git_branch() {
    # -- Finds and outputs the current branch name by parsing the list of all branches
    # -- Current branch is identified by an asterisk at the beginning
    # -- If not in a Git repository, error message goes to /dev/null and no output is produced
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

git_status() {
    # Outputs a series of indicators based on the status of the working directory:
    # + changes are staged and ready to commit
    # ! unstaged changes are present
    # ? untracked files are present
    # P local commits need to be pushed to the remote
    local status="$(git status --porcelain 2>/dev/null)"
    local output=""
    [[ -n $(egrep '^[MADRC]' <<<"$status") ]] && output="$output+"  # green with star
    [[ -n $(egrep '^.[MD]' <<<"$status") ]] && output="$output!"    # red with star
    [[ -n $(egrep '^\?\?' <<<"$status") ]] && output="$output?"     # red with ?
    [[ -n $(git log --branches --not --remotes) ]] && output="${output}P"  # blue with nothing
    echo "$output"
}

git_color() {
    # Receives output of git_status as argument; produces appropriate color code based on status:
    # - Red if there are uncommitted changes
    # - Blue if there are unpushed commits
    # - Green if branch is clean or all changes are staged
    local dirty=$([[ $1 =~ [!\?] ]] && echo yes)
    local needs_push=$([[ $1 =~ P ]] && echo yes)
    if [[ -n $dirty ]]; then
        echo -e '\033[31m'  # red
    elif [[ -n $needs_push ]]; then
        echo -e '\033[34m'  # blue
    else
        echo -e '\033[32m'  # green
    fi
}

git_display_state() {
    local staged=$([[ $1 =~ \+ ]] && echo yes)
    local dirty=$([[ $1 =~ [!] ]] && echo yes)
    local untracked=$([[ $1 =~ [\?] ]] && echo yes)
    local needs_push=$([[ $1 =~ P ]] && echo yes)
    if [[ -n $staged ]] || [[ -n $dirty ]]; then
        echo "*"
    elif [[ -n $needs_push ]]; then
        echo ""
    else
        echo "$1"
    fi
}

git_prompt() {
    local branch=$(git_branch)
    # empty output means we're not in a git repository, so produce no output
    if [[ -n $branch ]]; then
        local state=$(git_status)
        local color=$(git_color $state)
        local display_state=$(git_display_state $state)
        # Now output the actual code to insert the branch and status
        echo -e "\x01$color\x02[$branch$display_state]\x01\033[00m\x02"  # last bit resets color
    fi
}


