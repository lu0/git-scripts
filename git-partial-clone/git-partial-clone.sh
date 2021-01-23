#!/bin/bash

#
# The git-partial-clone script
#   Clone a subdirectory of a repo
#
# AUTHOR:
#   Lucero Alvarado
#   https://github.com/lu0/git-scripts
#
# USAGE:
# (1) ln -sr ./git-partial-clone.sh ~/.local/bin/git-partial-clone
#     cp ./git-partial-clone.conf ~/.git-partial-clone.conf
# (2) # Fill ~/.git-partial-clone.conf
# (3) git-partial-clone
#

notif() {
    e='\033[0;31m' && s='\033[0;32m'
    w='\033[0;33m' && n='\033[0m'
    GPC_MSG=$2 && STATUS=${!1}
    printf "\n"$STATUS"${GPC_MSG}\n" && printf ${n}
}

source ~/.git-partial-clone.conf

[ $PARENT_PATH ] || PARENT_PATH=${PWD}
[ ! -d ${PARENT_PATH} ] && notif e "Parent path does not exist" && exit
[[ "${PARENT_PATH}" == */ ]] && PARENT_PATH="${PARENT_PATH: : -1}"
GIT_CLONE_DIR=${PARENT_PATH}/${REPO_NAME}

if [ ! -d ${GIT_CLONE_DIR}/.git/ ]; then 
    git init ${GIT_CLONE_DIR}
    GIT_URL=${GIT_REMOTE}.com/${GIT_REPO_USER}/${REPO_NAME}
    git -C ${GIT_CLONE_DIR} remote add origin https://${GIT_REPO_USER}:${GIT_PWD}@${GIT_URL}.git
    export GIT_PWD=

    # Enable partial clone
    git -C ${GIT_CLONE_DIR} config --local extensions.partialClone origin
    git -C ${GIT_CLONE_DIR} fetch --depth 1 --filter=blob:none || 
        ( notif e "Aborted." && rm -rf ${GIT_CLONE_DIR} && exit 1 )
        err=$?; [[ $err != 0 ]] && exit $err
    git -C ${GIT_CLONE_DIR} sparse-checkout set $PARTIAL_PATH

    if [ "${BRANCH}" ]
    then
        git -C ${GIT_CLONE_DIR} checkout -b $BRANCH
        git -C ${GIT_CLONE_DIR} pull origin $BRANCH
        git -C ${GIT_CLONE_DIR} branch --set-upstream-to=origin/$BRANCH ${BRANCH} || \
            ( notif e "Aborted." && rm -rf ${GIT_CLONE_DIR} && exit 1 )
            err=$?; [[ $err != 0 ]] && exit $err
    else
        # Create empty branches
        N_BRANCHES=$(git -C ${GIT_CLONE_DIR} branch -r | wc -l)
        for ((i=1; i<=$N_BRANCHES; i++)); do
            BRANCH_i=$(git -C ${GIT_CLONE_DIR} branch -r | head -$i | tail -1 | sed s/"origin\/"// | xargs)
            git -C ${GIT_CLONE_DIR} checkout -b $BRANCH_i
        done

        # Pull and track each branch
        for ((i=1; i<=$N_BRANCHES; i++)); do
            BRANCH_i=$(git -C ${GIT_CLONE_DIR} branch -r | head -$i | tail -1 | sed s/"origin\/"// | xargs)
            git -C ${GIT_CLONE_DIR} checkout $BRANCH_i
            git -C ${GIT_CLONE_DIR} pull origin $BRANCH_i
            git -C ${GIT_CLONE_DIR} branch --set-upstream-to=origin/$BRANCH_i ${BRANCH_i}
            BRANCH=${BRANCH_i}
        done
    fi
    notif s "Done"
    notif w "${GIT_URL}/${PARTIAL_PATH} ->" && notif w "${GIT_CLONE_DIR}"
else 
    notif w "Already a git directory. Aborted."
fi
