# Quick cd to root of git repo.
function __git_tools_cd_root {
  GIT_ROOT=$(_git_tools_git_root)

  if [ "$GIT_ROOT" = "" ]; then
    return 128
  fi

  cd "$GIT_ROOT"
}

function __git_tools_git_rebase {
  git rebase -i "origin/${1:-$(_git_tools_default_branch)}"
}

function __git_tools_merge_origin {
  git merge "origin/${1:-$(_git_tools_default_branch)}"
}

alias gb='git branch'
alias gdb="_git_tools_default_branch"
alias gfp="git fetch --prune"
alias gmom="__git_tools_merge_origin"
alias gpfl="git push --force-with-lease"
alias gpp="git pull --prune"
alias gr="__git_tools_cd_root"
alias grc="git rebase --continue"
alias grm="__git_tools_git_rebase"
alias gs="git switch"
alias gsp="git stash push"
alias gst="git status"
