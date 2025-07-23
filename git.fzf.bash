#!/bin/bash

path=$HOME/.repos
repos=$(ls -1 $path)
edits=$''
x=1
cd $path

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

if [[ "$edits" == "" ]]; then
    edits="no edits"
fi
# echo $edits
# printf "%s" "$edits"

# until [[ "$edits" == "exit\n" || $x -eq 15 ]]; do
until [[ "$edits" == "" ]]; do
    edit=$(printf "%s" "$edits" | fzf --tmux 80%,80% --preview 'cd {} && git status --porcelain' --print-query)
    if [[ "$edit" == "e" || "$edit" == "exit" ]]; then
        exit 0
    fi

    edit="$(printf '%s' "$edit" | sed '1{/^$/d;}' )"
    cd "$path/$edit" || continue

    commit_msg=$(git status --porcelain | cut -c4- | \
        fzf --tmux 80%,80% \
        --border-label " $edit " \
        --preview "cd \"$path/$edit\" && git diff --color=always -- '{}'" \
        --preview-window=right:70%:wrap \
        --print-query)
        # --preview 'git diff --color=always -- "{}"' \
    if [[ -n "$commit_msg" ]]; then
        git add -A
        git commit -m "$commit_msg"
        git push
    fi

    edits=$(printf "%s" "$edits" | grep -vxF "$edit")
    (( x++ ))
done


