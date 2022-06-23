################
# PS1 settings #
################
BOLD="$(tput bold)"
GREEN="$(tput setaf 2)"
CYAN="$(tput setaf 6)"
BLUE="$(tput setaf 4)"
DEFAULT="$(tput sgr0)"

function ps1_working_dir() {
    # Are we in a git repo?
    # If we're not GIT_ROOT will be empty
    GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ -n $GIT_ROOT ]]
    then
        # If we're in a repo, find the branch
        GIT_BRANCH="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')"
        # If we're not on a branch, get the tags
        if [[ "$GIT_BRANCH" == " ((no branch))" ]]
        then
            GIT_BRANCH=" ($(git describe --tags 2> /dev/null))";
        fi
        # Get the path relative to GIT_ROOT
        GIT_WORKING_DIR=$(pwd | sed "s|$GIT_ROOT|$(basename $GIT_ROOT)|")
        # Output
        echo ".../$GIT_WORKING_DIR$DEFAULT$CYAN$GIT_BRANCH"
    else
        echo $(pwd | sed "s?$HOME/?~/?" | sed "s?$HOME\$?~?")
    fi
}

PS1="\[$BOLD$GREEN\]\u@\h\[$DEFAULT\]:\[$BOLD$BLUE\]\$(ps1_working_dir)\[$DEFAULT\]$ "
