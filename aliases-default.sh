# Quick cd to root of git repo.
function __git_tools_git_root {
  GIT_ROOT=$(git rev-parse --show-toplevel)

  if [ "$GIT_ROOT" = "" ]; then
    return 128
  fi

  cd "$GIT_ROOT"
}

function __git_tools_git_rebase {
  git rebase -i "origin/${1:-main}"
}

function __git_tools_merge_origin {
  git merge "origin/${1:-main}"
}

alias gb='git branch'
alias gfp="git fetch --prune"
alias gmom="__git_tools_merge_origin"
alias gpfl="git push --force-with-lease"
alias gpp="git pull --prune"
alias gr="__git_tools_git_root"
alias grc="git rebase --continue"
alias grm="__git_tools_git_rebase"
alias gs="git switch"
alias gsp="git stash push"
alias gst="git status"
