#!/bin/bash

# Vars
user='DJSiddharthVader'
spacer=" "
first_commit_msg="first commit"


function help(){
    echo 'Usage ./init-new-gitrepo.sh $repo_name $repo_description'
    exit 1
}
function createRemote(){
    repo_name="$1"
    repo_description="$2"
    dflag="$(jq -nc \
                --arg name "$repo_name" \
                --arg description "$repo_description" \
                --arg private "true" \
                '{ $name, $description, $private }'
            )"
    curl -X POST \
         -u "$user" \
         -H "Accept: application/vnd.github.v3+json" \
             https://api.github.com/user/repos \
         -d "$dflag" \
         -s #>> /dev/null 2>&1
}
function createLocal(){
    repo_name="$1"
    repo_description="$2"
    echo "$repo_description" >| README.md
    git init
    git add README.md
    git commit -m "$first_commit_msg"
    git remote add origin "git@github.com:$user/$repo_name.git"
    git push -u origin master
    git config remote.origin.push HEAD
}
function main(){
    repo_name="$1"
    repo_description="$2"
    mkdir -p "$repo_name"
    createRemote "$repo_name" "$repo_description"
    cd "$repo_name"
    createLocal "$repo_name" "$repo_description"
    cd -
}

#Args
if [[ $# -eq 2 ]];then
    repo_name="$1"
    repo_description="$2"
else
    help
fi
main "$repo_name" "$repo_description"
