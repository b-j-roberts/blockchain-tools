#!/bin/bash
#
# Update all git repositories as part of repos.json
#
# TODO: Somehow to stop on local changes? What to do about submodules?

SETUP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

REPOS_DIR=$SETUP_DIR/repos
REPOS_JSON=$SETUP_DIR/repos.json

mkdir -p $REPOS_DIR

for repo in $(jq -r '.[] | @base64' $REPOS_JSON); do
  _jq() {
    echo ${repo} | base64 --decode | jq -r ${1}
  }

  echo "Checking $(_jq '.name')"

  if [ -d "$REPOS_DIR/$(_jq '.name')" ]; then
    echo "Repo Exists $(_jq '.name')"
    cd "$REPOS_DIR/$(_jq '.name')"

    # Check commit or branch if specified
    if [ $(_jq '.branch') != "null" ]; then
      BRANCH=$(git rev-parse --abbrev-ref HEAD)
      if [ $BRANCH != $(_jq '.branch') ]; then
        echo "Branch $BRANCH != $(_jq '.branch'), checking out"
        git checkout $(_jq '.branch')
        git clean -xfd
        git submodule foreach --recursive git clean -xfd
        git reset --hard
        git submodule foreach --recursive git reset --hard
        git submodule update --init --recursive
      else
        echo "Branch $BRANCH == $(_jq '.branch'), checking commits"
        git fetch
        COMMIT=$(git rev-parse HEAD)
        REMOTE_COMMIT=$(git rev-parse origin/$(_jq '.branch'))
        if [ $COMMIT != $REMOTE_COMMIT ]; then
          echo "Commit $COMMIT != $REMOTE_COMMIT, checking out"
          git checkout $(_jq '.branch')
          git clean -xfd
          git submodule foreach --recursive git clean -xfd
          git reset --hard
          git submodule foreach --recursive git reset --hard
          git submodule update --init --recursive
        else
          echo "Commit $COMMIT == $REMOTE_COMMIT, up to date"
        fi
      fi
    fi
    if [ $(_jq '.commit') != "null" ]; then
      COMMIT=$(git rev-parse HEAD)
      if [ $COMMIT != $(_jq '.commit') ]; then
        echo "Commit $COMMIT != $(_jq '.commit'), checking out"
        git checkout $(_jq '.commit')
        git clean -xfd
        git submodule foreach --recursive git clean -xfd
        git reset --hard
        git submodule foreach --recursive git reset --hard
        git submodule update --init --recursive
      else
        echo "Commit $COMMIT == $(_jq '.commit'), up to date"
      fi
    fi
  else
    git clone $(_jq '.url') "$REPOS_DIR/$(_jq '.name')"
    
    # Set commit or branch if specified
    if [ $(_jq '.branch') != "null" ]; then
      echo "Checking out branch $(_jq '.branch')"
      cd "$REPOS_DIR/$(_jq '.name')"
      git checkout $(_jq '.branch')
      git submodule update --init --recursive
    fi
    if [ $(_jq '.commit') != "null" ]; then
      echo "Checking out commit $(_jq '.commit')"
      cd "$REPOS_DIR/$(_jq '.name')"
      git checkout $(_jq '.commit')
      git submodule update --init --recursive
    fi
  fi
done
