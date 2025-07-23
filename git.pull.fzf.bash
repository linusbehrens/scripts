#!/bin/bash

exit="▌ exit"
path=$HOME/.repos

repos=$(ls -1 $path)
cd $path

source_repos () {
    edits=$''
    edits+="$exit"
    edits+=$'\n'

    for repo in $repos; do
        cd $repo
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
    local test=$1
    if [[ -z "$test" || "$test" == "e" || "$test" == "▌ exit" ]]; then
        echo "$test"
        exit 0
    fi
}

while true; do
    source_repos
    edit=$(printf "%s" "$edits" | fzf --tmux 80%,80% --preview 'cd {} && git diff --name-status HEAD...origin/main --diff-filter=ACMRT' --print-query)
    if_exit $edit

    cd "$path/$edit" || continue
    echo "$edit"
    msg=$(git status --porcelain | cut -c4- | \
        fzf --tmux 80%,80% \
        --border-label " $edit " \
        --preview "cd \"$path/$edit\" && git diff --color=always -- '{}'" \
        --preview-window=right:70%:wrap \
        --print-query\
    )

    if_exit $msg

    if [[ -n "$msg" ]]; then
        echo "git pull $edit"
        git pull 
    fi
done


