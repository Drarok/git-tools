# Quick cd to root of git repo.
function git_root {
  GIT_ROOT=$(git rev-parse --show-toplevel)

  if [ "$GIT_ROOT" = "" ]; then
    return 128
  fi

  cd "$GIT_ROOT"
}

alias gb='git branch'
alias gfp="git fetch --prune"
alias gmom="git merge origin/master"
alias gpfl="git push --force-with-lease"
alias gpp="git pull --prune"
alias gr="git_root"
alias grm="git rebase -i origin/master"
alias gs="git switch"
alias gsp="git stash push"
alias gst="git status -uno"
