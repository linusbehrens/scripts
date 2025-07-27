#!/bin/bash

new="▌ new mail" 
mbsync -a

# get_index () {
#     index=$(printf "$(mthread | mscan)" | awk -v sel="$selection" 'BEGIN{i=0} $0==sel{print i; exit} {i++}')
#     return $index
# }

# mlist -N $MAIL | mseq -S

opts=$(
    mlist -N $MAIL | 
    while read -r msg; do
       printf '%s\t%s\n' "$msg" "$(mscan -f '%s' "$msg")"
    done
)
opts+=$'\n'
opts+="new"
opts+=$'\t'
opts+="new"
opts+=$'\n'

echo "$opts"

selection=$(
    echo "$opts" |
    fzf --delimiter=$'\t' \
        --with-nth=2 \
        --preview 'mshow {1} || echo "new mail"' \
        --tmux 80%,80% \
        --border-label ' mail@linus-behrens.de ' \
        --preview-window='right,70%,border' \
        --style full \
        --accept-nth=1
)

mshow $selection | nvim

# mlist -N $MAIL | mseq -S
# # selection=$(mthread | mscan | fzf --preview 'echo {} | mshow')
# selection=$(mlist -N $MAIL | fzf --preview 'echo {} | mshow' \
#     --tmux 80%,80% \
#     --border-label ' mail@linus-behrens.de ' \
#     --preview-window='right,70%,border' \
#     --style full ) || exit 0
#
# index=$(printf "$(mthread | mscan)" | awk -v sel="$selection" 'BEGIN{i=0} $0==sel{print i; exit} {i++}')
#
# index=index + 1
#
# tmux.inject.bash "mshow $index | nvim"
#
# # --bind 'focus:transform-preview-label:[[ -n {} ]] && mshow -h subject {}' \
