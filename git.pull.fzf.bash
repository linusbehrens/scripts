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
        echo "$repo"
        result=$(git fetch origin && git diff --name-status HEAD...origin/main --diff-filter=ACMRT)
        if [[ -n $result ]]; then
            edits+="$repo"
            edits+=$'\n'
        fi
        cd ..
    done
}

if_exit () {
    if [[ -z "$edit" || "$edit" == "e" || "$edit" == "▌ exit" ]]; then
        echo "$edit"
        exit 0
        exit 0
        exit 0
    fi
    if [[ "$msg" == "e" || "$msg" == "▌ exit" ]]; then
        echo "$edit"
        exit 0
        exit 0
        exit 0
    fi

}

until [[ "$edits" == "" ]]; do
    source_repos
    edit=$(printf "%s" "$edits" | fzf --tmux 80%,80% --preview 'cd {} && git diff --name-status HEAD...origin/main --diff-filter=ACMRT' --print-query)
    if_exit

    cd "$path/$edit" || continue
    echo "$edit"
    msg=$(git status --porcelain | cut -c4- | \
        fzf --tmux 80%,80% \
        --border-label " $edit " \
        --preview "cd \"$path/$edit\" && git diff --color=always -- '{}'" \
        --preview-window=right:70%:wrap \
        --print-query)
        # --preview 'git diff --color=always -- "{}"' \
    if_exit
    if [[ -n "$msg" ]]; then
        echo "git pull $edit"
        git pull 
    fi
done


