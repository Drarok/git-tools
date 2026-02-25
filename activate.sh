if [ -n "$BASH_VERSION" ]; then
  ROOT_DIR=$(dirname $BASH_SOURCE)
elif [ -n "$ZSH_VERSION" ]; then
  ROOT_DIR=$(dirname "${(%):-%x}")
fi

if [[ "$PATH" == *"$ROOT_DIR"* ]]; then
  echo "[WARN] Path already includes git-tools, skipped"
else
  export PATH="$PATH:$ROOT_DIR"
fi

function _git_tools_git_root {
  git rev-parse --show-toplevel
}

function _git_tools_alias_path {
  CANDIDATES=("aliases.sh" "aliases-default.sh")
  for CANDIDATE_NAME in ${CANDIDATES[@]}; do
    CANDIDATE_PATH="$ROOT_DIR/$CANDIDATE_NAME"
    if [ -f "$CANDIDATE_PATH" ]; then
      echo $CANDIDATE_PATH
      return
    fi
  done
}

function _git_tools_load {
  ALIAS_PATH=$(_git_tools_alias_path)
  if [ ! -z "$ALIAS_PATH" ]; then
    source "$ALIAS_PATH"
  fi
}

_git_tools_load
