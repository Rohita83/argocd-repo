#!/bin/bash

set -e

APPSET_FILES=applicationsets/development/appset.yaml
CLUSTER_CONFIG_FILES=configurations/development/cluster-config.yaml
CODE_BRANCH=code
CONFIGURATION_BRANCH=configuration
DEBUG=true
# TRAVIS_REPO_SLUG=Rohita83/argocd-repo

function initGlobal() {
    export cluster_config_file appset_files codeBranch configurationBranch
    codeBranch=${CODE_BRANCH:?}
    configurationBranch=${CONFIGURATION_BRANCH:?}
    cluster_config_file="${CLUSTER_CONFIG_FILES:?}"
    appset_files="${APPSET_FILES:?}"
}

function echoIt() {
  if [[ -n $DEBUG ]]; then
    echo "$@"
  fi
}

function updateTargetRevisionInAppset() {
    mkdir -p gitSpace
    cd gitSpace
    # git clone --branch "${configurationBranch}" "https://${GIT_TOKEN:?}@github.com/${TRAVIS_REPO_SLUG}.git"
    git clone --branch "${configurationBranch}" "https://github.com/${TRAVIS_REPO_SLUG}.git"

    cd ./*
    # gitlog=$(git log --pretty=oneline "${TRAVIS_COMMIT}~1..${TRAVIS_COMMIT}")
    gitlog=$(git log --format="%H" -n 1)
    echo "gitlog = $gitlog"
    TRAVIS_COMMIT=gitlog
    echo "TRAVIS_COMMIT = $TRAVIS_COMMIT"
    for appset_file in $appset_files; do
        echo "updating ${appset_file}"
        sed -i -E "s/targetRevision:.*/targetRevision:\ ${TRAVIS_COMMIT}/" "${appset_file}"
        cat ${appset_file}
        git config --global user.email "xyz@gmail.com"
        git add "${appset_file}"
    done
      ( git commit -m "Auto: Changing targetRevision for ApplicationSet" && git push ) || echo "No change in appset."
}

function start() {

  TRAVIS_REPO_SLUG="Rohita83/argocd-repo"
  echoIt "TRAVIS_REPO_SLUG=${TRAVIS_REPO_SLUG}"

  initGlobal
  updateTargetRevisionInAppset
}

# execute arguments
"$@"
