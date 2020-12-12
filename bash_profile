
source ~/.git-completion.bash
source ~/.git-prompt.sh


export PS1="\u@\h \W\[\033[32m\]\$(git_prompt)\[\033[00m\] \$ "


# Load pyenv automatically by appending
# the following to ~/.bash_profile:

eval "$(pyenv init -)"


