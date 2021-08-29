#!/bin/bash

#
# The github-now script
#   Create a new Github repo from the current directory
#
# AUTHOR:
#   Lucero Alvarado
#   https://github.com/lu0/git-scripts
#
# USAGE:
# (1) You'll need to generate a token, password authentication is deprecated.
#     https://github.com/settings/tokens
#     Save your token in a file named ".github-token" in your home directory
#
# (2) ln -sr ./github-now.sh ~/.local/bin/github-now
#

REMOTE="$(git config --get remote.origin.url)"
[ -n "$(git ls-remote 2>/dev/null)" ] && echo "Remote origin already exists in" ${REMOTE} && exit

REPONAME=${PWD##*/}
GITUSER=$(git config user.name)

echo -e "\nNAME OF REPOSITORY: ${REPONAME}"
read -p "PROVIDE A DESCRIPTION: " DESCRIPTION
read -p "IS PRIVATE? [y/n]: " PRIVATE_ANS

PRIVACY=PUBLIC && IS_PRIVATE=false
[ "$PRIVATE_ANS" == "y" ] && PRIVACY=PRIVATE && IS_PRIVATE=true

echo -e "\nAfter this operation, { ${REPONAME} } will be pushed to Github as a { $PRIVACY } repository for { ${GITUSER} }"
read -p "Continue? [y/n] " CONTINUE

[ "$CONTINUE" != "y" ] && echo "Operation cancelled :(" && exit

if [ "$( git log --oneline -1 2>/dev/null | wc -l )" -eq 0 ]
then 
    # Prepare initial commit
    git init $PWD
    GH_MESSAGE="Repository created and pushed with [github-now](https://github.com/lu0/git-scripts)"
    echo $GH_MESSAGE > README-github-now.md
    git -C $PWD add .
    git -C $PWD commit -m "${GH_MESSAGE}"
fi

TOKEN=$(cat ~/.github-token)

curl -s -u ${GITUSER}:${TOKEN} https://api.github.com/user/repos -d \
    "{\"name\": \"${REPONAME}\", \"description\": \"${DESCRIPTION}\", \"private\": $IS_PRIVATE}" #> /dev/null

git remote add origin https://${GITUSER}:${TOKEN}@github.com/${GITUSER}/${REPONAME}.git
git push origin master
