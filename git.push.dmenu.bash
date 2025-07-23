#!/bin/bash

path=$HOME/.repos
repos=$(ls -1 $path)
edits=$''
edits+="▌ exit"
edits+=$'\n'
x=1
cd $path

source_repos () {
    edits=$''
    edits+="▌ exit"
    edits+=$'\n'

    for repo in $repos; do
        cd $repo
        # echo $(pwd)
        result=$(git status --porcelain)
        if [[ -n $result ]]; then
            edits+="$repo"
            edits+=$'\n'
        fi
        cd ..
    done
}

if [[ "$edits" == "" ]]; then
    edits="no edits"
fi

until [[ "$edits" == "" ]]; do
    source_repos
    edit=$(printf "%s" "$edits" | dmenu -c -l 10 )

    if [[ "$edit" == "no edits" || "$edit" == "e" || "$edit" == "▌ exit" ]]; then
        echo "$edit"
        exit 0
        exit 0
        exit 0
    fi
    cd $edit

    cd "$path/$edit" || continue
    commit_msg=$(git status --porcelain | dmenu -i -c -l 10 -p "push $edit")
    if [[ -n "$commit_msg" ]]; then
        git add -A
        git commit -m "$commit_msg"
        git push
    fi
done


